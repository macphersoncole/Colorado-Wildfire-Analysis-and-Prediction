%% Basic Data Analysis
%
% Author: Ankrit Uprety
% Date: 11/08/2021

%% Housekeeping
clc;
clear;
close all;

%% Read Data
Wildfire = readtable('Data\Clean Data\Wildfires\CO_WIldfires_2009_2019_CLEANED.csv');
Acres = Wildfire(:, 4);
Acres = table2array(Acres);
cause = Wildfire(:,6);
cause = table2array(cause);
cause = string(cause);

fprintf('There were %d fires that burned over 5000 acres \n', length(cause));
NoCause = find(cause == 'No cause indicated');
fprintf('%d fires had no cause indicated \n', length(NoCause));


natural = find(cause == 'Natural');
NATURAL = find(cause == 'NATURAL');
naturalVec = [natural; NATURAL];
Natural = length(NATURAL) + length(natural);
fprintf('%d fires were due to natural causes \n', length(NATURAL) + length(natural));


oneLightning = find(cause == '1 - Lightning');
lightning = find(cause == 'Lightning');
lightningVec = [oneLightning; lightning];
Lightning = length(oneLightning) + length(lightning);
fprintf('%d fires were due to Lightning \n', length(oneLightning) + length(lightning));

Human = find(cause == 'Human');
fprintf('%d fires were due to humans \n', length(Human));


Unknown = find(cause == 'Unknown');
fprintf('%d fires had an unkown cause \n', length(Unknown));

miscellaneous = find(cause == '9 - Miscellaneous');
miscellaneousTwo = find(cause == 'Miscellaneous');
Miscellaneous = [miscellaneous; miscellaneousTwo];
fprintf('%d fires had a miscellaneous cause \n', length(miscellaneous) + length(miscellaneousTwo));

Undetermined = find(cause == 'Undetermined');
fprintf('%d fires had an undetermined cause \n', length(Undetermined));

Campfire = find(cause == '4 - Campfire');
fprintf('%d fires were caused by a campfire \n', length(Campfire));

Missing = find(cause == 'Missing/Undefined');
fprintf('%d fires had causes that were Missing/Undefined \n', length(Missing));

Equipment = find(cause == '2 - Equipment use');
fprintf('%d fires were caused by equipment use \n', length(Equipment));

Arson = find(cause == '7 - Arson');
fprintf('%d fires were caused by arson \n', length(Arson));

Smoking = find(cause == '3 - Smoking');
fprintf('%d fires were caused by smoking \n', length(Smoking));

Structure = find(cause == 'Structure Fire');
fprintf('%d fires were caused by a Structure Fire \n', length(Structure)); 


total = length(Campfire) + length(Undetermined) + length(Unknown) + length(lightning) + length(Human) + length(oneLightning) + length(natural) + length(NATURAL) + length(NoCause) + length(miscellaneous) + length(Equipment) + length(Arson) + length(miscellaneousTwo) + length(Smoking) + length(Structure) + length(Missing); 

humanCauseVec = [Arson; Human; Smoking; Structure; Equipment];
%Missing = Missing';
%Miscellaneous = Miscellaneous';
UnknownVec = [Unknown; Undetermined; Missing; Miscellaneous];
X = categorical({'Natural Causes', 'Lighting', 'Human', 'Uknown'});
X = reordercats(X,{'Natural Causes', 'Lighting', 'Human', 'Uknown'});
barGraph = [length(naturalVec), length(lightningVec), length(humanCauseVec), length(Unknown)];
figure
plot1 = bar(X, barGraph);
ylabel('Number of Wildfires', 'FontWeight', 'bold');
xlabel('Listed Cause', 'FontWeight', 'bold')
