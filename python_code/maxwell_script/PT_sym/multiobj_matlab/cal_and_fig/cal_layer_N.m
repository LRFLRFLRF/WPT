
%% ���ļ��¼��㸺����Ȧ �ڸı������ÿ������ʱ    ���к��Ըй�ϵ

%% ���㸺����Ȧ ��ͬ��������������µĻ������Ըб�
clear;
lay = 1:4;
N_lay = 5:10;%5:10
lpp = 5;
RES = [];
B = 1; % ��ͨ�ܶ�
for i = lay
    for j = N_lay
        %%�����Ը���
        if j*i == 1
            tw = 1;
        elseif j==1
            tw = 0.25/i;
        else
            tw = 0.25*(j-1)/(i*j-1);
        end
        
        
        para.send_maxR = lpp; %���뾶15cm
        para.send_tw = tw;%0.5; %�����Ѽ��
        para.aux_tw = 0;  %������Ȧ�Ѽ��
        para.overlay = 0;%10;   %���е�Ԫ�ص���
        para.send_N = i*j;    % ������Ȧ����
        para.aux_N = 0;
        para.aux_maxR = 0;%
        para.rec_maxR = 5;%     %������Ȧ���뾶
        para.array_num_y = 1;   % ���е�Ԫ��
        sweep.start_p = -10;    % ɨ����ʼ��
        sweep.end_p = para.array_num_y*2*para.send_maxR - (para.array_num_y-1)*para.overlay+10;  % ɨ����ֹ��
        sweep.steps = 2*para.array_num_y;   % ɨ�����
        sweep.start_z = 5; %2   %z����ɨ����ʼ��
        sweep.end_z = 5;  %8  %z����ɨ����ֹ��
        sweep.steps_z = 0;  %3   %z����ɨ�����
        sweep.fixed_x = para.send_maxR;%   %������Ȧ��y������   ���շ�װ��y���׼
        [paralist,sweeplist] = transform_para(para,sweep);
        L_array = cal_unit_L(paralist, sweeplist);
        
        
        %%���㻥����
        M = 0;
        for m = 1:j
            r = (lpp-0.25*(m-1))/100; %������Ѱ뾶 �����㵽m
            M = M + r^2*B/10000;  % B���㵽ƽ������
        end
        M = M*i;  % �˲���
        RES = [RES;i, j,  L_array, M];
    end
end
save('D:\works\WPT\python_code\maxwell_script\PT_sym\multiobj_matlab\cal_and_fig\history_record\fuzaixianquan_layer_and_N.mat','RES')


%% ��ͼ

addpath('D:\works\WPT\python_code\maxwell_script\PT_sym\multiobj_matlab\cal_and_fig\history_record');
MandL = importdata('fuzaixianquan_layer_and_N.mat');

%%һ�� ���ѵ�M��2.5E-7   L��0.9098
jizhun_huganbi = 2.5E-7/sqrt(0.9098);   % һ��һ�ѵĻ�׼���б�

huganbi = MandL(:,4)./sqrt(MandL(:,3));

res = reshape(huganbi, [6, 4]);   % ����M/sqrt��L2��
res1 = reshape(MandL(:,3), [6, 4]);  %  ��ʾ L2
m = reshape(MandL(:,4), [6, 4]);  %  ��ʾ m
res3 = res/jizhun_huganbi;  %  ��ʾ M

s = 0;
for m = 1:8
    r = (lpp-0.25*(m-1))/100; %������Ѱ뾶 �����㵽m
    s = s + r^2;  % B���㵽ƽ������
end
uni = (lpp/100)^2*8;

figure('color','w');
plot3(mc(:,1), qua_area(:,1), max_k(:,1),'pr');
xlabel(['���Ļ�����'],'fontsize',10);
ylabel(['׼���ȿ��'],'fontsize',10);
zlabel(['���ϵ��'],'fontsize',10);


