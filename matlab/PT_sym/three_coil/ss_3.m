
%% 三串联电路的耦合模推导 与  a1 a2 a3波形图绘制
clear; 
syms w1 w3  T lam g w2 ks1 ks2  T1 T2 alpa
syms a1(t)  a2(t) a3(t) t;

%% 解特征值

A = [1i*w1+g,         -1i*ks1,       -1i*ks1;...
    -1i*ks1,           1i*w1-T,           0;...
    -1i*ks1,   0,                     1i*w1-alpa*T;];


[e,D] = eig(A);
% pretty(e(2,1))
D
e
pretty(e(1,1))


%% 解微分方程得 a1 a2
syms alpa
% alpa = w3/w2;
% eq1 = diff(a1, t) == (1i*w1-g)*a1 -1i*ks1*a2 -1i*ks2*a3;
% eq2 = diff(a2, t) == -1i*ks1*a1 +(1i*w2-T)*a2;
% eq3 = diff(a3, t) == -1i*ks2*a1            +(1i*alpa*w2-T)*a3;

% 基础版
eq1 = diff(a1, t) == (1i*w1-g)*a1 -1i*ks1*a2 -1i*ks2*a3;
eq2 = diff(a2, t) == -1i*ks1*a1 +(1i*w1-T)*a2;
eq3 = diff(a3, t) == -1i*ks2*a1            +(1i*w1-T)*a3;



cond = [a1(0)==1, a2(0)==0, a3(0)==0];
[a1, a2, a3] = dsolve(eq1, eq2, eq3, cond)
%a1
%pretty(a1)

% A1 = -ks*1i*((g - w2*1i)*1i/ks  +   (  (- 4*ks^2 - w1^2 + 2*w1*w2 - w2^2)^(1/2)/2  +  w1*1i/2  + w2*1i/2  -g )/ks)   /   (- 4*ks^2 - w1^2 + 2*w1*w2 - w2^2)^(1/2)
% pretty(simplify(expand(A1)))
% 
% A2 = -ks*1i*( -(g - w2*1i)*1i/ks  +   (  (- 4*ks^2 - w1^2 + 2*w1*w2 - w2^2)^(1/2)/2  -  w1*1i/2  - w2*1i/2  +g )/ks)   /   (- 4*ks^2 - w1^2 + 2*w1*w2 - w2^2)^(1/2)
% % pretty(simplify(expand(A2)))


%% 绘图  a1 和 a2 的时域图像
g_m = -0E+5;
T_m = 0E+2;
w1_m = 400E+3;
w2_m = 400E+3;
w3_m = 400E+3;
alpa_m = 1;
ks1_m = 0.1*0.1*w1_m;
ks2_m = 0.1*0.1*w1_m;
x=[0:1E-6:1E-3];


figure();
a1 = abs(a1)^2;
a1 = vpa(subs(a1, [g,T, w1, w2, w3, ks1, ks2, alpa], [g_m,T_m,w1_m, w2_m, w3_m, ks1_m, ks2_m, alpa_m]))  %
z=subs(a1,t,x);
a1_avg = mean(z);
plot(x,z);
hold on;

%figure()
a2 = abs(a2)^2;
a2 = vpa(subs(a2, [g,T, w1, w2, w3, ks1, ks2, alpa], [g_m,T_m,w1_m, w2_m, w3_m, ks1_m, ks2_m, alpa_m]))
z=subs(a2,t,x);
a2_avg = mean(z);
plot(x,z);
hold on;

%figure()
a3 = abs(a3)^2;
a3 = vpa(subs(a3, [g,T, w1, w2, w3, ks1, ks2, alpa], [g_m,T_m,w1_m, w2_m, w3_m, ks1_m, ks2_m, alpa_m]))
z=subs(a3,t,x);
a3_avg = mean(z);
plot(x,z);
hold on;


Eprecent = vpa(a2_avg/a1_avg,4)


