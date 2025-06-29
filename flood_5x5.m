clc
clear
%
% maze wall information: wall(1:25), value = 0x------EN
% index: cell_number, east_wall(bit1:0x02), north_wall(bit0:0x01);
% 0:w/o wall, 1: with wall
%
wall = uint8([2 0 1 0 3 0 1 0 1 2 3 0 1 0 2 0 2 1 2 3 3 1 1 1 3]);
EAST = uint8(2);    %0b00000010;
NORTH= uint8(1);    %0b00000001;
%
% flood information: flood.value(1:25);
%
% set Goal cell
flood.goal = 25;
flood.start=  1;
%
flood.value = ones(25,1)*-1; 
flood.value(flood.start) = 0; 
flood.wave = ones(2,10)*-1;
flood.wave(1,1) = 1;
%
count = 1; % flood flows from cell 1
tmp_count = 0;
value = 0; % initial flood value
%offset = 0;
offset = 1;
while(flood.value(flood.goal) < 0)
    for i = 1:count
        if (flood.wave(offset,i)+1)<=25
            if ((flood.value(flood.wave(offset,i)+1) < 0)  & (bitand(wall(flood.wave(offset,i)),EAST) == 0) )  % east bound check
                flood.value(flood.wave(offset,i)+1) = value + 1;                    % flood value assignment
                if (offset==1)
                    flood.wave(offset+1,tmp_count+1) = flood.wave(offset,i) + 1; 	% cell number is saved
                else
                    flood.wave(offset-1,tmp_count+1) = flood.wave(offset,i) + 1;
                end;
                tmp_count = tmp_count + 1;                                          % count of next flood value cells
            end;
        end;
        if (flood.wave(offset,i)-5)>0
            if ((flood.value(flood.wave(offset,i)-5) < 0)  & (bitand(wall(flood.wave(offset,i)-5),NORTH) == 0) )  % south bound check
                flood.value(flood.wave(offset,i)-5) = value + 1;
                if (offset==1)
                    flood.wave(offset+1,tmp_count+1) = flood.wave(offset,i) - 5; 	% cell number is saved
                else
                    flood.wave(offset-1,tmp_count+1) = flood.wave(offset,i) - 5;
                end;
                tmp_count = tmp_count + 1;
            end;
        end;
        if (flood.wave(offset,i)-1)>0
            if ((flood.value(flood.wave(offset,i)-1) < 0)  & (bitand(wall(flood.wave(offset,i)-1),EAST) == 0) )  % west bound check
                flood.value(flood.wave(offset,i)-1) = value + 1;
                if (offset==1)
                    flood.wave(offset+1,tmp_count+1) = flood.wave(offset,i) - 1;   % cell number is saved
                    %offset
                else
                    flood.wave(offset-1,tmp_count+1) = flood.wave(offset,i) - 1;
                end;
                tmp_count = tmp_count + 1;
            end;
        end;
        if (flood.wave(offset,i)+5)<=25
            if ((flood.value(flood.wave(offset,i)+5) < 0)  & (bitand(wall(flood.wave(offset,i)),NORTH) == 0) )  % north bound check
                flood.value(flood.wave(offset,i)+5) = value + 1;
                if (offset==1)
                    flood.wave(offset+1,tmp_count+1) = flood.wave(offset,i) + 5;	% cell number is saved
                else
                    flood.wave(offset-1,tmp_count+1) = flood.wave(offset,i) + 5;
                end;
                tmp_count = tmp_count + 1;
            end;
        end;
    end;
    value = value + 1;
    if offset==1
        offset=2;
    else
        offset=1;
    end;
    count =  tmp_count;
    tmp_count = 0;
    flood_m = [flood.value(21:25)';flood.value(16:20)';flood.value(11:15)';flood.value(6:10)';flood.value(1:5)']
    pause(1);
end;
%
% find the directions for the shortest path
% dir(flood.value(1)+1) is used for cell directions, dir(1) is for the
% start cell, 1:east, 3:south, 5:west, 7:north, 0:stop
%
dir = ones(flood.value(flood.goal),1)*-1; 
number = flood.goal; done = 0;
for i = 1:flood.value(flood.goal)+1
    if flood.value(number)==0
        dir(i) = 0;
        dir2(:,i) = [number;0];
    end;
    if (rem(number,5)>0)
        if ((bitand(wall(number),EAST)==0) & (flood.value(number+1) == flood.value(number)-1) & done == 0)      %  east bound
            dir(i) = 1;
            dir2(:,i) = [number;1];
            number = number + 1; done = 1;
            [number dir(i) i];
        end;
    end;
    if (number>5)
        if ((bitand(wall(number-5),NORTH)==0) & (flood.value(number-5) == flood.value(number)-1) & done == 0)   %  south bound
            dir(i) = 3;
            dir2(:,i) = [number;3];
            number = number - 5; done = 1;
            [number dir(i) i];
        end;
    end;
    if (rem(number,5)~=1)
        if ((bitand(wall(number-1),EAST)==0) & (flood.value(number-1) == flood.value(number)-1) & done == 0)    %  west bound
            dir(i) = 5;
            dir2(:,i) = [number;5];
            number = number - 1; done = 1;
            [number dir(i) i];
        end;
    end;
    if (number<21)
        if ((bitand(wall(number),NORTH)==0) & (flood.value(number+5) == flood.value(number)-1) & done == 0)     %  north bound
            dir(i) = 7;
            dir2(:,i) = [number;7];
            number = number + 5; done = 1;
            [number dir(i) i];
        end;
    end;
    done = 0;
end;    
dir2
