%% 解微分方程得 a1 a2

clear; 
syms alpa
syms w1 w3  T lam g w2 ks1 ks2  T1 T2
syms a1(t)  a2(t) a3(t) t;
alpa = w3/w2;
eq1 = diff(a1, t) == (1i*w1+g)*a1 -1i*ks1*a2 -1i*ks1*a3;
eq2 = diff(a2, t) == -1i*ks1*a1 +(1i*w1-T1)*a2;
eq3 = diff(a3, t) == -1i*ks1*a1            +(1i*w1-alpa*T1)*a3;



cond = [a1(0)==1, a2(0)==0, a3(0)==0];
[a1, a2, a3] = dsolve(eq1, eq2, eq3, cond);

pretty(a1)


%% 绘图  a1 和 a2 的时域图像
g_m = 0.1E+5;
T1_m = 0.2E+2;
T2_m = 0.5E+2;
w1_m = 1E+6;
ks1_m = 0.5*0.1*w1_m;
x=[0:1E-5:1E-3];

a1
a2
a3

figure('color','w');
a1_m = abs(a1)^2;
a1_m = vpa(subs(a1_m, [g,T1,T2, w1,ks1], [g_m,T1_m,T2_m,w1_m, ks1_m,]));  %
z=subs(a1_m,t,x);
a1_avg = mean(z);
plot(x,z, 'r');
hold on;

a2_m = abs(a2)^2;
a2_m = vpa(subs(a2_m, [g,T1,T2, w1,ks1], [g_m,T1_m,T2_m,w1_m, ks1_m,]));
z=subs(a2_m,t,x);
a2_avg = mean(z);
plot(x,z, 'g');
hold on;

a3_m = abs(a3)^2;
a3_m = vpa(subs(a3_m, [g,T1,T2, w1,ks1], [g_m,T1_m,T2_m,w1_m, ks1_m,]));
z=subs(a3_m,t,x);
a3_avg = mean(z);
plot(x,z, 'b');
hold on;


Eprecent = vpa(a2_avg/a1_avg,4)


