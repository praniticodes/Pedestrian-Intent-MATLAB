clc;
clear;

% Load trained intent model
load intentClassifier.mat

% Load features from CSV
T = readtable('data/pedestrianFeaturesWithLabels.csv');

% Loop through time
uniqueTimes = unique(T.Time);
for t = uniqueTimes'
    % Extract pedestrian data at current time
    currentData = T(T.Time == t, :);
    
    fprintf('\n===== Time: %.1f sec =====\n', t);
    
    for i = 1:height(currentData)
        pedID = currentData.PedestrianID(i);
        speed = currentData.Speed_mps(i);
        gaze = currentData.GazeAngle_deg(i);
        dist = currentData.DistanceToEgo_m(i);

        % Feature set
        feat = table(gaze, speed, dist, ...
            'VariableNames', {'GazeAngle_deg', 'Speed_mps', 'DistanceToEgo_m'});
        
        % Predict intent
        pred = predict(model, feat);
        
        % Decide AV action
        if pred == "Crossing"
            if dist < 5
                action = "🚨 Emergency Stop";
            elseif dist < 10
                action = "⚠️ Slow Down";
            else
                action = "⚠️ Prepare to Slow";
            end
        elseif pred == "Uncertain"
            action = "⏳ Slow Down";
        else
            action = "✅ Continue";
        end

        % Display
        fprintf('👤 Ped %d | Gaze: %.1f | Speed: %.1f | Dist: %.1f → 🧠 Intent: %-12s | 🚗 Action: %s\n', ...
            pedID, gaze, speed, dist, string(pred), action);
    end
end
