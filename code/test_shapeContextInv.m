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

%Warning: the invariant version is quite slower than the non invariant version. This is because
%buildAnglesRel takes much longer than buildAngles. 

%Rotate the shape a little big, this will also cause some different scaling
I1 = imread('..\data\bw_fish5.png');
I1 = imrotate(I1,-20);
BW1 = imbinarize(I1);
C1 = bwboundaries(BW1,4); 
C1 = C1{1};
C1 = C1(1:5:end,:); 

I2 = imrotate(I1,20);
BW2 = imbinarize(I2);
C2 = bwboundaries(BW2,4); 
C2 = C2{1};
C2 = C2(1:5:end,:);

%Compute non invariant
[assign,cost] = shapeContext(C1, C2, 5, 6);

% The point matching is done so:
assign = assign(1:length(C1));
assign = [linspace(1,length(assign),length(assign)); assign];
assign(:,assign(2,:) == 0) = []; % For unequal cases
assign(:,assign(2,:) > length(C2)) = [];

%Visualize
vizSC(C1,C2,assign,'Small rotation of shape with non invariant shape context.');

%Compute invariant
[assign,cost] = shapeContextInv(C1, C2, 5, 6);

% The point matching is done so:
assign = assign(1:length(C1));
assign = [linspace(1,length(assign),length(assign)); assign];
assign(:,assign(2,:) == 0) = []; % For unequal cases
assign(:,assign(2,:) > length(C2)) = [];

%Visualize
vizSC(C1,C2,assign,'Small rotation of shape with invariant shape context.');

