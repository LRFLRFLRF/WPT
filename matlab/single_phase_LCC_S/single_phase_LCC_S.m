function [zin] = single_phase_LCC_S()
          %%  基于L1/Lp的
%%

syms RE L1 Cpp Cps Lp w m Css Ls w0 wn r Q RL k real%创建实数符号变量
syms Ir Ip Is Uin zin Uo
%% 元件阻抗
%元件阻抗
zL1 = 1i*w*L1;
zCpp = 1/(1i*w*Cpp);
zCps = 1/(1i*w*Cps);
zLp = 1i*w*Lp;
zLs = 1i*w*Ls;
zCss = 1/(1i*w*Css);

%% 电路变量定义    自变量 w0, wn, r, Q, RL, k
% 定义归一化频率  wn = w/w0
w_d = wn*w0;
% 定义Q值     Q = w*L1/RL;
L1_d = Q*RL/(w);
L1_d = subs(L1_d, w, w_d);     %把w替换成wn w0表示
% 定义电感比  r = L1/Lp
Lp_d = L1/r;
Lp_d = subs(Lp_d, [w, L1], [w_d, L1_d]);     %把w替换成wn w0表示
% 定义二次侧电感值Ls       Ls = Lp    也可修改成一个具体数值
Ls_d = Lp_d;
% 定义互感系数
k_d = 0.65;
m_d = k*sqrt(Lp*Ls);
m_d = subs(m_d, [k, Lp, Ls], [k_d, Lp_d, Ls_d]);

%% 确立谐振条件
%  Cpp与L1谐振             w0 = 1/sqrt(L1*Cpp);
Cpp_d = 1/(w0^2*L1);
Cpp_d = subs(Cpp_d, L1, L1_d);    %把L1替换成Q表示

%  Cps与(Lp-L1)谐振        w0 = 1/sqrt((Lp-L1)*Cps)
Cps_d = 1/(w0^2*(L1/r-L1));
Cps_d = subs(Cps_d, L1, L1_d);     %把L1替换成Q表示

%  Css与Ls谐振          w0 = 1/sqrt(Ls*Css);
Css_d = 1/(w0^2*Ls);
Css_d = subs(Css_d, Ls, Ls_d);    %把Ls替换成Q表示

% 反射阻抗展开成负载阻抗
RE_d = w^2*m^2/(RL+zLs+zCss);
RE_d = simplify(subs(RE_d, [w, Ls, Css, m], [w_d, Ls_d, Css_d, m_d]));


               %% 计算输入阻抗
%%
% 输入阻抗计算公式
zin = zL1 + par(zCpp, (zLp + zCps + RE));
% 带入谐振条件
zin = simplify(subs(zin, [L1, Lp, Cpp, Cps w, RE], [L1_d, Lp_d, Cpp_d, Cps_d, w_d, RE_d]));
pretty(zin);


%% 测试！！  当频率比wn等于1  即工作频率w等于谐振w0时 zin应等于L1^2*RL/m^2
%%反带入Q和r
% wn_test = 1;
% Q_test = solve(L1_d == L1, Q);
% Q_test = subs(Q_test, [wn], [wn_test]);
% r_test = solve(m_d == m, r);
% r_test = subs(r_test, [wn, Q], [wn_test, Q_test]);
% if size(r_test,1)~=1         %r_test 求解得到两个根，取其中第一个
%     r_test = r_test(1, 1);
% end
% % 输入阻抗
% a = simplify(subs(zin, [wn, Q, r], [wn_test, Q_test, r_test]));
% pretty(a)

%% 输入阻抗随频率变换绘图
r_d = 0.1;
w0_d = 2*pi*100E+3;
RL_d = 50;

% 输入阻抗 幅值 - 频率 图   改变Q值，即L1
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

% 输入阻抗 相角 - 频率 图   改变Q值，即L1
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


               %% 计算一次侧反射阻抗RE上的输出电压
%% 
%列写回路电流矩阵
syms Gu
z_m = [zL1+zCpp, -zCpp; -zCpp, zCps+zLp+RE+zCpp];
i_m = [Ir; Ip];
u_m = [Uin; 0];

% 求解一次侧电流Ip
i_m = solve(z_m*i_m == u_m, i_m);
Ip_d = i_m.Ip;
Ip_d = simplify(subs(Ip_d, [L1, Lp, w], [L1_d, Lp_d, w_d]));
Ip_d = simplify(subs(Ip_d, [L1, Cpp, Cps], [L1_d, Cpp_d, Cps_d]));
Ip_d = simplify(subs(Ip_d, [RE], [RE_d]));

% 计算二次侧电流Is
Is_d = 1i*w*m*Ip_d/(zCss+zLs+RL);
Is_d = simplify(subs(Is_d, [Ls, Css, w, m], [Ls_d, Css_d, w_d, m_d]));


% 负载输出电压
Uo_d = Is*RL;
Uo_d = simplify(subs(Uo_d, [Is], [Is_d]));
pretty(Uo_d);

% 计算LCC电压增益
Gu = Uo_d/Uin;
pretty(Gu);


%% 电压增益随频率变换绘图
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
%%阻抗并联计算函数
function [s] = par(z1, z2)
    s = 1/((1/z1) + (1/z2));
end

%%双元件分压计算函数  s为z1上电压
function [s] = fen(z1, z2, ui)
    s = z1/(z1+z2)*ui;
end



