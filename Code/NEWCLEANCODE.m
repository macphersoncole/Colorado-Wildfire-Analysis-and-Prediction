%% Cleaning Wildfires
%
%
% Author: Cole MacPherson

%% Housekeeping
clc;
clear;
close all;

%% Load data
data = readtable("Data\new_raw_data\fires.csv");

%% Cleaning data
idx_CO = ismember(data{:,3},'CO'); % filtering by state (CO)
%idx_year = ismember(data{:,8},2009:2019); % filtering by dates (2009-2019)

data_clean_CO = data(idx_CO,:);

idx_area_F = ismember(string(data_clean_CO{:,7}),"F"); % filtering by fire class (F class) (between 1,000 and 5,000 acres)
idx_area_G = ismember(string(data_clean_CO{:,7}),"G"); % filtering by fire class (G class) (greater than 5,000 acres)

idx = idx_area_F | idx_area_G;

data_clean = data_clean_CO(idx,:);

%% Write data to new csv file
writetable(data_clean,"Data\Clean Data\Wildfires\clean_geo_fires.csv");