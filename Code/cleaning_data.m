%% Data Cleaning
%
% Author: Cole MacPherson
% Date: 10/28/2021

%% Housekeeping
clc;
clear;
close all;

%% Drought Data Cleaning
drought_raw = readtable('Data\Raw Data\Drought\USDM-colorado_drought_weekly_2001_2021.csv');

d_temp = drought_raw{:,3:8};

% determine highest drought level
temp = strings(length(d_temp),1);
for i = 1:length(d_temp)
    if d_temp(i,1) == 100
        temp(i) = "None";
    elseif d_temp(i,6) ~= 0
        temp(i) = "D4";
    elseif d_temp(i,5) ~= 0
        temp(i) = "D3";
    elseif d_temp(i,4) ~= 0
        temp(i) = "D2";
    elseif d_temp(i,3) ~= 0
        temp(i) = "D1";
    elseif d_temp(i,2) ~= 0
        temp(i) = "D0";
    end
end

% set cleaned data
drought_cleaned = drought_raw(:,[9:10 3:8]);
drought_cleaned.HighestDroughtLevel = temp;

% write cleaned data to csv
writetable(drought_cleaned,'Data\Clean Data\Drought\USDM-colorado_drought_weekly_2001_2021_CLEANED.csv');

%% Weather Data Cleaning
base = 'Data\Raw Data\Weather';
list = dir(fullfile(base, '*.xlsx'));
weatherVals = zeros(4017,36);
for i = 1:numel(list)
    file = fullfile(base, list(i).name);
    result = readtable(file);
    weatherVals(:,(((i-1)*4)+1):(i*4)) = result{:,2:5};
    dates = result(:,1);
end

% find average values across eacch day
weather_avg_daily = zeros(4017,4);
for i = 1:length(weatherVals)
    weather_avg_daily(i,1) = mean(weatherVals(i,(1:4:36)),'omitnan');
    weather_avg_daily(i,2) = mean(weatherVals(i,(2:4:36)),'omitnan');
    weather_avg_daily(i,3) = mean(weatherVals(i,(3:4:36)),'omitnan');
    weather_avg_daily(i,4) = mean(weatherVals(i,(4:4:36)),'omitnan');
end

% put back in table format
weather_clean = array2table(weather_avg_daily);
weather_clean = [dates weather_clean];
weather_clean.Properties.VariableNames = {'Dates', 'Max Temp', 'Min Temp', 'Pcpn', 'Snow'};

% save file
writetable(weather_clean,'Data\Clean Data\Weather\weatherAvg_CLEANED.csv');

%% Population Data
pop_raw = readtable("Data\Raw Data\Population\popbycountyandmuni.xlsx");
pop_raw_cell = table2cell(pop_raw);

% counties data
pop_counties = cell(64,11);
j = 1;
for i = 3:length(pop_raw_cell)
    if isempty(pop_raw_cell{i,2})
        
    elseif pop_raw_cell{i,2} == '00000'
        pop_counties(j,1) = pop_raw_cell(i,3);
        pop_counties(j,2:11) = pop_raw_cell(i,4:13);
        j = j + 1;
    end
end

pop_counties = pop_counties(1:(end-1),:);

% cities data
pop_cities = cell(273,11);

j = 1;
UA_tot = zeros(1,10);
for i = 3:length(pop_raw_cell)
    if isempty(pop_raw_cell{i,1})
        
    elseif contains(pop_raw_cell{i,2}, '00000')
        
    elseif contains(pop_raw_cell{i,3},'(Part)')
        
    elseif contains(pop_raw_cell{i,3},'Unincorp. Area')
        for k = 1:10
            UA_tot(k) = UA_tot(k) + pop_raw_cell{i,(k+3)};
        end
        
    elseif contains(pop_raw_cell{i,3},'(Total)')
        idx = strfind(convertCharsToStrings(pop_raw_cell{i,3}), '(Total)');
        pop_cities(j,1) = cellstr(pop_raw_cell{i,3}(1:(idx-2)));
        pop_cities(j,2:11) = pop_raw_cell(i,4:13);
        j = j + 1;
    else
        pop_cities(j,1) = pop_raw_cell(i,3);
        pop_cities(j,2:11) = pop_raw_cell(i,4:13);
        j = j + 1;        
    end
end

pop_cities(273,1) = cellstr('Unincorp. Area');
pop_cities(273,2:11) = num2cell(UA_tot);

% create tables
counties_pop_table = cell2table(pop_counties,'VariableNames',{'County' '2010' '2011' '2012' '2013' '2014' '2015' '2016' '2017' '2018' '2019'});
cities_pop_table = cell2table(pop_cities,'VariableNames',{'City/Town' '2010' '2011' '2012' '2013' '2014' '2015' '2016' '2017' '2018' '2019'});

% save
writetable(counties_pop_table,'Data\Clean Data\Population\counties_CLEANED.csv');
writetable(cities_pop_table,'Data\Clean Data\Population\cities_CLEANED.csv');


%% Wildfire Data
wildfire_raw = readtable("Data\Raw Data\Wildfires\US_Wildfires_1878_2019.xlsx");
wildfire_raw_cell = table2cell(wildfire_raw);

wildfire_timerange = cell(1228,width(wildfire_raw));
j = 1;
for i = 1:height(wildfire_raw)
    if ~isnat(wildfire_raw_cell{i,4})
        if wildfire_raw_cell{i,7} >= 5000
            if wildfire_raw_cell{i,3} >= 2009 && wildfire_raw_cell{i,3} <= 2019
                wildfire_timerange(j,:) = wildfire_raw_cell(i,:);
                j = j + 1;
            end
        end
    end
end

wildfire_usefull = wildfire_timerange(:,[1 3:4 7:8 11 17:18]);

% create table
wildfire_table_clean = cell2table(wildfire_usefull,'VariableNames',{'Name' 'Year' 'Date' 'Acres' 'Hectares' 'Cause' 'Shape Length' 'Shape Area'});

% save table
writetable(wildfire_table_clean,'Data\Clean Data\Wildfires\CO_WIldfires_2009_2019_CLEANED.csv');

%% Plot Wildfires & Population vs Time

WFGC_Y = groupcounts(wildfire_table_clean,"Year");

WFGC_C = groupcounts(wildfire_table_clean,"Cause");

% Causes = categorical(["Humans", "Lightning", "Natural", "Unknown/Undefined"]);
% Causes = reordercats(Causes,["Humans", "Lightning", "Natural", "Unknown/Undefined"]);
% C_Counts = [sum(WFGC_C{2:5,2})+WFGC_C{7,2}, WFGC_C{1,2}+WFGC_C{8,2}, WFGC_C{11,2}+WFGC_C{12,2}, WFGC_C{9,2}+sum(WFGC_C{9:10,2})+sum(WFGC_C{13:16,2})];

Causes = categorical(["Humans", "Lightning", "Natural"]);
Causes = reordercats(Causes,["Humans", "Lightning", "Natural"]);
C_Counts = [sum(WFGC_C{2:5,2})+WFGC_C{7,2}, WFGC_C{1,2}+WFGC_C{8,2}, WFGC_C{11,2}+WFGC_C{12,2}];


figure
bar(Causes, C_Counts);

figure
yyaxis left
plot(WFGC_Y{:,1},WFGC_Y{:,2},'linewidth',2)
title("WIldfires and Population vs Time");
xlabel("Year")
ylabel("Number of Wildfires")
hold on
yyaxis right
ylabel("Total Population of Colorado")
plot([2010:2019],[pop_raw_cell{1,4:13}],'linewidth',2)
