function [ assignment, cost ] = shapeContextInv( pts1, pts2, dist_bin_nb, angle_bin_nb, dummy_eps, dummy_nb)
% Implementation of Belongie, Malik and Puzicha's Shape Contexts, with the SO2 invariant case. 
 
% Usage:   [ assignment, cost ] = shapeContextInv( pts1, pts2, dist_bin_nb, angle_bin_nb, dummy_eps, dummy_nb)
%
% Arguments:  
%             pts1  - First set of points m x 2
%             pts2  - Second set of points n x 2    
%      dist_bin_nb  - Number of bins along the radius 
%     angle_bin_nb  - Number of bins along the angles
%       dummmy_eps  - Value of the dummy nodes in the cost matrix (optional)
%        dummny_nb  - Number of dummy nodes (optional)
%
% Returns: 
%        assignment - Vector of indices matching pts1 to pts2, not all points are matched
%              cost - Earth Mover's Distance cost computer with Hungarian algo. 

% Example:
% I1 = imread('.\fish\bw_fish5.png');
% BW1 = imbinarize(I1);
% C1 = bwboundaries(BW1,4); 
% C1 = C1{1};
% C1 = C1(1:5:end,:); 
% 
% I2 = imread('.\fish\bw_fish5.png');
% BW2 = imbinarize(I2);
% C2 = bwboundaries(BW2,4); 
% C2 = C2{1};
% C2 = C2(1:5:end,:);
% 
% %Compute
% [assign,cost] = shapeContextInv(C1, C2, 5, 6);
% 
% % The point matching is done so:
% assign = assign(1:length(C1));
% assign = [linspace(1,length(assign),length(assign)); assign];
% assign(:,assign(2,:) == 0) = []; % For unequal cases
% assign(:,assign(2,:) > length(C2)) = [];
% 
% %Corresponding pts
% C1 = C1(assign(1,:),:);
% C2 = C1(assign(2,:),:);

% Reference: Belongie, S., Malik, J., & Puzicha, J. (2001). 
% Shape context: A new descriptor for shape matching and object recognition. 
% In Advances in neural information processing systems (pp. 831-837).

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

% Check number of inputs.
if nargin > 6
    error('bmpInv:TooManyInputs', ...
        'requires at most 6 optional inputs');
end

% Fill in unset optional values.
switch nargin
    case 2
        dist_bin_nb = 5;
        angle_bin_nb = 12;
        dummy_eps = 0;
        dummy_nb = 0;
    case 3
        angle_bin_nb = 12;
        dummy_eps = 0;
        dummy_nb = 0;
    case 4
        dummy_eps = 0;
        dummy_nb = 0;
    case 5
        dummy_nb = 0;
end

%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

%Pairwise distances and angles,
distances1 = pdist2(pts1, pts1,'euclidean');
mean_dist1 = sum(sum(distances1))/(length(pts1)^2);
distances1 = distances1/mean_dist1; %scale inv

distances2 = pdist2(pts2, pts2,'euclidean');
mean_dist2 = sum(sum(distances2))/(length(pts2)^2);
distances2 = distances2/mean_dist2; %scale inv

anglesRel1 = buildAnglesRel(pts1); %rot inv
anglesRel2 = buildAnglesRel(pts2); %rot inv

%Declare bins radius = 4;
radius = mean([mean_dist1,mean_dist2]);
dist_edges = logspace(0,(log(radius)/log(10)),dist_bin_nb+1)-1;
angle_edges = linspace(0,2*pi,angle_bin_nb+1);
angle_edges(end) = []; %because hist3 will bin whatever is past angle_edges(end)

%2D binning of the pairwise distances and angles
hist1 = zeros(size(pts1,1),length(dist_edges)*length(angle_edges));
for i = 1:size(pts1,1)
    res = hist3([distances1(:,i),anglesRel1(:,i)],'Edges', {dist_edges, angle_edges});
    hist1(i,:) = reshape(res,1,length(dist_edges)*length(angle_edges));
end
hist1 = hist1/sum(sum(hist1(1,:))); %same number of points

hist2 = zeros(size(pts2,1),length(dist_edges)*length(angle_edges));
for i = 1:size(pts2,1)
    res = hist3([distances2(:,i),anglesRel2(:,i)],'Edges', {dist_edges, angle_edges});
    hist2(i,:) = reshape(res, 1,length(dist_edges)*length(angle_edges));
end
hist2 = hist2/sum(sum(hist2(1,:))); %same number of points

%Chi Squared distance of histograms
cost_mat_rel = chisq(hist1, hist2);
%Add potential dummy nodes
dim = size(cost_mat_rel);
big = dummy_eps*ones(dim(1)+dummy_nb, dim(2)+dummy_nb);
big(1:dim(1),1:dim(2)) = cost_mat_rel;
%Something big (1000), so that the dummy points dont get matched together
big(dim(1)+1:end, dim(2)+1:end) = 1000;
cost_mat_rel = big;

%Hungarian method accepts non square cost matrices
[assignment,cost] = munkres(cost_mat_rel);
end

