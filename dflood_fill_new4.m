function [fld, best] = dflood_fill_new4(wall)
%
% initialize
fld.v = zeros(1,512);       % flood values
fld.dir = -ones(1,512);     % flood directions
fld.itr = zeros(1,512);     % flood direction iterations
f_src=1;
goal = [239 240 242 271];
dir567 = [29 32 31];
dir123 = [-1 -32 -3];
dir345 = [-31 -2 1];
dir107 = [-29 2 3];
%
% initial variables
%
% directions
EAST = 0; NORTHEAST = 7; NORTH = 6; NORTHWEST = 5;
WEST = 4; SOUTHWEST = 3; SOUTH = 2; SOUTHEAST = 1;
STOP = 9;
%
% weights for acceleration and decleration
drun = [0.49 0.33 0.26 0.24 0.24 0.24;
        0.07 0.17 0.25 0.31 0.35 0.36];
srun = [0.63 0.40 0.32 0.29 0.29 0.29;
        0.11 0.24 0.35 0.43 0.47 0.48];
%
fld.v(f_src+1) = 0.5;   % flood value start from 1, 0 means unvisited 
fld.dir(f_src+1) = NORTH;
fld.itr(f_src+1) = 1;
wave(1,1) = f_src*2;	% initial wavefront at north of cell 1, is border no.
f_cnt(1) = 1;			% no. of cells at wavefront 0
f_cnt(2) = 0;			% no. of cells at wavefront 1
ind0 = 0;				% index for wavefront 0
ind1 = 1;               % index for wavefront 1
f_val = [1 0.71];		% initial flood value to be filled
TO_GOAL=	0;
BACK_HOME=	1;
%mode=0;

