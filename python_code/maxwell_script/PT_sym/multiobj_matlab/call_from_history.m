%% ���ļ����ڴ���ʷ��¼�е�ȡ�Լ�����Ļ��д�ͨ  �����ظ�����

function [search_flag, result, record_new] = call_from_history(S, L, I, record)
% ������record   ��ʽ  ��һ�н���ƽ�� S [[4, 0],[4,0],1]  �ڶ��з��䵼�� L [a, -a]  �����е���I 1
% �����л��н��
% record = [4,0,4,0,1,2,-2,1,0];
% save('history_record.mat','record');

%addpath('D:\works\WPT\python_code\maxwell_script\PT_sym\multiobj_matlab\cal_and_fig\history_record');
%load('history_record.mat');

%% ��ѯ���
% �����Ƿ���S
a = find(record(:,1)==S{1}(1) & record(:,2)==S{1}(2) &...
    record(:,3)==S{2}(1)  & record(:,4)==S{2}(2)&...
    record(:,5)==S{3} &...
    record(:,6)==L(1) & record(:,7)==L(2) &...
    record(:,8)==I);

res = record(a, :);
if isempty(res)
    search_flag = 0;  % ��ʾδ�ҵ�
    result = 0;
else
    search_flag = 1;  % ��ʾ�ҵ�
    result = res(9);  %���ز��ҵ��Ļ���ֵͨ
end

end

