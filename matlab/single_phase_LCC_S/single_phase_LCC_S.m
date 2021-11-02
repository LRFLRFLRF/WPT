function [zin] = single_phase_LCC_S()
          %%  ����L1/Lp��
%%

syms RE L1 Cpp Cps Lp w m Css Ls w0 wn r Q RL k real%����ʵ�����ű���
syms Ir Ip Is Uin zin Uo
%% Ԫ���迹
%Ԫ���迹
zL1 = 1i*w*L1;
zCpp = 1/(1i*w*Cpp);
zCps = 1/(1i*w*Cps);
zLp = 1i*w*Lp;
zLs = 1i*w*Ls;
zCss = 1/(1i*w*Css);

%% ��·��������    �Ա��� w0, wn, r, Q, RL, k
% �����һ��Ƶ��  wn = w/w0
w_d = wn*w0;
% ����Qֵ     Q = w*L1/RL;
L1_d = Q*RL/(w);
L1_d = subs(L1_d, w, w_d);     %��w�滻��wn w0��ʾ
% �����б�  r = L1/Lp
Lp_d = L1/r;
Lp_d = subs(Lp_d, [w, L1], [w_d, L1_d]);     %��w�滻��wn w0��ʾ
% ������β���ֵLs       Ls = Lp    Ҳ���޸ĳ�һ��������ֵ
Ls_d = Lp_d;
% ���廥��ϵ��
k_d = 0.65;
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

% �����迹չ���ɸ����迹
RE_d = w^2*m^2/(RL+zLs+zCss);
RE_d = simplify(subs(RE_d, [w, Ls, Css, m], [w_d, Ls_d, Css_d, m_d]));


               %% ���������迹
%%
% �����迹���㹫ʽ
zin = zL1 + par(zCpp, (zLp + zCps + RE));
% ����г������
zin = simplify(subs(zin, [L1, Lp, Cpp, Cps w, RE], [L1_d, Lp_d, Cpp_d, Cps_d, w_d, RE_d]));
pretty(zin);


%% ���ԣ���  ��Ƶ�ʱ�wn����1  ������Ƶ��w����г��w0ʱ zinӦ����L1^2*RL/m^2
%%������Q��r
% wn_test = 1;
% Q_test = solve(L1_d == L1, Q);
% Q_test = subs(Q_test, [wn], [wn_test]);
% r_test = solve(m_d == m, r);
% r_test = subs(r_test, [wn, Q], [wn_test, Q_test]);
% if size(r_test,1)~=1         %r_test ���õ���������ȡ���е�һ��
%     r_test = r_test(1, 1);
% end
% % �����迹
% a = simplify(subs(zin, [wn, Q, r], [wn_test, Q_test, r_test]));
% pretty(a)

%% �����迹��Ƶ�ʱ任��ͼ
r_d = 0.1;
w0_d = 2*pi*100E+3;
RL_d = 50;

% �����迹 ��ֵ - Ƶ�� ͼ   �ı�Qֵ����L1
figure();
Q_list = [0.2, 0.4, 0.6, 0.8, 1, 2, 3, 4, 5, 6];
color=linspace(0.1,1,length(Q_list));
c_index = 1;
for i=Q_list
    Q_d = i;
    zin_temp = abs(subs(zin, [Q, r, w0, RL], [Q_d, r_d, w0_d, RL_d]));
    
    x_list = 0.5:0.01:1.5;
    y_list = [];
    for j=x_list
        y_list = [y_list, subs(zin_temp, wn, j)];
    end

    plot(x_list, y_list, 'color',[color(c_index) 0 0]);
    c_index = c_index +1;
    hold on;
end

% �����迹 ��� - Ƶ�� ͼ   �ı�Qֵ����L1
figure();
Q_list = [0.2, 0.4, 0.6, 0.8, 1, 2, 3];
color=linspace(0.1,1,length(Q_list));
c_index = 1;
for i=Q_list
    Q_d = i;
    zin_temp = angle(subs(zin, [Q, r, w0, RL, m], [Q_d, r_d, w0_d, RL_d, m_d]))*180/pi;
    
     x_list = 0.5:0.01:1.5;
    y_list = [];
    for j=x_list
        y_list = [y_list, subs(zin_temp, wn, j)];
    end

    plot(x_list, y_list, 'color',[color(c_index) 0 0]);
    c_index = c_index +1;
    hold on;
end


               %% ����һ�β෴���迹RE�ϵ������ѹ
%% 
%��д��·��������
syms Gu
z_m = [zL1+zCpp, -zCpp; -zCpp, zCps+zLp+RE+zCpp];
i_m = [Ir; Ip];
u_m = [Uin; 0];

% ���һ�β����Ip
i_m = solve(z_m*i_m == u_m, i_m);
Ip_d = i_m.Ip;
Ip_d = simplify(subs(Ip_d, [L1, Lp, w], [L1_d, Lp_d, w_d]));
Ip_d = simplify(subs(Ip_d, [L1, Cpp, Cps], [L1_d, Cpp_d, Cps_d]));
Ip_d = simplify(subs(Ip_d, [RE], [RE_d]));

% ������β����Is
Is_d = 1i*w*m*Ip_d/(zCss+zLs+RL);
Is_d = simplify(subs(Is_d, [Ls, Css, w, m], [Ls_d, Css_d, w_d, m_d]));


% ���������ѹ
Uo_d = Is*RL;
Uo_d = simplify(subs(Uo_d, [Is], [Is_d]));
pretty(Uo_d);

% ����LCC��ѹ����
Gu = Uo_d/Uin;
pretty(Gu);


%% ��ѹ������Ƶ�ʱ任��ͼ
r_d = 0.05;
w0_d = 2*pi*100E+3;
RL_d = 50;
syms Gu_temp

figure();
Q_list = [0.2, 0.4, 0.6, 0.8, 1, 2, 3, 4, 5, 6];
color=linspace(0.1,1,length(Q_list));
c_index = 1;
for i=Q_list
    Q_d = i;
    Gu_temp = simplify(abs(subs(Gu, [Q, r, RL, w0], [Q_d, r_d, RL_d, w0_d])));
    
    x_list = 0.95:0.002:1.05;
    y_list = [];
    for j=x_list
        y_list = [y_list, subs(Gu_temp, wn, j)];
    end

    plot(x_list, y_list, 'color',[color(c_index) 0 0]);
    c_index = c_index +1;
    hold on;
end

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