%------------------------------------ FLOOD ALGORITHM -----------------------------
while ( fld.v(238+1)==0 | fld.v(240+2)==0 | fld.v(238+2)==0 | fld.v(270+1)==0) 
	for ind=0:f_cnt(ind0+1)-1
        mode = rem(wave(ind0+1,ind+1),2);
        tmp_dir = fld.dir(wave(ind0+1,ind+1));
        tmp_dir2= rem(fld.dir(wave(ind0+1,ind+1)),7);
        if ((mode==0) && (tmp_dir>4))    % north wall and flow NORTHWEST, NORTH, NORTHEAST
            if ( bitand(wall(wave(ind0+1,ind+1)/2+16),2)==0 )       % NORTHEAST
                tmp.dir = NORTHEAST;
                if (tmp.dir~=fld.dir(wave(ind0+1,ind+1)))
                    tmp.itr=1;
                else
                    tmp.itr = fld.itr(wave(ind0+1,ind+1))+1;
                end;
                if ((tmp.itr>1)&(tmp.itr<8))
                    tmp.fldv = fld.v(wave(ind0+1,ind+1)) + drun(1,tmp.itr-1);
                elseif (tmp.itr>7)
                    tmp.fldv = fld.v(wave(ind0+1,ind+1)) + drun(1,6);
                elseif (fld.itr(wave(ind0+1,ind+1))>1)
                    if (fld.itr(wave(ind0+1,ind+1))>6)
                        if (tmp_dir==6)
                            tmp.fldv = fld.v(wave(ind0+1,ind+1)) + f_val(2) + srun(2,6);
                        else
                            tmp.fldv = fld.v(wave(ind0+1,ind+1)) + f_val(2) + drun(2,6);
                        end;
                    else
                        if (tmp_dir==6)
                            tmp.fldv = fld.v(wave(ind0+1,ind+1)) + f_val(2) + srun(2,fld.itr(wave(ind0+1,ind+1))-1);
                        else
                            tmp.fldv = fld.v(wave(ind0+1,ind+1)) + f_val(2) + drun(2,fld.itr(wave(ind0+1,ind+1))-1);
                        end;
                    end;
                else
                    tmp.fldv = fld.v(wave(ind0+1,ind+1)) + f_val(2);
                end;
                if (fld.v(wave(ind0+1,ind+1)+31)==0 | fld.v(wave(ind0+1,ind+1)+31)>tmp.fldv)
                    fld.v(wave(ind0+1,ind+1)+31) = tmp.fldv;
                    fld.dir(wave(ind0+1,ind+1)+31) = tmp.dir;
                    fld.itr(wave(ind0+1,ind+1)+31) = tmp.itr;
                    wave(ind1+1,f_cnt(ind1+1)+1) = wave(ind0+1,ind+1)+31;
                    f_cnt(ind1+1)=f_cnt(ind1+1)+1;
                end;
            end;
            if ( bitand(wall(wave(ind0+1,ind+1)/2+16),1)==0 )       % NORTH
                tmp.dir = NORTH;
                if (tmp.dir~=fld.dir(wave(ind0+1,ind+1)))
                    tmp.itr=1;
                else
                    tmp.itr = fld.itr(wave(ind0+1,ind+1))+1;
                end;
                if ((tmp.itr>1)&(tmp.itr<8))
                    tmp.fldv = fld.v(wave(ind0+1,ind+1)) + srun(1,tmp.itr-1);
                elseif (tmp.itr>7)
                    tmp.fldv = fld.v(wave(ind0+1,ind+1)) + srun(1,6);
                elseif (fld.itr(wave(ind0+1,ind+1))>1)
                    if (fld.itr(wave(ind0+1,ind+1))>6)              % previous dir must be 5 or 7
                        tmp.fldv = fld.v(wave(ind0+1,ind+1)) + f_val(1) + drun(2,6);
                    else
                        tmp.fldv = fld.v(wave(ind0+1,ind+1)) + f_val(1) + drun(2,fld.itr(wave(ind0+1,ind+1))-1);
                    end;
                else
                    tmp.fldv = fld.v(wave(ind0+1,ind+1)) + f_val(1);    % no penalty
                end;
                if (fld.v(wave(ind0+1,ind+1)+32)==0 | fld.v(wave(ind0+1,ind+1)+32)>tmp.fldv)
                    fld.v(wave(ind0+1,ind+1)+32) = tmp.fldv;
                    fld.dir(wave(ind0+1,ind+1)+32) = tmp.dir;
                    fld.itr(wave(ind0+1,ind+1)+32) = tmp.itr;
                    wave(ind1+1,f_cnt(ind1+1)+1) = wave(ind0+1,ind+1)+32;
                    f_cnt(ind1+1)=f_cnt(ind1+1)+1;
                end;
            end;
            if (rem(wave(ind0+1,ind+1)/2,16)~=1)                    % NOT at the 1st column
                if ( bitand(wall(wave(ind0+1,ind+1)/2+15),2)==0 )   % NORTHWEST
                    tmp.dir = NORTHWEST;
                    if (tmp.dir~=fld.dir(wave(ind0+1,ind+1)))
                        tmp.itr=1;
                    else
                        tmp.itr = fld.itr(wave(ind0+1,ind+1))+1;
                    end;
                    if ((tmp.itr>1)&(tmp.itr<8))
                        tmp.fldv = fld.v(wave(ind0+1,ind+1)) + drun(1,tmp.itr-1);
                    elseif (tmp.itr>7)
                        tmp.fldv = fld.v(wave(ind0+1,ind+1)) + drun(1,6);
                    elseif (fld.itr(wave(ind0+1,ind+1))>1)          % previous dir must be 6 or 7
                        if (fld.itr(wave(ind0+1,ind+1))>6)
                            if (tmp_dir==6)
                                tmp.fldv = fld.v(wave(ind0+1,ind+1)) + f_val(2) + srun(2,6);
                            else
                                tmp.fldv = fld.v(wave(ind0+1,ind+1)) + f_val(2) + drun(2,6);
                            end;
                        else
                            if (tmp_dir==6)
                                tmp.fldv = fld.v(wave(ind0+1,ind+1)) + f_val(2) + srun(2,fld.itr(wave(ind0+1,ind+1))-1);
                            else
                                tmp.fldv = fld.v(wave(ind0+1,ind+1)) + f_val(2) + drun(2,fld.itr(wave(ind0+1,ind+1))-1);
                            end;
                        end;
                    else
                        tmp.fldv = fld.v(wave(ind0+1,ind+1)) + f_val(2);
                    end;
                    if (fld.v(wave(ind0+1,ind+1)+29)==0 | fld.v(wave(ind0+1,ind+1)+29)>tmp.fldv)
                        fld.v(wave(ind0+1,ind+1)+29) = tmp.fldv;
                        fld.dir(wave(ind0+1,ind+1)+29) = tmp.dir;
                        fld.itr(wave(ind0+1,ind+1)+29) = tmp.itr;
                        wave(ind1+1,f_cnt(ind1+1)+1) = wave(ind0+1,ind+1)+29;
                        f_cnt(ind1+1)=f_cnt(ind1+1)+1;
                    end;
                end;
            end;
        elseif ((mode==0) && (tmp_dir<4))    % north wall and flow SOUTHWEST, SOUTH, SOUTHEAST
            if ( bitand(wall(wave(ind0+1,ind+1)/2),2)==0 )          % SOUTHEAST
                tmp.dir = SOUTHEAST;
                if (tmp.dir~=fld.dir(wave(ind0+1,ind+1)))
                    tmp.itr=1;
                else
                    tmp.itr = fld.itr(wave(ind0+1,ind+1))+1;
                end;
                if ((tmp.itr>1)&(tmp.itr<8))
                    tmp.fldv = fld.v(wave(ind0+1,ind+1)) + drun(1,tmp.itr-1);
                elseif (tmp.itr>7)
                    tmp.fldv = fld.v(wave(ind0+1,ind+1)) + drun(1,6);
                elseif (fld.itr(wave(ind0+1,ind+1))>1)              % previous dir must be 2 or 3
                    if (fld.itr(wave(ind0+1,ind+1))>6)
                        if (tmp_dir==2)
                            tmp.fldv = fld.v(wave(ind0+1,ind+1)) + f_val(2) + srun(2,6);
                        else
                            tmp.fldv = fld.v(wave(ind0+1,ind+1)) + f_val(2) + drun(2,6);
                        end;
                    else
                        if (tmp_dir==2)
                            tmp.fldv = fld.v(wave(ind0+1,ind+1)) + f_val(2) + srun(2,fld.itr(wave(ind0+1,ind+1))-1);
                        else
                            tmp.fldv = fld.v(wave(ind0+1,ind+1)) + f_val(2) + drun(2,fld.itr(wave(ind0+1,ind+1))-1);
                        end;
                    end;
                else
                    tmp.fldv = fld.v(wave(ind0+1,ind+1)) + f_val(2);
                end;
                if (fld.v(wave(ind0+1,ind+1)-1)==0 | fld.v(wave(ind0+1,ind+1)-1)>tmp.fldv)
                    fld.v(wave(ind0+1,ind+1)-1) = tmp.fldv;
                    fld.dir(wave(ind0+1,ind+1)-1) = tmp.dir;
                    fld.itr(wave(ind0+1,ind+1)-1) = tmp.itr;
                    wave(ind1+1,f_cnt(ind1+1)+1) = wave(ind0+1,ind+1)-1;
                    f_cnt(ind1+1)=f_cnt(ind1+1)+1;
                end;
            end;
            if ( wave(ind0+1,ind+1) > 32 )                          % NOT at the 1st row
                if ( bitand(wall(wave(ind0+1,ind+1)/2-16),1)==0 )   % SOUTH
                    tmp.dir = SOUTH;
                    if (tmp.dir~=fld.dir(wave(ind0+1,ind+1)))
                        tmp.itr=1;
                    else
                        tmp.itr = fld.itr(wave(ind0+1,ind+1))+1;
                    end;
                    if ((tmp.itr>1)&(tmp.itr<8))
                        tmp.fldv = fld.v(wave(ind0+1,ind+1)) + srun(1,tmp.itr-1);
                    elseif (tmp.itr>7)
                        tmp.fldv = fld.v(wave(ind0+1,ind+1)) + srun(1,6);
                    elseif (fld.itr(wave(ind0+1,ind+1))>1)          % previous dir must be 1 or 3
                        if (fld.itr(wave(ind0+1,ind+1))>6)
                            tmp.fldv = fld.v(wave(ind0+1,ind+1)) + f_val(1) + drun(2,6);
                        else
                            tmp.fldv = fld.v(wave(ind0+1,ind+1)) + f_val(1) + drun(2,fld.itr(wave(ind0+1,ind+1))-1);
                        end;
                    else
                        tmp.fldv = fld.v(wave(ind0+1,ind+1)) + f_val(1);
                    end;
                    if (fld.v(wave(ind0+1,ind+1)-32)==0 | fld.v(wave(ind0+1,ind+1)-32)>tmp.fldv)
                        fld.v(wave(ind0+1,ind+1)-32) = tmp.fldv;
                        fld.dir(wave(ind0+1,ind+1)-32) = tmp.dir;
                        fld.itr(wave(ind0+1,ind+1)-32) = tmp.itr;
                        wave(ind1+1,f_cnt(ind1+1)+1) = wave(ind0+1,ind+1)-32;
                        f_cnt(ind1+1)=f_cnt(ind1+1)+1;
                    end;
                end;
            end;
            if (rem(wave(ind0+1,ind+1),32)~=2)                      % NOT at the 1st column
                if ( bitand(wall(wave(ind0+1,ind+1)/2-1),2)==0 )    % SOUTHWEST
                    tmp.dir = SOUTHWEST;
                    if (tmp.dir~=fld.dir(wave(ind0+1,ind+1)))
                        tmp.itr=1;
                    else
                        tmp.itr = fld.itr(wave(ind0+1,ind+1))+1;
                    end;
                    if ((tmp.itr>1)&(tmp.itr<8))
                        tmp.fldv = fld.v(wave(ind0+1,ind+1)) + drun(1,tmp.itr-1);
                    elseif (tmp.itr>7)
                        tmp.fldv = fld.v(wave(ind0+1,ind+1)) + drun(1,6);
                    elseif (fld.itr(wave(ind0+1,ind+1))>1)          % previous dir must be 1 or 2
                        if (fld.itr(wave(ind0+1,ind+1))>6)
                            if (tmp_dir==2)
                                tmp.fldv = fld.v(wave(ind0+1,ind+1)) + f_val(2) + srun(2,6);
                            else
                                tmp.fldv = fld.v(wave(ind0+1,ind+1)) + f_val(2) + drun(2,6);
                            end;
                        else
                            if (tmp_dir==2)
                                tmp.fldv = fld.v(wave(ind0+1,ind+1)) + f_val(2) + srun(2,fld.itr(wave(ind0+1,ind+1))-1);
                            else
                                tmp.fldv = fld.v(wave(ind0+1,ind+1)) + f_val(2) + drun(2,fld.itr(wave(ind0+1,ind+1))-1);
                            end;
                        end;
                    else
                        tmp.fldv = fld.v(wave(ind0+1,ind+1)) + f_val(2);
                    end;
                    if (fld.v(wave(ind0+1,ind+1)-3)==0 | fld.v(wave(ind0+1,ind+1)-3)>tmp.fldv)
                        fld.v(wave(ind0+1,ind+1)-3) = tmp.fldv;
                        fld.dir(wave(ind0+1,ind+1)-3) = tmp.dir;
                        fld.itr(wave(ind0+1,ind+1)-3) = tmp.itr;
                        wave(ind1+1,f_cnt(ind1+1)+1) = wave(ind0+1,ind+1)-3;
                        f_cnt(ind1+1)=f_cnt(ind1+1)+1;
                    end;
                end;
            end;
        elseif ((mode~=0) && (tmp_dir2>2))  % EAST wall and flows westbound   
            if ( bitand(wall((wave(ind0+1,ind+1)+1)/2),1)==0 )      % NORTHWEST
                tmp.dir = NORTHWEST;
                if (tmp.dir~=fld.dir(wave(ind0+1,ind+1)))
                    tmp.itr=1;
                else
                    tmp.itr = fld.itr(wave(ind0+1,ind+1))+1;
                end;
                if ((tmp.itr>1)&(tmp.itr<8))
                    tmp.fldv = fld.v(wave(ind0+1,ind+1)) + drun(1,tmp.itr-1);
                elseif (tmp.itr>7)
                    tmp.fldv = fld.v(wave(ind0+1,ind+1)) + drun(1,6);
                elseif (fld.itr(wave(ind0+1,ind+1))>1)              % previous dir must be 3 or 4
                    if (fld.itr(wave(ind0+1,ind+1))>6)
                        if (tmp_dir==4)
                            tmp.fldv = fld.v(wave(ind0+1,ind+1)) + f_val(2) + srun(2,6);
                        else
                            tmp.fldv = fld.v(wave(ind0+1,ind+1)) + f_val(2) + drun(2,6);
                        end;
                    else
                        if (tmp_dir==4)
                            tmp.fldv = fld.v(wave(ind0+1,ind+1)) + f_val(2) + srun(2,fld.itr(wave(ind0+1,ind+1))-1);
                        else
                            tmp.fldv = fld.v(wave(ind0+1,ind+1)) + f_val(2) + drun(2,fld.itr(wave(ind0+1,ind+1))-1);
                        end;
                    end;
                else
                    tmp.fldv = fld.v(wave(ind0+1,ind+1)) + f_val(2);
                end;
                if (fld.v(wave(ind0+1,ind+1)+1)==0 | fld.v(wave(ind0+1,ind+1)+1)>tmp.fldv)
                    fld.v(wave(ind0+1,ind+1)+1) = tmp.fldv;
                    fld.dir(wave(ind0+1,ind+1)+1) = tmp.dir;
                    fld.itr(wave(ind0+1,ind+1)+1) = tmp.itr;
                    wave(ind1+1,f_cnt(ind1+1)+1) = wave(ind0+1,ind+1)+1;
                    f_cnt(ind1+1)=f_cnt(ind1+1)+1;
                end;
            end;
            if ( rem(wave(ind0+1,ind+1),32)~=1 )                    % NOT at the 1st column
                if ( bitand(wall((wave(ind0+1,ind+1)+1)/2-1),2)==0 )% WEST
                    tmp.dir = WEST;
                    if (tmp.dir~=fld.dir(wave(ind0+1,ind+1)))
                        tmp.itr=1;
                    else
                        tmp.itr = fld.itr(wave(ind0+1,ind+1))+1;
                    end;
                    if ((tmp.itr>1)&(tmp.itr<8))
                        tmp.fldv = fld.v(wave(ind0+1,ind+1)) + srun(1,tmp.itr-1);
                    elseif (tmp.itr>7)
                        tmp.fldv = fld.v(wave(ind0+1,ind+1)) + srun(1,6);
                    elseif (fld.itr(wave(ind0+1,ind+1))>1)          % previous dir must be 3 or 5
                        if (fld.itr(wave(ind0+1,ind+1))>6)
                            tmp.fldv = fld.v(wave(ind0+1,ind+1)) + f_val(1) + drun(2,6);
                        else
                            tmp.fldv = fld.v(wave(ind0+1,ind+1)) + f_val(1) + drun(2,fld.itr(wave(ind0+1,ind+1))-1);
                        end;
                    else
                        tmp.fldv = fld.v(wave(ind0+1,ind+1)) + f_val(1);
                    end;
                    if (fld.v(wave(ind0+1,ind+1)-2)==0 | fld.v(wave(ind0+1,ind+1)-2)>tmp.fldv)
                        fld.v(wave(ind0+1,ind+1)-2) = tmp.fldv;
                        fld.dir(wave(ind0+1,ind+1)-2) = tmp.dir;
                        fld.itr(wave(ind0+1,ind+1)-2) = tmp.itr;
                        wave(ind1+1,f_cnt(ind1+1)+1) = wave(ind0+1,ind+1)-2;
                        f_cnt(ind1+1)=f_cnt(ind1+1)+1;
                    end;
                end;
            end;
            if ( wave(ind0+1,ind+1)>32 )% NOT at the 1st row
