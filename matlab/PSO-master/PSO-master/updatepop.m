%����λ�ú��ٶ�
function [ newpop,newv ] = updatepop( pop,v,pbest,gbest )

[px,py]=size(pop);

%������ٶȾ���ֵ����Ϊ2
vmax=2;

for k=1:py
    %�����ٶ�
    newv(:,k)=0.25*v(:,k)+0.25*rand(1,1)*(pbest(:,k)-pop(:,k))+...
        0.5*rand(1,1)*(gbest-pop(:,k));
    %����������ٶȵ��ٶ�ֵ��Ϊ����ٶ�
    if abs(newv(:,k))>vmax
        if newv(:,k)<0
            newv(:,k)=-vmax;
        end
        if newv(:,k)>0
            newv(:,k)=vmax;
        end
    end
    %����λ��
    newpop(:,k)=pop(:,k)+newv(:,k);
    %�Գ����������λ��ȡ������߽�
    if newpop(1,k)<1
        newpop(1,k)=1;        
    end
    if newpop(1,k)>6
        newpop(1,k)=6;        
    end
    if newpop(2,k)<2
        newpop(2,k)=2;        
    end
    if newpop(2,k)>9
        newpop(2,k)=9;        
    end
end

end

