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

drought_cleaned = drought_raw[];
