
%% 三串联电路的耦合模推导 与  a1 a2 a3波形图绘制
clear; 
syms w1 T lam g ks1 ks2 K1 K2
syms a1(t)  a2(t) a3(t) t;

%% 解微分方程得 a1 a2

% 基础版
eq1 = diff(a1, t) == (1i*w1+g)*a1 -1i*K1*a2 -1i*K2*a3;
eq2 = diff(a2, t) == -1i*K1*a1 +(1i*w1-T)*a2;
eq3 = diff(a3, t) == -1i*K2*a1            +(1i*w1-T)*a3;

cond = [a1(0)==1, a2(0)==0, a3(0)==0];
[a1, a2, a3] = dsolve(eq1, eq2, eq3, cond)

%% 绘图  a1 和 a2 的时域图像
g_m = 5E+3;
T_m = 4E+3;
w1_m = 400E+3;
K1_m = 0.1*0.5*w1_m;
K2_m = 0.1*0.5*w1_m;
x=[0:1E-7:5E-3];

figure();
a1_m = abs(a1)^2;
%a1_m = a1;
a1_m = vpa(subs(a1_m, [g,T, w1, K1, K2], [g_m,T_m,w1_m, K1_m, K2_m]));  %
z1=double(subs(a1_m,t,x));
a1_avg = mean(z1);
plot(x,z1);
hold on;


a2_m = abs(a2)^2;
%a2_m = a2;
a2_m = vpa(subs(a2_m, [g,T, w1, K1, K2], [g_m,T_m,w1_m, K1_m, K2_m]));
z2=double(subs(a2_m,t,x));
a2_avg = mean(z2);
% figure();
plot(x,z2);
hold on;

%figure()
a3_m = abs(a3)^2;
%a3_m = a3;
a3_m = vpa(subs(a3_m, [g,T, w1, K1, K2], [g_m,T_m,w1_m, K1_m, K2_m]));
z3=double(subs(a3_m,t,x));
a3_avg = mean(z3);
% figure();
plot(x,z3);

Out = [x', z1', z2', z3'];
%save('C:\Users\LRF\OneDrive\works\WPT\PAPER\origin\matlab_record\Resonant\GdayuT.mat','Out');


Eprecent1 = vpa(a2_avg/a1_avg,4)
Eprecent2 = vpa(a3_avg/a1_avg,4)

%% 解特征值
A = [1i*w1+g,         -1i*K1,       -1i*K2;...
    -1i*K1,           1i*w1-T,           0;...
    -1i*K2,   0,                     1i*w1-T;];

[e,D] = eig(A);
D
e
%%
pretty(g/2 - T/2 + w1*1i - ((4*K1^2 + 4*K2^2 - T^2 - 2*T*g - g^2)^(1/2)*1i)/2);
pretty(g/2 - T/2 + w1*1i + ((4*K1^2 + 4*K2^2 - T^2 - 2*T*g - g^2)^(1/2)*1i)/2);

%%
clear;
syms w1 T lam g ks1 ks2 K1 K2
lmba1 = real(g/2 - T/2 + w1*1i - ((4*K1^2 + 4*K2^2 - T^2 - 2*T*g - g^2)^(1/2)*1i)/2);
lmba2 = real(g/2 - T/2 + w1*1i + ((4*K1^2 + 4*K2^2 - T^2 - 2*T*g - g^2)^(1/2)*1i)/2);

w1_m = 1;
% 耦合速率
K1_m = 0.1*0.5*w1_m;
K2_m = 0.1*0.5*w1_m;

T_d = 1.414*K1_m; % 损耗率等于耦合速率时
T_m = T_d*1.2;  %大于1 则损耗速率大于耦合速率  小于1 则满足强耦合条件
g1 = T_m
g2 = 2*K1_m^2/T_m

lmba1_m = vpa(subs(lmba1, [T, w1, K1, K2], [T_m,w1_m, K1_m, K2_m]),4);
lmba2_m = vpa(subs(lmba2, [T, w1, K1, K2], [T_m,w1_m, K1_m, K2_m]),4);

inter = [0,0.2];
y1 = sym(lmba1_m);
fplot(y1, inter);
hold on;
y2 = sym(lmba2_m);
fplot(y2, inter);
hold on;
line_m = 0;
y3 = sym(line_m);
fplot(y3, inter);
lma = [];
lmb = [];
lmc = [];
for i=0:0.001:0.2
    lma = [lma; double(vpa(subs(lmba1_m, [g], [i]),4))];
    lmb = [lmb; double(vpa(subs(lmba2_m, [g], [i]),4))];
    lmc = [lmc; double(vpa(subs(line_m, [g], [i]),4))];
end
lmg = 0:0.001:0.2;
Out = [lmg', lma, lmb, lmc];
%save('C:\Users\LRF\OneDrive\works\WPT\PAPER\origin\matlab_record\Relamda_g\GxiaoyuK.mat','Out');

