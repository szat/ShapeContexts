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

%Without dummy nodes
I1 = imread('..\data\bw_fish1.png');
BW1 = imbinarize(I1);
C1 = bwboundaries(BW1,4); 
C1 = C1{1};
C1 = C1(1:5:end,:); 

I2 = imread('..\data\bw_fish1_occ.png');
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

%Visualize
vizSC(C1,C2,assign,'Occlusion without dummy nodes');


%With dummy nodes
I1 = imread('..\data\bw_fish1.png');
BW1 = imbinarize(I1);
C1 = bwboundaries(BW1,4); 
C1 = C1{1};
C1 = C1(1:5:end,:); 

I2 = imread('..\data\bw_fish1_occ.png');
BW2 = imbinarize(I2);
C2 = bwboundaries(BW2,4); 
C2 = [C2{1};C2{2}]; %Two boundaries
C2 = C2(1:5:end,:);

%Compute with dummy nodes
[assign,cost] = shapeContext(C1, C2, 5, 6, 1,50);

% The point matching is done so:
assign = assign(1:length(C1));
assign = [linspace(1,length(assign),length(assign)); assign];
assign(:,assign(2,:) == 0) = []; % For unequal cases
assign(:,assign(2,:) > length(C2)) = [];

%Visualize
vizSC(C1,C2,assign,'Occlusion with dummy nodes');
