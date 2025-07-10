clc;
clear;

% Step 1: Load the labeled feature dataset
data = readtable('data/pedestrianFeaturesWithLabels.csv');

% Step 2: Preprocess - encode categorical label as categorical
data.IntentLabel = categorical(data.IntentLabel);

% Step 3: Select features and label
features = data(:, {'GazeAngle_deg', 'Speed_mps', 'DistanceToEgo_m'});
labels = data.IntentLabel;

% Step 4: Split into training and test sets (80/20)
cv = cvpartition(height(data), 'HoldOut', 0.2);
trainIdx = training(cv);
testIdx = test(cv);

XTrain = features(trainIdx, :);
YTrain = labels(trainIdx);
XTest = features(testIdx, :);
YTest = labels(testIdx);

% Step 5: Train the Decision Tree classifier
model = fitctree(XTrain, YTrain);

% Optional: View the tree
view(model, 'Mode', 'graph');

% Step 6: Test the model
YPred = predict(model, XTest);

% Step 7: Evaluate the model
accuracy = sum(YPred == YTest) / numel(YTest);
fprintf('🔍 Test Accuracy: %.2f%%\n', accuracy * 100);

% Confusion matrix
confMat = confusionmat(YTest, YPred);
disp('📊 Confusion Matrix:');
disp(confMat);

% Step 8: Save the trained model
save('intentClassifier.mat', 'model');
disp('✅ Model saved as intentClassifier.mat');

