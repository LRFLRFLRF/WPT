%PSO
%Copyright:jiaowenlong
%2017.4.17

clc
clear

%设置问题相关变量
popsize=2000;%个体数量
degree=100;%循环次数

[popmax,vmax]=Init(popsize);%初始化求�?��值群体的位置和�?�?
[popmin,vmin]=Init(popsize);%初始化求�?��值群体的位置和�?�?

%计算初始群体的�?应度,群体�?��个体
[value_max,gbestvaluemax,gbestmax]=calfitvaluemax(popmax);
[value_min,gbestvaluemin,gbestmin]=calfitvaluemin(popmin);

%将个体历史最优先设为初始化�?
pbestmax=popmax;
pbestmin=popmin;

%创建�?
set(gcf,'doublebuffer','on')
set(gcf,'Name','粒子群算法PSO演示')
axis([1 6 2 9])
grid on

for i=1:degree
    %产生新的位置
    [newpopmax,newvmax]=updatepop(popmax,vmax,pbestmax,gbestmax);
    [newpopmin,newvmin]=updatepop(popmin,vmin,pbestmin,gbestmin);
    
    %更新速度�?
    vmax=newvmax;
    vmin=newvmin;
    
    %更新位置�?
    popmax=newpopmax;
    popmin=newpopmin;
    
    %计算新的适应度�?，该次循环中的群体最�?
    [newvalue_max,newgbestvaluemax,newgbestmax]=calfitvaluemax(newpopmax);
    [newvalue_min,newgbestvaluemin,newgbestmin]=calfitvaluemin(newpopmin);
    
    %更新个体历史�?��
    for j=1:popsize
        if newvalue_max(j)>value_max(j)
            pbestmax(:,j)=newpopmax(:,j);
        end
        if newvalue_min(j)<value_min(j)
            pbestmin(:,j)=newpopmin(:,j);
        end      
    end
    
    %更新群体�?��
    if newgbestvaluemax>gbestvaluemax
        gbestvaluemax=newgbestvaluemax;
        gbestmax=newgbestmax;
    end
    
    if newgbestvaluemin<gbestvaluemin
        gbestvaluemin=newgbestvaluemin;
        gbestmin=newgbestmin;
    end
    
    %绘制动�?运动散点�?
    plot(newpopmax(1,:),newpopmax(2,:),'r*',newpopmin(1,:),newpopmin(2,:),'go');
    drawnow
    
end
