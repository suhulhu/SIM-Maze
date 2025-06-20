% Plot a 5x5 maze and a mouse at the start cell
wall=[2 0 1 0 3 0 1 0 1 2 3 0 1 0 2 0 2 1 2 3 3 1 1 1 3];
%
MouseX = [0 -5 -5 -4 -3 -3 -4 -4 -5 -5 -4 -4 -3 -3 -2  2  3  3  4  4  5 5 4  4  3 3 4 5 5]; 
MouseY = [6  3  2  2  1 -1 -1  1  1 -5 -5 -3 -3 -5 -6 -6 -5 -3 -3 -5 -5 1 1 -1 -1 1 2 2 3];
pgon = polyshape(MouseX,MouseY);
%
yw = -9:18:81;
f = figure(1);
set(f, 'color', 'white');
for x = -9:18:81
    if (x==9) 
        % mark the goal area
        rectangle('Position',[63 63 18 18],'FaceColor',[1 0.7 0.7],'EdgeColor','w');
        hold;
    end;
    % mark pole locations
    plot(x*ones(size(yw)),yw,'rs','MarkerFaceColor','r','MarkerSize',2);
end;
axis([-15 87 -15 87]);
axis('square');
% plot maze boundaries
hM = plot(pgon,'FaceColor','black','EdgeColor','black','FaceAlpha',0.3);
plot([-9 81], [-9 -9],'r'); plot([81 81], [-9 81],'r');
plot([-9 81], [81 81],'r'); plot([-9 -9], [-9 81],'r');
for i=1:25
    if (rem(wall(i),2)==1)  % North wall exists at cell i
        plot([(rem(i-1,5))*18-9 (rem(i-1,5))*18+9],[floor((i-1)/5)*18+9 floor((i-1)/5)*18+9],'r');
    end;
    a = floor(wall(i)/2);
    if (rem(a,2)==1)        % East wall exists at cell i
        plot([(rem(i-1,5))*18+9 (rem(i-1,5))*18+9],[floor((i-1)/5)*18-9 floor((i-1)/5)*18+9],'r');
    end;
end;
hold;
set(gca,'XTick',[0 18 36 54 72])
set(gca,'YTick',[0 18 36 54 72])
title('5x5 test maze','FontSize',18);
xlabel('X coordinate in cm','fontsize',12);
ylabel('Y coordinate in cm','fontsize',12);
pause;
delete(hM);
