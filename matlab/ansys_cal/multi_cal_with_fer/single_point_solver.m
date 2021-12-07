% 镜像法计算一长直导体产生的B场   导体在u1内  
function [B_sum, I_j] =single_point_solver(u1, u2, h, px, py, id)   
    syms X Y i u0 ur i0
    
    %定义等效导体位置矩阵
    point = [px, py; px, py-2*h;];
    %定义等效导体电流矩阵
    I = [id; id*(u2-u1)/(u2+u1);];
    %定义等效导体所在空间的磁导率矩阵
    u = [u1; u1;];
    
    %XY到等效导体位置的距离
    D = sqrt((X-point(:,1)).^2 + (Y-point(:,2)).^2);  
    
    %等效导体激发的B磁场
    Bi = (I(:,1).*(X-point(:,1))./D(:,1).^2).*u(:,1)/(2*pi);
    
    %B磁场矢量和  
    B_sum = sum(Bi); 
    
    I_j = id*(u2-u1)/(u2+u1);

end