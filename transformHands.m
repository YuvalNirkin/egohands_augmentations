function transformHands(varargin)
%TRANSFORMHANDS Summary of this function goes here
%   Detailed explanation goes here

%% Parse input arguments
p = inputParser;
addRequired(p, 'inDir', @ischar);
addRequired(p, 'outDir', @ischar);
parse(p, varargin{:});

%% Parse input directory
filt = '.*(png|jpg)';
fileDescs = dir(p.Results.inDir);
fileNames = {fileDescs.name};
fileNames = {fileDescs(~cellfun(@isempty,regexpi({fileDescs.name},filt))).name};

%% For each image in the input directory
angles = [135 180 225];
for i = 1:numel(fileNames)
    disp(['Processing "', fileNames{i}, '"']);
    [~, name, ext] = fileparts(fileNames{i});
    inPath = fullfile(p.Results.inDir, fileNames{i});
    I = imread(inPath);
    for j = 1:numel(angles)
        a = angles(j);
        outPath = fullfile(p.Results.outDir, [name '_a' num2str(a) ext]);
        if(strcmp(ext, '.png'))
            R = imrotate(I, a, 'nearest');
        else
            R = imrotate(I, a, 'bicubic');
        end
        imwrite(R, outPath);
    end
end

