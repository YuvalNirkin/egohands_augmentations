function createTrainVal(varargin)
%CREATETRAINVAL Summary of this function goes here
%   Detailed explanation goes here

%% Parse input arguments
p = inputParser;
addRequired(p, 'inDir', @ischar)
addRequired(p, 'outDir', @ischar);
addRequired(p, 'trainFile', @ischar);
addRequired(p, 'valFile', @ischar);
parse(p, varargin{:});


%% Parse input directory
filt = '.*(png|jpg)';
fileDescs = dir(p.Results.inDir);
fileNames = {fileDescs.name};
fileNames = {fileDescs(~cellfun(@isempty,regexpi({fileDescs.name},filt))).name};

%% Read train and val files
trainNames = readTextFile(p.Results.trainFile);
valNames = readTextFile(p.Results.valFile);

%% Initialize training and valuation set
train = {};
val = {};

%% For each image in the input directory
for i = 1:numel(fileNames)
    fileName = fileNames{i};
    [~, outName, ~] = fileparts(fileName);
    testName = fileName(1:end-9);
    if(any(ismember(valNames, testName)))
        val = [val; outName];
    else
        train = [train; outName];
    end
end

%% Write train and validation sets to file
writeTextFile(fullfile(p.Results.outDir, 'train.txt'), train);
writeTextFile(fullfile(p.Results.outDir, 'val.txt'), val);

end

function names = readTextFile(textFile)
    fileID = fopen(textFile);
    names = textscan(fileID,'%s');
    names = names{1};
    fclose(fileID);
end

function writeTextFile(textFile, set)
    fid = fopen(textFile,'wt');
    for i = 1:length(set)
         fprintf(fid, '%s\n', set{i});
    end
    fclose(fid);
end
