function fuhao()
syms RL L1 Cpp Cps Lp w m Css Ls real%����ʵ�����ű���
syms Ip Is Uin



%%��·����
%L1��Cppг��
Cpp = 1/(L1*w^2);
%��Lp-L1����Cpsг��   %Cpp��Cps����Lpг������ΪCpp��L1г�����Cps�루Lp-L1��г��
%Cps = simplify(solve(0 == simplify(1i*w*Lp+1/(1i*w*Cps)+1/(1i*w*Cpp)),Cps)); 
Lp = 1/(Cps*w^2)+L1;
%Ls��Cssг��
Ls = 1/(Css*w^2);

%% ����
% Lp = 17.57E-6;
% f = 100E+3;
% w = 2*pi*f;
% Cpp = 1E-6;
% 
% equ1 = Lp - 1/(Cps*w^2)+L1 == 0;
% equ2 = Cpp - 1/(L1*w^2) == 0;
% [cps, l1] = solve(equ1, equ2, Cps, L1);
% cps = vpa(cps, 4)
% l1 = vpa(l1, 4)



%% 
%Ԫ���迹
zL1 = 1i*w*L1;
zCpp = 1/(1i*w*Cpp);
zCps = 1/(1i*w*Cps);
zLp = 1i*w*Lp;
zLs = 1i*w*Ls;
zCss = 1/(1i*w*Css);

%%%LCC/S
%% zin ϵͳ�������迹
z2 = zLs + zCss + RL;%���β��迹
zZeq2 = w^2*m^2/z2;%����z2�迹��һ�β�
zin = simplify(zL1+par((zCps+zZeq2+zLp), zCpp));
zin_re = real(zin) %zinʵ��
zin_im = imag(zin) %zin�鲿
%[n_im d_im] = numden(im)

%% Ip����
Ucpp = simplify(fen(simplify(par(zCpp, zLp+zCps+zZeq2)), zL1, Uin));
Ip = simplify(Ucpp/simplify(zLp+zCps+zZeq2));

%% Is����
Is = 1i*w*m*Ip/(zCss+zLs+RL);
Uo = Is*RL

%% Pin Pout
Pin = simplify(Uin^2/zin)
Pout = simplify(Uo^2/RL)



end

%%�������㺯��
function [s] = par(z1, z2)
    s = 1/((1/z1) + (1/z2));
end

%%˫Ԫ����ѹ���㺯��  sΪz1�ϵ�ѹ
function [s] = fen(z1, z2, ui)
    s = z1/(z1+z2)*ui;
end
