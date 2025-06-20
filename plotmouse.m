function hP = plotmouse(cn, angle, mouse);
% W = 7.4;
% L = 10;
%
% Mouse coordinates
% center = [0;0.8];       %    ___
% M1 = [ W/4; L/2]+center; %  /   \ 
% M2 = [ W/2; L/4]+center; % |     |
% M3 = [ W/2;-L/2]+center; % |     |
% M4 = [-W/2;-L/2]+center; % |_____|
% M5 = [-W/2; L/4]+center;
% M6 = [-W/4; L/2]+center;
% mouse =[M1 M2 M3 M4 M5 M6 M1];
%angle = pi/2;
rot = [cos(angle) -sin(angle);sin(angle) cos(angle)];
mouse_r = rot*mouse;
mouse_x = rem(cn-1,16)*18;
mouse_y = floor((cn-1)/16)*18;
hP = plot(mouse_r(1,:)+mouse_x,mouse_r(2,:)+mouse_y,'k','LineWidth',1);
% hP = fill(mouse_r(1,:)+mouse_x,mouse_r(2,:)+mouse_y,'b','LineWidth',1);
