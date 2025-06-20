function [wallo, wallc] = ud_wallo(f_src, wallo, wallc, wall);
%
wallo(f_src) = wall(f_src);
wallc(f_src) = wallo(f_src);
if (f_src>16)
    wallo(f_src-16) = bitor(wallo(f_src-16),bitand(wall(f_src-16),1));
    wallc(f_src-16) = bitand(wallc(f_src-16),bitand(wall(f_src-16),1)+2);
end;
if (rem(f_src,16)~=1)
    wallo(f_src-1) = bitor(wallo(f_src-1),bitand(wall(f_src-1),2));
    wallc(f_src-1) = bitand(wallc(f_src-1),bitand(wall(f_src-1),2)+1);
end;