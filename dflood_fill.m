function fld = dflood_fill(wall)
%
% initialize
fld = zeros(1,512);     % flood values
f_start=1;
%
% initial variables
fld(f_start+1) = 0.5; 	% flood value start from 1, 0 means unvisited 
wave(1,1) = f_start*2;	% initial wavefront at north of cell 1
f_cnt(1) = 1;			% no. of cells at wavefront 0
f_cnt(2) = 0;			% no. of cells at wavefront 1
ind0 = 0;				% index for wavefront 0
ind1 = 1;               % index for wavefront 1
f_val = [1 0.71];		% initial flood value to be filled
TO_GOAL=	0;
BACK_HOME=	1;
EAST = 0; NORTH_EAST = 1; NORTH = 2; NORTH_WEST = 3;
WEST = 4; SOUTH_WEST = 5; SOUTH = 6; SOUTH_EAST = 7;
STOP = 9;
%mode=0;

%------------------------------------ FLOOD ALGORITHM -----------------------------
while ( (fld(238+1) | fld(240+2) | fld(238+2)| fld(270+1)) == 0) 
	for ind=0:f_cnt(ind0+1)-1
        mode = rem(wave(ind0+1,ind+1),2);
        if (mode == 0)  % north wall
            if ( bitand(wall(wave(ind0+1,ind+1)/2+16),2)==0 )       % NORTHEAST
                if (fld(wave(ind0+1,ind+1)+31)==0)
                    fld(wave(ind0+1,ind+1)+31) = fld(wave(ind0+1,ind+1)) + f_val(2);
                    wave(ind1+1,f_cnt(ind1+1)+1) = wave(ind0+1,ind+1)+31;
                    f_cnt(ind1+1)=f_cnt(ind1+1)+1;
                end;
            end;
            if ( bitand(wall(wave(ind0+1,ind+1)/2+16),1)==0 )       % NORTH
                if (fld(wave(ind0+1,ind+1)+32)==0)
                    fld(wave(ind0+1,ind+1)+32) = fld(wave(ind0+1,ind+1)) + f_val(1);
                    wave(ind1+1,f_cnt(ind1+1)+1) = wave(ind0+1,ind+1)+32;
                    f_cnt(ind1+1)=f_cnt(ind1+1)+1;
                end;
            end;
            if (rem(wave(ind0+1,ind+1)/2,16)~=1)                    % NOT at the 1st column
                if ( bitand(wall(wave(ind0+1,ind+1)/2+15),2)==0 )   % NORTHWEST
                    if (fld(wave(ind0+1,ind+1)+29)==0)
                        fld(wave(ind0+1,ind+1)+29) = fld(wave(ind0+1,ind+1)) + f_val(2);
                        wave(ind1+1,f_cnt(ind1+1)+1) = wave(ind0+1,ind+1)+29;
                        f_cnt(ind1+1)=f_cnt(ind1+1)+1;
                    end;
                end;
            end;
            if ( bitand(wall(wave(ind0+1,ind+1)/2),2)==0 )          % SOUTHEAST
                if (fld(wave(ind0+1,ind+1)-1)==0)
                    fld(wave(ind0+1,ind+1)-1) = fld(wave(ind0+1,ind+1)) + f_val(2);
                    wave(ind1+1,f_cnt(ind1+1)+1) = wave(ind0+1,ind+1)-1;
                    f_cnt(ind1+1)=f_cnt(ind1+1)+1;
                end;
            end;
            if ( wave(ind0+1,ind+1) > 32 )                          % NOT at the 1st row
                if ( bitand(wall(wave(ind0+1,ind+1)/2-16),1)==0 )   % SOUTH
                    if (fld(wave(ind0+1,ind+1)-32)==0)
                        fld(wave(ind0+1,ind+1)-32) = fld(wave(ind0+1,ind+1)) + f_val(1);
                        wave(ind1+1,f_cnt(ind1+1)+1) = wave(ind0+1,ind+1)-32;
                        f_cnt(ind1+1)=f_cnt(ind1+1)+1;
                    end;
                end;
            end;
            if (rem(wave(ind0+1,ind+1),32)~=2)                      % NOT at the 1st column
                if ( bitand(wall(wave(ind0+1,ind+1)/2-1),2)==0 )    % SOUTHWEST
                    if (fld(wave(ind0+1,ind+1)-3)==0)
                        fld(wave(ind0+1,ind+1)-3) = fld(wave(ind0+1,ind+1)) + f_val(2);
                        wave(ind1+1,f_cnt(ind1+1)+1) = wave(ind0+1,ind+1)-3;
                        f_cnt(ind1+1)=f_cnt(ind1+1)+1;
                    end;
                end;
            end;
        else  % EAST wall    
            if ( bitand(wall((wave(ind0+1,ind+1)+1)/2),1)==0 )      % NORTHWEST
                if (fld(wave(ind0+1,ind+1)+1)==0)
                    fld(wave(ind0+1,ind+1)+1) = fld(wave(ind0+1,ind+1)) + f_val(2);
                    wave(ind1+1,f_cnt(ind1+1)+1) = wave(ind0+1,ind+1)+1;
                    f_cnt(ind1+1)=f_cnt(ind1+1)+1;
                end;
            end;
            if ( rem(wave(ind0+1,ind+1),32)~=1 )                    % NOT at the 1st column
                if ( bitand(wall((wave(ind0+1,ind+1)+1)/2-1),2)==0 )% WEST
                    if (fld(wave(ind0+1,ind+1)-2)==0)
                        fld(wave(ind0+1,ind+1)-2) = fld(wave(ind0+1,ind+1)) + f_val(1);
                        wave(ind1+1,f_cnt(ind1+1)+1) = wave(ind0+1,ind+1)-2;
                        f_cnt(ind1+1)=f_cnt(ind1+1)+1;
                    end;
                end;
            end;
            if ( (rem(wave(ind0+1,ind+1),32)~=1)&&(wave(ind0+1,ind+1)>32) )% NOT at the 1st column and row
                if ( bitand(wall((wave(ind0+1,ind+1)+1)/2-16),1)==0 )% SOUTHWEST
                    if (fld(wave(ind0+1,ind+1)-31)==0)
                        fld(wave(ind0+1,ind+1)-31) = fld(wave(ind0+1,ind+1)) + f_val(2);
                        wave(ind1+1,f_cnt(ind1+1)+1) = wave(ind0+1,ind+1)-31;
                        f_cnt(ind1+1)=f_cnt(ind1+1)+1;
                    end;
                end;
            end;
            if ( bitand(wall((wave(ind0+1,ind+1)+1)/2+1),1)==0 )        % NORTHEAST
                if (fld(wave(ind0+1,ind+1)+3)==0)
                    fld(wave(ind0+1,ind+1)+3) = fld(wave(ind0+1,ind+1)) + f_val(2);
                    wave(ind1+1,f_cnt(ind1+1)+1) = wave(ind0+1,ind+1)+3;
                    f_cnt(ind1+1)=f_cnt(ind1+1)+1;
                end;
            end;
            if ( bitand(wall((wave(ind0+1,ind+1)+1)/2+1),2)==0 )        % EAST
                if (fld(wave(ind0+1,ind+1)+2)==0)
                    fld(wave(ind0+1,ind+1)+2) = fld(wave(ind0+1,ind+1)) + f_val(1);
                    wave(ind1+1,f_cnt(ind1+1)+1) = wave(ind0+1,ind+1)+2;
                    f_cnt(ind1+1)=f_cnt(ind1+1)+1;
                end;
            end;
            if ( wave(ind0+1,ind+1)>32 )                            % NOT at the 1st row
                if ( bitand(wall((wave(ind0+1,ind+1)+1)/2-15),1)==0 )% SOUTHEAST
                    if (fld(wave(ind0+1,ind+1)-29)==0)
                        fld(wave(ind0+1,ind+1)-29) = fld(wave(ind0+1,ind+1)) + f_val(2);
                        wave(ind1+1,f_cnt(ind1+1)+1) = wave(ind0+1,ind+1)-29;
                        f_cnt(ind1+1)=f_cnt(ind1+1)+1;
                    end;
                end;
            end;    
        end;
    end;
	f_cnt(ind0+1)=0; % reset the wavefront count
	
    if (ind0==0) 
        ind0 = 1;
        ind1 = 0;
    else 
        ind0 = 0;
        ind1 = 1;
    end;	
