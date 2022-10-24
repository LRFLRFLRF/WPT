%% 该文件用于从历史记录中调取以计算过的互感磁通  减少重复运算

function [search_flag, result, record_new] = call_from_history(S, L, I, record)
% 创建表record   格式  第一列接收平面 S [[4, 0],[4,0],1]  第二列发射导线 L [a, -a]  第三列电流I 1
% 第四列互感结果
% record = [4,0,4,0,1,2,-2,1,0];
% save('history_record.mat','record');

%addpath('D:\works\WPT\python_code\maxwell_script\PT_sym\multiobj_matlab\cal_and_fig\history_record');
%load('history_record.mat');

%% 查询结果
% 查找是否有S
a = find(record(:,1)==S{1}(1) & record(:,2)==S{1}(2) &...
    record(:,3)==S{2}(1)  & record(:,4)==S{2}(2)&...
    record(:,5)==S{3} &...
    record(:,6)==L(1) & record(:,7)==L(2) &...
    record(:,8)==I);

res = record(a, :);
if isempty(res)
    search_flag = 0;  % 表示未找到
    result = 0;
else
    search_flag = 1;  % 表示找到
    result = res(9);  %返回查找到的互磁通值
end

end

