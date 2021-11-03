%% Three Phase Series Resonant Tuning

warning off

syms Ca Cb Cc w La Lb Lc Mab Mbc Mca
syms Lya Lda Lyb Ldb Lyc Ldc Ld

L = [La,Mab,Mca;Mab,Lb,Mbc;Mca,Mbc,Lc]; % Inductance Matrix (Equation 1)
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
%% Delta-L Delta-C
%%
 % 6x6 circuit matrix
Z = [1i*w*P*L,P*I;-I,1i*w*C]

% Transform to alpha-beta-gamma coordinates
Zdq = blkdiag(T,T)*Z*blkdiag(T,T)'

% 2x2 Schur complement impedance matrix
Zdq = simplify(Zdq(1:2,1:2)-simplify(Zdq(1:2,3:6)*(simplify(Zdq(3:6,3:6)\Zdq(3:6,1:2)))))

% Solve for capacitor values
z_dd.Ca = solve(Zdq(1,1),Ca);
Zdq = subs(Zdq,Ca,z_dd.Ca);
z_dd.Cb = solve(Zdq(1,2),Cb);
Zdq = subs(Zdq,Cb,z_dd.Cb);
z_dd.Cc = solve(Zdq(2,2),Cc);
z_dd.Cb = subs(z_dd.Cb,Cc,z_dd.Cc);
z_dd.Ca = subs(z_dd.Ca,Cc,z_dd.Cc);
z_dd.Ca = subs(z_dd.Ca,Cb,z_dd.Cb);

% Verify resonance condition
Zdq = simplify(subs(Zdq,[Ca,Cb,Cc],[z_dd.Ca,z_dd.Cb,z_dd.Cc]))

% Equation 37
Ca_dd = simplify(z_dd.Ca)
%% Wye-L Delta-C
%%
% 6x6 circuit matrix
Z = [1i*w*P*L,Dy;-Dd,1i*w*C];
    
Zdq = blkdiag(T,T)*Z*blkdiag(T,T)'; % Transform to alpha-beta-gamma coordinates

% 2x2 Schur complement impedance matrix
Zdq = (Zdq(1:2,1:2)-(Zdq(1:2,3:6)*((Zdq(3:6,3:6)\Zdq(3:6,1:2)))))

% Solve for capacitor values
z_yd = solve([Zdq(1,1),Zdq(1,2),Zdq(2,2)],[Ca,Cb,Cc]);
% Verify resonance condition
Zdq = simplify(subs(Zdq,[Ca,Cb,Cc],[z_yd.Ca,z_yd.Cb,z_yd.Cc]))

% Substitute Equation 34 for Phases A, B, and C for an intermediate result
Ca_yd = simplify(subs(z_yd.Ca,[La,Lb,Lc],[Lda-Mab-Mca,Ldb-Mbc-Mab,Ldc-Mca-Mbc]))

% Substitute Equation 35 to get Equation 38
Ca_yd = simplify(subs(Ca_yd,Lda,Ld-Ldb-Ldc))
%% Delta-L Wye-C
%%
% 6x6 circuit matrix
Z = [1i*w*Dy*L,P;-I,1i*w*Dd*C];
    
% Transform to alpha-beta-gamma coordinates 
Zdq = blkdiag(T,T)*Z*blkdiag(T,T)';

% 2x2 Schur complement impedance matrix
Zdq = simplify(Zdq(1:2,1:2)-simplify(Zdq(1:2,3:6)*(simplify(Zdq(3:6,3:6)\Zdq(3:6,1:2)))));

% Solve for capacitor values
z_dy = solve([Zdq(1,1),Zdq(1,2),Zdq(2,2)],[Ca,Cb,Cc]);

% Verify resonance condition
Zdq = simplify(subs(Zdq,[Ca,Cb,Cc],[z_dy.Ca,z_dy.Cb,z_dy.Cc]))

% Substitute Equation 33 for Phases A, B, and C to get Equation 39
Ca_dy = simplify(subs(z_dy.Ca,[La,Lb,Lc],[Lya+Mab-Mbc+Mca,Lyb+Mbc-Mca+Mab,Lyc+Mca-Mab+Mbc]))
%% Wye-L Wye-C
%%
% 6x6 circuit matrix
Z = [1i*w*Dy*L,Dy; -I,1i*w*C];

 % Transform to alpha-beta-gamma coordinates
Zdq = blkdiag(T,T)*Z*blkdiag(T,T)';

% 3x3 Schur complement impedance matrix
Zdq = simplify(Zdq(1:3,1:3)-simplify(simplify(Zdq(1:3,4:6))*(simplify(Zdq(4:6,4:6)\simplify(Zdq(4:6,1:3))))));

% Solve for capacitor values
z_yy = solve([Zdq(1,1),Zdq(1,2),Zdq(2,2),Zdq(2,1)],[Ca,Cb,Cc]);

% Verify resonance condition (Zdq(1:3,1:2) == [0,0;0,0])
Zdq = simplify(subs(Zdq,[Ca,Cb,Cc],[z_yy.Ca,z_yy.Cb,z_yy.Cc]))

% Substitute Equation 33 to get Equation 40
Ca_yy = subs(z_yy.Ca,La,Lya+Mab-Mbc+Mca)

warning on