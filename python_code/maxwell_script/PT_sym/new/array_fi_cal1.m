%% ������������������еĴ�ͨ�ֲ� 
function [B] = array_fi_cal1()  % sweeplist ɨ�����  paralist ��Ȧ����   sweeplist, paralist
%%%%%%%%%%%%%%%%%%%%%%%%%%%%������һЩ���Բ���  ����ʱע�͵�
sweeplist.start_p = 0;
sweeplist.end_p = 30/100;
sweeplist.steps = 6;
sweeplist.fixed_x = 15/100;
sweeplist.fixed_z = 5/100;

paralist.send_maxR = 15/100;
paralist.send_tw = 0.27/100;
paralist.overlay = 0;
paralist.send_N = 1;
paralist.aux_N = 1;
paralist.aux_maxR = 5/100;
paralist.rec_maxR = 5/100;
paralist.array_num_y = 1;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



% �趨һ���������
I = 1;

% ɨ���Ϊ������Ȧ���ĵ�
start_p = sweeplist.start_p;
end_p = sweeplist.end_p;
steps = sweeplist.steps;

% �̶�x z������  ֻ��y����ɨ��
fixed_x = sweeplist.fixed_x;
fixed_z = sweeplist.fixed_z;

% ������Ȧ�İ뾶
rec_R = paralist.rec_maxR;  

% �����õ�һϵ��ɨ���P
lens = (end_p-start_p)/steps;
P_list = [];
for i = start_p:lens:end_p
    P_list = [P_list; fixed_x,i,fixed_z];
end


% ��������Ԫ��Ȧ�����о���
dupli_dis = paralist.send_maxR*2-paralist.overlay;

P_list_temp = P_list;
Fi_list = [];

% ���������������P��ų�ǿ��
for i = 1:paralist.array_num_y
    % ��P�������������Ȧ������ϵת������Ԫ���еĶ�������ϵ
    P_list_temp(:,1) = P_list(:,1)-paralist.send_maxR;  %x����
    P_list_temp(:,2) = P_list(:,2)-(i-1)*dupli_dis-paralist.send_maxR;   %y����
    
    
    [r,c] = size(P_list_temp);    % ��ȡ��r����c
    temp = [];
    for j = 1:r
        % ����ÿһ�����е�Ԫ�����Ĵų�
        S = {[P_list_temp(j,1)+rec_R, P_list_temp(j,1)-rec_R],
            [P_list_temp(j,2)+rec_R, P_list_temp(j,2)-rec_R],
            P_list_temp(j,3)};   % ����ɨ�������ÿ��������Ȧ�ľ������S
        
        % ����������е�Ԫ�Ĵ�ͨ��
        fi = unit_fi_cal1(paralist, S, I);
        temp = [temp, fi];
    end
    Fi_list(:, :, i)= temp;
end

Fi = sum(Fi_list, 3)


end



