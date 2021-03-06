function [RES] = single_phase_LCC_S_matrix_Q()
          %%  基于Q的      仅含w0, wn, r, Q, RL, k
%%

syms R1 R2 RE L1 Cpp Cps Lp w m Css Ls w0 wn r Q RL k real%创建实数符号变量
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
k_d = k;
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


%% 回路电流法
z_m = [R1+zL1+zCpp, -zCpp, 0; -zCpp, zCps+zLp+zCpp, -1i*w*m; 0, -1i*w*m, zCss+zLs+RL+R2];
i_m = [Ir; Ip; Is];
u_m = [Uin; 0; 0];

% 求解
i_m = solve(z_m*i_m == u_m, i_m);

% 计算一次侧电流Ip
Ip_d = i_m.Ip;
Ip_d = simplify(subs(Ip_d, [L1, Lp, Ls, w], [L1_d, Lp_d, Ls_d, w_d]));
Ip_d = simplify(subs(Ip_d, [Cpp, Cps, Css, w], [Cpp_d, Cps_d, Css_d,w_d]));
Ip_d = simplify(subs(Ip_d, [m], [m_d]));

% 计算二次侧电流Is
Is_d = i_m.Is;
Is_d = simplify(subs(Is_d, [L1, Lp, Ls, w], [L1_d, Lp_d, Ls_d, w_d]));
Is_d = simplify(subs(Is_d, [Cpp, Cps, Css, w], [Cpp_d, Cps_d, Css_d,w_d]));
Is_d = simplify(subs(Is_d, [m], [m_d]));

% 计算输入电流Ir
Ir_d = i_m.Ir;
Ir_d = simplify(subs(Ir_d, [L1, Lp, Ls, w], [L1_d, Lp_d, Ls_d, w_d]));
Ir_d = simplify(subs(Ir_d, [Cpp, Cps, Css, w], [Cpp_d, Cps_d, Css_d,w_d]));
Ir_d = simplify(subs(Ir_d, [m], [m_d]));

% 输入电阻
zin = Uin/Ir;
zin = simplify(subs(zin, [Ir], [Ir_d]));
pretty(zin)

% 电压增益
Uo_d = Is*RL;
Uo_d = simplify(subs(Uo_d, [Is], [Is_d]));
Gu = simplify(Uo_d/Uin);
pretty(Gu);

% 输出功率
Po = Is^2*RL;
Po = simplify(subs(Po, [Is], [Is_d]));
pretty(Po);

%% 结果回调
RES = struct('L1', {L1_d}, 'Lp', {Lp_d},'Ls', {Ls_d},'Cpp', {Cpp_d},'Cps', {Cps_d},'Css', {Css_d},'zin', {zin}, 'Gu', {Gu}, 'Po', {Po});

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



