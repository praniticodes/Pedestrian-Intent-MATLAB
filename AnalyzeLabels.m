% Load pedestrian intent labeled dataset
T = readtable('data/pedestrianFeaturesWithLabels.csv');

% Show first few rows
disp(head(T));

% Example: Count labels
numCrossing = sum(strcmp(T.IntentLabel, 'Crossing'));
numNotCrossing = sum(strcmp(T.IntentLabel, 'Not Crossing'));
numUncertain = sum(strcmp(T.IntentLabel, 'Uncertain'));

fprintf('Crossing: %d\nNot Crossing: %d\nUncertain: %d\n', ...
    numCrossing, numNotCrossing, numUncertain);
