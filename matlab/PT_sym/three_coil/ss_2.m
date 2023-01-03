
%% 双串联电路的耦合模推导 与  a1 a2波形图绘制

syms w1 w t lam g w2 ks k
syms a1(t)  a2(t) T;

%% 解特征值
A = [1i*w1+g,         -1i*ks;...
    -1i*ks,   1i*w1-T;];

[e,D] = eig(A)
pretty(e(2,1))
e


%% 解微分方程得 a1 a2
eq1 = diff(a1, t) == (1i*w1-g)*a1 -1i*ks*a2;
eq2 = diff(a2, t) == -1i*ks*a1 +(1i*w2-T)*a2;

cond = [a1(0)==1, a2(0)==0];
[a1, a2] = dsolve(eq1, eq2, cond)


% a1
% pretty(a1)



% A1 = -ks*1i*((g - w2*1i)*1i/ks  +   (  (- 4*ks^2 - w1^2 + 2*w1*w2 - w2^2)^(1/2)/2  +  w1*1i/2  + w2*1i/2  -g )/ks)   /   (- 4*ks^2 - w1^2 + 2*w1*w2 - w2^2)^(1/2)
% pretty(simplify(expand(A1)))
% 
% A2 = -ks*1i*( -(g - w2*1i)*1i/ks  +   (  (- 4*ks^2 - w1^2 + 2*w1*w2 - w2^2)^(1/2)/2  -  w1*1i/2  - w2*1i/2  +g )/ks)   /   (- 4*ks^2 - w1^2 + 2*w1*w2 - w2^2)^(1/2)
% pretty(simplify(expand(A2)))



%% 绘图  a1 和 a2 的时域图像
figure();
a1 = abs(a1)^2;
a1 = vpa(subs(a1, [g,T, w1, w2, ks], [-4E+2,3E+2, 1E+6, 1E+6, 0.5*0.1E+6]))  %
x=[0:1E-7:1E-3];
z=subs(a1,t,x);
plot(x,z);
hold on;


a2 = abs(a2)^2;
a2 = vpa(subs(a2, [g,T, w1, w2, ks], [-4E+2,3E+2, 1E+6, 1E+6, 0.5*0.1E+6]))
x=[0:1E-7:1E-3];
z=subs(a2,t,x);
plot(x,z);
hold on;

