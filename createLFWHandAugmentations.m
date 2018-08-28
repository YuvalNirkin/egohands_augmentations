function createHandAugmentations(varargin)
%CREATEHANDAUGMENTATIONS Summary of this function goes here
%   Detailed explanation goes here

%% Parse input arguments
p = inputParser;
addRequired(p, 'inDir', @ischar);
addRequired(p, 'handImgDir', @ischar);
addRequired(p, 'handSegDir', @ischar);
addRequired(p, 'outDir', @ischar);
addOptional(p, 'hand_pixels', 2400, @isscalar)
parse(p, varargin{:});

%% Parse input hand images directory
filt = '.*(png|jpg)';
handImgDescs = dir(p.Results.handImgDir);
handImgNames = {handImgDescs(~cellfun(@isempty,regexpi({handImgDescs.name},filt))).name};

%% Parse input directory
fileDescs = dir(p.Results.inDir);
dirNames = {fileDescs([fileDescs.isdir]).name};
dirNames = dirNames(3:end);

%% For each directory find all LFW image paths
disp(['Parsing input LFW directory...'])
inImgPaths = {};
for i = 1:length(dirNames)

    % Parse input images in current directory
    inImgDescs = dir(fullfile(p.Results.inDir, dirNames{i}));
    inImgNames = {inImgDescs(~cellfun(@isempty,regexpi({inImgDescs.name},filt))).name};
    
    % For each input image
    for j = 1:length(inImgNames)
        inImgPaths = [inImgPaths ...
            fullfile(p.Results.inDir, dirNames{i}, inImgNames{j})]; 
    end
    
    % Create output folder structure
    currOutDir = fullfile(p.Results.outDir, dirNames{i});
    if ~exist(currOutDir, 'dir')
        mkdir(currOutDir);
    end
end

%% Sample hand image for each input image
handInd = datasample(1:numel(handImgNames), numel(inImgPaths));

%% For each input image
for i = 1:numel(inImgPaths)
    [inImgDirPath, inImgName, ext] = fileparts(inImgPaths{i});
    [~, inImgDirName, ~] = fileparts(inImgDirPath);
    disp(['Processing ' inImgName ext '...'])
    
    %% Read images
    hi = handInd(i);
    [~, handImgName, handImgExt] = fileparts(handImgNames{hi});
    inImg = imread(inImgPaths{i});
    handImg = imread(fullfile(p.Results.handImgDir, handImgNames{hi}));
    handSeg = imread(fullfile(p.Results.handSegDir, [handImgName '.png']));
    
    %% Calculate scale
    curr_hand_pixels = nnz(handSeg);
    scale = sqrt(p.Results.hand_pixels/curr_hand_pixels);
    
    %% Downscale hand images by scale
    handImg = imresize(handImg, scale);
    handSeg = imresize(handSeg, scale);
    
    %% Calculate random position
    quart_width = round(size(inImg,2)/4);
    rx = randi([quart_width (size(inImg,2) - quart_width)], 1);
    quart_height = round(size(inImg,1)/4);
    ry = randi([quart_height (size(inImg,1) - quart_height)], 1);
    %ry = randi([round(size(inImg,1)/2) size(inImg,1)], 1);
    pos = [rx ry];
    
    %% Augment hand on image
    inSeg = logical(zeros(size(inImg, 1), size(inImg, 2)));
    outImg = augmentHand(handImg, handSeg, inImg, inSeg, pos);
    
    %% Write output image to file
    outImgPath = fullfile(p.Results.outDir, inImgDirName, [inImgName ext]);
    imwrite(outImg, outImgPath);

end

end
