
%% ִ�������������Ȧ���з���    ����NSGA�㷨��Ӧ�Ⱥ�������

function [Var_mean, Mean_mean] = func_cal1(sweep, para)  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%������һЩ���Բ���  ����ʱע�͵�

% paralist.send_maxR = 15;%
% paralist.send_tw = 1.71;%
% paralist.aux_tw = 0.27;%
% paralist.overlay = 1.63;
% paralist.send_N = 4;
% paralist.aux_N = 4;
% paralist.aux_maxR = 2;%
% paralist.rec_maxR = 5;%
% paralist.array_num_y = 2;
% 
% 
% sweeplist.start_p = paralist.rec_maxR;
% sweeplist.end_p = (paralist.send_maxR*4-paralist.overlay)/2;%
% sweeplist.steps = 10;
% sweeplist.start_z = 2;
% sweeplist.end_z = 15;%
% sweeplist.steps_z = 3;
% sweeplist.fixed_x = 15;%
% %sweeplist.fixed_z = 2/100;%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% ��ʱ
tic


%% һЩ�ߴ������Ҫ����100  ʵ��m��cm����
paralist = para;
sweeplist = sweep;

paralist.send_maxR = double(paralist.send_maxR/100);%
paralist.send_tw = double(paralist.send_tw/100);%
paralist.aux_tw = double(paralist.aux_tw/100);%
paralist.overlay = double(paralist.overlay/100);
paralist.aux_maxR = double(paralist.aux_maxR/100);%
paralist.rec_maxR = double(paralist.rec_maxR/100);%

sweeplist.start_p = double(sweeplist.start_p/100);
sweeplist.end_p = double(sweeplist.end_p/100);%
sweeplist.start_z = double(sweeplist.start_z/100);
sweeplist.end_z = double(sweeplist.end_z/100);%
sweeplist.fixed_x = double(sweeplist.fixed_x/100);
paralist
sweeplist
%% ���������Ȧ�ڲ�ͬλ��ʱ�Ļ���ͨ

% ɨ���Ϊ������Ȧ���ĵ�
start_p = sweeplist.start_p;
end_p = sweeplist.end_p;
steps = sweeplist.steps;

start_z = sweeplist.start_z;
end_z = sweeplist.end_z;
steps_z = sweeplist.steps_z;
% �̶�x z������  ֻ��y����ɨ��
fixed_x = sweeplist.fixed_x;
%fixed_z = sweeplist.fixed_z;

% ������Ȧƽ��İ뾶
rec_R = paralist.rec_maxR;

% �����õ�һϵ��ɨ���P
lens = (end_p-start_p)/steps;
lens_z = (end_z-start_z)/steps_z;
P_list = [];
for j = start_z:lens_z:end_z
    for i = start_p:lens:end_p
        P_list = [P_list; fixed_x,i,j, rec_R];
    end
end

% ������������ڵĴ�ͨ��
res = array_fi_cal1(paralist, P_list);
res1 = reshape(res, [steps+1, length(res)/(steps+1)]);
res1 = res1';


%% ��������ָ��
% �������λת����uH
res1 = res1*1E+6;  

% ���м���ƽ��ֵ   ������ÿ���߶��µĻ���ƽ��ֵ
Mean = mean(res1, 2);
Mean_mean = mean(Mean);
% ���м��㷽��   ������ÿ���߶��µķ����
Var = var(res1,0,2);
Var_mean = mean(Var);



%% ��ͼ ������
fig = figure('color','w');
x = start_p:lens:end_p;
x = x.*100;
plot(x,res1(1,:)','-r.');
hold on;
plot(x,res1(2,:)','-g.');
hold on;
plot(x,res1(3,:)','-b.');
hold on;
plot(x,res1(4,:)','-c.');
hold on;
% legend �������½�
legend(['Var=',num2str(Var(1,1)),';Mean=',num2str(Mean(1,1))], ...
    ['Var=',num2str(Var(2,1)),';Mean=',num2str(Mean(2,1))],...
    ['Var=',num2str(Var(3,1)),';Mean=',num2str(Mean(3,1))],...
    ['Var=',num2str(Var(4,1)),';Mean=',num2str(Mean(4,1))],...
    'Location', 'southeast');

xlabel(['tw=',num2str(paralist.send_tw*100),';over=',num2str(paralist.overlay*100),';s_N=',num2str(paralist.send_N),...
    ';a_N=',num2str(paralist.aux_N),';aux_maxR=',num2str(paralist.aux_maxR*100)],'fontsize',10);

set(gca, 'XGrid', 'on');% ��ʾ����
set(gca, 'YGrid', 'on');% ��ʾ����

frame = getframe(fig); % ��ȡframe
img = frame2im(frame); % ��frame�任��imwrite��������ʶ��ĸ�ʽ
path = 'D:\works\WPT\python_code\maxwell_script\PT_sym\multiobj_matlab\img\';
imwrite(img,[path,'Var_',num2str(Var_mean),';Mean_',num2str(Mean_mean),'.png']); % ���浽����Ŀ¼��

Mean_mean = -1 * Mean_mean;

%% ��ʾ����ʱ��
toc
disp(['times: ',num2str(toc)]);
%% ���㷢�����е��Ը�

% % matlabΪ���볤ֱ���ߣ����߰뾶�����㣬 ��˼����Ըд�ͨʱҪƫ��һ�����߰뾶
% wire_R = 0/100;
% 
% % �Ը���ȦΪ��������õ�P_list
% P_list = [];
% % ��������Ԫ��Ȧ�����о���
% dupli_dis = paralist.send_maxR*2-paralist.overlay;
% for i = 1:paralist.array_num_y
%     
%     % ���㲻ͬ�������ĵ�y����
%     y = (i-1)*dupli_dis + paralist.send_maxR;
%     
%     for j = 1:paralist.send_N
%         % ���㷢����Ȧÿ�ѵİ뾶
%         plane_R = paralist.send_maxR-(j-1)*paralist.send_tw;
%         % ����ÿ�ѵ�λ�úʹ�С����ɨ���б�
%         P_list = [P_list; fixed_x, y, wire_R, plane_R];
%     end
%     
%     for j = 1:paralist.aux_N
%         % ���㸨����Ȧÿ�ѵİ뾶
%         plane_R = paralist.aux_maxR-(j-1)*paralist.aux_tw;
%         % ����ÿ�ѵ�λ�úʹ�С����ɨ���б�
%         P_list = [P_list; fixed_x, y, wire_R, plane_R];
%     end
% end
% 
% % ������õ���P_list������������  ����ÿ��ƽ��Ĵ�ͨ��
% fi_list = array_fi_cal1(paralist, P_list);
% % ÿ����Ȧ��Χƽ��Ĵ�ͨ������һ��  ��Ϊ�������е��Ը��ܴ�ͨ
% fi_array = sum(fi_list)

end



