%% 计算x y平面中有限长度导线在接收线圈区域内引起的磁场及磁通   
%type可为'x'(表示导线平行x轴放置)  或'y' (表示导线平行y轴放置)
%S = {[x_start, x_end], [y_start, y_end], z0}   为接收线圈区域 也为二重积分边界
%L = [a, b]为导线起始点终止点到轴距离  
%t 为导线与平行的坐标轴的距离  
%I 电流大小   正值表示流入  负值流出
function [fi] = line_fi_cal1(type, S, L, t, I)     
syms x0 y0
u0 = pi*4E-7;
z0 = S{3};

if type == 'x'   % 导线平行x轴放置
    r1 = sqrt((L(1)-x0)^2+(y0-t)^2+z0^2); %P点和启示端点间空间距离
    r2 = sqrt((L(2)-x0)^2+(y0-t)^2+z0^2); %P点和终止端点间空间距离
    r0 = sqrt((y0-t)^2+z0^2);
    
    cosq1 = (L(1)-x0)/r1;
    cosq2 = (L(2)-x0)/r2;
    cosv = abs(t-y0)/r0;    % 这里只计算cosv的绝对值   正负由后面位置关系判断
    
elseif type=='y'   %导线平行y轴放置
    r1 = sqrt((L(1)-y0)^2+(x0-t)^2+z0^2); %P点和启示端点间空间距离
    r2 = sqrt((L(2)-y0)^2+(x0-t)^2+z0^2); %P点和终止端点间空间距离
    r0 = sqrt((x0-t)^2+z0^2);
    
    cosq1 = (L(1)-y0)/r1;
    cosq2 = (L(2)-y0)/r2;
    cosv = abs(t-x0)/r0;    % 这里只计算cosv的绝对值   正负由后面位置关系判断
end

% 计算得到B场强度的数值   注意是数值！ 均为正数  不包含方向
B = u0*abs(I)/(4*pi*r0)*(cosq1-cosq2);

% 计算z方向的B值   并根据符号函数修正Bz方向   大于零表示指向z轴正方向
if type == 'x'
    Bz = B * cosv * sign(t-y0) * sign(I);%
elseif type == 'y'
    Bz = -1 * B * cosv * sign(t-x0) * sign(I);  % 若是平行y轴放置的导线   由于右手螺旋定则  Bz得乘一个负号
end

% res = vpa(B)
% res1 = vpa(Bz)

%% 计算接收线圈区域内的磁通量
S_x = S{1};  % 接收线圈x方向的范围边界
S_y = S{2};

% intx = int(Bz, S_x(2), S_x(1));
% inty = int(intx, S_y(2), S_y(1));
% fi = vpa(inty);

% 采用数值积分方法进行z轴方向磁通量计算
fi = quad2d(matlabFunction(Bz), S_x(2), S_x(1), S_y(2), S_y(1));
fi = vpa(fi);

end




