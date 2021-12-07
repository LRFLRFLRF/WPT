
%����XY   �ŵ���u0 ��Դŵ���ur  ���������߾�y�����m   ����������߾�y�����n   ������Ȧ��x�����h   ������Ȧ��x��ƽ�ƾ���s 
syms X Y u0 ur m n h s 
syms L1 L2 d  %˫����Ȧ��   ������Ȧ��   ˫����Ȧ�����ľ���
syms a1 b1 a2 b2 a3 b3 a4 b4 i0

%% ���㷢����Ȧ������B��

%%���鷢����Ȧ
send = [a1, 0.5; a2, 0.5; a3, 0.5; a4, 0.5;];
I = [i0; -1*i0; i0; -1*i0;];

%%��x�Ḵ��һ�鷢����Ȧ
send_copy = send;   %һ���ĸ����ߵ�����
send_copy(:,1) = send_copy(:,1)+d+2*n;    %�ڶ��鵼������ 
send = [send; send_copy;]; 

send_copy(:,1) = send_copy(:,1)+d+2*n;    %�����鵼������
send = [send; send_copy;]; 

send_copy(:,1) = send_copy(:,1)+d+2*n;    %�����鵼������
send = [send; send_copy;]; 

I = [I; I;I;I;];

[r,c] = size(send);
B = [];
for j = 1:r
    %%ÿ��ѭ������һ������
    
    %%ԭʼ����Է����������B������
    [bi, I_j] = single_point_solver(u0, u0*ur, 0.5, send(j, 1), send(j, 2), I(j, 1));
    B = [B; bi];
    
    %ԭʼ����Խ����������B������
    bi = single_point_solver(u0, u0*ur, 0.5-15, send(j, 1), send(j, 2), I(j, 1));   %����Ϊԭʼ����ĵ���
    B = [B; bi];
    %������Խ����������B������
    sendj = send;
    sendj(:,2) = sendj(:,2)-2*0.5;
    bi = single_point_solver(u0, u0*ur, -0.5-15, sendj(j, 1), sendj(j, 2), I_j);    %����Ϊ�Է���������ľ������
    B = [B; bi];
end
B_sum = sum(B); 



%Լ������
i0_d = 1;   %���ߵ���
a4_d = n; a1_d = -a4_d; a3_d = m; a2_d = -a3_d;  %���ߺ�����
%����Լ��
t = [i0, a1, a2, a3, a4];
t1 = [i0_d, a1_d, a2_d, a3_d, a4_d];
B_sum = simplify(subs(B_sum, t, t1))


%%  ���㻥�д�ͨ
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
rec = [ s-L2/2, h, s+L2/2, h;];

% ���ּ����ͨ
Fi = int(B_sum, X);

[r,c] = size(rec);
F = [];
for i = 1:r
    t = [X];
    t1 = [rec(i, 3)];
    t2 = [rec(i, 1)];
    F = [F;simplify(subs(Fi, t, t1) - subs(Fi, t, t2));];
end
%����F ��������λ��Чֵ
F = vpa(simplify(sum(F)),4)



%% ������Ȧƽ��ʱ���д�ͨ����
%������Ȧ����ֵ����
m_d = 9;
n_d = 34;
u0_d= 4*pi*10^-7;
ur_d = 1000;
F_temp = vpa(simplify(subs(F, [m, n, u0, ur], [m_d, n_d, u0_d, ur_d])), 4);
% ������Ȧ����ֵ����
L2_d = 30;
h_d = 15;
d_d = 10;

%%��ͼ
figure();
x_lim = [-34, 300];
resol = 100;
resolution = (x_lim(2)-x_lim(1))/resol;
x_list = x_lim(1):resolution:x_lim(2);
y_list = [];
for j=x_list
    s_d = j;
    t = [s, L2, d, Y, h];
    t1 = [s_d, L2_d, d_d, h_d, h_d];
    y_list = [y_list, subs(F_temp, t, t1)];
end
plot(x_list, y_list);
%ylim([0 2.6E-6]);