end;
%
% debug
a1 = 1:2:21;
a2 = 2:2:22;
for i = 1:15
    a1 = [i*32+1:2:i*32+21;a1];
    a2 = [i*32+2:2:i*32+22;a2];
end;
%fld_a1 = fld(a1)
%fld_a2 = fld(a2)
% 		if (fld(120) > 0) 
% 			length_1 = fld(120);
% 			path(length_1) = 120;		
%         elseif (fld(121) > 0) 
% 			length_1 = fld(121);
% 			path(length_1) = 121;		
%         elseif (fld(136) > 0) 
% 			length_1 = fld(136);
% 			path(length_1) = 136;		
%         elseif (fld(137) > 0) 
% 			length_1 = fld(137);
% 			path(length_1) = 137;		
%         end;
%         dir(length_1) = STOP;

%
% number ¥Ø«e¦ì¸m
% north:0(2), east=1(0), south=2(6), west=3(4), stop=9;  for dir[xx]
% 0: east, 1: north-east, 2: north, 3: north-west, 4: west,
% 5: south-west, 6: south, 7: south-east
% length_1: number of cells in the shortest path minus 1
% from f_start to GOAL --> follow the directions dir[length_1] to dir[0]
	
%length_1 = flood[path[0]]-1; // because flood value starts from 1
%path[length_1] = f_start;
% path(1) = f_start+1;
% for ind=length_1:-1:2 
% 	number = path(ind);
% 	if ( ( bitand(wall(number),2)==0 ) && (fld(number+1)==(fld(number)-1)) ) 
% 			path(ind-1) = number+1;
% 			dir(ind-1) = WEST;
%     elseif ( (bitand(wall(number),8)==0) && (fld(number-1)==(fld(number)-1)) )  
% 			path(ind-1) = number-1;
% 			dir(ind-1) = EAST;
%     elseif ( (bitand(wall(number),4)==0) && (fld(number-16)==(fld(number)-1)) ) 
% 			path(ind-1) = number-16;
% 			dir(ind-1) = NORTH;
%     elseif ( (bitand(wall(number),1)==0) && (fld(number+16)==(fld(number)-1)) ) 
% 			path(ind-1) = number+16;
% 			dir(ind-1) = SOUTH;
%     end;	
% end;
