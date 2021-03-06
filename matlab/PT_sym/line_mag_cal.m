%% 计算x y平面中有限长度导线在P点引起的磁场强度   
%type可为'x'(表示导线平行x轴放置)  或'y' (表示导线平行y轴放置)
%P = [x0, y0, z0]   为代求点坐标
%L = [a, b]为导线起始点终止点到轴距离  
%t 为导线与平行的坐标轴的距离  
%I 电流大小   正值表示流入  负值流出
function [res] = line_mag_cal(type, P, L, t, I)     
syms x y 
syms u0

x0 = P(1);
y0 = P(2);
z0 = P(3);

r = sqrt((x0-x)^2+(y0-y)^2+z0^2); %P点和dl间空间距离
R_hat = [x0-x; y0-y; z0]/r; %dl指向P点的单位矢量

l = [x; y; 0];
if type == 'x'   %若是对x方向求积分，即导线是平行x轴放置  则令dl的y为0
    l = subs(l, [y], [0]);
elseif type == 'y'
    l = subs(l, [x], [0]);
end
dl = diff(l); %dl空间矢量

% 计算得到dB = u0/(4*pi) * IdlxR/r^2
dB = u0/(4*pi)*I*cross(R_hat, dl)/(r^2);

% 带入I,u0，以及P点x0，y0, z0坐标
dB = simplify(subs(dB, {u0}, {pi*4E-7}));

if type == 'x'  
    % 对变量x进行积分dB得到P点的磁场强度分量  L为导线半长
    B = int(dB, x, L(2), L(1));
    % 带入导线y坐标位置信息  求得P点磁场强度数值
    B = simplify(subs(B, {y}, {t}));
    res = vpa(B);
elseif type == 'y'
    % 对变量y进行积分dB得到P点的磁场强度分量  L为导线半长
    B = int(dB, y, L(2), L(1));
    % 带入导线x坐标位置信息  求得P点磁场强度数值
    B = simplify(subs(B, {x}, {t}));
    res = vpa(B);
end




