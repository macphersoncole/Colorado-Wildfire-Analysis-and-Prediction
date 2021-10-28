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
