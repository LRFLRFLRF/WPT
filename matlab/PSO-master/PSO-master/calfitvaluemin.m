%CALFITVALUE ������Ӧ��ֵ
function [ fitvalue,gbestvalue,gbest ] = calfitvaluemin( pop )

[px,py]=size(pop);

%�������и������Ӧ��ֵ
for i=1:py
    fitvalue(i)=3*pop(1,i)^2+4*pop(2,i)+pop(2,i)^2;
end

%ÿ��ѭ���е�Ⱥ������
[gbestvalue,gbestindex]=min(fitvalue);
gbest=pop(:,gbestindex);