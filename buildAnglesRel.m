function [ rel_angles ] = buildAnglesRel( contour )
% Angles measured with respect to the tangent at the contour point. Works best with nice contours. 
% [rel_angles] = buildAnglesRel(contour) returns a matrix of pairwise angles between the points of contour. 
% rel_angles(i,j) represents the relative angle between point i and j on the contour. 
% For this to work best, it is better to have the point on the contour more or less equidistant. 
% To have contours with equidistant points, download for instance the project "buildContour".

% Example: a contour with m points
%{
m = 10;
contour = rand(m,2);
[rel_angles] = buildAnglesRel(contour);
%}

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

%creates relative angles of the contour, use for SO2 invariance

string = diff(contour);
norms = sqrt(sum(string.^2,2));
delta = mean(norms(1:end-1));

%Tangent
dR = -(circshift(contour(:,1), 1) - circshift(contour(:,1),-1))/(2*delta);
dC = -(circshift(contour(:,2), 1) - circshift(contour(:,2),-1))/(2*delta);

%Smoothen a bit
dR =  dR * 6/8 + circshift(dR, 1)/8 + circshift(dR,-1)/8;
dC =  dC * 6/8 + circshift(dC, 1)/8 + circshift(dC,-1)/8;

%Normalize
dR = dR ./ sqrt(dR.^2 + dC.^2);
dC = dC ./ sqrt(dR.^2 + dC.^2);

%Normal
tempR = dR;
tempC = dC;
dRperp = tempC;
dCperp = -tempR; 

angles = zeros(length(contour), length(contour));
R1 = [ 0  1  0 ]';
C1 = [ 0  0  1 ]';
for i = 1:length(contour)
    R2 = [ contour(i,1) contour(i,1)+ dR(i)  contour(i,1)+dRperp(i)]';
    C2 = [ contour(i,2) contour(i,2)+ dC(i)  contour(i,2)+dCperp(i)]';
    tform = fitgeotrans([R2 C2],[R1 C1],'affine'); 
    [tR, tC] = transformPointsForward(tform, contour(:,1), contour(:,2));
    angles(i,:) = atan2(tR, tC);
end
angles(eye(size(angles))==1) = 0;

rel_angles = angles;
end

