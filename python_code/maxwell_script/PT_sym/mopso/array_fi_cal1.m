%% ������������������еĴ�ͨ�ֲ� 
 % paralist ��Ȧ����  P_list ɨ��ƽ�������λ�� 
function [Fi] = array_fi_cal1(paralist, P_list) 

% �趨һ���������
I = 1;

% ��������Ԫ��Ȧ�����о���
dupli_dis = paralist.send_maxR*2-paralist.overlay;

P_list_temp = P_list;
Fi_list = [];



% ���������������P��ų�ǿ��
for i = 1:paralist.array_num_y
    disp(['unit_num:',num2str(i)]);
    
    % ��P�������������Ȧ������ϵת������Ԫ���еĶ�������ϵ
    P_list_temp(:,1) = P_list(:,1)-paralist.send_maxR;  %x����
    P_list_temp(:,2) = P_list(:,2)-(double(i)-1)*dupli_dis-paralist.send_maxR;   %y����
    
    [r,c] = size(P_list_temp);    % ��ȡ��r����c
    temp = [];

    parfor j = 1:r        
        disp(['plane +1']);
        
        % plane_R������ƽ��İ뾶  
        plane_R = P_list(j,4);
        
        % ����ÿһ�����е�Ԫ�����Ĵų�
        S = {[P_list_temp(j,1)+plane_R, P_list_temp(j,1)-plane_R],
            [P_list_temp(j,2)+plane_R, P_list_temp(j,2)-plane_R],
            P_list_temp(j,3)};   % ����ɨ�������ÿ��������Ȧ�ľ������S
        
        % ����������е�Ԫ����յ�Ԫ��Ĵ�ͨ��
        fi = unit_fi_cal1(paralist, S, I);
        temp = [temp, fi];

    end
    Fi_list(:, :, i)= temp;  %��¼��ͬ��Ԫ���еĽ��
end

% ���Ӳ�ͬ���䵥Ԫ�ڽ�����Ȧ����Ĵ�ͨ��  �Լ���������ָ��ƽ�������ڵ��ܻ���ͨ��
Fi = sum(Fi_list, 3)

end

