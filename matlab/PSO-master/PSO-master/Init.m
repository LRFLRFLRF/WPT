%������Ⱥ���г�ʼ��
function [ pop,v ] = Init( size )

for i=1:size
    %��ʼ��λ��
    pop(1,i)=1+rand(1,1)*5;
    pop(2,i)=2+rand(1,1)*7;
    %��ʼ���ٶ�
    v(1,i)=1*(rand(1,1)*2-1);
    v(2,i)=1*(rand(1,1)*2-1);
    
end
end

