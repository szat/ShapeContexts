%For this to work, please download the kovesiMIT package from
%http://www.peterkovesi.com/matlabfns/


% Copyright (c) Adrian Szatmari
% Author: Adrian Szatmari
% Date: 2017-11-30
% License: MIT, patent permitting
%
% Permission is hereby granted, free of charge, to any person obtaining a copy
% of this software and associated documentation files (the "Software"), to deal
% in the Software without restriction, subject to the following conditions:
% 
% The above copyright notice and this permission notice shall be included in 
% all copies or substantial portions of the Software.
%
% The Software is provided "as is", without warranty of any kind.

%I2 is the partially occluded version of I1
I1 = imread('.\fish\bw_fish1.png');
BW1 = imbinarize(I1);
C1 = bwboundaries(BW1,4); 
C1 = C1{1};
C1 = C1(1:5:end,:); 

I2 = imread('.\fish\bw_fish1_occ.png');
BW2 = imbinarize(I2);
C2 = bwboundaries(BW2,4); 
C2 = [C2{1};C2{2}]; %Two boundaries
C2 = C2(1:5:end,:);

%Compute without dummy nodes
[assign,cost] = shapeContext(C1, C2, 5, 6);

% The point matching is done so:
assign = assign(1:length(C1));
assign = [linspace(1,length(assign),length(assign)); assign];
assign(:,assign(2,:) == 0) = []; % For unequal cases
assign(:,assign(2,:) > length(C2)) = [];

vizSC(C1,C2,assign,'Before RANSAC');

C1_permute = C1(assign(1,:),:);
C2_permute = C2(assign(2,:),:);

% RANSAC
t = 0.001;
[H_homo, inliers] = ransacfithomography(C1_permute', C2_permute', t);
H_homo = H_homo/(H_homo(3,3)); %For stability normalize
C1_ransac = C1_permute(inliers,:);
C2_ransac = C1_permute(inliers,:);

%Visualize
vizSC(C1_ransac,C2_ransac,[1:length(C1_ransac);1:length(C2_ransac)],'After RANSAC');


%I1 and I2 are two different shapes 
I1 = imread('.\fish\bw_fish1.png');
BW1 = imbinarize(I1);
C1 = bwboundaries(BW1,4); 
C1 = C1{1};
C1 = C1(1:5:end,:); 

I2 = imread('.\fish\bw_fish2.png');
BW2 = imbinarize(I2);
C2 = bwboundaries(BW2,4); 
C2 = C2{1}; %Two boundaries
C2 = C2(1:5:end,:);

%Compute without dummy nodes
[assign,cost] = shapeContext(C1, C2, 5, 6);

% The point matching is done so:
assign = assign(1:length(C1));
assign = [linspace(1,length(assign),length(assign)); assign];
assign(:,assign(2,:) == 0) = []; % For unequal cases
assign(:,assign(2,:) > length(C2)) = [];

vizSC(C1,C2,assign,'Before RANSAC');

C1_permute = C1(assign(1,:),:);
C2_permute = C2(assign(2,:),:);

% RANSAC
t = 0.5;
[H_homo, inliers] = ransacfithomography(C1_permute', C2_permute', t);
H_homo = H_homo/(H_homo(3,3)); %For stability normalize
C1_ransac = C1_permute(inliers,:);
C2_ransac = C2_permute(inliers,:);

%Visualize
vizSC(C1_ransac,C2_ransac,[1:length(C1_ransac);1:length(C2_ransac)],'After RANSAC');
