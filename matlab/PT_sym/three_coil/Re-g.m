
syms w0 w t k12 k13 lam g kk

A = [1i*w0+g,         -0.5i*k12*w0-k12*t,    -0.5i*k13*w0-k13*t;...
    -0.5i*k12*w0+k12*t,   1i*w0-t,           0;...
    -0.5i*k13*w0+k13*t,   0,                     1i*w0-t;];

detA = det(lam*eye(3)-A)

res = solve(detA, lam)
pretty(res(3,1))

temp = - g^2 - 2*g*t- t^2;%4*k12^2*t^2 + k12^2*w0^2 + 4*k13^2*t^2 + k13^2*w0^2 ;%
temp1 = factor(temp)
pretty(temp1)


% »æÖÆ gºÍreal£¨lamda£©µÄÍ¼Ïñ
temp = real(g/2 - t/2 + w0*1i + ((- g^2 - 2*g*t - t^2 + kk^2*(4*t^2+w0^2) )^(1/2)*1i)/2);%

temp = vpa(subs(temp, [t, kk, w0],[0.2, 0.5, 1]),4)
y = sym(temp);
fplot(y);
hold on;

temp = real(g/2 - t/2 + w0*1i - ((- g^2 - 2*g*t - t^2 + kk^2*(4*t^2+w0^2) )^(1/2)*1i)/2);%
temp = vpa(subs(temp, [t, kk, w0],[0.2, 0.5, 1]),4)
y = sym(temp);
fplot(y);



