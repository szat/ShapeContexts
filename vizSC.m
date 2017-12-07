function [ ] = vizSC( contour1, contour2, assign, str)
% Simple visualization tool for contour matching.

% Usage:   [ ] = vizSC( contour1, contour2, assign, str)
%
% Arguments:  
%         contour1  - First set of points m x 2
%         contour1  - Second set of points n x 2    
%           assign  - Correspondance between contour1 and contour2, should be 2 x min(m,n) 
%              str  - String that is the title

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

% Viz
z1 = zeros(length(contour1),1);
z2 = 500*ones(length(contour2),1);
contour1z = [contour1, z1];
contour2z = [contour2, z2];

figure;
hold on;
for i = 1:length(assign)
    P1 = contour1z(assign(1,i),:);
    P2 = contour2z(assign(2,i),:);
    pts = [P1; P2];
    p1 = plot3(pts(:,1), pts(:,2), pts(:,3), 'DisplayName',' 1.5', 'LineWidth', 1);
    p1.Color(4) = 0.5;
end
title(str);
camorbit(-20,-20)
hold off;
end

