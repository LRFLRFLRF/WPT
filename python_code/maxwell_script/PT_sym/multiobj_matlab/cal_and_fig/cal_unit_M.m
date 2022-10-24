function [res1] = cal_unit_M(paralist,sweeplist)
%% ���������Ȧ�ڲ�ͬλ��ʱ�Ļ���ͨ
addpath('D:\works\WPT\python_code\maxwell_script\PT_sym\multiobj_matlab');
addpath('D:\works\WPT\python_code\maxwell_script\PT_sym\multiobj_matlab\cal_and_fig\xkcd_rgb_v1.5\XKCD_RGB');
% ɨ���Ϊ������Ȧ���ĵ�
start_p = sweeplist.start_p;
end_p = sweeplist.end_p;
steps = sweeplist.steps;

start_z = sweeplist.start_z;
end_z = sweeplist.end_z;
steps_z = sweeplist.steps_z;
% �̶�x z������  ֻ��y����ɨ��
fixed_x = sweeplist.fixed_x;
%fixed_z = sweeplist.fixed_z;

% ������Ȧƽ��İ뾶
rec_R = paralist.rec_maxR;

% �����õ�һϵ��ɨ���P
if end_p~=start_p
    lens = (end_p-start_p)/steps;
else
    lens = 1;   % �����ʼ�������ֹ��  ���趨����Ϊһ������0��ֵ   ʹ���б���һ��ֵ���
end

if end_z~=start_z
    lens_z = (end_z-start_z)/steps_z;
else
    lens_z = 1;
end

P_list = [];
for j = start_z:lens_z:end_z
    for i = start_p:lens:end_p
        P_list = [P_list; fixed_x,i,j, rec_R];
    end
end

% ������������ڵĴ�ͨ��
res = array_fi_cal1(paralist, P_list);
% ��ͬ�������Ľ��  ת���¸�ʽ ����plot
res1 = reshape(res, [steps+1, length(res)/(steps+1)]);
res1 = res1';

% �������λת����uH
res1 = res1*1E+6;  
end

