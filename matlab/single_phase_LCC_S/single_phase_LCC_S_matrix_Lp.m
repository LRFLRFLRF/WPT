function [RES] = single_phase_LCC_S_matrix_Lp()
          %%  ����Lp��      ����w0, wn, r, Lp, RL, k
%%

syms R1 R2 RE L1 Cpp Cps Lp w m Css Ls w0 wn r Q RL k real%����ʵ�����ű���
syms Ir Ip Is Uin zin Uo
%% Ԫ���迹
%Ԫ���迹
zL1 = 1i*w*L1;
zCpp = 1/(1i*w*Cpp);
zCps = 1/(1i*w*Cps);
zLp = 1i*w*Lp;
zLs = 1i*w*Ls;
zCss = 1/(1i*w*Css);

%% ��·��������    �Ա��� w0, wn, r, Lp, RL, k
% �����һ��Ƶ��  wn = w/w0
w_d = wn*w0;
% ����Lp
Lp_d= Lp;
% �����б�  r = L1/Lp
L1_d = Lp*r;
L1_d = subs(L1_d, [w], [w_d]);     %��w�滻��wn w0��ʾ
% ������β���ֵLs       Ls = Lp    Ҳ���޸ĳ�һ��������ֵ
Ls_d = Lp_d;
% ���廥��ϵ��
k_d = k;
m_d = k*sqrt(Lp*Ls);
m_d = subs(m_d, [k, Lp, Ls], [k_d, Lp_d, Ls_d]);



%% ȷ��г������
%  Cpp��L1г��             w0 = 1/sqrt(L1*Cpp);
Cpp_d = 1/(w0^2*L1);
Cpp_d = subs(Cpp_d, L1, L1_d);    %��L1�滻��Q��ʾ

%  Cps��(Lp-L1)г��        w0 = 1/sqrt((Lp-L1)*Cps)
Cps_d = 1/(w0^2*(L1/r-L1));
Cps_d = subs(Cps_d, L1, L1_d);     %��L1�滻��Q��ʾ

%  Css��Lsг��          w0 = 1/sqrt(Ls*Css);
Css_d = 1/(w0^2*Ls);
Css_d = subs(Css_d, Ls, Ls_d);    %��Ls�滻��Q��ʾ


%% ��·������
z_m = [R1+zL1+zCpp, -zCpp, 0; -zCpp, zCps+zLp+zCpp, -1i*w*m; 0, -1i*w*m, zCss+zLs+RL+R2];
i_m = [Ir; Ip; Is];
u_m = [Uin; 0; 0];

% ���
i_m = solve(z_m*i_m == u_m, i_m);

% ����һ�β����Ip
Ip_d = i_m.Ip;
Ip_d = simplify(subs(Ip_d, [L1, Lp, Ls, w], [L1_d, Lp_d, Ls_d, w_d]));
Ip_d = simplify(subs(Ip_d, [Cpp, Cps, Css, w], [Cpp_d, Cps_d, Css_d,w_d]));
Ip_d = simplify(subs(Ip_d, [m], [m_d]));

% ������β����Is
Is_d = i_m.Is;
Is_d = simplify(subs(Is_d, [L1, Lp, Ls, w], [L1_d, Lp_d, Ls_d, w_d]));
Is_d = simplify(subs(Is_d, [Cpp, Cps, Css, w], [Cpp_d, Cps_d, Css_d,w_d]));
Is_d = simplify(subs(Is_d, [m], [m_d]));

% �����������Ir
Ir_d = i_m.Ir;
Ir_d = simplify(subs(Ir_d, [L1, Lp, Ls, w], [L1_d, Lp_d, Ls_d, w_d]));
Ir_d = simplify(subs(Ir_d, [Cpp, Cps, Css, w], [Cpp_d, Cps_d, Css_d,w_d]));
Ir_d = simplify(subs(Ir_d, [m], [m_d]));

% �������
zin = Uin/Ir;
zin = simplify(subs(zin, [Ir], [Ir_d]));
pretty(zin)

% ��ѹ����
Uo_d = Is*RL;
Uo_d = simplify(subs(Uo_d, [Is], [Is_d]));
Gu = simplify(Uo_d/Uin);
pretty(Gu);

% �������
Po = Is^2*RL;
Po = simplify(subs(Po, [Is], [Is_d]));
pretty(Po);

%% ����ص�
RES = struct('L1', {L1_d}, 'Lp', {Lp_d},'Ls', {Ls_d},'Cpp', {Cpp_d},'Cps', {Cps_d},'Css', {Css_d},'zin', {zin}, 'Gu', {Gu}, 'Po', {Po});

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


