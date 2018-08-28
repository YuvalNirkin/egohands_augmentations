function extractHands(varargin)
%EXTRACTHANDS Summary of this function goes here
%   Detailed explanation goes here

%% Parse input arguments
p = inputParser;
addRequired(p, 'outDir', @ischar);
addOptional(p, 'Location', 'OFFICE,COURTYARD,LIVINGROOM');
addOptional(p, 'Activity', 'CHESS,JENGA,PUZZLE,CARDS');
addOptional(p, 'Viewer', 'B,S,T,H');
addOptional(p, 'Partner', 'B,S,T,H');
addOptional(p, 'MainSplit', 'TRAIN,TEST,VALID');
parse(p, varargin{:});

%%
% Let's load the video of actor B playing jenga in the livingroom.
% getMetaBy() returns a struct that contains all possible meta information (including
% the ground-truth data) about the video. Check the getMetaBy() documentation for more.
%vid = getMetaBy('Location', 'LIVINGROOM', 'Activity', 'JENGA', 'Viewer', 'B');
videos = getMetaBy('Location', p.Results.Location, 'Activity', p.Results.Activity, 'Viewer', p.Results.Viewer, 'MainSplit', p.Results.MainSplit);

%% For each video
for vi = 1:numel(videos)
    vid = videos(vi);
    curr_dir = fullfile(p.Results.outDir, vid.video_id);
    if(exist(curr_dir) ~= 7)
        mkdir(curr_dir);
    end
    
    % loop over frames...
    num_frames = length(vid.labelled_frames);
    for i = 1:num_frames
        img = imread(getFramePath(vid, i));

        if ~isempty(vid.labelled_frames(i).yourright)
            poly = vid.labelled_frames(i).yourright;
            mask = poly2mask(poly(:,1), poly(:,2), 720, 1280);
            bbox = calc_bbox(mask);
            cropped_img = imcrop(img, bbox);
            cropped_mask = imcrop(mask, bbox);
            debug_img = make_debug_img(cropped_img, cropped_mask);
            imwrite(cropped_img, fullfile(curr_dir, [vid.video_id '_' num2str(i,'%04d') '_yourright.jpg']));
            imwrite(cropped_mask, fullfile(curr_dir, [vid.video_id '_' num2str(i,'%04d') '_yourright.png']));
            imwrite(debug_img, fullfile(curr_dir, [vid.video_id '_' num2str(i,'%04d') '_yourright_debug.jpg']));
        end

        if ~isempty(vid.labelled_frames(i).yourleft)
            poly = vid.labelled_frames(i).yourleft;
            mask = poly2mask(poly(:,1), poly(:,2), 720, 1280);
            bbox = calc_bbox(mask);
            cropped_img = imcrop(img, bbox);
            cropped_mask = imcrop(mask, bbox);
            debug_img = make_debug_img(cropped_img, cropped_mask);
            imwrite(cropped_img, fullfile(curr_dir, [vid.video_id '_' num2str(i,'%04d') '_yourleft.jpg']));
            imwrite(cropped_mask, fullfile(curr_dir, [vid.video_id '_' num2str(i,'%04d') '_yourleft.png']));
            imwrite(debug_img, fullfile(curr_dir, [vid.video_id '_' num2str(i,'%04d') '_yourleft_debug.jpg']));
        end
        %{
        if ~isempty(vid.labelled_frames(i).myright)
            poly = vid.labelled_frames(i).myright;
            mask = poly2mask(poly(:,1), poly(:,2), 720, 1280);
            bbox = calc_bbox(mask);
            cropped_img = imcrop(img, bbox);
            cropped_mask = imcrop(mask, bbox);
            debug_img = make_debug_img(cropped_img, cropped_mask);
            imwrite(cropped_img, fullfile(curr_dir, [vid.video_id '_' num2str(i,'%04d') '_myright.jpg']));
            imwrite(cropped_mask, fullfile(curr_dir, [vid.video_id '_' num2str(i,'%04d') '_myright.png']));
            imwrite(debug_img, fullfile(curr_dir, [vid.video_id '_' num2str(i,'%04d') '_myright_debug.jpg']));
        end

        if ~isempty(vid.labelled_frames(i).myleft)
            poly = vid.labelled_frames(i).myleft;
            mask = poly2mask(poly(:,1), poly(:,2), 720, 1280);
            bbox = calc_bbox(mask);
            cropped_img = imcrop(img, bbox);
            cropped_mask = imcrop(mask, bbox);
            debug_img = make_debug_img(cropped_img, cropped_mask);
            imwrite(cropped_img, fullfile(curr_dir, [vid.video_id '_' num2str(i,'%04d') '_myleft.jpg']));
            imwrite(cropped_mask, fullfile(curr_dir, [vid.video_id '_' num2str(i,'%04d') '_myleft.png']));
            imwrite(debug_img, fullfile(curr_dir, [vid.video_id '_' num2str(i,'%04d') '_myleft_debug.jpg']));
        end
        %}
    end
end
end

function bbox = calc_bbox(mask)
    minr = size(mask,1);
    minc = size(mask,2);
    maxr = 1;
    maxc = 1;
    for r = 1:size(mask,1)
        for c = 1:size(mask,2)
            if(mask(r,c) > 0)
                minr = min(r, minr);
                minc = min(c, minc);
                maxr = max(r, maxr);
                maxc = max(c, maxc);
            end
        end
    end
    bbox = [minc minr (maxc - minc + 1) (maxr - minr + 1)];
end

function debug_img = make_debug_img(img, mask)
    R = img(:,:,1);
    G = img(:,:,2);
    B = img(:,:,3);
    R(~mask) = 0;
    G(~mask) = 0;
    B(~mask) = 0;
    debug_img(:,:,1) = R;
    debug_img(:,:,2) = G;
    debug_img(:,:,3) = B;
end