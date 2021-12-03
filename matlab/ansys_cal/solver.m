%����XY   �ŵ���u0  ���������߾�y�����m   ����������߾�y�����n   ������Ȧ��x�����h   ������Ȧ��x��ƽ�ƾ���s 
syms X Y u0 m n h s   
syms L1 L2 d  %˫����Ȧ��   ������Ȧ��   ˫����Ȧ�����ľ���
syms a1 b1 a2 b2 a3 b3 a4 b4 I1 I2 I3 I4

%% ���㷢����Ȧ������B��
send = [a1, b1; a2, b2; a3, b3; a4, b4;];
I = [I1; I2; I3; I4;];


D = sqrt((X-send(:,1)).^2 + (Y-send(:,2)).^2);   %xy �� �ĸ����ߵľ������
Bi = u0/(2*pi) * I(:,1).*(X-send(:,1))./D(:,1).^2;   %ÿһ�����ߵ�B
B_sum = sum(Bi);     %B ��ʸ����

%Լ������
I2_d = 1; I3_d = I2_d; I1_d = -I2_d; I4_d = -I2_d;  %����
a4_d = n; a1_d = -a4_d; a3_d = m; a2_d = -a3_d;  %���ߺ�����
b1_d = 0; b2_d = b1_d; b3_d = b1_d; b4_d = b1_d;   %����������
%����Լ��
t = [I1, I2, I3, I4, a1, a2, a3, a4, b1, b2, b3, b4];
t1 = [I1_d, I2_d, I3_d, I4_d, a1_d, a2_d, a3_d, a4_d, b1_d, b2_d, b3_d, b4_d];
B_sum = simplify(subs(B_sum, t, t1));

% m_d = 1;
% n_d = 51;
% u0_d= 4*pi*10^-7;
% B_sum = simplify(subs(B_sum, [m, n, u0], [m_d, n_d, u0_d]));

%%  ���㻥�д�ͨ
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
rec = [s-d-L1, h, s-d, h; s+d, h, s+d+L1, h; s-L2/2, h, s+L2/2, h;];   %������Ȧ��3�����ֵ�λ��

Fi = int(B_sum, X);

[r,c] = size(rec);
F = [];
for i = 1:r
    t = [X, Y];
    t1 = [rec(i, 3), h_d];
    t2 = [rec(i, 1), h_d];
    F = [F;simplify(subs(Fi, t, t1) - subs(Fi, t, t2));];
end

F(1,1) = -F(1,1);   %˫����Ȧ һ��ż���ӵ��淨���ǳ���y�Ḻ�����
F = vpa(simplify(sum(F)),4)


%% ���㷽��  ��������������С����
% resol = 5;
% m_lim = [1, 11]; 
% resolution = (m_lim(2)-m_lim(1))/resol;
% m_list = m_lim(1):resolution:m_lim(2);
% 
% resol = 10;
% n_lim = [10, 60]; 
% resolution = (n_lim(2)-n_lim(1))/resol;
% n_list = n_lim(1):resolution:n_lim(2);
% 
% resol = 9;
% L1_lim = [5, 50]; 
% resolution = (L1_lim(2)-L1_lim(1))/resol;
% L1_list = L1_lim(1):resolution:L1_lim(2);
% 
% resol = 9;
% L2_lim = [5, 100]; 
% resolution = (L2_lim(2)-L2_lim(1))/resol;
% L2_list = L2_lim(1):resolution:L2_lim(2);
% 
% resol = 5;
% d_lim = [0, 10]; 
% resolution = (d_lim(2)-d_lim(1))/resol;
% d_list = d_lim(1):resolution:d_lim(2);
% 
% resol = 6;
% s_lim = [0, 30]; 
% resolution = (s_lim(2)-s_lim(1))/resol;
% s_list = s_lim(1):resolution:s_lim(2);
% 
% %��������������F�ķ��� ��s�仯��
% mat = [];
% u0_d = 4*pi*10^-7;
% for i = d_list
%     for j = L1_list
%         for k = L2_list
%             for p = m_list
%                 for q = n_list
%                     y_list = [];
%                     for l = s_list
%                         t = [L1, L2, s, d, Y, m, n, u0];
%                         t1 = [j, k, l, i, 15, p, q, u0_d];
%                         temp = sym2poly(simplify(subs(F, t, t1)));
%                         y_list = [y_list; temp;];
%                     end
%                     avg = mean(y_list, 1);
%                     std = sqrt(var(y_list(:,1)))
%                     mat = [mat; i, j, k, p, q, std, avg;];
%                     
%                 end
%             end
%         end
%     end
% end



%% ������Ȧƽ��ʱ���д�ͨ����

% ������Ȧ����ֵ����
m_d = 7;
n_d = 40;
u0_d= 4*pi*10^-7;
F = vpa(simplify(subs(F, [m, n, u0], [m_d, n_d, u0_d])), 4);

% ������Ȧ����ֵ����
L1_d = 10;
L2_d = 90;
h_d = 15;
d_d = 6;

%%��ͼ
figure();
x_lim = [0, 30];
resol = 40;
resolution = (x_lim(2)-x_lim(1))/resol;
x_list = x_lim(1):resolution:x_lim(2);
y_list = [];
for j=x_list
    s_d = j;
    t = [s, L1, L2, d, Y];
    t1 = [s_d, L1_d, L2_d, d_d, h_d];
    y_list = [y_list, subs(F, t, t1)];
end
plot(x_list, y_list);
ylim([0 3E-7]);




