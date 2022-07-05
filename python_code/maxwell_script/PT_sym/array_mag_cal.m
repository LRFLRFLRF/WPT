%% ������������������еĴų��ֲ�
function [B] = array_mag_cal(sweeplist, paralist)  % sweep_par ɨ�����  paralist ��Ȧ����

start_p = sweeplist.start_p;
end_p = sweeplist.end_p;
steps = sweeplist.steps;

fixed_x = sweeplist.fixed_x;
fixed_z = sweeplist.fixed_z;

% ������xy�������ϵ���������
ar_y = 1;

% �����õ�һϵ��ɨ���P
lens = (end_p-start_p)/steps;
P_list = [];
for i = start_p:lens:end_p
    P_list = [P_list; fixed_x,i,fixed_z];
end


% ��������Ԫ��Ȧ�����о���
dupli_dis = paralist.send_maxR*2-paralist.overlay;

P_list_temp = P_list;
B_list = [];

% ���������������P��ų�ǿ��
for i = 1:ar_y
    % ��P�������������Ȧ������ϵת������Ԫ���еĶ�������ϵ
    P_list_temp(:,1) = P_list(:,1)-paralist.send_maxR;  %x����
    P_list_temp(:,2) = P_list(:,2)-(i-1)*dupli_dis-paralist.send_maxR;   %y����
    
    
    [r,c] = size(P_list_temp);    % ��ȡ��r����c
    temp = [];
    for j = 1:r
        % ����ÿһ�����е�Ԫ�����Ĵų�
        b = unit_mag_cal(paralist, P_list_temp(j,:));
        temp = [temp, b];
    end
    B_list(:, :, i)= temp;
end

B = sum(B_list, 3)
end



