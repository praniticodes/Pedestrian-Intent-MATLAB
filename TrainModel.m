load trainingData.mat
X = trainingData(:, 1:2);   % Features
Y = trainingData(:, 3);     % Labels

% Train decision tree (or try other models)
treeModel = fitctree(X, Y);

% Save model
save('treeModel.mat', 'treeModel');
