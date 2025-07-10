clc;
clear;

% Load previously extracted features
T = readtable('data/pedestrianFeatures.csv');

% Initialize label column
numRows = height(T);
labels = strings(numRows, 1);

% Define thresholds (you can tune these)
for i = 1:numRows
    speed = T.Speed_mps(i);
    gaze = abs(T.GazeAngle_deg(i));  % absolute angle
    distance = T.DistanceToEgo_m(i);

    if (speed > 0.5) && (gaze > 70 && gaze < 110) && (distance < 15)
        labels(i) = "Crossing";
    elseif (speed < 0.2) && (distance > 20)
        labels(i) = "Not Crossing";
    else
        labels(i) = "Uncertain";
    end
end

% Add to table
T.IntentLabel = labels;

% Save labeled data
writetable(T, 'data/pedestrianFeaturesWithLabels.csv');

disp('🏷️ Labeling complete. File saved as data/pedestrianFeaturesWithLabels.csv');
