%% �����ص����lo�仯ʱ�Ļ�����״
tw = 0.378;
rd = 0.5;
lpp = 14;
n = round(rd*lpp/tw);
n=11;
single_unit_plot(tw, 4.5, n, lpp, 2);

%% ����˫����PTϵͳ�������������
Udc = 24;  % ֱ����ѹ
Us = Udc*0.9;   %ȫ���������ѹ��Чֵ
%PL = Us^2*LS/(2*RL*LP)*0.9138  % ˫Rx��һ��Rx���������  �ܹ���Ӧ������2��

RL = 5;
r1 = 0.36;
r2 = 0.54;
LS = 72.263E-6;
LP = 2*59.525E-6; %#1+1 2*59.525E-6   #2x1 105.41E-6  #1+2x1 105.41E-6+59.525E-6   #2x2x1 2*105.41E-6

% % %�����������ʵ����� ƽʱ����
% % r1 = 0.536;
% % r2 = 0.623;
% % LS = 240E-6;
% % LP = 191.282E-6;
% % RL = 16.67;

%˫Rx���������
PLtotal = Us^2*RL/((r2+RL)^2*LP/LS+2*(r2+RL)*r1+LS/LP*r1^2)
%��Ч�ʼ���
et = RL*LP/(r1*LS+LP*(RL+r2))

%����ʵ�鲿������Ч�ʺ��������
w1 = 2*pi*400E+3;
Q1 = w1*LS/RL;
t=0.0:0.01:0.3;
[x,y]=meshgrid(t);
PL_QIANG = Us^2*RL/((r2+RL)^2*LP/LS+2*(r2+RL)*r1+LS/LP*r1^2);
PL_RUO = Us^2*RL./((x.^2+y.^2).*Q1^2*(r2+RL)^2*LP/LS+2*(RL+r2)*r1+LS*r1^2/LP);
PL = PL_QIANG.*((x.^2+y.^2)<1&sqrt(x.^2+y.^2)>sqrt(1-0.25*(2-Q1^(-2))^2)) + PL_RUO.*(sqrt(x.^2+y.^2)<sqrt(1-0.25*(2-Q1^(-2))^2));
mesh(x,y,PL);
%���湦�ʼ�������mat ����origin��ͼ
%save('C:\Users\LRF\OneDrive\works\WPT\PAPER\origin\matlab_record\ChapterV\totalpower.mat','PL');

et_QIANG = RL*LP/(r1*LS+LP*(RL+r2));
et_RUO = (w1^2*RL*LS*LP).*(x.^2+y.^2)./(r1*(RL+r2)^2+(w1^2*(RL+r2)*LS*LP).*(x.^2+y.^2));
et = et_QIANG.*((x.^2+y.^2)<1&sqrt(x.^2+y.^2)>sqrt(1-0.25*(2-Q1^(-2))^2)) + et_RUO.*(sqrt(x.^2+y.^2)<sqrt(1-0.25*(2-Q1^(-2))^2));
et = et.*100;
mesh(x,y,et);
%���湦�ʼ�������mat ����origin��ͼ
save('C:\Users\LRF\OneDrive\works\WPT\PAPER\origin\matlab_record\ChapterV\eta.mat','et');


%% �������۹���Ƶ��
% ����Rx���ϵ����ͬ
x=0:0.001:0.4;
y=x;
w1 = 2*pi*400E+3;
Q1 = w1*72E-6/10;
fzheng=real(w1./sqrt(2*(1-(x.^2+y.^2))).*sqrt(2- Q1^(-2) +sqrt(4*(x.^2+y.^2-1)+(2-Q1^(-2))^2)).*((x.^2+y.^2)<1&sqrt(x.^2+y.^2)>sqrt(1-0.25*(2-Q1^(-2))^2))+w1.*(sqrt(x.^2+y.^2)<sqrt(1-0.25*(2-Q1^(-2))^2)))./(2*pi);
ffu=real(w1./sqrt(2*(1-(x.^2+y.^2))).*sqrt(2- Q1^(-2) -sqrt(4*(x.^2+y.^2-1)+(2-Q1^(-2))^2)).*((x.^2+y.^2)<1&sqrt(x.^2+y.^2)>sqrt(1-0.25*(2-Q1^(-2))^2))+w1.*(sqrt(x.^2+y.^2)<sqrt(1-0.25*(2-Q1^(-2))^2)))./(2*pi);

