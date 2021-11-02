function fuhao()
syms RL L1 Cpp Cps Lp w m Css Ls real%创建实数符号变量
syms Ip Is Uin



%%电路条件
%L1和Cpp谐振
Cpp = 1/(L1*w^2);
%（Lp-L1）与Cps谐振   %Cpp与Cps串联Lp谐振，又因为Cpp与L1谐振，因此Cps与（Lp-L1）谐振
%Cps = simplify(solve(0 == simplify(1i*w*Lp+1/(1i*w*Cps)+1/(1i*w*Cpp)),Cps)); 
Lp = 1/(Cps*w^2)+L1;
%Ls与Css谐振
Ls = 1/(Css*w^2);

%% 计算
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
%元件阻抗
zL1 = 1i*w*L1;
zCpp = 1/(1i*w*Cpp);
zCps = 1/(1i*w*Cps);
zLp = 1i*w*Lp;
zLs = 1i*w*Ls;
zCss = 1/(1i*w*Css);

%%%LCC/S
%% zin 系统总输入阻抗
z2 = zLs + zCss + RL;%二次侧阻抗
zZeq2 = w^2*m^2/z2;%归算z2阻抗到一次侧
zin = simplify(zL1+par((zCps+zZeq2+zLp), zCpp));
zin_re = real(zin) %zin实部
zin_im = imag(zin) %zin虚部
%[n_im d_im] = numden(im)

%% Ip计算
Ucpp = simplify(fen(simplify(par(zCpp, zLp+zCps+zZeq2)), zL1, Uin));
Ip = simplify(Ucpp/simplify(zLp+zCps+zZeq2));

%% Is计算
Is = 1i*w*m*Ip/(zCss+zLs+RL);
Uo = Is*RL

%% Pin Pout
Pin = simplify(Uin^2/zin)
Pout = simplify(Uo^2/RL)



end

%%并联计算函数
function [s] = par(z1, z2)
    s = 1/((1/z1) + (1/z2));
end

%%双元件分压计算函数  s为z1上电压
function [s] = fen(z1, z2, ui)
    s = z1/(z1+z2)*ui;
end
