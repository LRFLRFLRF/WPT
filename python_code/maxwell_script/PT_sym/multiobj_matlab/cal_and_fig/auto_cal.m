
%% 本文件根据设定的优化流程进行阵列双单元优化


%% 第一步 tw0.5固定 进行最大半径maxR和绕组宽度比rd优化
% 找到粗略的最优准均匀区域大小    结果：tw=1;over=7;N=8;rd=0.54;recR=5;maxR=13;Qua=53%
clear;

tw = 1;
zhunarea_set = 0.9;

delt_maxR = 1;
delt_rd = 0.1;
rd_first = 0.6;
maxR = 10;

% 外层更新maxR
rd = rd_first;
flag = 0;
while 1
    
    % 内层更新rd
    while 1
        
        % 计算匝数
        n = round(rd*maxR/tw);
        % 仿真计算
        % 计算独立线圈
        [a, b, c, d] = single_unit_plot(tw, 0, n, maxR, 1);
        
        
        % 判断有效发射面积是否符合设定值
        if b>zhunarea_set   %符合有效面积标准
            flag = 2; %表示找到符合条件的
            break;
        elseif max(d)>a      %互感最大值比中心互感值大则表明绕组比太低了  图像上中心处已下陷
            flag = 3; %表示没找到符合条件的 需要改变maxR继续遍历
            
            %将以当前的独立单元rd值为基准  对双单元重叠进行优化
            % 根据负值区位置及quasi区域宽度计算重叠度
            fu_index = find(d==min(min(d)));  %负值最小值索引
            [~, col] = size(d);
            centre_index = col/2;  %单元中心处索引
            reslo = (2*maxR+20)/col; %每个索引的分辨率
            if size(fu_index)~=1
                fu_index = fu_index(1);
            end
            lfu = abs(fu_index-centre_index)*reslo;%负值区到中心的距离
            lquasi = b*maxR;  % quasi区边界到中心的距离
            x = lfu-maxR;
            overlay_min = maxR - lquasi - x;
            overlay_max = maxR - x;
            
            over_resol = (overlay_max - overlay_min)/3;
            for i = overlay_min:over_resol:overlay_max
                % 根据计算双线圈
                [a, b, c, d] = single_unit_plot(tw, i, n, maxR, 2);     %over = tw*(n-1)
            end
            
            break;
        elseif rd > 0.2  %若rd还没有减到最小
            rd = rd - delt_rd;
        else   %若rd已到减到最小，则改变maxR
            flag = 3;
            break;
        end
    end
    
    if flag == 3
        maxR = maxR + delt_maxR;
        rd = rd_first; %重新赋初值
    end
    
    if maxR == 15
        disp('');
    end
    
    if flag == 2
        % 找到符合条件的
        disp('');
    end
    
    disp('go on');
    
end
%%  第一步细节优化  得到结果：rd 0.47  lpp 19  overlay为10 xy双方向考虑下的最优结构参数
%                   %得到结果：rd 0.31  lpp 13  overlay为4.6 xy双方向考虑下的最优结构参数

clear;
tw = 1;
rd = 0.47;
lpp = 19;
n=10;

% 计算独立线圈
[a, b, c, d] = single_unit_plot(tw, tw*(n-1), n, lpp, 1);

% 根据负值区位置及quasi区域宽度计算重叠度
fu_index = find(d==min(min(d)));  %负值最小值索引
[~, col] = size(d);
centre_index = col/2;  %单元中心处索引
reslo = (2*lpp+20)/col; %每个索引的分辨率
if size(fu_index)~=1
    fu_index = fu_index(1);
end
lfu = abs(fu_index-centre_index)*reslo;%负值区到中心的距离
lquasi = b*lpp;  % quasi区边界到中心的距离
x = lfu-lpp;
overlay_min = 8;%lpp - lquasi - x;
overlay_max = 12;%lpp - x;

over_resol = (overlay_max - overlay_min)/6;
for i = overlay_min:over_resol:overlay_max
    % 根据计算双线圈
    [a, b, c, d] = single_unit_plot(tw, i, n, lpp, 2); 
end



%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 第二步  根据第一步rd和lpp   进行对tw的优化  
%% 该段落实现rd小范围调优   实际可不用  用下一个代码段的固定rd方法即可
delt_N = 3;
delt_rd = 0.02;
rd_first = 0.5;
N_first = 8;
maxR = 13;

rd = rd_first;
N = N_first;
flag = 0;

result = [];
while 1
    while 1
        % 计算tw
        tw = round(maxR*rd/(N-1),2);
        % 仿真计算
        [a, b, c, d] = single_unit_plot(tw, tw*(N-1), N, maxR);
        
        % 计算绕组长度
        decay = 0;
        for i = 1:N
            r = (maxR-(i-1)*tw)*8;
            decay = decay+r;
        end
        result = [result; decay*2, a, b, tw, rd, N, c];
        save('D:\works\WPT\python_code\maxwell_script\PT_sym\multiobj_matlab\cal_and_fig\history_record\step2.mat','result')
        
        if tw>0.3
            N = N + delt_N;
        else
            flag = 1;
            break;
        end
    end
    
    if flag==1
        if rd<0.64
            rd = rd + delt_rd;
            N = N_first;
        else
            break;
        end
        
    end
end

%%  根据固定rd  直接遍历所有可能的导线匝数N  计算铜耗量、互感、耦合系数、准均匀百分比quasi
clear;
delta_N = 1;
maxR = 19;
N_first = 2;

N = N_first;
rd = 0.47;
overlay = 10;
result = [];
while 1
    % 计算tw
    tw = round(maxR*rd/(N-1),2);
    % 仿真计算
    [a, b, c, d] = single_unit_plot(tw, 10, N, maxR, 2);
    
    % 计算绕组长度
    decay = 0;
    for i = 1:N
        r = (maxR-(i-1)*tw)*8;
        decay = decay+r;
    end
    result = [result; decay*2, a, b, tw, rd, N, c];
    save('D:\works\WPT\python_code\maxwell_script\PT_sym\multiobj_matlab\cal_and_fig\history_record\step2.mat','result')
    
    if N<25
        N = N + delta_N;
    else
        break;
    end
    
end

%% 加载第二步计算结果  并绘图
clear;
addpath('D:\works\WPT\python_code\maxwell_script\PT_sym\multiobj_matlab\cal_and_fig\history_record');
result = importdata('step2_xy.mat');

% 读取绕组总长
dec = result(:,1);

% 读取单元耦合系数
k = result(:,7:end);
[~, c] = size(k);
k = k(:,round(c/2));

% 读取均匀区域
quasi = result(:,3);

% 结果汇总
rrr = [result(:,1:6), k];

figure('color','w');
plot(k(:,1), dec(:,1),'pr');
xlabel(['耦合系数'],'fontsize',10);
ylabel(['绕组总长'],'fontsize',10);

figure('color','w');
plot3(k(:,1), dec(:,1), quasi(:,1),'pr');
xlabel(['耦合系数'],'fontsize',10);
ylabel(['绕组总长'],'fontsize',10);
zlabel(['准均匀宽度'],'fontsize',10);





