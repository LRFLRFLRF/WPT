



clear;
%% 计算电流增益
syms w1 w2 k12 k13 Q1 Q2 d real; 
syms w real;
syms ip is1 is2;
% 设sqrt(L2/L1)=d   


A = [w1/w-w/w1-1i/Q1,     w/w1*k12*d,    w/w1*k13*d;...
    w/w1*k12/d,   w1/w-w/w1+1i/Q1,           0;...
    w/w1*k13/d,   0,                     w1/w-w/w1+1i/Q1;];


%w_d = w1/sqrt(2*(1-(k12^2+k13^2)))*sqrt(2- Q1^(-2) -sqrt(4*(k12^2+k13^2-1)+(2-Q1^(-2))^2));

%A1 = simplify(subs(A, [w], [w_d]));
A1 = A;
eq1 = A1(2,1)*ip +  A1(2,2)*is1 == 0;

ipbiis1 = simplify((-A1(2,2)/A1(2,1)));
pretty(ipbiis1)


ipbiis1abs = sqrt(real(-(d*(- Q1*w^2 + w*w1*1i + Q1*w1^2))/(Q1*k12*w^2))^2 + imag(-(d*(- Q1*w^2 + w*w1*1i + Q1*w1^2))/(Q1*k12*w^2))^2);
pretty(ipbiis1abs)
