% ���񷨼���һ��ֱ���������B��   ������u1��  
function [B_sum, I_j] =single_point_solver(u1, u2, h, px, py, id)   
    syms X Y i u0 ur i0
    
    %�����Ч����λ�þ���
    point = [px, py; px, py-2*h;];
    %�����Ч�����������
    I = [id; id*(u2-u1)/(u2+u1);];
    %�����Ч�������ڿռ�Ĵŵ��ʾ���
    u = [u1; u1;];
    
    %XY����Ч����λ�õľ���
    D = sqrt((X-point(:,1)).^2 + (Y-point(:,2)).^2);  
    
    %��Ч���弤����B�ų�
    Bi = (I(:,1).*(X-point(:,1))./D(:,1).^2).*u(:,1)/(2*pi);
    
    %B�ų�ʸ����  
    B_sum = sum(Bi); 
    
    I_j = id*(u2-u1)/(u2+u1);

end