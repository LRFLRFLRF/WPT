
%% 双线圈PT对称理论下的推导

syms L1 L2
syms w0 w k t1 t2 tL v

A = [1i*(w0-w)-t1+v, 0.5*1i*k*w0;
    0.5*1i*k*w0, 1i*(w0-w)-t2-tL];

fun=det(A);%求解行列式的结果
x=solve(fun, w);%解行列式等于0
pretty(x)


%%%
syms K T G a1 a2
A = [1i*w0+G, -1i*K;
    -1i*K, 1i*w0-T];

x = dsolve('Da1 == (1i*w0+G)*a1 + (-1i*K)*a2','Da2 == (-1i*K)*a1 + (1i*w0-T)*a2')
pretty(x.G)


%% 求解lamda
syms K T
A = [1i*w0+T, -1i*K;
    -1i*K, 1i*w0-T];
EIG = eig(A)
pretty(EIG)

%% 求特征方程实部

eq1 = 0.5*(g-T)-sqrt((0.5*(g+T))^2-K^2) == 0;
RES = solve(eq1, g)
pretty(RES)
