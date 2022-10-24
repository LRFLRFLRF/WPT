

%% ���ļ�����  �ı��Ѽ��Ϳ�ȱ�ʱ����Ԫ��Ȧ�Ļ�����������  ����������ǰ��


%% ɨ�� �Ѽ��tw �� ����N   ����õ�mc��qua_area
clear;
tw = 0.35:0.02:0.7;
N = 10:20;
lpp = 15;
parto = {};
for n = N
    for t = tw
        [a,b, c] = single_unit_plot(t, t*(n-1), n, lpp);
        
        % ����ͭ����
        decay = 0;
        for i = 1:n
            r = (lpp-(i-1)*t)*8;
            decay = decay+r;
        end
        
        res = {n, t, a, b, c, decay};
        parto(end+1, :) = res;
        % ���������ļ�
        save('D:\works\WPT\python_code\maxwell_script\PT_sym\multiobj_matlab\cal_and_fig\history_record\parto_res.mat','parto')
    end
end
disp('');

%% ��������ǰ��ͼƬ

% �������н��
addpath('D:\works\WPT\python_code\maxwell_script\PT_sym\multiobj_matlab\cal_and_fig\history_record');
parto = importdata('parto_res_2unit.mat');

% ��ȡ��Ԫ���ĵķ�ֵ����ֵ
[r, ~] = size(parto{1, 3});
mc = cell2mat(parto(:,3));
mc = reshape(mc, r, []);
mc = mc';

% ��ȡ��Ԫ�Ļ���׼���������ȱ�
[r, ~] = size(parto{1, 4});
qua_area = cell2mat(parto(:,4));
qua_area = reshape(qua_area, r, []);
qua_area = qua_area';

% % ��ȡ��Ԫͭ��
% [r, ~] = size(parto{1, 6});
% decay = cell2mat(parto(:,6));
% decay = reshape(decay, r, []);
% decay = decay';

% ��ȡ���ϵ��
[~, c] = size(parto{1, 5});
k = cell2mat(parto(:,5));
k = reshape(k, [], c);
[max_k,~]=max(k,[],2);

figure();
plot3(mc(:,1), qua_area(:,1), max_k(:,1),'pr');
xlabel(['���Ļ�����'],'fontsize',10);
ylabel(['׼���ȿ��'],'fontsize',10);
zlabel(['���ϵ��'],'fontsize',10);


figure();
plot(mc(:,1), max_k(:,1),'pr');
xlabel(['���Ļ�����'],'fontsize',10);
ylabel(['���ϵ��'],'fontsize',10);

figure();
plot(qua_area(:,1), max_k(:,1),'pr');
xlabel(['׼���ȿ��'],'fontsize',10);
ylabel(['���ϵ��'],'fontsize',10);

%% ��perto�в��ҵ�
findres = find(abs(max_k-0.1469) < 0.0001); %�������̶ȷ�����ѯ  ����С���޷��ҵ�
zashu = parto{findres, 1}
zajianju = parto{findres, 2}


%% ���õ��ͼ��
tw = 0.47;
rd = 0.31;
lpp = 13;
n = round(rd*lpp/tw);
n=9;
single_unit_plot(tw, 4.6, n, lpp, 2);

%% ���õ��ͼ��
tw = 0.25/2;
rd = 0.31;
lpp = 5;
n = round(rd*lpp/tw);
n=8;
single_unit_plot(tw, 4.6, n, lpp, 1);




