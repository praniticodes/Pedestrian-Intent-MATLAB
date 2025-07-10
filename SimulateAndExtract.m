clc;
clear;

% Run simulation
[allData, scenario, sensors] = design();

numFrames = length(allData);
numPedestrians = 4;

% Preallocate cell array (estimated size for speed)
pedestrianData = cell(numFrames * numPedestrians, 7);
row = 1;

for t = 1:numFrames
    poses = allData(t).ActorPoses;
    time = allData(t).Time;

    % Ego position
    egoPos = poses(1).Position(1:2);

    % For each pedestrian
    for p = 1:numPedestrians
        pedIdx = p + 1;
        pedPose = poses(pedIdx).Position(1:2);

        % Gaze vector
        if t < numFrames
            nextPedPose = allData(t + 1).ActorPoses(pedIdx).Position(1:2);
        else
            nextPedPose = pedPose;
        end

        gazeVec = nextPedPose - pedPose;
        if norm(gazeVec) > 0
            gazeAngle = atan2d(gazeVec(2), gazeVec(1));
        else
            gazeAngle = NaN;
        end

        % Distance to ego
        distanceToEgo = norm(egoPos - pedPose);

        % Speed
        if t > 1
            prevPedPose = allData(t - 1).ActorPoses(pedIdx).Position(1:2);
            dt = allData(t).Time - allData(t - 1).Time;
            speed = norm(pedPose - prevPedPose) / dt;
        else
            speed = 0;
        end

        % Store values (each row = 1 pedestrian at time t)
        pedestrianData{row, 1} = time;
        pedestrianData{row, 2} = p;
        pedestrianData{row, 3} = pedPose(1);        % X
        pedestrianData{row, 4} = pedPose(2);        % Y
        pedestrianData{row, 5} = gazeAngle;         % Gaze angle
        pedestrianData{row, 6} = speed;             % Speed
        pedestrianData{row, 7} = distanceToEgo;     % Distance to ego

        row = row + 1;
    end
end

% Convert to table
T = cell2table(pedestrianData, 'VariableNames', ...
    {'Time', 'PedestrianID', 'PosX', 'PosY', 'GazeAngle_deg', 'Speed_mps', 'DistanceToEgo_m'});

% Create folder and save
if ~exist('data', 'dir')
    mkdir('data');
end
writetable(T, 'data/pedestrianFeatures.csv');

disp('✅ Feature extraction complete. File saved to data/pedestrianFeatures.csv');
