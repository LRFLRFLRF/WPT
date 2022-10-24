
%% 本文件下计算负载线圈 在改变层数和每层匝数时    互感和自感关系

%% 计算负载线圈 不同匝数、绕组层数下的互感与自感比
clear;
lay = 1:4;
N_lay = 5:10;%5:10
lpp = 5;
RES = [];
B = 1; % 磁通密度
for i = lay
    for j = N_lay
        %%计算自感量
        if j*i == 1
            tw = 1;
        elseif j==1
            tw = 0.25/i;
        else
            tw = 0.25*(j-1)/(i*j-1);
        end
        
        
        para.send_maxR = lpp; %最大半径15cm
        para.send_tw = tw;%0.5; %绕组匝间距
        para.aux_tw = 0;  %辅助线圈匝间距
        para.overlay = 0;%10;   %阵列单元重叠度
        para.send_N = i*j;    % 发射线圈匝数
        para.aux_N = 0;
        para.aux_maxR = 0;%
        para.rec_maxR = 5;%     %接收线圈最大半径
        para.array_num_y = 1;   % 阵列单元数
        sweep.start_p = -10;    % 扫描起始点
        sweep.end_p = para.array_num_y*2*para.send_maxR - (para.array_num_y-1)*para.overlay+10;  % 扫描中止点
        sweep.steps = 2*para.array_num_y;   % 扫描点数
        sweep.start_z = 5; %2   %z方向扫描起始点
        sweep.end_z = 5;  %8  %z方向扫描中止点
        sweep.steps_z = 0;  %3   %z方向扫描点数
        sweep.fixed_x = para.send_maxR;%   %接收线圈的y轴坐标   即收发装置y轴对准
        [paralist,sweeplist] = transform_para(para,sweep);
        L_array = cal_unit_L(paralist, sweeplist);
        
        
        %%计算互感量
        M = 0;
        for m = 1:j
            r = (lpp-0.25*(m-1))/100; %计算各匝半径 并换算到m
            M = M + r^2*B/10000;  % B换算到平方厘米
        end
        M = M*i;  % 乘层数
        RES = [RES;i, j,  L_array, M];
    end
end
save('D:\works\WPT\python_code\maxwell_script\PT_sym\multiobj_matlab\cal_and_fig\history_record\fuzaixianquan_layer_and_N.mat','RES')


%% 绘图

addpath('D:\works\WPT\python_code\maxwell_script\PT_sym\multiobj_matlab\cal_and_fig\history_record');
MandL = importdata('fuzaixianquan_layer_and_N.mat');

%%一层 单匝的M是2.5E-7   L是0.9098
jizhun_huganbi = 2.5E-7/sqrt(0.9098);   % 一层一匝的基准互感比

huganbi = MandL(:,4)./sqrt(MandL(:,3));

res = reshape(huganbi, [6, 4]);   % 计算M/sqrt（L2）
res1 = reshape(MandL(:,3), [6, 4]);  %  显示 L2
m = reshape(MandL(:,4), [6, 4]);  %  显示 m
res3 = res/jizhun_huganbi;  %  显示 M

s = 0;
for m = 1:8
    r = (lpp-0.25*(m-1))/100; %计算各匝半径 并换算到m
    s = s + r^2;  % B换算到平方厘米
end
uni = (lpp/100)^2*8;

figure('color','w');
plot3(mc(:,1), qua_area(:,1), max_k(:,1),'pr');
xlabel(['中心互感量'],'fontsize',10);
ylabel(['准均匀宽度'],'fontsize',10);
zlabel(['耦合系数'],'fontsize',10);


