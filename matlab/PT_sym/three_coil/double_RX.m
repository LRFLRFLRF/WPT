%% Çó½âlamda
syms K T 
A = [1i*w0+T, -1i*K;
    -1i*K, 1i*w0-T];
EIG = eig(A)
pretty(EIG)