%            if ( (rem(wave(ind0+1,ind+1),32)~=1)&&(wave(ind0+1,ind+1)>32) )% NOT at the 1st column and row
                if ( bitand(wall((wave(ind0+1,ind+1)+1)/2-16),1)==0 )% SOUTHWEST
                    tmp.dir = SOUTHWEST;
                    if (tmp.dir~=fld.dir(wave(ind0+1,ind+1)))
                        tmp.itr=1;
                    else
                        tmp.itr = fld.itr(wave(ind0+1,ind+1))+1;
                    end;
                    if ((tmp.itr>1)&(tmp.itr<8))
                        tmp.fldv = fld.v(wave(ind0+1,ind+1)) + drun(1,tmp.itr-1);
                    elseif (tmp.itr>7)
                        tmp.fldv = fld.v(wave(ind0+1,ind+1)) + drun(1,6);
                    elseif (fld.itr(wave(ind0+1,ind+1))>1)          % previous dir must be 4 or 5
                        if (fld.itr(wave(ind0+1,ind+1))>6)
                            if (tmp_dir==4)
                                tmp.fldv = fld.v(wave(ind0+1,ind+1)) + f_val(2) + srun(2,6);
                            else
                                tmp.fldv = fld.v(wave(ind0+1,ind+1)) + f_val(2) + drun(2,6);
                            end;
                        else
                            if (tmp_dir==4)
                                tmp.fldv = fld.v(wave(ind0+1,ind+1)) + f_val(2) + srun(2,fld.itr(wave(ind0+1,ind+1))-1);
                            else
                                tmp.fldv = fld.v(wave(ind0+1,ind+1)) + f_val(2) + drun(2,fld.itr(wave(ind0+1,ind+1))-1);
                            end;
                        end;
                    else
                        tmp.fldv = fld.v(wave(ind0+1,ind+1)) + f_val(2);
                    end;
                    if (fld.v(wave(ind0+1,ind+1)-31)==0 | fld.v(wave(ind0+1,ind+1)-31)>tmp.fldv)
                        fld.v(wave(ind0+1,ind+1)-31) = tmp.fldv;
                        fld.dir(wave(ind0+1,ind+1)-31) = tmp.dir;
                        fld.itr(wave(ind0+1,ind+1)-31) = tmp.itr;
                        wave(ind1+1,f_cnt(ind1+1)+1) = wave(ind0+1,ind+1)-31;
                        f_cnt(ind1+1)=f_cnt(ind1+1)+1;
                    end;
                end;
            end;
        elseif ((mode~=0) && (tmp_dir2<2))  % EAST wall and flows east bound
            if ( bitand(wall((wave(ind0+1,ind+1)+1)/2+1),1)==0 )        % NORTHEAST
                tmp.dir = NORTHEAST;
                if (tmp.dir~=fld.dir(wave(ind0+1,ind+1)))
                    tmp.itr=1;
                else
                    tmp.itr = fld.itr(wave(ind0+1,ind+1))+1;
                end;
                if ((tmp.itr>1)&(tmp.itr<8))
                    tmp.fldv = fld.v(wave(ind0+1,ind+1)) + drun(1,tmp.itr-1);
                elseif (tmp.itr>7)
                    tmp.fldv = fld.v(wave(ind0+1,ind+1)) + drun(1,6);
                elseif (fld.itr(wave(ind0+1,ind+1))>1)                  % previous dir must be 0 or 1
                    if (fld.itr(wave(ind0+1,ind+1))>6)
                        if (tmp_dir==0)
                            tmp.fldv = fld.v(wave(ind0+1,ind+1)) + f_val(2) + srun(2,6);
                        else
                            tmp.fldv = fld.v(wave(ind0+1,ind+1)) + f_val(2) + drun(2,6);
                        end;
                    else
                        if (tmp_dir==0)
                            tmp.fldv = fld.v(wave(ind0+1,ind+1)) + f_val(2) + srun(2,fld.itr(wave(ind0+1,ind+1))-1);
                        else
                            tmp.fldv = fld.v(wave(ind0+1,ind+1)) + f_val(2) + drun(2,fld.itr(wave(ind0+1,ind+1))-1);
                        end;
                    end;
                else
                    tmp.fldv = fld.v(wave(ind0+1,ind+1)) + f_val(2);
                end;
                if (fld.v(wave(ind0+1,ind+1)+3)==0 | fld.v(wave(ind0+1,ind+1)+3)>tmp.fldv)
                    fld.v(wave(ind0+1,ind+1)+3) = tmp.fldv;
                    fld.dir(wave(ind0+1,ind+1)+3) = tmp.dir;
                    fld.itr(wave(ind0+1,ind+1)+3) = tmp.itr;
                    wave(ind1+1,f_cnt(ind1+1)+1) = wave(ind0+1,ind+1)+3;
                    f_cnt(ind1+1)=f_cnt(ind1+1)+1;
                end;
            end;
            if ( bitand(wall((wave(ind0+1,ind+1)+1)/2+1),2)==0 )        % EAST
                tmp.dir = EAST;
                if (tmp.dir~=fld.dir(wave(ind0+1,ind+1)))
                    tmp.itr=1;
                else
                    tmp.itr = fld.itr(wave(ind0+1,ind+1))+1;
                end;
                if ((tmp.itr>1)&(tmp.itr<8))
                    tmp.fldv = fld.v(wave(ind0+1,ind+1)) + srun(1,tmp.itr-1);
                elseif (tmp.itr>7)
                    tmp.fldv = fld.v(wave(ind0+1,ind+1)) + srun(1,6);
                elseif (fld.itr(wave(ind0+1,ind+1))>1)                  % previous dir must be 1 or 7
                    if (fld.itr(wave(ind0+1,ind+1))>6)
                        tmp.fldv = fld.v(wave(ind0+1,ind+1)) + f_val(1) + drun(2,6);
                    else
                        tmp.fldv = fld.v(wave(ind0+1,ind+1)) + f_val(1) + drun(2,fld.itr(wave(ind0+1,ind+1))-1);
                    end;
                else
                    tmp.fldv = fld.v(wave(ind0+1,ind+1)) + f_val(1);
                end;
                if (fld.v(wave(ind0+1,ind+1)+2)==0 | fld.v(wave(ind0+1,ind+1)+2)>tmp.fldv)
                    fld.v(wave(ind0+1,ind+1)+2) = tmp.fldv;
                    fld.dir(wave(ind0+1,ind+1)+2) = tmp.dir;
                    fld.itr(wave(ind0+1,ind+1)+2) = tmp.itr;
                    wave(ind1+1,f_cnt(ind1+1)+1) = wave(ind0+1,ind+1)+2;
                    f_cnt(ind1+1)=f_cnt(ind1+1)+1;
                end;
            end;
            if ( wave(ind0+1,ind+1)>32 )                                % NOT at the 1st row
                if ( bitand(wall((wave(ind0+1,ind+1)+1)/2-15),1)==0 )   % SOUTHEAST
                    tmp.dir = SOUTHEAST;
                    if (tmp.dir~=fld.dir(wave(ind0+1,ind+1)))
                        tmp.itr=1;
                    else
                        tmp.itr = fld.itr(wave(ind0+1,ind+1))+1;
                    end;
                    if ((tmp.itr>1)&(tmp.itr<8))
                        tmp.fldv = fld.v(wave(ind0+1,ind+1)) + drun(1,tmp.itr-1);
                    elseif (tmp.itr>7)
                        tmp.fldv = fld.v(wave(ind0+1,ind+1)) + drun(1,6);
                    elseif (fld.itr(wave(ind0+1,ind+1))>1)              % previous dir must be 0 or 7
                        if (fld.itr(wave(ind0+1,ind+1))>6)
                            if (tmp_dir==0)
                                tmp.fldv = fld.v(wave(ind0+1,ind+1)) + f_val(2) + srun(2,6);
                            else
                                tmp.fldv = fld.v(wave(ind0+1,ind+1)) + f_val(2) + drun(2,6);
                            end;
                        else
                            if (tmp_dir==0)
                                tmp.fldv = fld.v(wave(ind0+1,ind+1)) + f_val(2) + srun(2,fld.itr(wave(ind0+1,ind+1))-1);
                            else
                                tmp.fldv = fld.v(wave(ind0+1,ind+1)) + f_val(2) + drun(2,fld.itr(wave(ind0+1,ind+1))-1);
                            end;
                        end;
                    else
                        tmp.fldv = fld.v(wave(ind0+1,ind+1)) + f_val(2);
                    end;
                    if (fld.v(wave(ind0+1,ind+1)-29)==0 | fld.v(wave(ind0+1,ind+1)-29)>tmp.fldv)
                        fld.v(wave(ind0+1,ind+1)-29) = tmp.fldv;
                        fld.dir(wave(ind0+1,ind+1)-29) = tmp.dir;
                        fld.itr(wave(ind0+1,ind+1)-29) = tmp.itr;
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
best.v(1) = 9999; % an initial large number
for i = 1:4
    if (fld.v(goal(i))>0 & rem(fld.dir(goal(i)),2)==0)
        if (fld.v(goal(i))<best.v(1))
            best.v(1) = fld.v(goal(i));
            best.path(1) = goal(i);
            best.dir(1) = fld.dir(goal(i));
        end;
    end;
