function [ abs_angles ] = buildAngles( contour )
% [abs_angles] = buildAngles(contour) returns a matrix of pairwise angles between the points of contour. 
% abs_angles(i,j) represents the absolute angle between point i and j on the contour. 

% Example: a contour with m points
%{
m = 10;
contour = rand(m,2);
[abs_angles] = buildAngles(contour);
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

diff_rows = contour(:,1) - contour(:,1)';
diff_cols = contour(:,2) - contour(:,2)';
abs_angles = atan2(diff_rows,diff_cols);
end

