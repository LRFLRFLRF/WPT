
%% 将耦合系数不同的 Rx输出功率波形导出到origin！！
res = out.ScopeData6{1}.Values;
Res = [res.time, res.data];
save('C:\Users\LRF\OneDrive\文档\WPT\PAPER\origin\matlab_record\diff_coef_Rxpower.mat','Res');


%% 计算两个实验Tx线圈互感值构成的2x1阵列值

exA = [0.06
0.08
0.06
0.08
0.06
0.08
0.1
0.1
0.1
0.12
0.08
0.1
0.1
0.08
0.09
0.1
0.08
0.08
0.1
0.1
0.12
0.1
0.08
0.05
-0.1
-0.06];

exB = [-0.06
-0.12
0.01
0.06
0.1
0.05
-0.08
-0.1
-0.12
-0.08
-0.06
-0.1
-0.08
-0.06
-0.09
-0.04
-0.1
-0.12
-0.14
-0.1
0.02
0.09
0.12
0.1
0.07
-0.12];

exC=[-0.1
-0.14
-0.16
-0.14
-0.04
-0.01
0.06
0.08
0.12
0.14
0.1
0.08
0.08
0.03
0.05
0.05
0.06
0.08
0.09
0.04
0
-0.09
-0.12
-0.16
-0.15
-0.15];

exD = [-0.16
-0.19
-0.11
-0.06
-0.06
-0.1
-0.05
0.02
0.09
0.11
0.04
0.06
0.09
0.12
0.06
0.09
0.11
0.1
0.07
0.08
0.08
0.09
0.1
0.12
0.09
0.14];

%% 原始2x1阵列互感图像
tw = 0.378;
rd = 0.25;
lpp = 14;
n = round(rd*lpp/tw);
n=11;
[~,~,~,res1] = single_unit_plot(tw, 4.5, n, lpp, 2);

%% 
res=res1.*14.6;
lens = (61.5+10)/90;
x = -10:lens:61.5;
res = [x', res'];
RES = res;

%%
%A和B Tx
lens = (27.3333-0.6667)/25;
x1 = 0.6667:lens:27.3333;
x2 = x1+24-4.5;
for i=1:length(x1)
    for j = 2:length(RES(:,1))
        if RES(j,1)>=x1(i) && RES(j-1,1)< x1(i)
            RES(j,2) = RES(j,2) + exA(i,1);
        end
    end   
end
for i=1:length(x2)
    for j = 2:length(RES(:,1))
        if RES(j,1)>=x2(i) && RES(j-1,1)< x2(i)
            RES(j,2) = RES(j,2) + exB(i,1);
        end
    end   
end

%AB阵列互感导出 用于绘制origin
save('C:\Users\LRF\OneDrive\文档\WPT\PAPER\origin\matlab_record\Array_AB_MQ.mat','RES');

%%
%B和C Tx
lens = (27.3333-0.6667)/25;
x1 = 0.6667:lens:27.3333;
x2 = x1+24-4.5;
for i=1:length(x1)
    for j = 2:length(RES(:,1))
        if RES(j,1)>=x1(i) && RES(j-1,1)< x1(i)
            RES(j,2) = RES(j,2) + exB(i,1);
        end
    end   
end
for i=1:length(x2)
    for j = 2:length(RES(:,1))
        if RES(j,1)>=x2(i) && RES(j-1,1)< x2(i)
            RES(j,2) = RES(j,2) + exC(i,1);
        end
    end   
end

%BC阵列互感导出 用于绘制origin
save('C:\Users\LRF\OneDrive\文档\WPT\PAPER\origin\matlab_record\Array_BC_MQ.mat','RES');


%%
%C和D Tx
lens = (27.3333-0.6667)/25;
x1 = 0.6667:lens:27.3333;
x2 = x1+24-4.5;
for i=1:length(x1)
    for j = 2:length(RES(:,1))
        if RES(j,1)>=x1(i) && RES(j-1,1)< x1(i)
            RES(j,2) = RES(j,2) + exC(i,1);
        end
    end   
end
for i=1:length(x2)
    for j = 2:length(RES(:,1))
        if RES(j,1)>=x2(i) && RES(j-1,1)< x2(i)
            RES(j,2) = RES(j,2) + exD(i,1);
        end
    end   
end

%CD阵列互感导出 用于绘制origin
save('C:\Users\LRF\OneDrive\文档\WPT\PAPER\origin\matlab_record\Array_CD_MQ.mat','RES');

figure();
plot(RES(:,1), RES(:, 2));