end;
if (best.v(1)==9999)
    for i = 1:4
        if (fld.v(goal(i))>0 & fld.v(goal(i))<best.v(1) )
            best.v(1) = fld.v(goal(i));
            best.path(1) = goal(i);
            best.dir(1) = fld.dir(goal(i));
        end;
    end;
end;
%best.path;
best.cnt = 1;
best.ang(1) = 0;
%
% Find best path
%
% number ¥Ø«e¦ì¸m
% 0: east, 1: southeast, 2: south, 3: southwest, 4: west,
% 5: northwest, 6: north, 7: northeast
% best.cnt: number of borders in the shortest path
% from f_src to GOAL --> follow the directions dir[length_1] to dir[0]
while (best.path(best.cnt)~=2)
    tmp.dir = best.dir(best.cnt)-4;
    if (tmp.dir<0)
        tmp.dir = tmp.dir + 8;
    end;
    mode = rem(best.path(best.cnt),2);
    if ((mode==0) && (tmp.dir>4))    % north wall and flow NORTHWEST, NORTH, NORTHEAST
        if ( fld.itr(best.path(best.cnt))>1 )
            switch tmp.dir
                case 5
                    best.v(best.cnt+1) = fld.v(best.path(best.cnt)+dir567(1));
                    best.dir(best.cnt+1) = fld.dir(best.path(best.cnt)+dir567(1));
                    best.path(best.cnt+1) = best.path(best.cnt)+dir567(1);
                case 6
                    best.v(best.cnt+1) = fld.v(best.path(best.cnt)+dir567(2));
                    best.dir(best.cnt+1) = fld.dir(best.path(best.cnt)+dir567(2));
                    best.path(best.cnt+1) = best.path(best.cnt)+dir567(2);
                case 7
                    best.v(best.cnt+1) = fld.v(best.path(best.cnt)+dir567(3));
                    best.dir(best.cnt+1) = fld.dir(best.path(best.cnt)+dir567(3));
                    best.path(best.cnt+1) = best.path(best.cnt)+dir567(3);
            end;
        else
            tmp_v = best.v(best.cnt);
            if (rem(best.path(best.cnt)/2,16)~=1)
                if (fld.v(best.path(best.cnt)+dir567(1))~=0 & fld.v(best.path(best.cnt)+dir567(1))<tmp_v)
                    best.v(best.cnt+1) = fld.v(best.path(best.cnt)+dir567(1));
                    best.dir(best.cnt+1) = fld.dir(best.path(best.cnt)+dir567(1));
                    best.path(best.cnt+1) = best.path(best.cnt)+dir567(1);
                    tmp_v = best.v(best.cnt+1);
                end;
            end;
            if (fld.v(best.path(best.cnt)+dir567(2))~=0 & fld.v(best.path(best.cnt)+dir567(2))<tmp_v)
                best.v(best.cnt+1) = fld.v(best.path(best.cnt)+dir567(2));
                best.dir(best.cnt+1) = fld.dir(best.path(best.cnt)+dir567(2));
                best.path(best.cnt+1) = best.path(best.cnt)+dir567(2);
                tmp_v = best.v(best.cnt+1);
            end;
            if (fld.v(best.path(best.cnt)+dir567(3))~=0 & fld.v(best.path(best.cnt)+dir567(3))<tmp_v)
                best.v(best.cnt+1) = fld.v(best.path(best.cnt)+dir567(3));
                best.dir(best.cnt+1) = fld.dir(best.path(best.cnt)+dir567(3));
                best.path(best.cnt+1) = best.path(best.cnt)+dir567(3);
            end;
        end;
        tmp_dir = best.dir(best.cnt+1)- 4;
        if (tmp_dir<0) 
            tmp_dir = tmp_dir + 8;
        end;
        turn_ang = (tmp_dir-tmp.dir)*45;
        if (turn_ang>90)
            turn_ang = turn_ang - 360;
        elseif (turn_ang<-90)
            turn_ang = turn_ang + 360;
        end;
        if (tmp_dir~=tmp.dir)
            if (rem(best.dir(best.cnt),2)==0)
                best.ang(best.cnt+1) = turn_ang;
            else
                best.ang(best.cnt+1) = best.ang(best.cnt)+turn_ang;
            end;
        else
            best.ang(best.cnt+1) = 0;
        end;
        best.cnt = best.cnt + 1;
    elseif ((mode==0) && (tmp.dir<4))    % north wall and flow SOUTHWEST, SOUTH, SOUTHEAST
        if ( fld.itr(best.path(best.cnt))>1 )
            switch tmp.dir
                case 1
                    best.v(best.cnt+1) = fld.v(best.path(best.cnt)+dir123(1));
                    best.dir(best.cnt+1) = fld.dir(best.path(best.cnt)+dir123(1));
                    best.path(best.cnt+1) = best.path(best.cnt)+dir123(1);
                case 2
                    best.v(best.cnt+1) = fld.v(best.path(best.cnt)+dir123(2));
                    best.dir(best.cnt+1) = fld.dir(best.path(best.cnt)+dir123(2));
                    best.path(best.cnt+1) = best.path(best.cnt)+dir123(2);
                case 3
                    best.v(best.cnt+1) = fld.v(best.path(best.cnt)+dir123(3));
                    best.dir(best.cnt+1) = fld.dir(best.path(best.cnt)+dir123(3));
                    best.path(best.cnt+1) = best.path(best.cnt)+dir123(3);
            end;
        else
            tmp_v = best.v(best.cnt);
            if (best.path(best.cnt) > 32)
                if (fld.v(best.path(best.cnt)+dir123(2))~=0 & fld.v(best.path(best.cnt)+dir123(2))<tmp_v)
                    best.v(best.cnt+1) = fld.v(best.path(best.cnt)+dir123(2));
                    best.dir(best.cnt+1) = fld.dir(best.path(best.cnt)+dir123(2));
                    best.path(best.cnt+1) = best.path(best.cnt)+dir123(2);
                    tmp_v = best.v(best.cnt+1);
                end;
            end;
            if (fld.v(best.path(best.cnt)+dir123(1))~=0 & fld.v(best.path(best.cnt)+dir123(1))<tmp_v)
                best.v(best.cnt+1) = fld.v(best.path(best.cnt)+dir123(1));
                best.dir(best.cnt+1) = fld.dir(best.path(best.cnt)+dir123(1));
                best.path(best.cnt+1) = best.path(best.cnt)+dir123(1);
                tmp_v = best.v(best.cnt+1);
            end;
            if (rem(best.path(best.cnt),32)~=2)
                if (fld.v(best.path(best.cnt)+dir123(3))~=0 & fld.v(best.path(best.cnt)+dir123(3))<tmp_v)
                    best.v(best.cnt+1) = fld.v(best.path(best.cnt)+dir123(3));
                    best.dir(best.cnt+1) = fld.dir(best.path(best.cnt)+dir123(3));
                    best.path(best.cnt+1) = best.path(best.cnt)+dir123(3);
                end;
            end;
        end;
        tmp_dir = best.dir(best.cnt+1)- 4;
        if (tmp_dir<0) 
            tmp_dir = tmp_dir + 8;
        end;
        turn_ang = (tmp_dir-tmp.dir)*45;
        if (turn_ang>90)
            turn_ang = turn_ang - 360;
        elseif (turn_ang<-90)
            turn_ang = turn_ang + 360;
        end;
        if (tmp_dir~=tmp.dir)
            if (rem(best.dir(best.cnt),2)==0)
                best.ang(best.cnt+1) = turn_ang;
            else
                best.ang(best.cnt+1) = best.ang(best.cnt)+turn_ang;
            end;
        else
            best.ang(best.cnt+1) = 0;
        end;
        best.cnt = best.cnt + 1;
    elseif (rem(tmp.dir,7)>2)           % east wall and flows westbound
        if ( fld.itr(best.path(best.cnt))>1 )
            switch tmp.dir
                case 3
                    best.v(best.cnt+1) = fld.v(best.path(best.cnt)+dir345(1));
                    best.dir(best.cnt+1) = fld.dir(best.path(best.cnt)+dir345(1));
                    best.path(best.cnt+1) = best.path(best.cnt)+dir345(1);
                case 4
                    best.v(best.cnt+1) = fld.v(best.path(best.cnt)+dir345(2));
                    best.dir(best.cnt+1) = fld.dir(best.path(best.cnt)+dir345(2));
                    best.path(best.cnt+1) = best.path(best.cnt)+dir345(2);
                case 5
                    best.v(best.cnt+1) = fld.v(best.path(best.cnt)+dir345(3));
                    best.dir(best.cnt+1) = fld.dir(best.path(best.cnt)+dir345(3));
                    best.path(best.cnt+1) = best.path(best.cnt)+dir345(3);
            end;
        else
            tmp_v = best.v(best.cnt);
            if (rem(best.path(best.cnt),32)~=1)
                if (fld.v(best.path(best.cnt)+dir345(2))~=0 & fld.v(best.path(best.cnt)+dir345(2))<tmp_v)
                    best.v(best.cnt+1) = fld.v(best.path(best.cnt)+dir345(2));
                    best.dir(best.cnt+1) = fld.dir(best.path(best.cnt)+dir345(2));
                    best.path(best.cnt+1) = best.path(best.cnt)+dir345(2);
                    tmp_v = best.v(best.cnt+1);
                end;
            end;
            if (fld.v(best.path(best.cnt)+dir345(3))~=0 & fld.v(best.path(best.cnt)+dir345(3))<tmp_v)
                best.v(best.cnt+1) = fld.v(best.path(best.cnt)+dir345(3));
                best.dir(best.cnt+1) = fld.dir(best.path(best.cnt)+dir345(3));
                best.path(best.cnt+1) = best.path(best.cnt)+dir345(3);
                tmp_v = best.v(best.cnt+1);
            end;
            if (best.path(best.cnt)>32)
                if (fld.v(best.path(best.cnt)+dir345(1))~=0 & fld.v(best.path(best.cnt)+dir345(1))<tmp_v)
                    best.v(best.cnt+1) = fld.v(best.path(best.cnt)+dir345(1));
                    best.dir(best.cnt+1) = fld.dir(best.path(best.cnt)+dir345(1));
                    best.path(best.cnt+1) = best.path(best.cnt)+dir345(1);
                end;
            end;
        end;
        tmp_dir = best.dir(best.cnt+1)- 4;
        if (tmp_dir<0) 
            tmp_dir = tmp_dir + 8;
        end;
        turn_ang = (tmp_dir-tmp.dir)*45;
        if (turn_ang>90)
            turn_ang = turn_ang - 360;
        elseif (turn_ang<-90)
            turn_ang = turn_ang + 360;
        end;
        if (tmp_dir~=tmp.dir)
            if (rem(best.dir(best.cnt),2)==0)
                best.ang(best.cnt+1) = turn_ang;
            else
                best.ang(best.cnt+1) = best.ang(best.cnt)+turn_ang;
            end;
        else
            best.ang(best.cnt+1) = 0;
        end;
        best.cnt = best.cnt + 1;
    elseif (rem(tmp.dir,7)<2)           % north wall and flows eastbound
        if ( fld.itr(best.path(best.cnt))>1 )
            switch tmp.dir
                case 1
                    best.v(best.cnt+1) = fld.v(best.path(best.cnt)+dir107(1));
                    best.dir(best.cnt+1) = fld.dir(best.path(best.cnt)+dir107(1));
                    best.path(best.cnt+1) = best.path(best.cnt)+dir107(1);
                case 0
                    best.v(best.cnt+1) = fld.v(best.path(best.cnt)+dir107(2));
                    best.dir(best.cnt+1) = fld.dir(best.path(best.cnt)+dir107(2));
                    best.path(best.cnt+1) = best.path(best.cnt)+dir107(2);
                case 7
                    best.v(best.cnt+1) = fld.v(best.path(best.cnt)+dir107(3));
                    best.dir(best.cnt+1) = fld.dir(best.path(best.cnt)+dir107(3));
                    best.path(best.cnt+1) = best.path(best.cnt)+dir107(3);
            end;
        else
            tmp_v = best.v(best.cnt);
            if (best.path(best.cnt)>32)
                if (fld.v(best.path(best.cnt)+dir107(1))~=0 & fld.v(best.path(best.cnt)+dir107(1))<tmp_v)
                    best.v(best.cnt+1) = fld.v(best.path(best.cnt)+dir107(1));
                    best.dir(best.cnt+1) = fld.dir(best.path(best.cnt)+dir107(1));
                    best.path(best.cnt+1) = best.path(best.cnt)+dir107(1);
                    tmp_v = best.v(best.cnt+1);
                end;
            end;
            if (fld.v(best.path(best.cnt)+dir107(2))~=0 & fld.v(best.path(best.cnt)+dir107(2))<tmp_v)
                best.v(best.cnt+1) = fld.v(best.path(best.cnt)+dir107(2));
                best.dir(best.cnt+1) = fld.dir(best.path(best.cnt)+dir107(2));
                best.path(best.cnt+1) = best.path(best.cnt)+dir107(2);
                tmp_v = best.v(best.cnt+1);
            end;
            if (fld.v(best.path(best.cnt)+dir107(3))~=0 & fld.v(best.path(best.cnt)+dir107(3))<tmp_v)
                best.v(best.cnt+1) = fld.v(best.path(best.cnt)+dir107(3));
                best.dir(best.cnt+1) = fld.dir(best.path(best.cnt)+dir107(3));
                best.path(best.cnt+1) = best.path(best.cnt)+dir107(3);
            end;
        end;
        tmp_dir = best.dir(best.cnt+1)- 4;
        if (tmp_dir<0) 
            tmp_dir = tmp_dir + 8;
        end;
        turn_ang = (tmp_dir-tmp.dir)*45;
        if (turn_ang>90)
            turn_ang = turn_ang - 360;
        elseif (turn_ang<-90)
            turn_ang = turn_ang + 360;
        end;
        if (tmp_dir~=tmp.dir)
            if (rem(best.dir(best.cnt),2)==0)
                best.ang(best.cnt+1) = turn_ang;
            else
                best.ang(best.cnt+1) = best.ang(best.cnt)+turn_ang;
            end;
        else
            best.ang(best.cnt+1) = 0;
        end;
        best.cnt = best.cnt + 1;
    end;
end;
% 
% Find the xy coordinates of the best path
% 
for ind=1:best.cnt 
    north_border = rem(best.path(ind),2);
    if (north_border==1)
        best.x(ind) = 9 + floor(rem(best.path(ind),32)/2)*18;
        best.y(ind) = floor(best.path(ind)/32)*18;
    else
        best.x(ind) = floor(rem(best.path(ind)-1,32)/2)*18;
        best.y(ind) = 9+floor((best.path(ind)-1)/32)*18;
    end;
end;
best.x(best.cnt+1) = 0;
best.y(best.cnt+1) = 0;