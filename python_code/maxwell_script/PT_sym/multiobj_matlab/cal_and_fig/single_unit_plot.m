%% ���㵥�����䵥Ԫ��������  ����ͼ
% �������㲻ͬ�ߴ���Ȧ�Ļ���  �����Ը�  �������ϵ��   �Լ���ͼ
function [Mc, zhunarea, k, res1] = single_unit_plot(canshu1, canshu2, canshu3, canshu4, canshu5)
addpath('D:\works\WPT\python_code\maxwell_script\PT_sym\multiobj_matlab');
addpath('D:\works\WPT\python_code\maxwell_script\PT_sym\multiobj_matlab\cal_and_fig\xkcd_rgb_v1.5\XKCD_RGB');
%%�趨��Ȧ�������������
para.send_maxR = canshu4; %���뾶15cm
para.send_tw = canshu1;%0.5; %�����Ѽ��
para.aux_tw = 0;  %������Ȧ�Ѽ��
para.overlay = canshu2;%10;   %���е�Ԫ�ص���
para.send_N = canshu3;    % ������Ȧ����
para.aux_N = 0;
para.aux_maxR = 0;%
para.rec_maxR = 5;%     %������Ȧ���뾶
para.array_num_y = canshu5;   % ���е�Ԫ��

sweep.start_p = -10;    % ɨ����ʼ��
%sweep.end_p = para.array_num_y*(2*para.send_maxR-para.overlay)+10;  % ɨ����ֹ��
sweep.end_p = para.array_num_y*2*para.send_maxR - (para.array_num_y-1)*para.overlay+10;  % ɨ����ֹ��
sweep.steps = 45*para.array_num_y;   % ɨ����� 
sweep.start_z = 5; %2   %z����ɨ����ʼ��    
sweep.end_z = 5;  %8  %z����ɨ����ֹ��
sweep.steps_z = 0;  %3   %z����ɨ�����
sweep.fixed_x = para.send_maxR;%   %������Ȧ��y������   ���շ�װ��y���׼

%% ������ ��Щ��������Ҫ��  ���ǰ�ǰ���趨�����ݽ���һ��ת��
%% һЩ�ߴ������Ҫ����100  ʵ��m��cm����
% paralist = para;
% sweeplist = sweep;
% paralist.send_maxR = double(paralist.send_maxR/100);%
% paralist.send_tw = double(paralist.send_tw/100);%
% paralist.aux_tw = double(paralist.aux_tw/100);%
% paralist.overlay = double(paralist.overlay/100);
% paralist.aux_maxR = double(paralist.aux_maxR/100);%
% paralist.rec_maxR = double(paralist.rec_maxR/100);%
% sweeplist.start_p = double(sweeplist.start_p/100);
% sweeplist.end_p = double(sweeplist.end_p/100);%
% sweeplist.start_z = double(sweeplist.start_z/100);
% sweeplist.end_z = double(sweeplist.end_z/100);%
% sweeplist.fixed_x = double(sweeplist.fixed_x/100);
% 
% % ����ɨ�貽��
% sweeplist.lens = (sweeplist.end_p-sweeplist.start_p)/sweeplist.steps;
% sweeplist.lens_z = (sweeplist.end_z-sweeplist.start_z)/sweeplist.steps_z;

[paralist,sweeplist] = transform_para(para,sweep);


%% ���������Ȧ�ڲ�ͬλ��ʱ�Ļ���ͨ
res1 = cal_unit_M(paralist,sweeplist);


%% ����׼���������С
[r,c]=size(res1);


% �Ҽ���ֵ��ͼ�Сֵ��
extrMaxValue = res1(find(diff(sign(diff(res1)))==-2)+1);
extrMinValue = res1(find(diff(sign(diff(res1)))==+2)+1);
extrMinValue = extrMinValue(2:end-1);
if isempty(extrMinValue)
    cent_L = res1(:,round(c/2));   %��Ԫ����λ�õĻ�����
else
    cent_L = (mean(extrMaxValue)+mean(extrMinValue))/2;   % �Ծֲ�����ֵ����Сֵ��ƽ������Ϊ��׼
end


