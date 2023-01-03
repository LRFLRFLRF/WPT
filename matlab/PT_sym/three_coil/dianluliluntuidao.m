
clear;
%%
syms w1 w2 k12 k13 Q1 Q2 d real; 
syms w real;
% Éèsqrt(L2/L1)=d   
A = [w1/w-w/w1-1i/Q1,     w/w1*k12*d,    w/w1*k13*d;...
    w/w1*k12/d,   w1/w-w/w1+1i/Q1,           0;...
    w/w1*k13/d,   0,                     w1/w-w/w1+1i/Q1;];

RES = simplify(det(A));
pretty(RES)

realres = simplify(real(RES));
pretty(realres)

imagres = simplify(imag(RES))
pretty(imagres)

%% 
aa = - Q1^2*k12^2*w^4 - Q1^2*k13^2*w^4 + Q1^2*w^4 - 2*Q1^2*w^2*w1^2 + Q1^2*w1^4 + w^2*w1^2;
r = solve(aa, w,'ReturnConditions', true);
pretty(r.w(3))
r.conditions

%% kcÌõ¼þ 
syms k real;
bb = ((4*Q1^4*k^2 - 4*Q1^2 + 1)^(1/2) + 2*Q1^2 - 1);
r = solve(bb, k,'ReturnConditions', true);
pretty(r.k)
r.conditions

%pretty(((4*Q1^2 + (2*Q1^2 - 1)^2 - 1)/(4*Q1^4))^(1/2))
%pretty((4*Q1^4*k^2 - 4*Q1^2 + 1)^(1/2) + 2*Q1^2 - 1)


%% 
res = eig(A)

aa = (w*(4*Q1^2*Q2^2*k12^2*w^2 + 4*Q1^2*Q2^2*k13^2*w^2 - Q1^2*w1^2 + 2*Q1*Q2*w1^2 - Q2^2*w1^2)^(1/2) + Q1*w*w1*1i + Q2*w*w1*1i - 2*Q1*Q2*w^2 + 2*Q1*Q2*w1^2)/(2*Q1*Q2*w*w1);
r = solve(real(aa), Q1)

%% 
eq1 = det(A)==0;
res = solve(eq1, w,'ReturnConditions', true)
res.w
% 
%pretty((w1*1i + w1*((2*Q2 - 1)*(2*Q2 + 1))^(1/2))/(2*Q2))
%pretty(Q1*Q2*w^4 - Q1*Q2*k13^2*w^4 - Q1*Q2*k12^2*w^4 - Q2*w1*w^3*1i - Q1*w1*w^3*1i - 2*Q1*Q2*w1^2*w^2 - w1^2*w^2 + Q2*w1^3*w*1i + Q1*w1^3*w*1i + Q1*Q2*w1^4)
pretty(Q1^2*w^4 - Q1^2*k13^2*w^4 - Q1^2*k12^2*w^4 - Q1*w1*w^3*2i - 2*Q1^2*w1^2*w^2 - w1^2*w^2 + Q1*w1^3*w*2i + Q1^2*w1^4)
