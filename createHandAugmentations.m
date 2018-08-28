function createHandAugmentations(varargin)
%CREATEHANDAUGMENTATIONS Summary of this function goes here
%   Detailed explanation goes here

%% Parse input arguments
p = inputParser;
addRequired(p, 'inImgDir', @ischar);
addRequired(p, 'inSegDir', @ischar);
addRequired(p, 'handImgDir', @ischar);
addRequired(p, 'handSegDir', @ischar);
addRequired(p, 'outImgDir', @ischar);
addRequired(p, 'outSegDir', @ischar);
parse(p, varargin{:});

%% Parse input images directory
filt = '.*(png|jpg)';
inImgDescs = dir(p.Results.inImgDir);
inImgNames = {inImgDescs.name};
inImgNames = {inImgDescs(~cellfun(@isempty,regexpi({inImgDescs.name},filt))).name};

%% Parse input hand images directory
handImgDescs = dir(p.Results.handImgDir);
handImgNames = {handImgDescs.name};
handImgNames = {handImgDescs(~cellfun(@isempty,regexpi({handImgDescs.name},filt))).name};

%% Sample hand image for each input image
handInd = datasample(1:numel(handImgNames), numel(inImgNames));

%% For each input image
for i = 1:numel(inImgNames)
    %% Calculate paths
    s = handInd(i);
    [~, inImgName, inImgExt] = fileparts(inImgNames{i});
    [~, handImgName, handImgExt] = fileparts(handImgNames{s});
    inImgPath = fullfile(p.Results.inImgDir, inImgNames{i});
    inSegPath = fullfile(p.Results.inSegDir, [inImgName '.png']);
    handImgPath = fullfile(p.Results.handImgDir, handImgNames{s});
    handSegPath = fullfile(p.Results.handSegDir, [handImgName '.png']);
    outImgPath = fullfile(p.Results.outImgDir, [inImgName '_hand.jpg']);
    outSegPath = fullfile(p.Results.outSegDir, [inImgName '_hand.png']);
    
    %% Check if already processed
    if(exist(outImgPath, 'file') == 2)
        disp(['Skipping "', inImgNames{i}, '"']);
        continue;
    else
        disp(['Processing "', inImgNames{i}, '"']);
    end
    
    %% Read images
    inImg = imread(inImgPath);
    inSeg = imread(inSegPath);
    handImg = imread(handImgPath);
    handSeg = imread(handSegPath);
    
    %% Calculate random position
    quart_width = round(size(inImg,2)/4);
    rx = randi([quart_width (size(inImg,2) - quart_width)], 1);
    ry = randi([round(size(inImg,1)/2) size(inImg,1)], 1);
    pos = [rx ry];
    
    %% Augment hand on image
    [outImg outSeg] = augmentHand(handImg, handSeg, inImg, inSeg, pos);
    
    %% Write output image and segmentation to file
    imwrite(outImg, outImgPath);
    imwrite(outSeg, outSegPath);
end


end

