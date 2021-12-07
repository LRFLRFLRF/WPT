clc;

%����XY   �ŵ���u0 ��Դŵ���ur  ������Ȧ��x�����h 
syms X Y u0 ur h
syms i0
syms ps_x ps_y s rr rs offset   %��һ�鷢����Ȧ����λ������  xy    

zu_width = 20;

%% ����һ�鷢����Ȧ������B��
send = [ps_x-rs, ps_y; ps_x+rs, ps_y;]; %������Ȧ�������������
I = [i0; -1*i0;];   %������Ȧ��������ĵ���

[r,c] = size(send);
B = [];
for j = 1:r
    %%ÿ��ѭ������һ������
    
    %%ԭʼ����Է����������B������
    [bi, I_j, I_f] = single_point_solver(u0, u0*ur, ps_y, send(j, 1), send(j, 2), I(j, 1));
    B = [B; bi];
    
    
%     %ԭʼ����Խ����������B������
%     bi = single_point_solver(u0, u0*ur, ps_y-h, send(j, 1), send(j, 2), I(j, 1));   %����Ϊԭʼ����ĵ���
%     B = [B; bi];
%     %������Խ����������B������
%     sendj = send;
%     sendj(:,2) = sendj(:,2)-2*0.5;
%     bi = single_point_solver(u0, u0*ur, -ps_y-h, sendj(j, 1), sendj(j, 2), I_j);    %����Ϊ�Է���������ľ������
%     B = [B; bi];
%     %���ӵ���Խ����������B������
%     bi = single_point_solver(u0, u0*ur, 0.5-15, send(j, 1), send(j, 2), I_f);      %����Ϊ�Է���������ĸ��ӵ���
%     B = [B; bi];
end
single_B = simplify(sum(B))    %single_B �� ���鷢����Ȧ��B�����㹫ʽ

%% ��ͬ���鷢����Ȧ����ͬλ�÷���
par_number = 8; %Ҫ���õ�����

B = [];
for i = 1:par_number
    %%���ݵ����B����ʽ��ѭ����������B
    ps_x_d = i*zu_width - zu_width/2 + offset;  % ÿ����Ȧ����������
    t = [ps_x];
    t1 = [ps_x_d];
    B_temp = subs(single_B, t, t1);
    B = [B; B_temp];   %��¼ÿ���B��
end
multi_B = simplify(sum(B))      %multi_B  :  ���鷢����Ȧ��B����ʽ


%%  ����ƽ��ʱ�Ļ��д�ͨ
rec = [ s-rr, h, s+rr, h;];   %������Ȧ���������������λ��   s��λ�Ʊ���

% ������Ȧˮƽ���ã���x����B���������ͨ
Fi = int(multi_B, X)

%�������������
t = [X];
t1 = [rec(1, 3)];
t2 = [rec(1, 1)];
F = simplify(subs(Fi, t, t1) - subs(Fi, t, t2));

%����F ������λ��Чֵ
F = vpa(F,4)









