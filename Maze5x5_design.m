clc;
clear;
wall(21)=1; wall(25)=3; wall(1)=0; wall(5)=2;
for i=22:24
   wall(i)=1;
end;
% for i=2:4
%    wall(i)=0;
% end;
for i=2:4
   wall(i*5)=2;
end;
% for i=2:15
%    wall(i*16)=2;
% end;
load maze5x5.mat

yw = -9:18:81;
h1 = figure(1);
set(h1,'color','white','Position',[50 50 750 750]);
for x = -9:18:81
    if (x==9) 
        hold;
    end;
    plot(x*ones(size(yw)),yw,'rs','MarkerFaceColor','r','MarkerSize',2);
end;
axis([-18 90 -18 90]);
axis('square');
% left border, bottom border, hight, width of axis in figure;
set(gca,'Position',[0.1 0.1 0.8 0.8]);
plot([-9 81], [-9 -9],'r'); plot([81 81], [-9 81],'r');
plot([-9 81], [81 81],'r'); plot([-9 -9], [-9 81],'r');
for i=1:25
    if (rem(wall(i),2)==1)
        plot([(rem(i-1,5))*18-9 (rem(i-1,5))*18+9],[floor((i-1)/5)*18+9 floor((i-1)/5)*18+9],'r');
    end;
    a = floor(wall(i)/2);
    if (rem(a,2)==1)
        plot([(rem(i-1,5))*18+9 (rem(i-1,5))*18+9],[floor((i-1)/5)*18-9 floor((i-1)/5)*18+9],'r');
    end;
end;
title('Press any key to stop the design','FontSize',14);
xlabel('X coordinate in cm');
ylabel('Y coordinate in cm');
% The coordinate of the lower left corner of the figure is 0.1*750, 0.1*750
% The pixels the figure occupies is 0.8*750, 0.8*750, therefore, 100 pixels
% equal 18cm. i.e. 0.18cm/pixel
x0 = 0.1*750 + (0.8*750)/6/2;
y0 = 0.1*750 + (0.8*750)/6/2;
%text(0,0,'0','HorizontalAlignment','center');
check = 0;
i = 1;
while (check==0)
    w = waitforbuttonpress;
    if (w == 0)
        pos(i,:)=(get(h1,'CurrentPoint')-[x0 y0])*0.18
        if ((18-rem(pos(i,1),18))<3)
            x = floor(pos(i,1)/18)
            y = floor(pos(i,2)/18)
            if (rem(floor(wall(x+y*5+1)/2),2)==0)
                plot([x*18+9 x*18+9],[y*18-9 y*18+9],'r');
                wall(x+y*5+1) = wall(x+y*5+1) + 2;
            else
                plot([x*18+9 x*18+9],[y*18-9 y*18+9],'w');
                plot((x*18+9)*ones(size(yw)),yw,'rs','MarkerFaceColor','r','MarkerSize',2);
                wall(x+y*5+1) = wall(x+y*5+1) - 2;
            end;
        elseif ((18-rem(pos(i,1),18))>15)  
            x = (floor(pos(i,1)/18)-1)
            y = floor(pos(i,2)/18)
            if (rem(floor(wall(x+y*5+1)/2),2)==0)
                plot([x*18+9 x*18+9],[y*18-9 y*18+9],'r');
                wall(x+y*5+1) = wall(x+y*5+1) + 2;
            else
                plot([x*18+9 x*18+9],[y*18-9 y*18+9],'w');
                plot((x*18+9)*ones(size(yw)),yw,'rs','MarkerFaceColor','r','MarkerSize',2);
                wall(x+y*5+1) = wall(x+y*5+1) - 2;
            end;
        elseif ((18-rem(pos(i,2),18))<3)
            y = floor(pos(i,2)/18)
            x = floor(pos(i,1)/18)
            if (rem(wall(x+y*5+1),2)==0)
                plot([x*18-9 x*18+9],[y*18+9 y*18+9],'r');
                wall(x+y*5+1) = wall(x+y*5+1) + 1;
            else
                plot([x*18-9 x*18+9],[y*18+9 y*18+9],'w');
                plot(yw,(y*18+9)*ones(size(yw)),'rs','MarkerFaceColor','r','MarkerSize',2);
                wall(x+y*5+1) = wall(x+y*5+1) - 1;
            end;
        elseif ((18-rem(pos(i,2),18))>15)  
            y = (floor(pos(i,2)/18)-1)
            x = floor(pos(i,1)/18)
            if (rem(wall(x+y*5+1),2)==0)
                plot([x*18-9 x*18+9],[y*18+9 y*18+9],'r');
                wall(x+y*5+1) = wall(x+y*5+1) + 1;
            else
                plot([x*18-9 x*18+9],[y*18+9 y*18+9],'w');
                plot(yw,(y*18+9)*ones(size(yw)),'rs','MarkerFaceColor','r','MarkerSize',2);
                wall(x+y*5+1) = wall(x+y*5+1) - 1;
            end;
        end;
        i = i + 1;
    else
        check = 1;
        title('Maze Design is Done','FontSize',14);
    end;
end;
hold;