Out = [x', fzheng', ffu'];
%save('C:\Users\LRF\OneDrive\works\WPT\PAPER\origin\matlab_record\GiGvandPower\f.mat','Out');
kc_m = sqrt(1-0.25*(2-Q1^(-2))^2)/1.414   %�����˳�����2  ��Ϊ��������Ȧ���ϵ��


% ����Rx���ϵ����ͬ  Rx1 0.1�̶�   Rx2�仯
x=0.1;
y=0:0.001:0.5;
fzheng=real(w1./sqrt(2*(1-(x.^2+y.^2))).*sqrt(2- Q1^(-2) +sqrt(4*(x.^2+y.^2-1)+(2-Q1^(-2))^2)).*((x.^2+y.^2)<1&sqrt(x.^2+y.^2)>sqrt(1-0.25*(2-Q1^(-2))^2))+w1.*(sqrt(x.^2+y.^2)<sqrt(1-0.25*(2-Q1^(-2))^2)))./(2*pi);
ffu=real(w1./sqrt(2*(1-(x.^2+y.^2))).*sqrt(2- Q1^(-2) -sqrt(4*(x.^2+y.^2-1)+(2-Q1^(-2))^2)).*((x.^2+y.^2)<1&sqrt(x.^2+y.^2)>sqrt(1-0.25*(2-Q1^(-2))^2))+w1.*(sqrt(x.^2+y.^2)<sqrt(1-0.25*(2-Q1^(-2))^2)))./(2*pi);

Out = [y', fzheng', ffu'];
%save('C:\Users\LRF\OneDrive\works\WPT\PAPER\origin\matlab_record\GiGvandPower\f_with_diffK.mat','Out');


%%����ͬTx��Ȧ��ͬ��λƫ�����ϵ����Ӧ��Ƶ������
load('C:\Users\LRF\OneDrive\works\WPT\PAPER\origin\matlab_record\ChapterIV\Kps_of_singleTx.mat')
kps = RESULT(:,2);
x=kps;
y=x;
w1 = 2*pi*400E+3;
Q1 = w1*72E-6/5;
fzheng=real(w1./sqrt(2*(1-(x.^2+y.^2))).*sqrt(2- Q1^(-2) +sqrt(4*(x.^2+y.^2-1)+(2-Q1^(-2))^2)).*((x.^2+y.^2)<1&sqrt(x.^2+y.^2)>sqrt(1-0.25*(2-Q1^(-2))^2))+w1.*(sqrt(x.^2+y.^2)<sqrt(1-0.25*(2-Q1^(-2))^2)))./(2*pi);
ffu=real(w1./sqrt(2*(1-(x.^2+y.^2))).*sqrt(2- Q1^(-2) -sqrt(4*(x.^2+y.^2-1)+(2-Q1^(-2))^2)).*((x.^2+y.^2)<1&sqrt(x.^2+y.^2)>sqrt(1-0.25*(2-Q1^(-2))^2))+w1.*(sqrt(x.^2+y.^2)<sqrt(1-0.25*(2-Q1^(-2))^2)))./(2*pi);

Out = [RESULT(:,1), x, fzheng, ffu];
save('C:\Users\LRF\OneDrive\works\WPT\PAPER\origin\matlab_record\ChapterV\fandK.mat','Out');
kc_m = sqrt(1-0.25*(2-Q1^(-2))^2)/1.414   %�����˳�����2  ��Ϊ��������Ȧ���ϵ��


%% ����Txÿ����Ȧ�뾶
lpmax = 14;
for i = 1:11
    l = (lpmax - (i-1)*0.378)*1.414
end


%% ����г�����
clc
f0 = 400E+3;
L = 73.19E-6;
C1 = (1/(2*pi*sqrt(L))/f0)^2
C2 = (2/1.77-1)*C1


% C = 3.3E-9;
% F = 1/(2*pi*sqrt(L*C))


%% ��ǰ������·����
f = 400E+3;
w = 2*pi*f;
R1 = 100;
R2 = 200;
C = 3.97E-9;%��λnf
% ʵ����Ҫcita=30  t=5E-7

cita = atan(w*R1*C)-atan((w*R1*R2*C)/(R1+R2));
cita = cita*180/pi
t = pi*R1^2*C/(180*(R1+R2))

%x = R1*C;  y=R2/(R1+R2);
x = 1E-8*1:1E-8:1E-8*1000;
y = 0.1:0.05:0.5;
[X,Y]=meshgrid(x, y);
c1 = (atan(w.*X)-atan(w.*X.*Y)).*(180/pi);
mesh(X, Y ,c1)

C = 3.9e-9;
x = 1.19E-6;
R1 = x/C
y = 0.1;
R2 = R1*(1/(1-y)-1)
%% ����GI GV ��POWER�����ݵ�origin
times = out.Gi{1}.Values.time;
GI_P = out.Gi{1}.Values.data;
GI_S1 = out.Gi{2}.Values.data;
GI_S2 = out.Gi{3}.Values.data;
GI = [GI_P, GI_S1, GI_S2];

GV_P = out.Gv{1}.Values.data;
GV_S1 = out.Gv{2}.Values.data;
GV_S2 = out.Gv{3}.Values.data;
GV = [GV_P, GV_S1, GV_S2];
Out = [times, GI, GV];
%save('C:\Users\LRF\OneDrive\works\WPT\PAPER\origin\matlab_record\GiGvandPower\wave_of_GIGV_with_k0.2Lp59.52Ls72.26.mat','Out');

times = out.Power{1}.Values.time;
Power_P = out.Power{1}.Values.data;
Power_S1 = out.Power{2}.Values.data;
Power_S2 = out.Power{3}.Values.data;
Power = [times, Power_P, Power_S1, Power_S2];
Out = Power;
%save('C:\Users\LRF\OneDrive\works\WPT\PAPER\origin\matlab_record\GiGvandPower\wave_of_POWER_with_k0.2Lp59.52Ls72.26.mat','Out');

%% �������������С
k1 = 0.1;
k2 = 0.1:0.05:0.4;
Lp = 59.52E-6;
Ls1 = 72.26E-6;
GI1 = k1./sqrt(k1^2+k2.^2).*sqrt(Lp/Ls1);
GI2 = k2./sqrt(k1^2+k2.^2).*sqrt(Lp/Ls1);

GV1 = k1./sqrt(k1^2+k2.^2).*sqrt(Ls1/Lp);
GV2 = k2./sqrt(k1^2+k2.^2).*sqrt(Ls1/Lp);


%% ���������������
Up = 43.11;
RL1 = 10;
RL2 = 10;
Lp = 59.52E-6;
Ls1 = 72.26E-6;

t=0.1:0.01:0.5;
[k1,k2]=meshgrid(t);
PL1 = Up^2*k1.^2./(k1.^2+k2.^2)/(RL1*(Lp/Ls1));
PL2 = Up^2*k2.^2./(k1.^2+k2.^2)/(RL2*(Lp/Ls1));
mesh(k1,k2,PL1);
hold on;
mesh(k1,k2,PL2);
hold on;
mesh(k1,k2,PL1+PL2);

PLtotal = PL1+PL2;
%save('C:\Users\LRF\OneDrive\works\WPT\PAPER\origin\matlab_record\GiGvandPower\outputpower_RL1.mat','PL1');
%save('C:\Users\LRF\OneDrive\works\WPT\PAPER\origin\matlab_record\GiGvandPower\outputpower_RL2.mat','PL2');
%save('C:\Users\LRF\OneDrive\works\WPT\PAPER\origin\matlab_record\GiGvandPower\outputpower_RLtotal.mat','PLtotal');

%% ����Rx1���صĵ�ѹ�������Լ�������ʲ���
times = out.IandVofRx1{1}.Values.time;
IandV = out.IandVofRx1{1}.Values.data;
Out = [times, IandV];
%save('C:\Users\LRF\OneDrive\works\WPT\PAPER\origin\matlab_record\I_V_Power_Rx1\IandV_Rx1.mat','Out');


times = out.outputPowerofRx1{1}.Values.time;
outPower = out.outputPowerofRx1{1}.Values.data;
Out = [times, outPower];
%save('C:\Users\LRF\OneDrive\works\WPT\PAPER\origin\matlab_record\I_V_Power_Rx1\outpower_Rx1.mat','Out');


%% ������Ȧ���ϵ������������̬����Ƶ�ʲ�fd ����֤Rxλ�ü�ⷽ��
addpath('C:\Users\LRF\OneDrive\works\WPT\PAPER\origin\matlab_record\ChapterIV');
Kps = importdata('Kps_of_singleTx.mat');
rows = size(Kps);

x=Kps(:,2);
y=0;
w1 = 2*pi*400E+3;
Q1 = w1*72E-6/10;
fzheng=real(w1./sqrt(2*(1-(x.^2+y.^2))).*sqrt(2- Q1^(-2) +sqrt(4*(x.^2+y.^2-1)+(2-Q1^(-2))^2)).*((x.^2+y.^2)<1&sqrt(x.^2+y.^2)>sqrt(1-0.25*(2-Q1^(-2))^2))+w1.*(sqrt(x.^2+y.^2)<sqrt(1-0.25*(2-Q1^(-2))^2)))./(2*pi);
fdzheng = fzheng-w1/(2*pi);
ffu=real(w1./sqrt(2*(1-(x.^2+y.^2))).*sqrt(2- Q1^(-2) -sqrt(4*(x.^2+y.^2-1)+(2-Q1^(-2))^2)).*((x.^2+y.^2)<1&sqrt(x.^2+y.^2)>sqrt(1-0.25*(2-Q1^(-2))^2))+w1.*(sqrt(x.^2+y.^2)<sqrt(1-0.25*(2-Q1^(-2))^2)))./(2*pi);
fdfu = ffu-w1/(2*pi);

Out = [Kps(:,1), fdzheng, fdfu];
%save('C:\Users\LRF\OneDrive\works\WPT\PAPER\origin\matlab_record\ChapterIV\Fd.mat','Out');


%% ������Ȧͭ����

lmax = 5;
D = 0;
for i = 1:8
    r = lmax- (i-1)*0.28;
    D = D + r*8*3;
end
D

%% ������Ȧͭ��
lmax = 14;
D = 0;
for i = 1:11
    r = lmax- (i-1)*0.378;
    D = D + r*8;
end
D

%%
f = 500E+3;
w = 2*pi*f;
vdc = 21;
Co = 76E-12;
eta = 0.9;
Po = 100;
t = (acos(1/(1+vdc^2*Co*w*eta/(pi*Po)))/w)*180/pi

