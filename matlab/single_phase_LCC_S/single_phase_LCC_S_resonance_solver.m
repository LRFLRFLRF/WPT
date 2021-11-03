
function single_phase_LCC_S_resonance_solver()
syms R1 R2 RE L1 Cpp Cps Lp w m Css Ls w0 wn r Q RL k real%����ʵ�����ű���
syms Ir Ip Is Uin zin Uo
syms zL1 zCpp zCps zLp zLs zCss
%% Ԫ���迹
%Ԫ���迹
zL1 = 1i*w*L1;
zCpp = 1/(1i*w*Cpp);
zCps = 1/(1i*w*Cps);
zLp = 1i*w*Lp;
zLs = 1i*w*Ls;
zCss = 1/(1i*w*Css);


%% ��·������
z_m = [zL1+zCpp, -zCpp, 0; -zCpp, zCps+zLp+zCpp, -1i*w*m; 0, -1i*w*m, zCss+zLs+RL];
i_m = [Ir; Ip; Is];
u_m = [Uin; 0; 0];



% ��д����
eq1 = z_m*i_m == u_m;
eq2 = zCss+zLs == 0;
eq3 = simplify(par(zCps+zLp, zCpp)+zL1) == 0;
eq4 = zCpp>0;
eq3
a = solve([eq3, eq4], [Cps, Cpp]);
a.Cps
%a.Css
a.Cpp

% ���
i_m = solve(z_m*i_m == u_m, i_m);

% ����һ�β����Ip
Ip_d = i_m.Ip;
Ip_d = simplify(subs(Ip_d, [L1, Lp, Ls, w], [L1_d, Lp_d, Ls_d, w_d]));
Ip_d = simplify(subs(Ip_d, [Cpp, Cps, Css, w], [Cpp_d, Cps_d, Css_d,w_d]));
Ip_d = simplify(subs(Ip_d, [m], [m_d]));

end


%%
%%�迹�������㺯��
function [s] = par(z1, z2)
    s = 1/((1/z1) + (1/z2));
end

%%˫Ԫ����ѹ���㺯��  sΪz1�ϵ�ѹ
function [s] = fen(z1, z2, ui)
    s = z1/(z1+z2)*ui;
end
