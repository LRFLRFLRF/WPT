
%% ���ļ������趨���Ż����̽�������˫��Ԫ�Ż�


%% ��һ�� tw0.5�̶� �������뾶maxR�������ȱ�rd�Ż�
% �ҵ����Ե�����׼���������С    �����tw=1;over=7;N=8;rd=0.54;recR=5;maxR=13;Qua=53%
clear;

tw = 1;
zhunarea_set = 0.9;

delt_maxR = 1;
delt_rd = 0.1;
rd_first = 0.6;
maxR = 10;

% ������maxR
rd = rd_first;
flag = 0;
while 1
    
    % �ڲ����rd
    while 1
        
        % ��������
        n = round(rd*maxR/tw);
        % �������
        % ���������Ȧ
        [a, b, c, d] = single_unit_plot(tw, 0, n, maxR, 1);
        
        
        % �ж���Ч��������Ƿ�����趨ֵ
        if b>zhunarea_set   %������Ч�����׼
            flag = 2; %��ʾ�ҵ�����������
            break;
        elseif max(d)>a      %�������ֵ�����Ļ���ֵ������������̫����  ͼ�������Ĵ�������
            flag = 3; %��ʾû�ҵ����������� ��Ҫ�ı�maxR��������
            
            %���Ե�ǰ�Ķ�����ԪrdֵΪ��׼  ��˫��Ԫ�ص������Ż�
            % ���ݸ�ֵ��λ�ü�quasi�����ȼ����ص���
            fu_index = find(d==min(min(d)));  %��ֵ��Сֵ����
            [~, col] = size(d);
            centre_index = col/2;  %��Ԫ���Ĵ�����
            reslo = (2*maxR+20)/col; %ÿ�������ķֱ���
            if size(fu_index)~=1
                fu_index = fu_index(1);
            end
            lfu = abs(fu_index-centre_index)*reslo;%��ֵ�������ĵľ���
            lquasi = b*maxR;  % quasi���߽絽���ĵľ���
            x = lfu-maxR;
            overlay_min = maxR - lquasi - x;
            overlay_max = maxR - x;
            
            over_resol = (overlay_max - overlay_min)/3;
            for i = overlay_min:over_resol:overlay_max
                % ���ݼ���˫��Ȧ
                [a, b, c, d] = single_unit_plot(tw, i, n, maxR, 2);     %over = tw*(n-1)
            end
            
            break;
        elseif rd > 0.2  %��rd��û�м�����С
            rd = rd - delt_rd;
        else   %��rd�ѵ�������С����ı�maxR
            flag = 3;
            break;
        end
    end
    
    if flag == 3
        maxR = maxR + delt_maxR;
        rd = rd_first; %���¸���ֵ
    end
    
    if maxR == 15
        disp('');
    end
    
    if flag == 2
        % �ҵ�����������
        disp('');
    end
    
    disp('go on');
    
end
%%  ��һ��ϸ���Ż�  �õ������rd 0.47  lpp 19  overlayΪ10 xy˫�������µ����Žṹ����
%                   %�õ������rd 0.31  lpp 13  overlayΪ4.6 xy˫�������µ����Žṹ����

clear;
tw = 1;
rd = 0.47;
lpp = 19;
n=10;

% ���������Ȧ
[a, b, c, d] = single_unit_plot(tw, tw*(n-1), n, lpp, 1);

% ���ݸ�ֵ��λ�ü�quasi�����ȼ����ص���
fu_index = find(d==min(min(d)));  %��ֵ��Сֵ����
[~, col] = size(d);
centre_index = col/2;  %��Ԫ���Ĵ�����
reslo = (2*lpp+20)/col; %ÿ�������ķֱ���
if size(fu_index)~=1
    fu_index = fu_index(1);
end
lfu = abs(fu_index-centre_index)*reslo;%��ֵ�������ĵľ���
lquasi = b*lpp;  % quasi���߽絽���ĵľ���
x = lfu-lpp;
overlay_min = 8;%lpp - lquasi - x;
overlay_max = 12;%lpp - x;

over_resol = (overlay_max - overlay_min)/6;
for i = overlay_min:over_resol:overlay_max
    % ���ݼ���˫��Ȧ
    [a, b, c, d] = single_unit_plot(tw, i, n, lpp, 2); 
end



%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% �ڶ���  ���ݵ�һ��rd��lpp   ���ж�tw���Ż�  
%% �ö���ʵ��rdС��Χ����   ʵ�ʿɲ���  ����һ������εĹ̶�rd��������
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
        % ����tw
        tw = round(maxR*rd/(N-1),2);
        % �������
        [a, b, c, d] = single_unit_plot(tw, tw*(N-1), N, maxR);
        
        % �������鳤��
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

%%  ���ݹ̶�rd  ֱ�ӱ������п��ܵĵ�������N  ����ͭ���������С����ϵ����׼���Ȱٷֱ�quasi
clear;
delta_N = 1;
maxR = 19;
N_first = 2;

N = N_first;
rd = 0.47;
overlay = 10;
result = [];
while 1
    % ����tw
    tw = round(maxR*rd/(N-1),2);
    % �������
    [a, b, c, d] = single_unit_plot(tw, 10, N, maxR, 2);
    
    % �������鳤��
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

%% ���صڶ���������  ����ͼ
clear;
addpath('D:\works\WPT\python_code\maxwell_script\PT_sym\multiobj_matlab\cal_and_fig\history_record');
result = importdata('step2_xy.mat');

% ��ȡ�����ܳ�
dec = result(:,1);

% ��ȡ��Ԫ���ϵ��
k = result(:,7:end);
[~, c] = size(k);
k = k(:,round(c/2));

% ��ȡ��������
quasi = result(:,3);

% �������
rrr = [result(:,1:6), k];

figure('color','w');
plot(k(:,1), dec(:,1),'pr');
xlabel(['���ϵ��'],'fontsize',10);
ylabel(['�����ܳ�'],'fontsize',10);

figure('color','w');
plot3(k(:,1), dec(:,1), quasi(:,1),'pr');
xlabel(['���ϵ��'],'fontsize',10);
ylabel(['�����ܳ�'],'fontsize',10);
zlabel(['׼���ȿ��'],'fontsize',10);





