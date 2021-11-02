

%% 集肤深度计算

sig = 5.8*1E+07;   %铜的电导率
u0 = 4*pi*1E-07;   %真空磁导率
f = 50*1E+03;    %额定频率
%%计算集肤深度delta 单位m
delta = 1/sqrt(pi*f*u0*sig);
disp(['depth = ', num2str(delta*1E+3), 'mm'])

%% 谐振频率计算
syms C L f

sol = simplify(solve(2*f*pi*sqrt(L*C) == 1,C));

L = 17.57E-6;
f = 100E+3;
sol = vpa(subs(sol),4)


