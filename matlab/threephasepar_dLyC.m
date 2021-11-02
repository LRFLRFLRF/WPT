warning off

syms Ca Cb Cc w La Lb Lc Mab Mbc Mca
syms Lya Lda Lyb Ldb Lyc Ldc Ld

L = [La,Mab,Mca;Mab,Lb,Mbc;Mca,Mbc,Lc]; % Inductance Matrix (Equation 1)
%L = [La,0,0;0,Lb,0;0,0,Lc];
C = diag([Ca,Cb,Cc]);                   % Capacitor Matrix (Equation 21)
O = sym(zeros(3,3));                    % Zero Matrix
I = sym(eye(3,3));                      % Identity Matrix
P = circshift(I,[1,0]);                 % Permutation Matrix (Equation 6)
Dy = I - P';                            % Wye-Difference Matrix (Equation 5)
Dd = P - P';                            % Delta-Difference Matrix (Equation 3)


% Clarke transformation matrix (Equation 14)
T = sqrt(2/3)*sym([1,-1/2,-1/2;
                    0,sqrt(3)/2,-sqrt(3)/2;
                    sqrt(2)/2,sqrt(2)/2,sqrt(2)/2]);
                
                
                %% Delta-L Wye-C
%%
% 6x6 circuit matrix
Z = [-1i*w*P*L,Dy;Dd,1i*w*C];
    
Zdq = blkdiag(T,T)*Z*blkdiag(T,T)'% Transform to alpha-beta-gamma coordinates


%% 2x2 Schur complement impedance matrix
Zdq = (Zdq(1:2,1:2)-(Zdq(1:2,3:6)*((Zdq(3:6,3:6)\Zdq(3:6,1:2)))))     %ø…”√

% Solve for capacitor values
z_yd.Ca = solve(Zdq(1,1),Ca);
z_yd.Ca
Zdq = simplify(subs(Zdq,Ca,z_yd.Ca))

z_yd.Cb = solve(Zdq(1,2),Cb);
z_yd.Cb
Zdq = simplify(subs(Zdq,Cb,z_yd.Cb))

z_yd.Cc = solve(Zdq(2,2),Cc);
%z_yd.Cc(1,1)
Zdq = simplify(subs(Zdq,Cc,z_yd.Cc(1,1)))  %

z_yd.Cb = subs(z_yd.Cb,Cc,z_yd.Cc(1,1));   %
z_yd.Ca = subs(z_yd.Ca,Cc,z_yd.Cc(1,1));   %
z_yd.Ca = subs(z_yd.Ca,Cb,z_yd.Cb);
z_yd.Ca
% Verify resonance condition
Zdq = simplify(subs(Zdq,[Ca,Cb,Cc],[z_yd.Ca,z_yd.Cb,z_yd.Cc(1,1)]))   %


Ca_yd = simplify(z_yd.Ca)

La = 175E-6;
Lb = 175E-6;
Lc = 175E-6;
Mab = 0;
Mbc = 0;
Mca = 0;
Ca_yd = simplify(subs(Ca_yd))

