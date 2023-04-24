
%% 绘制工作频率轨迹曲面   xy轴分别为k12和k13   y轴为实际工作频率
t=0:0.01:0.5;
[x,y]=meshgrid(t); 

w1 = 2*pi*400E+3;
Q1 = w1*72E-6/10;
z1=real(w1./sqrt(2*(1-(x.^2+y.^2))).*sqrt(2- Q1^(-2) -sqrt(4*(x.^2+y.^2-1)+(2-Q1^(-2))^2)).*((x.^2+y.^2)<1&sqrt(x.^2+y.^2)>sqrt(1-0.25*(2-Q1^(-2))^2))+w1.*(sqrt(x.^2+y.^2)<sqrt(1-0.25*(2-Q1^(-2))^2)))./(2*pi);
z2=real(w1./sqrt(2*(1-(x.^2+y.^2))).*sqrt(2- Q1^(-2) +sqrt(4*(x.^2+y.^2-1)+(2-Q1^(-2))^2)).*((x.^2+y.^2)<1&sqrt(x.^2+y.^2)>sqrt(1-0.25*(2-Q1^(-2))^2))+w1.*(sqrt(x.^2+y.^2)<sqrt(1-0.25*(2-Q1^(-2))^2)))./(2*pi);
mesh(x,y,z1)
hold on
mesh(x,y,z2)

%% 导出数据到origin！！！
% save('C:\Users\LRF\OneDrive\文档\WPT\PAPER\origin\matlab_record\f_zheng.mat','z2');
% save('C:\Users\LRF\OneDrive\文档\WPT\PAPER\origin\matlab_record\f_fu.mat','z1');

%% 计算kc
kc = sqrt(1-0.25*(2-Q1^(-2))^2)


%% 绘制工作频率轨迹曲面   xy轴分别为sqrt(k12^2+k13^2) 和 Q1   y轴为实际工作频率
t1 = 0:0.02:0.6;
t2 = 5:0.1:20;
[x,y]=meshgrid(t1, t2); 

w1 = 2*pi*400E+3;
z1=real(w1./sqrt(2*(1-x.^2)).*sqrt(2- y.^(-2) -sqrt(4*(x.^2-1)+(2-y.^(-2)).^2)).*(x.^2<1&x>sqrt(1-0.25*(2-y.^(-2)).^2))+w1.*(x<sqrt(1-0.25*(2-y.^(-2)).^2)))./(2*pi);
z2=real(w1./sqrt(2*(1-x.^2)).*sqrt(2- y.^(-2) +sqrt(4*(x.^2-1)+(2-y.^(-2)).^2)).*(x.^2<1&x>sqrt(1-0.25*(2-y.^(-2)).^2))+w1.*(x<sqrt(1-0.25*(2-y.^(-2)).^2)))./(2*pi);

mesh(x,y,z1)
hold on
mesh(x,y,z2)

%%导出数据到origin！！！
% save('C:\Users\LRF\OneDrive\文档\WPT\PAPER\origin\matlab_record\f_zheng_kandQ.mat','z2');
% save('C:\Users\LRF\OneDrive\文档\WPT\PAPER\origin\matlab_record\f_fu_kandQ.mat','z1');
