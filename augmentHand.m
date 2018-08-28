function [O S] = augmentHand(handImg, handSeg, tgtImg, tgtSeg, pos)
%AUGMENTHAND Summary of this function goes here
%   Detailed explanation goes here
hand_sz = [size(handImg,2) size(handImg,1)];
tgt_sz = [size(tgtImg,2) size(tgtImg,1)];
tl = pos - round(hand_sz/2);
br = tl + hand_sz - 1;

tl = max(tl, [1 1]);
br = min(br, tgt_sz);

O = tgtImg;
S = tgtSeg;
for r = 1:br(2)-tl(2)+1
    tr = r + tl(2) - 1;
    for c = 1:br(1)-tl(1)+1
        tc = c + tl(1) - 1;
        if(handSeg(r, c) > 0)
            O(tr, tc, :) = handImg(r, c, :);
            S(tr, tc, :) = 0;
        end
    end
end

%tgtMask = logical(zeros(size(tgtImg,1), size(tgtImg,2)));
%tgtMask(tl(1):br(1), tl(2):br(2)) = handSeg > 0;
%tgtImg(tgtMask) = handImg(handSeg > 0);
end

