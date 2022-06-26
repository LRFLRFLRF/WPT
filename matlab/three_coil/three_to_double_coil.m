

syms uin is ia ir La Lr Ls RL Rr Ra Rs w ksa kar ksr Cs Ca Cr Zs Za Zr Msa Mar Msr 
syms Msa Mar Msr A1 A2 A3 
%A123是三个回路工作频率和谐振频率的比值  w/ws
Cs = 1/(Ls*(w/A1)^2);
Ca = 1/(La*(w/A2)^2);
Cr = 1/(Lr*(w/A3)^2);

Zs = 1i*w*Ls + 1/(1i*w*Cs) + Rs;
Za = 1i*w*La + 1/(1i*w*Ca) + Ra;
Zr = 1i*w*Lr + 1/(1i*w*Cr) + Rr;

% Msa = ksa*sqrt(Ls*La);
% Msr = ksr*sqrt(Ls*Lr);
% Mar = kar*sqrt(Lr*La);

eq1 = uin == Zs*is + 1i*w*Msa*ia - 1i*w*Msr*ir;
eq2 = 0 == -1i*w*Msr*is - 1i*w*Mar*ia + (Zr+RL)*ir;
ia_d = (-1i*w*Msa*is + 1i*w*Mar*ir)/Za;

eq1 = simplify(subs(eq1, ia, ia_d));
eq2 = simplify(subs(eq2, ia, ia_d));

%expand(eq1)

% pretty(eq1)
% pretty(eq2)
a = solve([eq1,eq2], [is, ir]);
%a.is
%a.ir
% pretty(a.is)
% pretty(a.ir)

%%计算效率yita
is_m = abs(a.is);
is_an = angle(a.is);
pin = uin*is_m*cos(-is_an);
ir_m = abs(a.ir);
pout = ir_m^2*RL;
yita = pout/pin;

%%计算输入阻抗
zin = uin/a.is;
zin_m = uin/is_m;
zin_an = -is_an/pi*180;

%%三线圈互感与双线圈比例
m_bi = abs(-1i*w*Mar*Msa/Za + Msr)/Msr;
%pretty(yita)


ksa_d = 0.3;
ksr_d = 0.2;
kar_d = 0.1;
Ls_d = 1E-4;
Lr_d = 0.5E-4;
La_d = 0.2E-4;
Msa_d = ksa_d*sqrt(Ls_d*La_d);
Msr_d = ksr_d*sqrt(Ls_d*Lr_d);
Mar_d = kar_d*sqrt(Lr_d*La_d);

t = [uin, w,...
    Ls, Lr, La, ...
    Mar, Msa, Msr, ...
    Ra, Rs, Rr, RL];
t_d = [10, 5E+5,...
    Ls_d, Lr_d, La_d,  ...
    Mar_d, Msa_d, Msr_d, ...
    0.1, 0.1, 0.1, 5];
yita = simplify(subs(yita, t, t_d));
pout = simplify(subs(pout, t, t_d));
zin = vpa(simplify(subs(zin, t, t_d)), 4);
zin_m = simplify(subs(zin_m, t, t_d));
zin_an = simplify(subs(zin_an, t, t_d));
m_bi = simplify(subs(m_bi, t, t_d));
%pretty(yita)

%zin = vpa(simplify(subs(zin, [A2, A3], [A1, A1])), 4);
zin_m = vpa(simplify(abs(zin)),4)
zin_an = vpa(simplify(angle(zin)/pi*180),4)

%% 绘制zin的模和阻抗角
figure();
x_lim = [0.6, 1.4];
resol = 100;
color=linspace(0.1,1,1);
c_index = 1;
resolution = (x_lim(2)-x_lim(1))/resol;
x_list = x_lim(1):resolution:x_lim(2);

y1_list = [];
y2_list = [];
for j=x_list
    t = [A1];
    t_d = [j];
    y1_list = [y1_list, subs(zin_m, t, t_d)];
    y2_list = [y2_list, subs(zin_an, t, t_d)]; 
end
subplot(2,1,1)
plot(x_list, y1_list, 'color',[color(c_index) 0 0]);
subplot(2,1,2)
plot(x_list, y2_list, 'color',[color(c_index) 0 0]);

%三维绘制
figure();
x_lim = [0.6, 1.4];
resol = 50;
resolution = (x_lim(2)-x_lim(1))/resol;
x_list1 = x_lim(1):resolution:x_lim(2);
x_list2 = x_list1;
[x,y] = meshgrid(x_list1,x_list2);

y1_list = [];
y2_list = [];
for j=x_list1
    temp1 = [];
    temp2 = [];
    for i = x_list2
        t = [A1, A2, A3];
        t_d = [j, i, j];
        temp1 = [temp1, sym2poly(vpa(simplify(subs(zin_m, t, t_d)),4))];
        temp2 = [temp2, sym2poly(vpa(subs(zin_an, t, t_d),4))]; 
    end
    y1_list = [y1_list; temp1];
    y2_list = [y2_list; temp2];
end
mesh(x,y,y1_list);

figure();
mesh(x, y, y2_list)

%% plot
figure();
x_lim = [0.6, 1.4];
resol = 50;
color=linspace(0.1,1,1);
c_index = 1;
resolution = (x_lim(2)-x_lim(1))/resol;
x_list = x_lim(1):resolution:x_lim(2);

y1_list = [];
y2_list = [];
y3_list = [];
y4_list = [];
y5_list = [];
for j=x_list
    
    t = [A1, A2, A3];
    t_d = [j, 0.75*j, j];
    y1_list = [y1_list, subs(yita, t, t_d)];
    
    y2_list = [y2_list, subs(pout, t, t_d)];
    
    y3_list = [y3_list, subs(zin_m, t, t_d)];
    
    y4_list = [y4_list, subs(zin_an, t, t_d)];
    
    y5_list = [y5_list, subs(m_bi, t, t_d)];    
end

subplot(5,1,1)
plot(x_list, y1_list, 'color',[color(c_index) 0 0]);
subplot(5,1,2)
plot(x_list, y2_list, 'color',[color(c_index) 0 0]);
subplot(5,1,3)
plot(x_list, y3_list, 'color',[color(c_index) 0 0]);
subplot(5,1,4)
plot(x_list, y4_list, 'color',[color(c_index) 0 0]);
subplot(5,1,5)
plot(x_list, y5_list, 'color',[color(c_index) 0 0]);



