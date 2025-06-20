 function varargout = SIM_maze_diagonal(varargin)
% SIM_MAZE_DIAGONAL M-file for SIM_maze_diagonal.fig
%      SIM_MAZE_DIAGONAL, by itself, creates a new SIM_MAZE_DIAGONAL or raises the existing
%      singleton*.
%
%      H = SIM_MAZE_DIAGONAL returns the handle to a new SIM_MAZE_DIAGONAL or the handle to
%      the existing singleton*.
%
%      SIM_MAZE_DIAGONAL('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SIM_MAZE_DIAGONAL.M with the given input arguments.
%
%      SIM_MAZE_DIAGONAL('Property','Value',...) creates a new SIM_MAZE_DIAGONAL or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before SIM_maze_diagonal_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to SIM_maze_diagonal_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help SIM_maze_diagonal

% Last Modified by GUIDE v2.5 20-May-2013 10:20:38

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @SIM_maze_diagonal_OpeningFcn, ...
                   'gui_OutputFcn',  @SIM_maze_diagonal_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before SIM_maze_diagonal is made visible.
function SIM_maze_diagonal_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to SIM_maze_diagonal (see VARARGIN)

% Choose default command line output for SIM_maze_diagonal
handles.output = hObject;

for i = 1:256
    wall(i) = 0;
    wallc(i)= 3;
end;
wall(256)=3; wall(241)=1; wall(1)=2; wall(16)=2;
wallc(1)=2; wallc(120)=0; wallc(121)=2; wallc(136)=1;wallc(137)=3;
for i=242:255
    wall(i)=1;
end;
for i=2:15
    wall(i*16)=2;
end;
%
handles.wall = wall;
handles.wallo= wall;
handles.wallc= wallc;
handles.srch = 0;
%
W = 7.4;
L = 10;
%
% Mouse coordinates
center = [0;0.8];       %    ___
M1 = [ W/4; L/2]+center; %  /   \ 
M2 = [ W/2; L/4]+center; % |     |
M3 = [ W/2;-L/2]+center; % |     |
M4 = [-W/2;-L/2]+center; % |_____|
M5 = [-W/2; L/4]+center;
M6 = [-W/4; L/2]+center;
handles.mouse =[M1 M2 M3 M4 M5 M6 M1];
%
plot_maze(handles.wall)
t = (0:1/8192:0.1);
handles.s=0.4*exp(-15*t).*sin(2*pi*400*t);

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes SIM_maze_diagonal wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = SIM_maze_diagonal_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
%
% wall : wall information for east (ind*2+0) and north (ind*2+1) in each cell
clc
%
% Update handles structure
guidata(hObject, handles);


% --------------------------------------------------------------------
function File_Callback(hObject, eventdata, handles)
% hObject    handle to File (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function SaveMaze_Callback(hObject, eventdata, handles)
% hObject    handle to SaveMaze (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
wall = handles.wall;
uisave('wall');


% --------------------------------------------------------------------
function OpenMaze_Callback(hObject, eventdata, handles)
% hObject    handle to OpenMaze (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
file = uigetfile('*.mat');
if ~isequal(file, 0)
    %load file;
    temp=open(file);
    wall = temp.wall;
end
handles.wall = wall;
% initial values for search
src.v = 2; src.dir = 6;
goal = [239 240 242 271];
handles.src = src;
handles.goal = goal;
plot_maze(wall);
%
% initialize
for i = 1:256
    wallo(i) = 0;
    wallc(i)= 3;
end;
wallo(256)=3; wallo(241)=1; wallo(1)=2; wallo(16)=2;
wallc(1)=2; wallc(120)=0; wallc(121)=2; wallc(136)=1;wallc(137)=3;
for i=242:255
    wallo(i)=1;
end;
for i=2:15
    wallo(i*16)=2;
end;
%
handles.wallo= wallo;
handles.wallc= wallc;
handles.srch = 0;

% Update handles structure
guidata(hObject, handles);


% --- Executes on mouse press over figure background, over a disabled or
% --- inactive control, or over an axes background.
function figure1_WindowButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
wall = handles.wall;
hold;
yw = -9:18:279;
h_ax = gca;
cp = get(h_ax,'CurrentPoint');
pos = cp(1,1:2)+[9 9];
if (pos(1)>3 && pos(1)<285 && pos(2)>3 && pos(2)<285)
    if ((18-rem(pos(1),18))<3)
        x = floor(pos(1)/18);
        y = floor(pos(2)/18);
        if (rem(floor(wall(x+y*16+1)/2),2)==0)
            plot([x*18+9 x*18+9],[y*18-9 y*18+9],'r');
            wall(x+y*16+1) = wall(x+y*16+1) + 2;
        else
            plot([x*18+9 x*18+9],[y*18-9 y*18+9],'w');
            plot((x*18+9)*ones(size(yw)),yw,'rs','MarkerFaceColor','r','MarkerSize',2);
            wall(x+y*16+1) = wall(x+y*16+1) - 2;
        end;
    elseif ((18-rem(pos(1),18))>15)  
        x = (floor(pos(1)/18)-1);
        y = floor(pos(2)/18);
        if (rem(floor(wall(x+y*16+1)/2),2)==0)
            plot([x*18+9 x*18+9],[y*18-9 y*18+9],'r');
            wall(x+y*16+1) = wall(x+y*16+1) + 2;
        else
            plot([x*18+9 x*18+9],[y*18-9 y*18+9],'w');
            plot((x*18+9)*ones(size(yw)),yw,'rs','MarkerFaceColor','r','MarkerSize',2);
            wall(x+y*16+1) = wall(x+y*16+1) - 2;
        end;
    elseif ((18-rem(pos(2),18))<3)
        x = floor(pos(1)/18);
        y = floor(pos(2)/18);
        if (rem(wall(x+y*16+1),2)==0)
            plot([x*18-9 x*18+9],[y*18+9 y*18+9],'r');
            wall(x+y*16+1) = wall(x+y*16+1) + 1;
        else
            plot([x*18-9 x*18+9],[y*18+9 y*18+9],'w');
            plot(yw,(y*18+9)*ones(size(yw)),'rs','MarkerFaceColor','r','MarkerSize',2);
            wall(x+y*16+1) = wall(x+y*16+1) - 1;
        end;
    elseif ((18-rem(pos(2),18))>15)  
        x = floor(pos(1)/18);
        y = (floor(pos(2)/18)-1);
        if (rem(wall(x+y*16+1),2)==0)
            plot([x*18-9 x*18+9],[y*18+9 y*18+9],'r');
            wall(x+y*16+1) = wall(x+y*16+1) + 1;
        else
            plot([x*18-9 x*18+9],[y*18+9 y*18+9],'w');
            plot(yw,(y*18+9)*ones(size(yw)),'rs','MarkerFaceColor','r','MarkerSize',2);
            wall(x+y*16+1) = wall(x+y*16+1) - 1;
        end;
    end;
end;
hold;
handles.wall = wall;
% Update handles structure
guidata(hObject, handles);


% --- Executes on button press in CLEARmaze.
function CLEARmaze_Callback(hObject, eventdata, handles)
% hObject    handle to CLEARmaze (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
for i = 1:256
    wall(i) = 0;
    wallc(i)= 3;
end;
wall(256)=3; wall(241)=1; wall(1)=2; wall(16)=2;
wallc(1)=2; wallc(120)=0; wallc(121)=2; wallc(136)=1;wallc(137)=3;
for i=242:255
    wall(i)=1;
end;
for i=2:15
    wall(i*16)=2;
end;
%
handles.wall = wall;
handles.wallo= wall;
handles.wallc= wallc;
handles.srch = 0;
%
plot_maze(handles.wall)
% Update handles structure
guidata(hObject, handles);
%

% --- Executes on button press in dFLOOD.
function dFLOOD_Callback(hObject, eventdata, handles)
% hObject    handle to dFLOOD (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.fld = dflood_fill(handles.wall);
fld = handles.fld;
for j = 1:16
    for i = 1:16
        if (fld(2*i+(j-1)*32)~=0)
            text(18*(i-1),9+18*(j-1),num2str(fld(2*i+(j-1)*32)),'HorizontalAlignment','center','fontsize',9);
        end;
    end;
    for i = 1:16
        if (fld(2*i-1+(j-1)*32)~=0)
            text(9+18*(i-1),18*(j-1),num2str(fld(2*i-1+(j-1)*32)),'HorizontalAlignment','center','fontsize',9);
        end;
    end;
end;


% --- Executes on button press in dFLOODnew.
function dFLOODnew_Callback(hObject, eventdata, handles)
% hObject    handle to dFLOODnew (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[handles.fld, handles.best] = dflood_fill_new4(handles.wall);
fld = handles.fld;
best = handles.best;
best.path
%fld.dir(1:16)
for j = 1:16
    for i = 1:16
        if (fld.v(2*i+(j-1)*32)~=0)
            text(18*(i-1),9+18*(j-1),num2str(fld.v(2*i+(j-1)*32)),'HorizontalAlignment','center','fontsize',9);
            tmpdir = fld.dir(2*i+(j-1)*32);
            tmpitr = fld.itr(2*i+(j-1)*32);
            text(18*(i-1),9+18*(j-1)-4,strcat(num2str(tmpdir),', ',num2str(tmpitr)),'HorizontalAlignment','center','fontsize',9,'color','blue');
        end;
    end;
    for i = 1:16
        if (fld.v(2*i-1+(j-1)*32)~=0)
            text(9+18*(i-1),18*(j-1),num2str(fld.v(2*i-1+(j-1)*32)),'HorizontalAlignment','center','fontsize',9);
            tmpdir = fld.dir(2*i-1+(j-1)*32);
            tmpitr = fld.itr(2*i-1+(j-1)*32);
            text(9+18*(i-1),18*(j-1)-4,strcat(num2str(tmpdir),', ',num2str(tmpitr)),'HorizontalAlignment','center','fontsize',9,'color','blue');
        end;
    end;
end;
hold;
plot(best.x,best.y,'r','LineWidth',2);
hold;


% --- Executes on button press in pushbutton4.
function dFLOODsearch(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
ptime= 0.2;
src.v = 2; src.dir = 6;
goal = [239 240 242 271];
handles.srch = 0;
%src = handles.src;
%goal = handles.goal;
wallo= handles.wallo;
wallc= handles.wallc;
wall = handles.wall;
mouse= handles.mouse;
if (handles.srch==0)
    rectangle('Position',[-7 -7 14 14],'FaceColor',[1 0.7 0.7],'EdgeColor','w');
    hold;
    handles.pmouse(1)=plotmouse(1, 0, mouse);
    hold;
    %sound(handles.s);
    pause(ptime);
end;
while ( src.v~=goal(1) & src.v~=goal(2) & src.v~=goal(3) & src.v~=goal(4) )
    if (rem(src.v,2)==0) 
        if (src.dir>4)
            f_src=src.v/2;
            f_srcn=f_src+16;
            angle = 0;
        else
            f_src=src.v/2+16;
            f_srcn=f_src-16;
            angle = pi;
        end;
    else
        tmpd = rem(src.dir,7);
        if (tmpd<2)
            f_src=floor(src.v/2) + 1;
            f_srcn=f_src+1;
            angle = -pi/2;
        else
            f_src=floor(src.v/2) + 2;
            f_srcn=f_src-1;
            angle = pi/2;
        end;
    end;
    % update wallo information
    [wallo, wallc] = ud_wallo(f_srcn, wallo, wallc, wall);
    
    % find best path according to current maze information
    [fld, best] = dflood_fill_new_search_r2(wallo, goal, src);
    
    if (src.v==best.path(best.cnt))
        src.v = best.path(best.cnt-1);
        src.dir = best.dir(best.cnt-1);
        if ( rem(best.path(best.cnt-1),2)==0 )  % North wall
            if (best.dir(best.cnt-1)>4)
                angle = 0;
            else
                angle = pi;
            end;
        else
            tmpd = rem(best.dir(best.cnt-1),7);
            if (tmpd<2)
                angle = -pi/2;
            else
                angle = pi/2;
            end;
        end;
        % plot bestpath
        hold;
        if (handles.srch==0)
            rectangle('Position',[rem((f_srcn-1),16)*18-7 floor((f_srcn-1)/16)*18-7 14 14],'FaceColor',[1 0.7 0.7],'EdgeColor','w');
            if (best.cnt>1)
                bestpath=plot(best.x(1:best.cnt-1),best.y(1:best.cnt-1),'b','LineWidth',2);
            end;
            handles.srch = 1;
        else
            delete(bestpath);
            rectangle('Position',[rem((f_srcn-1),16)*18-7 floor((f_srcn-1)/16)*18-7 14 14],'FaceColor',[1 0.7 0.7],'EdgeColor','w');
            if (best.cnt>1)
                bestpath=plot(best.x(1:best.cnt-1),best.y(1:best.cnt-1),'b','LineWidth',2);
            end;
        end;
        pmouse(f_srcn)=plotmouse(f_srcn, angle, mouse);
        %sound(handles.s);
        hold;
        pause(ptime);
    else
        if ( rem(src.v,2)==0 )  % North wall
            if (src.dir>4)
                angle = 0;
            else
                angle = pi;
            end;
        else
            tmpd = rem(src.dir,7);
            if (tmpd<2)
                angle = -pi/2;
            else
                angle = pi/2;
            end;
        end;
        delete(bestpath);
        rectangle('Position',[rem((f_srcn-1),16)*18-7 floor((f_srcn-1)/16)*18-7 14 14],'FaceColor',[1 0 0],'EdgeColor','w');
        hold;
        %sound(handles.s);
        pmouse(f_srcn)=plotmouse(f_srcn, angle-pi, mouse);
        pause(ptime);
        if ( rem(best.path(best.cnt),2)==0 )  % North wall
            if (best.dir(best.cnt-1)>4)
                angle = 0;
            else
                angle = pi;
            end;
        else
            tmpd = rem(best.dir(best.cnt),7);
            if (tmpd<2)
                angle = -pi/2;
            else
                angle = pi/2;
            end;
        end;
        %hold;        
        %hold;
        %sound(handles.s);
        pmouse(f_src)=plotmouse(f_src, angle, mouse);
        pause(ptime);
        hold;        
        % plot bestpath
        hold;
        if (handles.srch==0)
            if (best.cnt>1)
                bestpath=plot(best.x(1:best.cnt),best.y(1:best.cnt),'b','LineWidth',2);
            end;
            handles.srch = 1;
        else
            if (best.cnt>1)
                bestpath=plot(best.x(1:best.cnt),best.y(1:best.cnt),'b','LineWidth',2);
            end;
        end;
        hold;
        pause(ptime+0.1);
        src.v = best.path(best.cnt);
        src.dir = best.dir(best.cnt);
    end;
end;

% save starting point for going back
tmp.v = best.path(best.cnt);
tmp.dir=best.dir(best.cnt);

src.v = 2; src.dir = 6;
[fld, best] = dflood_fill_new4(wallo);
[fldc, bestc]=dflood_fill_new4(wallc);
hold;
bestpath = plot(best.x(1:best.cnt),best.y(1:best.cnt),'b','LineWidth',2);
bestpathc= plot(bestc.x(1:bestc.cnt),bestc.y(1:bestc.cnt),'k--','LineWidth',2);
hold;
pause(3);
delete(bestpath);
delete(bestpathc);

% Update wall information at goal area
[wallo, wallc] = ud_wallo(120, wallo, wallc, wall);
[wallo, wallc] = ud_wallo(121, wallo, wallc, wall);
[wallo, wallc] = ud_wallo(136, wallo, wallc, wall);
[wallo, wallc] = ud_wallo(137, wallo, wallc, wall);

% Search back
src.v  = tmp.v; 
% Reverse the search direction
tmp.dir = tmp.dir + 4;
if (tmp.dir>8)
    tmp.dir = tmp.dir - 8;
end;
src.dir= tmp.dir;

goal = [2 2 2 2];
handles.srch = 0;
while ( src.v~=goal(1) & src.v~=goal(2) & src.v~=goal(3) & src.v~=goal(4) )
    if (rem(src.v,2)==0) 
        if (src.dir>4)
            f_src=src.v/2;
            f_srcn=f_src+16;
            angle = 0;
        else
            f_src=src.v/2+16;
            f_srcn=f_src-16;
            angle = pi;
        end;
    else
        tmpd = rem(src.dir,7);
        if (tmpd<2)
            f_src=floor(src.v/2) + 1;
            f_srcn=f_src+1;
            angle = -pi/2;
        else
            f_src=floor(src.v/2) + 2;
            f_srcn=f_src-1;
            angle = pi/2;
        end;
    end;
    % update wallo information
    [wallo, wallc] = ud_wallo(f_srcn, wallo, wallc, wall);
    
    % find best path according to current maze information
    [fld, best] = dflood_fill_new_search_r2(wallo, goal, src);
    
    if (src.v==best.path(best.cnt))
        src.v = best.path(best.cnt-1);
        src.dir = best.dir(best.cnt-1);
        if ( rem(best.path(best.cnt-1),2)==0 )  % North wall
            if (best.dir(best.cnt-1)>4)
                angle = 0;
            else
                angle = pi;
            end;
        else
            tmpd = rem(best.dir(best.cnt-1),7);
            if (tmpd<2)
                angle = -pi/2;
            else
                angle = pi/2;
            end;
        end;
        % plot bestpath
        hold;
        if (handles.srch==0)
            rectangle('Position',[rem((f_srcn-1),16)*18-7 floor((f_srcn-1)/16)*18-7 14 14],'FaceColor',[1 0.7 0.7],'EdgeColor','w');
            if (best.cnt>1)
                bestpath=plot(best.x(1:best.cnt-1),best.y(1:best.cnt-1),'b','LineWidth',2);
            end;
            handles.srch = 1;
        else
            delete(bestpath);
            rectangle('Position',[rem((f_srcn-1),16)*18-7 floor((f_srcn-1)/16)*18-7 14 14],'FaceColor',[1 0.7 0.7],'EdgeColor','w');
            if (best.cnt>1)
                bestpath=plot(best.x(1:best.cnt-1),best.y(1:best.cnt-1),'b','LineWidth',2);
            end;
        end;
        pmouse(f_srcn)=plotmouse(f_srcn, angle, mouse);
        %sound(handles.s);
        hold;
        pause(ptime);
    else
        if ( rem(src.v,2)==0 )  % North wall
            if (src.dir>4)
                angle = 0;
            else
                angle = pi;
            end;
        else
            tmpd = rem(src.dir,7);
            if (tmpd<2)
                angle = -pi/2;
            else
                angle = pi/2;
            end;
        end;
        if (handles.srch==0)
            handles.srch=1;
        else
            delete(bestpath);
        end;
        rectangle('Position',[rem((f_srcn-1),16)*18-7 floor((f_srcn-1)/16)*18-7 14 14],'FaceColor',[1 0 0],'EdgeColor','w');
        hold;
        %sound(handles.s);
        pmouse(f_srcn)=plotmouse(f_srcn, angle-pi, mouse);
        pause(ptime);
        if ( rem(best.path(best.cnt),2)==0 )  % North wall
            if (best.dir(best.cnt-1)>4)
                angle = 0;
            else
                angle = pi;
            end;
        else
            tmpd = rem(best.dir(best.cnt),7);
            if (tmpd<2)
                angle = -pi/2;
            else
                angle = pi/2;
            end;
        end;
        %hold;        
        %hold;
        %sound(handles.s);
        pmouse(f_src)=plotmouse(f_src, angle, mouse);
        pause(ptime);
        hold;        
        % plot bestpath
        hold;
        if (handles.srch==0)
            if (best.cnt>1)
                bestpath=plot(best.x(1:best.cnt),best.y(1:best.cnt),'b','LineWidth',2);
            end;
            handles.srch = 1;
        else
            if (best.cnt>1)
                bestpath=plot(best.x(1:best.cnt),best.y(1:best.cnt),'b','LineWidth',2);
            end;
        end;
        hold;
        pause(ptime+0.1);
        src.v = best.path(best.cnt);
        src.dir = best.dir(best.cnt);
    end;
end;

src.v = 2; src.dir = 6;
[fld, best] = dflood_fill_new4(wallo);
[fldc, bestc]=dflood_fill_new4(wallc);
hold;
bestpath = plot(best.x(1:best.cnt),best.y(1:best.cnt),'b','LineWidth',2);
bestpathc= plot(bestc.x(1:bestc.cnt),bestc.y(1:bestc.cnt),'k--','LineWidth',2);
hold;
pause(3);
delete(bestpath);
delete(bestpathc);
%
% search goal again
handles.srch = 0;
goal = handles.goal;
while ( src.v~=goal(1) & src.v~=goal(2) & src.v~=goal(3) & src.v~=goal(4) )
    if (rem(src.v,2)==0) 
        if (src.dir>4)
            f_src=src.v/2;
            f_srcn=f_src+16;
            angle = 0;
        else
            f_src=src.v/2+16;
            f_srcn=f_src-16;
            angle = pi;
        end;
    else
        tmpd = rem(src.dir,7);
        if (tmpd<2)
            f_src=floor(src.v/2) + 1;
            f_srcn=f_src+1;
            angle = -pi/2;
        else
            f_src=floor(src.v/2) + 2;
            f_srcn=f_src-1;
            angle = pi/2;
        end;
    end;
    % update wallo information
    [wallo, wallc] = ud_wallo(f_srcn, wallo, wallc, wall);
    
    % find best path according to current maze information
    [fld, best] = dflood_fill_new_search_r2(wallo, goal, src);
    
    if (src.v==best.path(best.cnt))
        src.v = best.path(best.cnt-1);
        src.dir = best.dir(best.cnt-1);
        if ( rem(best.path(best.cnt-1),2)==0 )  % North wall
            if (best.dir(best.cnt-1)>4)
                angle = 0;
            else
                angle = pi;
            end;
        else
            tmpd = rem(best.dir(best.cnt-1),7);
            if (tmpd<2)
                angle = -pi/2;
            else
                angle = pi/2;
            end;
        end;
        % plot bestpath
        hold;
        if (handles.srch==0)
            rectangle('Position',[rem((f_srcn-1),16)*18-7 floor((f_srcn-1)/16)*18-7 14 14],'FaceColor',[1 0.7 0.7],'EdgeColor','w');
            if (best.cnt>1)
                bestpath=plot(best.x(1:best.cnt-1),best.y(1:best.cnt-1),'b','LineWidth',2);
            end;
            handles.srch = 1;
        else
            delete(bestpath);
            rectangle('Position',[rem((f_srcn-1),16)*18-7 floor((f_srcn-1)/16)*18-7 14 14],'FaceColor',[1 0.7 0.7],'EdgeColor','w');
            if (best.cnt>1)
                bestpath=plot(best.x(1:best.cnt-1),best.y(1:best.cnt-1),'b','LineWidth',2);
            end;
        end;
        pmouse(f_srcn)=plotmouse(f_srcn, angle, mouse);
        %sound(handles.s);
        hold;
        pause(ptime);
    else
        if ( rem(src.v,2)==0 )  % North wall
            if (src.dir>4)
                angle = 0;
            else
                angle = pi;
            end;
        else
            tmpd = rem(src.dir,7);
            if (tmpd<2)
                angle = -pi/2;
            else
                angle = pi/2;
            end;
        end;
        delete(bestpath);
        rectangle('Position',[rem((f_srcn-1),16)*18-7 floor((f_srcn-1)/16)*18-7 14 14],'FaceColor',[1 0 0],'EdgeColor','w');
        hold;
        %sound(handles.s);
        pmouse(f_srcn)=plotmouse(f_srcn, angle-pi, mouse);
        pause(ptime);
        if ( rem(best.path(best.cnt),2)==0 )  % North wall
            if (best.dir(best.cnt-1)>4)
                angle = 0;
            else
                angle = pi;
            end;
        else
            tmpd = rem(best.dir(best.cnt),7);
            if (tmpd<2)
                angle = -pi/2;
            else
                angle = pi/2;
            end;
        end;
        %hold;        
        %hold;
        %sound(handles.s);
        pmouse(f_src)=plotmouse(f_src, angle, mouse);
        pause(ptime);
        hold;        
        % plot bestpath
        hold;
        if (handles.srch==0)
            if (best.cnt>1)
                bestpath=plot(best.x(1:best.cnt),best.y(1:best.cnt),'b','LineWidth',2);
            end;
            handles.srch = 1;
        else
            if (best.cnt>1)
                bestpath=plot(best.x(1:best.cnt),best.y(1:best.cnt),'b','LineWidth',2);
            end;
        end;
        hold;
        pause(ptime+0.1);
        src.v = best.path(best.cnt);
        src.dir = best.dir(best.cnt);
    end;
end;

% save starting point for going back
tmp.v = best.path(best.cnt);
tmp.dir=best.dir(best.cnt);

src.v = 2; src.dir = 6;
[fld, best] = dflood_fill_new4(wallo);
[fldc, bestc]=dflood_fill_new4(wallc);
hold;
bestpath = plot(best.x(1:best.cnt),best.y(1:best.cnt),'b','LineWidth',2);
bestpathc= plot(bestc.x(1:bestc.cnt),bestc.y(1:bestc.cnt),'k--','LineWidth',2);
hold;
pause(3);
delete(bestpath);
delete(bestpathc);
%
% Search back again
src.v  = tmp.v; 
% Reverse the search direction
tmp.dir = tmp.dir + 4;
if (tmp.dir>8)
    tmp.dir = tmp.dir - 8;
end;
src.dir= tmp.dir;

goal = [2 2 2 2];
handles.srch = 0;
while ( src.v~=goal(1) & src.v~=goal(2) & src.v~=goal(3) & src.v~=goal(4) )
    if (rem(src.v,2)==0) 
        if (src.dir>4)
            f_src=src.v/2;
            f_srcn=f_src+16;
            angle = 0;
        else
            f_src=src.v/2+16;
            f_srcn=f_src-16;
            angle = pi;
        end;
    else
        tmpd = rem(src.dir,7);
        if (tmpd<2)
            f_src=floor(src.v/2) + 1;
            f_srcn=f_src+1;
            angle = -pi/2;
        else
            f_src=floor(src.v/2) + 2;
            f_srcn=f_src-1;
            angle = pi/2;
        end;
    end;
    % update wallo information
    [wallo, wallc] = ud_wallo(f_srcn, wallo, wallc, wall);
    
    % find best path according to current maze information
    [fld, best] = dflood_fill_new_search_r2(wallo, goal, src);
    
    if (src.v==best.path(best.cnt))
        src.v = best.path(best.cnt-1);
        src.dir = best.dir(best.cnt-1);
        if ( rem(best.path(best.cnt-1),2)==0 )  % North wall
            if (best.dir(best.cnt-1)>4)
                angle = 0;
            else
                angle = pi;
            end;
        else
            tmpd = rem(best.dir(best.cnt-1),7);
            if (tmpd<2)
                angle = -pi/2;
            else
                angle = pi/2;
            end;
        end;
        % plot bestpath
        hold;
        if (handles.srch==0)
            rectangle('Position',[rem((f_srcn-1),16)*18-7 floor((f_srcn-1)/16)*18-7 14 14],'FaceColor',[1 0.7 0.7],'EdgeColor','w');
            if (best.cnt>1)
                bestpath=plot(best.x(1:best.cnt-1),best.y(1:best.cnt-1),'b','LineWidth',2);
            end;
            handles.srch = 1;
        else
            delete(bestpath);
            rectangle('Position',[rem((f_srcn-1),16)*18-7 floor((f_srcn-1)/16)*18-7 14 14],'FaceColor',[1 0.7 0.7],'EdgeColor','w');
            if (best.cnt>1)
                bestpath=plot(best.x(1:best.cnt-1),best.y(1:best.cnt-1),'b','LineWidth',2);
            end;
        end;
        pmouse(f_srcn)=plotmouse(f_srcn, angle, mouse);
        %sound(handles.s);
        hold;
        pause(ptime);
    else
        if ( rem(src.v,2)==0 )  % North wall
            if (src.dir>4)
                angle = 0;
            else
                angle = pi;
            end;
        else
            tmpd = rem(src.dir,7);
            if (tmpd<2)
                angle = -pi/2;
            else
                angle = pi/2;
            end;
        end;
        if (handles.srch==0)
            handles.srch=1;
        else
            delete(bestpath);
        end;
        rectangle('Position',[rem((f_srcn-1),16)*18-7 floor((f_srcn-1)/16)*18-7 14 14],'FaceColor',[1 0 0],'EdgeColor','w');
        hold;
        %sound(handles.s);
        pmouse(f_srcn)=plotmouse(f_srcn, angle-pi, mouse);
        pause(ptime);
        if ( rem(best.path(best.cnt),2)==0 )  % North wall
            if (best.dir(best.cnt-1)>4)
                angle = 0;
            else
                angle = pi;
            end;
        else
            tmpd = rem(best.dir(best.cnt),7);
            if (tmpd<2)
                angle = -pi/2;
            else
                angle = pi/2;
            end;
        end;
        %hold;        
        %hold;
        %sound(handles.s);
        pmouse(f_src)=plotmouse(f_src, angle, mouse);
        pause(ptime);
        hold;        
        % plot bestpath
        hold;
        if (handles.srch==0)
            if (best.cnt>1)
                bestpath=plot(best.x(1:best.cnt),best.y(1:best.cnt),'b','LineWidth',2);
            end;
            handles.srch = 1;
        else
            if (best.cnt>1)
                bestpath=plot(best.x(1:best.cnt),best.y(1:best.cnt),'b','LineWidth',2);
            end;
        end;
        hold;
        pause(ptime+0.1);
        src.v = best.path(best.cnt);
        src.dir = best.dir(best.cnt);
    end;
end;

src.v = 2; src.dir = 6;
[fld, best] = dflood_fill_new4(wallo);
[fldc, bestc]=dflood_fill_new4(wallc);
hold;
bestpath = plot(best.x(1:best.cnt),best.y(1:best.cnt),'b','LineWidth',2);
bestpathc= plot(bestc.x(1:bestc.cnt),bestc.y(1:bestc.cnt),'k--','LineWidth',2);
hold;


% show FLOOD values
%
% for j = 1:16
%     for i = 1:16
%         if (fld.v(2*i+(j-1)*32)~=0)
%             text(18*(i-1),9+18*(j-1),num2str(fld.v(2*i+(j-1)*32)),'HorizontalAlignment','center','fontsize',9);
%             tmpdir = fld.dir(2*i+(j-1)*32);
%             tmpitr = fld.itr(2*i+(j-1)*32);
%             text(18*(i-1),9+18*(j-1)-4,strcat(num2str(tmpdir),', ',num2str(tmpitr)),'HorizontalAlignment','center','fontsize',9,'color','blue');
%         end;
%     end;
%     for i = 1:16
%         if (fld.v(2*i-1+(j-1)*32)~=0)
%             text(9+18*(i-1),18*(j-1),num2str(fld.v(2*i-1+(j-1)*32)),'HorizontalAlignment','center','fontsize',9);
%             tmpdir = fld.dir(2*i-1+(j-1)*32);
%             tmpitr = fld.itr(2*i-1+(j-1)*32);
%             text(9+18*(i-1),18*(j-1)-4,strcat(num2str(tmpdir),', ',num2str(tmpitr)),'HorizontalAlignment','center','fontsize',9,'color','blue');
%         end;
%     end;
% end;
handles.wallc = wallc;
handles.wallo = wallo;
% Update handles structure
guidata(hObject, handles);
