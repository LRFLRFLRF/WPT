


% attt3 = subs(a3, [k^2, k^3, r1^2, r1^3], [0, 0, 0, 0])
% pretty(attt3)
% syms k w1 r1
% temp = ((2*(w1*1i + (k*w1*1i)/4))/(r1*w1*1i + k*r1*w1*1i) - (k + 2)/(r1 + k*r1));
% [N,D]=numden(temp)

clear
% syms a1 a1g Cpp L1 a1_d1 w1 Rn
% syms a2 a2g Cps Lp a2_d1 w2 M k
% syms a3 a3g Css Ls a3_d1 w3
% syms a4 a4g Csp L2 a4_d1 w4 RL
% syms r1 r2 g t
syms k w1 r1 ks1 ks2  w2 g T
syms a1(t)  a2(t) a3(t) a4(t) t;

syms a1g Cpp L1 a1_d1 w1 Rn
syms a2g Cps Lp a2_d1 w2 M k
syms a3g Css Ls a3_d1 w3
syms a4g Csp L2 a4_d1 w4 RL

A = [w1, -0.5*r1*w1, 0, 0.5*k*r1*w1;...
    -0.5*r1*w1, w1, 0.5*k*r1*w1, -0.5*k*w1;...
    0,        0.5*k*r1*w1, w1, -0.5*r1*w1;...
    0.5*k*r1*w1, -0.5*k*w1, -0.5*r1*w1, w1;];


A = [1i*w1-g,     -1i*ks2,            0,       1i*k*ks2;...
    -1i*ks1,      1i*w2,       1i*k*ks1,     -0.5*k*w2;...
    0,           1i*k*ks2,        1i*w1-T,    -1i*ks2;...
    1i*k*ks1,   -0.5*k*w2,      -1i*ks1,        1i*w2;];



qcps_m = -1i*Cps^0.5/2^0.5*(a2-a2g);
qcps_d1_m = (a2+a2g)/2^0.5/Lp^0.5;
qcps_d2_m = 2^0.5/Lp^0.5*(a2_d1-1i*(a2+a2g)/(2*Lp^0.5*Cps^0.5));

qcss_m = -1i*Css^0.5/2^0.5*(a3-a3g);
qcss_d1_m = (a3+a3g)/2^0.5/Ls^0.5;
qcss_d2_m = 2^0.5/Ls^0.5*(a3_d1-1i*(a3+a3g)/(2*Ls^0.5*Css^0.5));

qcpp_m = -1i*Cpp^0.5/2^0.5*(a1-a1g);
qcpp_d1_m = (a1+a1g)/2^0.5/L1^0.5;
qcpp_d2_m = 2^0.5/L1^0.5*(a1_d1-1i*(a1+a1g)/(2*L1^0.5*Cpp^0.5));

qcsp_m = -1i*Csp^0.5/2^0.5*(a4-a4g);
qcsp_d1_m = (a4+a4g)/2^0.5/L2^0.5;
qcsp_d2_m = 2^0.5/L2^0.5*(a4_d1-1i*(a4+a4g)/(2*L2^0.5*Csp^0.5));

% 
eq1 = L1*qcpp_d2_m + L1*qcps_d2_m + qcpp_m/Cpp   == 0;%+ Rn*qcpp_d1_m + Rn*qcps_d1_m 
eq2 = Lp*qcps_d2_m + qcps_m/Cps + M*qcss_d2_m - qcpp_m/Cpp == 0; % 
eq3 = Ls*qcss_d2_m + qcss_m/Css + M*qcps_d2_m - qcsp_m/Csp == 0; %
eq4 = L2*qcsp_d2_m + L2*qcss_d2_m + qcsp_m/Csp == 0;%- RL*qcsp_d1_m - RL*qcss_d1_m 
% 求解得到da/dt
[a1t, a2t, a3t, a4t] = solve(eq1,eq2,eq3,eq4,a1_d1,a2_d1,a3_d1,a4_d1);

temp1 = 1/w1^2;
temp2 = 1/w2^2;
temp3 = 1/w2^2;
temp4 = 1/w1^2;
a1t = simplify(subs(a1t, [L1*Cpp, Lp*Cps, Ls*Css, L2*Csp, M/(Ls*Lp)^0.5, M^2, a4g, a3g, a2g, a1g], [temp1, temp2, temp3, temp4, k,0, 0 ,0, 0, 0]))
a2t = simplify(subs(a2t, [L1*Cpp, Lp*Cps, Ls*Css, L2*Csp, M/(Ls*Lp)^0.5, M^2, a4g, a3g, a2g, a1g], [temp1, temp2, temp3, temp4, k,0, 0 ,0, 0, 0]));
a3t = simplify(subs(a3t, [L1*Cpp, Lp*Cps, Ls*Css, L2*Csp, M/(Ls*Lp)^0.5, M^2, a4g, a3g, a2g, a1g], [temp1, temp2, temp3, temp4, k,0, 0 ,0, 0, 0]));
a4t = simplify(subs(a4t, [L1*Cpp, Lp*Cps, Ls*Css, L2*Csp, M/(Ls*Lp)^0.5, M^2, a4g, a3g, a2g, a1g], [temp1, temp2, temp3, temp4, k,0, 0 ,0, 0, 0]));

eq1 = diff(a1, t) == a1t;
eq2 = diff(a2, t) == a2t;
eq3 = diff(a3, t) == a3t;
eq4 = diff(a4, t) == a4t;


% eq1 = diff(a1, t) == (1i*w1-g)*a1 -1i*ks2*a2  + 1i*k*ks2*a3;
% eq2 = diff(a2, t) == -1i*ks1*a1 + 1i*w2*a2 + 1i*k*ks1*a4 -0.5*k*w2 *a3;
% eq3 = diff(a3, t) == 1i*k*ks1*a1 -0.5*k*w2*a2  -1i*ks1*a4 +  1i*w2*a3;
% eq4 = diff(a4, t) ==          1i*k*ks2*a2 + (1i*w1-T)*a4  -1i*ks2*a3;


cond = [a1(0)==1, a2(0)==0, a3(0)==0, a4(0)==0];
[a1,a2,a3,a4] = dsolve(eq1, eq2, eq3, eq4, cond);


%% 绘图  a1 和 a2 的时域图像
g_m = -0E+2;
T_m = 1E+2;
w1_m = 1E+6;
w2_m = 1E+6;
k_m = 0.5;
ks1_m = 0.5*0.1*w1_m;
ks2_m = 0.5*0.1*w2_m;

figure();
a1t = abs(a1t)^2;
a1t = vpa(subs(a1t, [g,T, w1, w2, ks1, ks2, k], [g_m,T_m,w1_m, w2_m, ks1_m, ks2_m, k_m]), 4)  %
x=[0:1E-7:1E-3];
z=subs(a1t,t,x);
plot(x,z);
hold on;

figure();
a3t = abs(a3t)^2;
a3t = vpa(subs(a3t, [g,T, w1, w2, ks1, ks2, k], [g_m,T_m,w1_m, w2_m, ks1_m, ks2_m, k_m]), 4)  %
x=[0:1E-7:1E-3];
z=subs(a3t,t,x);
plot(x,z);
hold on;


