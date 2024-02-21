function f=runRadarPlot(R,Lable,LineColor,FillColor,LineStyle,LevelNum)
%Creates a radar (spider) plot for multi-data series.
%edit by Cheng Li
%Tsinghua University
%INPUT: 
%R
%   Data, if R is a m*n matrix, means m samples with n options
%Label
%   Label, Label of options
%	Cells of string
%LineColor
%	Color of Line
%	Cells of MatLab colors
%
%FillColor
%	Cells of MatLab colors
%
%LineStyle
%	Cells of MatLab colors
%
%LevelNum
%	number of axis's levels
%
%Example:
%radarplot([1 2 3 4 5 6])
%radarplot([1 2 3 4 5 6;7 8 9 10 11 12.5])
%radarplot([1 2 3 4 5 6;7 8 9 10 11 12.5],{'option1','a','b','','c','d'})
%radarplot([1 2 3 4 5 6;7 8 9 10 11 12.5],{'option1','','','','',''},{'r','g'})
%radarplot([1 2 3 4 5 6;7 8 9 10 11 12.5],{'option1','','','','',''},{},{'b','r'})
%radarplot([1 2 3 4 5 6;7 8 9 10 11 12.5],{'option1','','','','',''},{'r','g'})
%radarplot([1 2 3 4 5 6;7 8 9 10 11 12.5],{'option1','','','','',''},{'r','g'},{'b','r'},{'no',':'}
%radarplot([1 2 3 4 5 6;7 8 9 10 11 12.5],{'option1','a','b','c','','e'},{'r','g'},{'b','r'},{'no',':'},5)

R_SEM_below = R(2,:); 
R_SEM_above = R(3,:);
R = R(1,:);

%themeArray = [1,1,1,1,1,1,1,1,1,1,2,2,2,2,2,3,3,3,3,4,4,4,4,4,4,4,4,4,4,...
%    5,6,7,8,9,10,11,12];
themeArray = [1,1,1,1,1,2,2,2,2,2,3,3,3,3,4,4,4,4,4,4,4,4,4,4,...
    5,5,5,5,5,6,6,7,8,9,10,11,12,13,14,15,16,17,18,19];
cmap = hsv(max(themeArray));

n=size(R,2);
m=size(R,1);
if nargin<6
    LevelNum=4;
end

% SEM in the background
% R_SEM_below=[R_SEM_below R_SEM_below(:,1)];
% [Theta_SEM_below,M_SEM_below]=meshgrid(2*pi/n*[0:n]+pi/n,ones(1,size(R_SEM_below,1)));
% X_SEM_below=R_SEM_below.*sin(Theta_SEM_below);
% Y_SEM_below=R_SEM_below.*cos(Theta_SEM_below);
% B=plot(X_SEM_below',Y_SEM_below','LineWidth',1,'Color','g');
% hold on
% R_SEM_above=[R_SEM_above R_SEM_above(:,1)];
% [Theta_SEM_above,M_SEM_above]=meshgrid(2*pi/n*[0:n]+pi/n,ones(1,size(R_SEM_above,1)));
% X_SEM_above=R_SEM_above.*sin(Theta_SEM_above);
% Y_SEM_above=R_SEM_above.*cos(Theta_SEM_above);
% B=plot(X_SEM_above',Y_SEM_above','LineWidth',1,'Color','g');
% F_SEM = fill([X_SEM_below, fliplr(X_SEM_above)], [Y_SEM_below, fliplr(Y_SEM_above)], 'g'); 
% set(F_SEM,'FaceAlpha', 0.15);
%F_SEM = fill(X_SEM(1,:),Y_SEM(1,:), 'g', 'LineStyle','none');
%set(F_SEM, 'FaceAlpha', 0.05);
% Main chart
R=[R R(:,1)];
[Theta,M]=meshgrid(2*pi/n*[0:n]+pi/n,ones(1,size(R,1)));
X=R.*sin(Theta);
Y=R.*cos(Theta);
B=plot(X',Y','LineWidth',1,'Color','k');
hold on
%grayColor = [17 17 17]/255;'Color', 'grayColor',
%F = fill(X(1,:),Y(1,:), 'b', 'LineStyle','none');
%set(F,'FaceAlpha',0.15)

R_SEM_below=[R_SEM_below R_SEM_below(:,1)];
[Theta_SEM_below,M_SEM_below]=meshgrid(2*pi/n*[0:n]+pi/n,ones(1,size(R_SEM_below,1)));
X_SEM_below=R_SEM_below.*sin(Theta_SEM_below);
Y_SEM_below=R_SEM_below.*cos(Theta_SEM_below);
%B=plot(X_SEM_below',Y_SEM_below','Linestyle','--', 'LineWidth',0.1,'Color','g');
plot(X_SEM_below',Y_SEM_below',':','Color','b');
hold on
R_SEM_above=[R_SEM_above R_SEM_above(:,1)];
[Theta_SEM_above,M_SEM_above]=meshgrid(2*pi/n*[0:n]+pi/n,ones(1,size(R_SEM_above,1)));
X_SEM_above=R_SEM_above.*sin(Theta_SEM_above);
Y_SEM_above=R_SEM_above.*cos(Theta_SEM_above);
%B=plot(X_SEM_above',Y_SEM_above','Linestyle','--','LineWidth',0.1,'Color','g');
plot(X_SEM_above',Y_SEM_above',':','Color','b');
%F_SEM = fill([X_SEM_below, fliplr(X_SEM_above)], [Y_SEM_below, fliplr(Y_SEM_above)], 'b');
%set(F_SEM,'EdgeColor', [0.47,0.67,0.19], 'FaceAlpha', 0.15, 'LineStyle',':', 'LineWidth',0.01);

% If there are problems with SEM (that it shows up outside of the borders):
 for kk = 1:44
     F_SEM = fill([X_SEM_below(kk:kk+1), fliplr(X_SEM_above(kk:kk+1))], [Y_SEM_below(kk:kk+1), fliplr(Y_SEM_above(kk:kk+1))], 'b'); 
     set(F_SEM,'EdgeColor', [0.47,0.67,0.19], 'FaceAlpha', 0.15, 'LineStyle',':', 'LineWidth',0.01);
 end



for j = 1:length(themeArray)
    thisColor = themeArray(j);
    plot(X(j),Y(j),'o','LineWidth', 1,'MarkerSize', 10,'Color', cmap(thisColor,:),'markerfacecolor', cmap(thisColor,:))
end
%MAXAXIS=max(max(R))*1.1;
MAXAXIS=1;
axis([-MAXAXIS MAXAXIS -MAXAXIS MAXAXIS]);
axis equal
axis off
if LevelNum>0
    %AxisR=linspace(0,max(max(R)),LevelNum);
     AxisR=linspace(0,1,LevelNum);
%     for i=1:LevelNum
%         text(AxisR(i)*sin(pi/n-0.3),AxisR(i)*cos(pi/n-0.3),num2str(AxisR(i),2),'FontSize',10)
%     end
    [M,AxisR]=meshgrid(ones(1,n),AxisR);
    AxisR=[AxisR AxisR(:,1)];
    [AxisTheta,M]=meshgrid(2*pi/n*[0:n]+pi/n,ones(1,size(AxisR,1)));
    AxisX=AxisR.*sin(AxisTheta);
    AxisY=AxisR.*cos(AxisTheta);
    hold on
    plot(AxisX, AxisY, ':', 'Color', [0.5 0.5 0.5]);
    plot(AxisX',AxisY',':', 'Color', [0.5 0.5 0.5]);
    %plot(AxisX, AxisY,':k');
    %plot(AxisX',AxisY',':k')
    hold on
    set(gcf,'color','w');
    %cmap = jet(12);
    r_in = 0.98;
    r_out = 1;
    ThetaHalf = (Theta(2)-Theta(1))/2;
    for k = 1:length(themeArray)
        %tt = linspace(Theta(k), Theta(k+1)); % For colors between the lines
        tt = linspace(Theta(k)-ThetaHalf, Theta(k+1)-ThetaHalf); % For colors across the lines
        xi_in = r_in * sin(tt);% + x0;
        yi_in = r_in * cos(tt);% + y0;
        xi_out = r_out * sin(tt);% + x0;
        yi_out = r_out * cos(tt);% + y0;    
        thisColor = themeArray(k);
        fill([xi_in(:); flipud(xi_out(:))], [yi_in(:); flipud(yi_out(:))], cmap(thisColor,:), 'EdgeColor','none');

    hold on
    end
    
    AxisR=linspace(0,1,LevelNum);
%     for i=2:LevelNum
%         text(AxisR(i)*sin(pi/n-0.1),AxisR(i)*cos(pi/n-0.3),num2str(AxisR(i),2),'FontSize',7)
%     end
    
    
end

if nargin>1
    if length(Lable)>=n
        LableTheta=2*pi/n*[0:n-1]+pi/n;
        LableR=MAXAXIS+0.04;
        LableX=LableR.*sin(LableTheta);
        LableY=LableR.*cos(LableTheta);
        rotateMe = 100;
        for i = 1:n   
            if ~sum(strcmpi({'' },Lable(i)))
                rotateMeNow = rotateMe - (360/(length(themeArray)-1.5));
                if rotateMeNow < -94
                    rotateMeNow = 90
                    alignment = 'right';
                end
                if i <= (n/2)
                    txt = text(LableX(i), LableY(i),cell2mat(Lable(i)), 'FontSize',14,'HorizontalAlignment','left','Rotation',rotateMeNow)

                elseif i == length(themeArray)
                    text(LableX(i), LableY(i),cell2mat(Lable(i)), 'FontSize',14,'HorizontalAlignment','left','Rotation',94)
                else
                    text(LableX(i), LableY(i),cell2mat(Lable(i)), 'FontSize',14,'HorizontalAlignment','right','Rotation',rotateMeNow)
                end
                %sprintf('Label %s, rotation: %d', cell2mat(Lable(i)), rotateMeNow)
                rotateMe = rotateMeNow;
            end
        end
    end
else
    return
end
if nargin>2
    if length(LineColor)>=m
        for i=1:m
            if sum(strcmpi({'y' 'm' 'c' 'r' 'g' 'b' 'w' 'k' },LineColor(i)))
                set(A(i),'Color',cell2mat(LineColor(i)))
            end
        end
    end
else
    return
end
if nargin>3
    if length(FillColor)>=m
        for i=1:m
            if sum(strcmpi({'y' 'm' 'c' 'r' 'g' 'b' 'w' 'k' },FillColor(i)))
                hold on;
                F=fill(X(i,:),Y(i,:),cell2mat(FillColor(i)),'LineStyle','none');
                set(F,'FaceAlpha',0.3)
            end
        end
    end
else
    return
end
if nargin>4
    if length(LineStyle)>=m
        for i=1:m
            if sum(strcmpi({'-' '--' ':' '-.'},LineStyle(i)))
                set(A(i),'LineStyle',cell2mat(LineStyle(i)))
            end
        end
    end
else
    return
end