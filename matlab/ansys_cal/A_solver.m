%����XY   �ŵ���u0 ��Դŵ���ur  ���������߾�y�����m   ����������߾�y�����n   ������Ȧ��x�����h   ������Ȧ��x��ƽ�ƾ���s 
syms X Y u0 ur m n h s 
syms L1 L2 d  %˫����Ȧ��   ������Ȧ��   ˫����Ȧ�����ľ���
syms a1 b1 a2 b2 a3 b3 a4 b4 i0

%% ���㷢����Ȧ������B��

%%���鷢����Ȧ
send = [a1, 0.5; a2, 0.5; a3, 0.5; a4, 0.5;];
I = [i0; -i0; i0; -i0;];
u = [u0; u0; u0; u0;];

%%���鷢����Ȧ
send1 = send;   %һ���ĸ����ߵ�����
send1(:,1) = send1(:,1)+d+2*n;    %�ڶ��鵼������ 
send = [send; send1;]; 

% ���� ������
send_c = send;         
send_c(:, 2) = send_c(:,2)*(-1);  %����������ľ��������� 
send_c2 = send;
send_c2(:,2) = send_c2(:,2)+2*h;   %����������ľ���������
%ԭʼ�����鵼�� I   ����������ľ���I'   ԭʼ���鵼��I''   ���������徵�� I'  ԭʼ���鵼��I''  
send = [send; send_c; send; ];   %send; send_c2; send
 

I1 = I;
I1(:,1) = I1(:,1)*(1);
I = [I; I1;];
%�������
I_c = I;          
I_c(:, 1) =  I_c(:, 1)*(ur-1)/(ur+1);
I_c1 = I;
I_c1(:, 1) =  I_c1(:, 1)*2/(ur+1);
%ԭʼ�����鵼�� I   ����������ľ���I'   ԭʼ���鵼��I''   ���������徵�� I'  ԭʼ���鵼��I''  
I = [I; I_c; I_c1; ];%I; I_c; I_c1

%%u����
u = [u; u;];  %���鵼��
u_c = u;
u_c(:,1) = u_c(:,1)*ur;  %I''�����ڴŵ���Ϊur*u0�Ľ�����
u = [u; u; u_c; ];%u; u; u_c

D = sqrt((X-send(:,1)).^2 + (Y-send(:,2)).^2);   %xy �� �ĸ����ߵľ������
Bi = (1/(2*pi) * I(:,1).*(X-send(:,1))./D(:,1).^2).*u(:,1)   %ÿһ�����ߵ�B
B_sum = sum(Bi);     %B ��ʸ����



%Լ������
i0_d = 1;   %���ߵ���
a4_d = n; a1_d = -a4_d; a3_d = m; a2_d = -a3_d;  %���ߺ�����
%����Լ��
t = [i0, a1, a2, a3, a4];
t1 = [i0_d, a1_d, a2_d, a3_d, a4_d];
B_sum = simplify(subs(B_sum, t, t1));


%%  ���㻥�д�ͨ
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
rec = [ s-L2/2, h, s+L2/2, h;];

Fi = int(B_sum, X);

[r,c] = size(rec);
F = [];

for i = 1:r
    t = [X, Y];
    t1 = [rec(i, 3), h_d];
    t2 = [rec(i, 1), h_d];
    F = [F;simplify(subs(Fi, t, t1) - subs(Fi, t, t2));];
end

F = vpa(simplify(sum(F)),4)


%% ���㷽��  ��������������С����
% resol = 5;
% m_lim = [1, 11]; 
% resolution = (m_lim(2)-m_lim(1))/resol;
% m_list = m_lim(1):resolution:m_lim(2);
% 
% resol = 5;
% n_lim = [10, 50]; 
% resolution = (n_lim(2)-n_lim(1))/resol;
% n_list = n_lim(1):resolution:n_lim(2);
% 
% resol = 5;
% L2_lim = [10, 110]; 
% resolution = (L2_lim(2)-L2_lim(1))/resol;
% L2_list = L2_lim(1):resolution:L2_lim(2);
% 
% resol = 5;
% d_lim = [0, 20]; 
% resolution = (d_lim(2)-d_lim(1))/resol;
% d_list = d_lim(1):resolution:d_lim(2);
% 
% 
% %%��������������F�ķ��� ��s�仯��
% mat = [];
% u0_d = 4*pi*10^-7;
% for i = d_list
%     for k = L2_list
%         for p = m_list
%             for q = n_list
%                 y_list = [];
%                 
%                 resol = 6;
%                 s_lim = [q, 3*q]; 
%                 resolution = (s_lim(2)-s_lim(1))/resol;
%                 s_list = s_lim(1):resolution:s_lim(2);
%                 
%                 for l = s_list
%                     t = [L2, s, d, Y, m, n, u0];
%                     t1 = [k, l, i, 15, p, q, u0_d];
%                     temp = sym2poly(simplify(subs(F, t, t1)));
%                     y_list = [y_list; temp;];
%                 end
%                 avg = mean(y_list, 1);
%                 std = sqrt(var(y_list(:,1)))
%                 mat = [mat; i, k, p, q, std, avg;];
% 
%             end
%         end
%     end
% end



%% ������Ȧƽ��ʱ���д�ͨ����

% ������Ȧ����ֵ����
m_d = 9;
n_d = 34;
u0_d= 4*pi*10^-7;
ur_d = 1000;
F = vpa(simplify(subs(F, [m, n, u0], [m_d, n_d, u0_d])), 4);

% ������Ȧ����ֵ����
L2_d = 70;
h_d = 15;
d_d = 20;

%%��ͼ
figure();
x_lim = [34, 68];
resol = 80;
resolution = (x_lim(2)-x_lim(1))/resol;
x_list = x_lim(1):resolution:x_lim(2);
y_list = [];
for j=x_list
    s_d = j;
    t = [s, L1, L2, d, Y, h, ur];
    t1 = [s_d, L1_d, L2_d, d_d, h_d, h_d, ur_d];
    y_list = [y_list, subs(F, t, t1)];
end
plot(x_list, y_list);
%ylim([0 2.6E-6]);



