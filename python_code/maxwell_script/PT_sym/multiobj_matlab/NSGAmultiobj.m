%% NSGA��Ŀ���Ż�ģ��


clear;

%% ģ������
% ��Ӧ�Ⱥ����ĺ������
fitnessfcn=@fitnessFun;
% ��������
nvars=3;

% Լ��������ʽ1������������
ub=[2, 10, 8];
lb=[0.25, 0, 3];

% Լ��������ʽ2�����Բ���ʽԼ��������ȡ������[]��
% A*X <= b 
A = [];

b = [];

% Լ��������ʽ3�����Ե�ʽԼ��������ȡ������[]��
% Aeq*X == beq
Aeq=[];
beq=[];


%% ���������
% ���Ÿ���ϵ��paretoFraction
% ��Ⱥ��Сpopulationsize
% ����������generations
% ֹͣ����stallGenLimit
% ��Ӧ�Ⱥ���ƫ��TolFun
% ����gaplotpareto������Paretoǰ�� 
options=gaoptimset('paretoFraction',0.5,'populationsize',60,'generations',100,'stallGenLimit',50,'TolFun',1e-18,'PlotFcns',@gaplotpareto);

%% �����
[x,fval]=gamultiobj(fitnessfcn,nvars,A,b,Aeq,beq,lb,ub,options);

%% �����ȡ
% ��Ϊgamultiobj����Ŀ�꺯������ȡ��СֵΪĿ�꣬
% �����y=Fun(x)��ȡ�෴����Ŀ�꺯����ȡ�෴������ԭʼ���
plot(fval(:,1),-fval(:,2),'pr')
xlabel('f_1(x)')
ylabel('f_2(x)')
title('Pareto front')
grid on