cond_l = cent_L.*0.95;    %����15%ƫ��ʱ���½�
cond_h = cent_L.*1.05;    %����15%ƫ��ʱ���Ͻ�


area_num = [];
for i = 1:r
    js = 0;
    for j = round(length(res1(i,:))/2):-1:1    % ����������߱���
        if res1(i,j)>cond_l(i,1) && res1(i,j)<cond_h(i,1)   %% �жϷ��������ĵ�
            js = js + 1;
        else
            break;
        end
    end
    area_num = [area_num; js*2];  %��Ϊ�ǰ�߱���   ����Ҫ��2  %���������ĵ���
    %area_num = [area_num; length(find(res1(i,:)>cond_l(i,1) & res1(i,:)<cond_h(i,1)))];  %���������ĵ���
end
if para.array_num_y==1
    overlayyy = 0;
else
    overlayyy = (paralist.array_num_y-1)*paralist.overlay;
end
% ����׼��������ռ��Ȧ��ȵİٷֱ�
zhunarea = area_num./(paralist.array_num_y*paralist.send_maxR*2/sweeplist.lens-overlayyy);   %׼��������ռ��Ȧ��ȵİٷֱ�


% ����������������Ļ��д�С
Mc = [];
for i = 1:r
    m = res1(i, round(c/2-area_num(i,1)/2):round(c/2+area_num(i,1)/2));
    Mc = [Mc; mean(m)];
end

%Mc = res1(:,round(c/2));


% %%�Ż�����ȡ��С  ���ȡ����
% zhunarea = -zhunarea;
% Mc = -Mc;

%% ���㻥�зֲ�ƽ��ֵ�뷽��ָ��
% ���м���ƽ��ֵ   ������ÿ���߶��µĻ���ƽ��ֵ
Mean = mean(res1, 2);
Mean_mean = mean(Mean);
% ���м��㷽��   ������ÿ���߶��µķ����
Var = var(res1,0,2);
Var_mean = mean(Var);



%% ��ͼ ������
% �������鳤��
decay = 0;
for i = 1:paralist.send_N
    r = (paralist.send_maxR-(i-1)*paralist.send_tw)*8;
    decay = decay+r;
end
rd = (paralist.send_N-1)*paralist.send_tw/paralist.send_maxR;
%%���Ƶ���Rx�Ļ��м���ֵ
plot_M(sweeplist, paralist, res1,Var,Mean, rd, zhunarea, decay);

%% ���������Ը�
L_array = cal_unit_L(paralist, sweeplist);

%% ���ϵ��
% ���������Ȧ15��  ����ԼΪ���ѵ�10��
% res1=res1.*10;
% k = res1(:,:)./sqrt(17.66*L_array);

% ���������Ȧ3��8��  ��ʵ�Ը�72uH  ����ԼΪ���Ѽ���ֵ��14.6��
res=res1.*14.6;
if canshu5 ==1  %%��ʵ�ĵ�Ԫ��2x1�Ը�
    L_array = 59.522;
elseif canshu5 ==2
    L_array = 105.41;
end 
k = res(:,:)./sqrt(72*L_array);

%k = 0;
%% ��ͼ  ���ϵ��
plot_L(paralist,sweeplist, k,Var,Mean, rd, zhunarea,decay, L_array)


%% ��ͼ  ��������Rx�ļ��㻥��
plot_M(sweeplist, paralist, res,Var,Mean, rd, zhunarea, decay);

%% ���������ڵ������ݵĴ��� ����origin��ͼ ƽʱ���ã�����
% %��Tx���м���������
% x = sweeplist.start_p:sweeplist.lens:sweeplist.end_p;
% x = x.*100;
% RESULT = [x', res'];
% % ��������mat 
% save('C:\Users\LRF\OneDrive\�ĵ�\WPT\PAPER\origin\matlab_record\single_Tx_MQ.mat','RESULT');

% %˫Tx��2x1���л��м���������
x = sweeplist.start_p:sweeplist.lens:sweeplist.end_p;
x = x.*100;
RESULT = [x', res'];
% % ��������mat 
% save('C:\Users\LRF\OneDrive\�ĵ�\WPT\PAPER\origin\matlab_record\double_Tx_MQ.mat','RESULT');

end
