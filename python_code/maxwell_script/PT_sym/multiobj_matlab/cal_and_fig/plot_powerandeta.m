

%% 三线圈系统输出功率和效率特性

t=0:0.01:0.5;
[x,y]=meshgrid(t); 
vin = 48;
RL = 10;
LP = 72.6E-6;
LS = LP;
r1 = 0.25;
r2 = 0.25;
w1 = 2*pi*400E+3;
Q1 = w1*72E-6/10;
z1 = RL*vin^2/((LP*(RL+r2)^2)/LS+2*(RL+r2)*r1+LP*r1^2/LS).*((x.^2+y.^2)<1&sqrt(x.^2+y.^2)>sqrt(1-0.25*(2-Q1^(-2))^2))+vin^2*RL./((x.^2+y.^2).*(Q1^2*(LP*(RL+r2)^2)/LS)+2*(RL+r2)*r1+LP*r1^2/LS).*(sqrt(x.^2+y.^2)<sqrt(1-0.25*(2-Q1^(-2))^2));
%%绘制系统输出功率
mesh(x,y,z1)

%% 导出数据到origin！！！
save('C:\Users\LRF\OneDrive\文档\WPT\PAPER\origin\matlab_record\power_out.mat','z1');



%% 绘制系统效率
z2 = RL*LP/(r1*LS+LP*(RL+r2)).*((x.^2+y.^2)<1&sqrt(x.^2+y.^2)>sqrt(1-0.25*(2-Q1^(-2))^2)) + ((x.^2+y.^2).*(w1^2*RL*LP*LS)./(r1*(RL+r2)^2+(x.^2+y.^2).*(w1^2*(RL+r2)*LP*LS))).*(sqrt(x.^2+y.^2)<sqrt(1-0.25*(2-Q1^(-2))^2));
%%绘制系统输出效率
mesh(x,y,z2)

%% 导出数据到origin！！！
save('C:\Users\LRF\OneDrive\文档\WPT\PAPER\origin\matlab_record\eta_out.mat','z2');
