% ���� LCC/S ��·��Ԫ��ֵ���

syms R1 R2 RE L1 Cpp Cps Lp w m Css Ls w0 wn r Q RL k real%����ʵ�����ű���
syms Ir Ip Is Uin zin u_RE Uo


% �趨��·����
Uin_d = 50;    %�����ѹ��ֵ
r_d = 0.1;   % ��б�
Q_d = 0.1;    % Qֵ
RL_d = 50;   % ���β��������
w0_d = 2*pi*100E+3;     % ����г��Ƶ��
wn_d = 1;         % ʵ�ʹ���Ƶ�������г��Ƶ�ʱ�ֵ
k_d = 0.65;      %����
R1_d = 0.5;     %һ�βർ�ߵ���
R2_d = 0.5;     %���βർ�ߵ���

% ����·
res = single_phase_LCC_S_matrix();

% �����趨����
L1 =res.L1
L1 = vpa(simplify(subs(res.L1, [r, Q, RL, w0, wn, k, R1, R2], [r_d, Q_d, RL_d, w0_d, wn_d, k_d, R1_d, R2_d])), 4)
Lp =res.Lp
Lp = vpa(simplify(subs(res.Lp, [r, Q, RL, w0, wn, k, R1, R2], [r_d, Q_d, RL_d, w0_d, wn_d, k_d, R1_d, R2_d])), 4)
Ls = res.Ls
Ls = vpa(simplify(subs(res.Ls, [r, Q, RL, w0, wn, k, R1, R2], [r_d, Q_d, RL_d, w0_d, wn_d, k_d, R1_d, R2_d])), 4)
Cpp = res.Cpp
Cpp = vpa(simplify(subs(res.Cpp, [r, Q, RL, w0, wn, k, R1, R2], [r_d, Q_d, RL_d, w0_d, wn_d, k_d, R1_d, R2_d])), 4)
Cps = res.Cps
Cps = vpa(simplify(subs(res.Cps, [r, Q, RL, w0, wn, k, R1, R2], [r_d, Q_d, RL_d, w0_d, wn_d, k_d, R1_d, R2_d])), 4)
Css = res.Css
Css = vpa(simplify(subs(res.Css, [r, Q, RL, w0, wn, k, R1, R2], [r_d, Q_d, RL_d, w0_d, wn_d, k_d, R1_d, R2_d])), 4)
zin = res.zin
zin = vpa(simplify(subs(res.zin, [r, Q, RL, w0, wn, k, R1, R2], [r_d, Q_d, RL_d, w0_d, wn_d, k_d, R1_d, R2_d])), 4)
Gu = res.Gu
Gu = simplify(subs(res.Gu, [R1, R2], [0, 0]))   % ����R1 R2Ӱ��  �Լ򻯱���ʽ
Gu = vpa(simplify(subs(res.Gu, [r, Q, RL, w0, wn, k, R1, R2], [r_d, Q_d, RL_d, w0_d, wn_d, k_d, R1_d, R2_d])), 4)
Po = res.Po
Po = simplify(subs(res.Po, [R1, R2], [0, 0]))   % ����R1 R2Ӱ��  �Լ򻯱���ʽ
Po = vpa(simplify(subs(res.Po, [r, Q, RL, w0, wn, k, R1, R2], [r_d, Q_d, RL_d, w0_d, wn_d, k_d, R1_d, R2_d])), 4)

%% �����迹 zin ��ֵ - Ƶ�� ��Ƶ�� wn �任��ͼ   ��Q�仯��
func = abs(subs(res.zin, [r, w0, RL, k, R1, R2], [r_d, w0_d, RL_d, k_d, R1_d, R2_d]));
single_phase_LCC_S_parmamer_plot(func, Q, [0.2, 0.4, 0.6, 0.8, 1, 2, 3], wn, [0.7, 1.4], 100);  

%% �����迹 zin ��ֵ - ��λ ��Ƶ�� wn �任��ͼ   ��Q�仯��
func = angle(subs(res.zin, [r, w0, RL, k, R1, R2], [r_d, w0_d, RL_d, k_d, R1_d, R2_d]))*180/pi;
single_phase_LCC_S_parmamer_plot(func, Q, [0.2, 0.4, 0.6, 0.8, 1, 2, 3], wn, [0.7, 1.4], 100);  

%% ��ѹ���� Gu ��Ƶ�� wn �任��ͼ   ��Q�仯��
func = simplify(abs(subs(res.Gu, [r, RL, w0, k, R1, R2], [r_d, RL_d, w0_d, k_d, R1_d, R2_d])));
single_phase_LCC_S_parmamer_plot(func, Q, [0.2, 0.4, 0.6, 0.8, 1, 2, 3], wn, [0.7, 1.4], 100);  

%% ������� Po ��Ƶ�� wn �任��ͼ   (Q�仯)
func = simplify(abs(subs(res.Po, [r, RL, w0, k, Uin, R1, R2], [r_d, RL_d, w0_d, k_d, Uin_d, R1_d, R2_d])));
single_phase_LCC_S_parmamer_plot(func, Q, [0.2, 0.4, 0.6, 0.8, 1, 2, 3, 4, 5, 6], wn, [0.7, 1.4], 100);  

%% ������� Po ��Ƶ�� wn �任��ͼ �����ر仯��
func = simplify(abs(subs(res.Po, [Q, r, k, w0, Uin, R1, R2], [Q_d, r_d, k_d, w0_d, Uin_d, R1_d, R2_d])));
single_phase_LCC_S_parmamer_plot(func, RL, [5, 10, 20, 30, 40, 50, 60], wn, [0.7, 1.4], 100);  

%% ������� Po ��Ƶ�� wn �任��ͼ ��k�仯��
func = simplify(abs(subs(res.Po, [Q, r, RL, w0, Uin, R1, R2], [Q_d, r_d, RL_d, w0_d, Uin_d, R1_d, R2_d])));
single_phase_LCC_S_parmamer_plot(func, k, [0.1, 0.3, 0.5, 0.7, 0.9, 1], wn, [0.7, 1.4], 100);  

%% ������� Po �� k �仯��ͼ  ��wn�仯��
func = simplify(abs(subs(res.Po, [Q, r, RL, w0, Uin, R1, R2], [Q_d, r_d, RL_d, w0_d, Uin_d, R1_d, R2_d])));
single_phase_LCC_S_parmamer_plot(func, wn, [0.7, 0.8, 0.9, 1, 1.1, 1.2], k, [0.1, 1], 100);  
