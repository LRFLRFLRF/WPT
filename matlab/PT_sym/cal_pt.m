clear;

syms C1 r1 L1 L2 C2 r2 RL RN M k 
syms w I1 I2 Q1 Q2 w1 w2
%% 元件阻抗
%元件阻抗
zL1 = 1i*w*L1;
zC1 = 1/(1i*w*C1);
zL2 = 1i*w*L2;
zC2 = 1/(1i*w*C2);
zM = 1i*w*M;
%% 电路变量定义
%w1 = 1/sqrt(L1*C1);
d1 = 1/w1;

%w2 = 1/sqrt(L2*C2);
d2 = 1/w2;

%Q1 = w1*L1/(-RN+r1);
d3 = w1*L1/Q1;

%Q2 = w2*L2/(RL+r2);
d4 = w2*L2/Q2;

I = [I1; I2];
Z = [-RN+r1+zL1+zC1, -zM;
    -zM, RL+r2+zL2+zC2];


% 将Z中的M用k替换掉  
M_d = k*sqrt(L1*L2);
Z_d = simplify(subs(Z, {M, -RN+r1, RL+r2}, {M_d, d3, d4}));
Z_d = simplify(subs(Z_d, {sqrt(L1*C1), sqrt(L2*C2)}, {d1, d2}))

pretty(Z_d)

Z_d = [w1/w-w/w1+1i*(1/Q1), w/w1*k*sqrt(L2/L1);
    w/w1*k*sqrt(L2/L1), w2/w-w/w2+1i*(1/Q2)];

Z_d = simplify(subs(Z_d, {w2}, {w1}));
Z_h = det(Z_d);

real = simplify(real(Z_h))
imag = simplify(imag(Z_h))

