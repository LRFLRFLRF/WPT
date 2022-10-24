

%% 本文件计算  改变匝间距和宽度比时，单元线圈的互感特性曲线  并生成帕托前沿


%% 扫描 匝间距tw 和 匝数N   计算得到mc和qua_area
clear;
tw = 0.35:0.02:0.7;
N = 10:20;
lpp = 15;
parto = {};
for n = N
    for t = tw
        [a,b, c] = single_unit_plot(t, t*(n-1), n, lpp);
        
        % 计算铜耗量
        decay = 0;
        for i = 1:n
            r = (lpp-(i-1)*t)*8;
            decay = decay+r;
        end
        
        res = {n, t, a, b, c, decay};
        parto(end+1, :) = res;
        % 保存结果到文件
        save('D:\works\WPT\python_code\maxwell_script\PT_sym\multiobj_matlab\cal_and_fig\history_record\parto_res.mat','parto')
    end
end
disp('');

%% 绘制帕托前沿图片

% 加载帕托结果
addpath('D:\works\WPT\python_code\maxwell_script\PT_sym\multiobj_matlab\cal_and_fig\history_record');
parto = importdata('parto_res_2unit.mat');

% 读取单元中心的峰值互感值
[r, ~] = size(parto{1, 3});
mc = cell2mat(parto(:,3));
mc = reshape(mc, r, []);
mc = mc';

% 读取单元的互感准均匀区域宽度比
[r, ~] = size(parto{1, 4});
qua_area = cell2mat(parto(:,4));
qua_area = reshape(qua_area, r, []);
qua_area = qua_area';

% % 读取单元铜耗
% [r, ~] = size(parto{1, 6});
% decay = cell2mat(parto(:,6));
% decay = reshape(decay, r, []);
% decay = decay';

% 读取耦合系数
[~, c] = size(parto{1, 5});
k = cell2mat(parto(:,5));
k = reshape(k, [], c);
[max_k,~]=max(k,[],2);

figure();
plot3(mc(:,1), qua_area(:,1), max_k(:,1),'pr');
xlabel(['中心互感量'],'fontsize',10);
ylabel(['准均匀宽度'],'fontsize',10);
zlabel(['耦合系数'],'fontsize',10);


figure();
plot(mc(:,1), max_k(:,1),'pr');
xlabel(['中心互感量'],'fontsize',10);
ylabel(['耦合系数'],'fontsize',10);

figure();
plot(qua_area(:,1), max_k(:,1),'pr');
xlabel(['准均匀宽度'],'fontsize',10);
ylabel(['耦合系数'],'fontsize',10);

%% 从perto中查找点
findres = find(abs(max_k-0.1469) < 0.0001); %采用容忍度方法查询  否则小数无法找到
zashu = parto{findres, 1}
zajianju = parto{findres, 2}


%% 画该点的图像
tw = 0.47;
rd = 0.31;
lpp = 13;
n = round(rd*lpp/tw);
n=9;
single_unit_plot(tw, 4.6, n, lpp, 2);

%% 画该点的图像
tw = 0.25/2;
rd = 0.31;
lpp = 5;
n = round(rd*lpp/tw);
n=8;
single_unit_plot(tw, 4.6, n, lpp, 1);




