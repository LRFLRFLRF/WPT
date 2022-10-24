
%% ���㵥�����䵥Ԫ��������  ����ͼ
function [Self_inductance_ratio, Cross_MI_ratio] = cal_cross(canshu1, canshu2, canshu3)
addpath('D:\works\WPT\python_code\maxwell_script\PT_sym\multiobj_matlab');
addpath('D:\works\WPT\python_code\maxwell_script\PT_sym\multiobj_matlab\cal_and_fig\xkcd_rgb_v1.5\XKCD_RGB');
%%�趨��Ȧ�������������
para.send_maxR = 15; %���뾶15cm
para.send_tw = canshu1;%0.5; %�����Ѽ��
para.aux_tw = 0;  %������Ȧ�Ѽ��
para.overlay = canshu2;%10;   %���е�Ԫ�ص���
para.send_N = canshu3;    % ������Ȧ����
para.aux_N = 0;
para.aux_maxR = 0;%
para.rec_maxR = 5;%     %������Ȧ���뾶
para.array_num_y = 2;   % ���е�Ԫ��

sweep.start_p = -10;    % ɨ����ʼ��
%sweep.end_p = para.array_num_y*(2*para.send_maxR-para.overlay)+10;  % ɨ����ֹ��
sweep.end_p = para.array_num_y*2*para.send_maxR - (para.array_num_y-1)*para.overlay+10;  % ɨ����ֹ��
sweep.steps = 15*para.array_num_y;   % ɨ�����
sweep.start_z = 2;    %z����ɨ����ʼ��
sweep.end_z = 8;    %z����ɨ����ֹ��
sweep.steps_z = 3;   %z����ɨ�����
sweep.fixed_x = para.send_maxR;%   %������Ȧ��y������   ���շ�װ��y���׼

%% ������ ��Щ��������Ҫ��  ���ǰ�ǰ���趨�����ݽ���һ��ת��
%% һЩ�ߴ������Ҫ����100  ʵ��m��cm����
[paralist,sweeplist] = transform_para(para,sweep);


%% �������������Ը�
paralist_copy = paralist;
paralist_copy.array_num_y = 2;
L_array = cal_unit_L(paralist_copy, sweeplist);

%% ���㵥����Ԫ���Ը�
paralist_copy = paralist;
paralist_copy.array_num_y = 1;
L_unit = cal_unit_L(paralist_copy, sweeplist);

%% �����Ըб�
Self_inductance_ratio = L_array/L_unit;


%% %%%%%%%%%%%%%%%%%%%%%%%%%%%
%% ���㵥Ԫ�佻�滥��
res1 = [];
for j = 1:para.send_N
    
    
    %�޸�ɨ������Լ�������Ԫ�以��
    sweep_copy = sweep;
    para_copy = para;
    
    para_copy.array_num_y = 1;
    
    % ����ÿ�Ѱ뾶
    R = para_copy.send_maxR-(j-1)*para_copy.send_tw;
    
    para_copy.rec_maxR = R;
    sweep_copy.start_p = 3*para_copy.send_maxR-para_copy.overlay;
    sweep_copy.end_p = sweep_copy.start_p;
    sweep_copy.steps = 0;
    sweep_copy.start_z = 0;
    sweep_copy.end_z = sweep_copy.start_z;
    sweep_copy.steps_z = 0;
    
    %���½��е�λת��
    [paralist_copy,sweeplist_copy] = transform_para(para_copy,sweep_copy);
    
    % ���е�������һ��Ԫ�以��ֵ����
    a = cal_unit_M(paralist_copy,sweeplist_copy);
    res1 = [res1, a];
end
% ������ѻ����ܺ�
res1 = sum(res1);


%% ���㽻�滥�б�
Cross_MI_ratio = res1/L_unit;

end

