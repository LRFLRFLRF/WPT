function [L_array] = cal_unit_L(paralist,sweeplist)

%% ���㷢�����е��Ը�
addpath('D:\works\WPT\python_code\maxwell_script\PT_sym\multiobj_matlab');
addpath('D:\works\WPT\python_code\maxwell_script\PT_sym\multiobj_matlab\cal_and_fig\xkcd_rgb_v1.5\XKCD_RGB');

% matlabΪ���볤ֱ���ߣ����߰뾶�����㣬 ��˼����Ըд�ͨʱҪƫ��һ�����߰뾶
wire_R = 0/100;

% �Ը���ȦΪ��������õ�P_list
P_list = [];
% ��������Ԫ��Ȧ�����о���
dupli_dis = paralist.send_maxR*2-paralist.overlay;
for i = 1:paralist.array_num_y
    
    % ���㲻ͬ�������ĵ�y����
    y = (i-1)*dupli_dis + paralist.send_maxR;
    
    for j = 1:paralist.send_N
        % ���㷢����Ȧÿ�ѵİ뾶
        plane_R = paralist.send_maxR-(j-1)*paralist.send_tw;
        % ����ÿ�ѵ�λ�úʹ�С����ɨ���б�
        P_list = [P_list; sweeplist.fixed_x, y, wire_R, plane_R];
    end
    
    for j = 1:paralist.aux_N
        % ���㸨����Ȧÿ�ѵİ뾶
        plane_R = paralist.aux_maxR-(j-1)*paralist.aux_tw;
        % ����ÿ�ѵ�λ�úʹ�С����ɨ���б�
        P_list = [P_list; sweeplist.fixed_x, y, wire_R, plane_R];
    end
end

% ������õ���P_list������������  ����ÿ��ƽ��Ĵ�ͨ��
fi_list = array_fi_cal1(paralist, P_list);
% ÿ����Ȧ��Χƽ��Ĵ�ͨ������һ��  ��Ϊ�������е��Ը��ܴ�ͨ
fi_array = sum(fi_list);

% �������λת����uH
L_array = fi_array*1E+6;

end

