function [avg_img_size avg_hand_pixels] = handStats(handSegDir, scale)
%HANDSTATS Summary of this function goes here
%   Detailed explanation goes here

%% Parse segmented hand images directory
filt = '.*(png|jpg)';
handSegDescs = dir(handSegDir);
handSegNames = {handSegDescs(~cellfun(@isempty,regexpi({handSegDescs.name},filt))).name};

%% For each input image
img_sizes = zeros(numel(handSegNames), 2);
hand_pixels = zeros(numel(handSegNames), 1);
for i = 1:numel(handSegNames)
    handSeg = imread(fullfile(handSegDir, handSegNames{i}));
    handSeg = imresize(handSeg, scale);
    img_sizes(i,:) = size(handSeg);
    hand_pixels(i) = nnz(handSeg);
end

%% Output result
avg_img_size = mean(img_sizes);
avg_hand_pixels = mean(hand_pixels);

