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
noCause = find(cause == 'No cause indicated');
fprintf('%d fires had no cause indicated \n', length(noCause));


natural = find(cause == 'Natural');
NATURAL = find(cause == 'NATURAL');
fprintf('%d fires were due to natural causes \n', length(NATURAL) + length(natural));


oneLightning = find(cause == '1 - Lightning');
lightning = find(cause == 'Lightning');
fprintf('%d fires were due to Lightning \n', length(oneLightning) + length(lightning));

human = find(cause == 'Human');
fprintf('%d fires were due to humans \n', length(human));


unknown = find(cause == 'Unknown');
fprintf('%d fires had an unkown cause \n', length(unknown));

miscellaneous = find(cause == '9 - Miscellaneous');
miscellaneousTwo = find(cause == 'Miscellaneous');
fprintf('%d fires had a miscellaneous cause \n', length(miscellaneous) + length(miscellaneousTwo));

undetermined = find(cause == 'Undetermined');
fprintf('%d fires had an undetermined cause \n', length(undetermined));

fourCampfire = find(cause == '4 - Campfire');
fprintf('%d fires were caused by a campfire \n', length(fourCampfire));

missing = find(cause == 'Missing/Undefined');
fprintf('%d fires had causes that were Missing/Undefined \n', length(missing));

equipment = find(cause == '2 - Equipment use');
fprintf('%d fires were caused by equipment use \n', length(equipment));

arson = find(cause == '7 - Arson');
fprintf('%d fires were caused by arson \n', length(arson));

smoking = find(cause == '3 - Smoking');
fprintf('%d fires were caused by smoking \n', length(smoking));

structure = find(cause == 'Structure Fire');
fprintf('%d fires were caused by a Structure Fire \n', length(structure)); 


total = length(fourCampfire) + length(undetermined) + length(unknown) + length(lightning) + length(human) + length(oneLightning) + length(natural) + length(NATURAL) + length(noCause) + length(miscellaneous) + length(equipment) + length(arson) + length(miscellaneousTwo) + length(smoking) + length(structure) + length(missing); 
% 
% for i = 1:length(cause)
%     if cause(i) ~= '7 - Arson' && cause(i) ~= '2 - Equipment use' && cause(i) ~= '4 - Campfire' && cause(i) ~= 'Undetermined' && cause(i) ~= '9 - Miscellaneous' && cause(i) ~= 'Unknown' && cause(i) ~= 'Lightning' && cause(i) ~= '1 - Lightning' && cause(i) ~= 'Human' && cause(i) ~= 'Natural' && cause(i) ~= 'NATURAL' && cause(i) ~= 'No cause indicated'
%         fprintf('%s', cause(i));
%         i
%     end
%     
% end
plot1 = histogram(Acres);
