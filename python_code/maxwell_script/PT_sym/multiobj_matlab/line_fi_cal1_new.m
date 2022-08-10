%% ����x yƽ�������޳��ȵ����ڽ�����Ȧ����������Ĵų�����ͨ   
%type��Ϊ'x'(��ʾ����ƽ��x�����)  ��'y' (��ʾ����ƽ��y�����)
%S = {[x_start, x_end], [y_start, y_end], z0}   Ϊ������Ȧ���� ҲΪ���ػ��ֱ߽�
%L = [a, b]Ϊ������ʼ����ֹ�㵽�����  
%t Ϊ������ƽ�е�������ľ���  
%I ������С   ��ֵ��ʾ����  ��ֵ����
function [fi] = line_fi_cal1_new(type, S, L, t, I)     
syms x0 y0
u0 = pi*4E-7;
z0 = S{3};

if type == 'x'   % ����ƽ��x�����
    r1 = sqrt((L(1)-x0)^2+(y0-t)^2+z0^2); %P�����ʾ�˵��ռ����
    r2 = sqrt((L(2)-x0)^2+(y0-t)^2+z0^2); %P�����ֹ�˵��ռ����
    r0 = sqrt((y0-t)^2+z0^2);
    
    cosq1 = (L(1)-x0)/r1;
    cosq2 = (x0-L(2))/r2;
    cosv = (t-y0)/r0;    % 
    
elseif type=='y'   %����ƽ��y�����
    r1 = sqrt((L(1)-y0)^2+(x0-t)^2+z0^2); %P�����ʾ�˵��ռ����
    r2 = sqrt((L(2)-y0)^2+(x0-t)^2+z0^2); %P�����ֹ�˵��ռ����
    r0 = sqrt((x0-t)^2+z0^2);
    
    cosq1 = (L(1)-y0)/r1;
    cosq2 = (y0-L(2))/r2;
    cosv = (x0-t)/r0;    % 
end

% ����õ�B��ǿ�ȵ���ֵ  
B = u0*I/(4*pi*r0)*(cosq1+cosq2);

% ����z�����Bֵ 
Bz = B * cosv;%


% res = vpa(B)
% res1 = vpa(Bz)

%% ���������Ȧ�����ڵĴ�ͨ��
S_x = S{1};  % ������Ȧx����ķ�Χ�߽�
S_y = S{2};

% intx = int(Bz, S_x(2), S_x(1));
% inty = int(intx, S_y(2), S_y(1));
% fi = vpa(inty);

% ������ֵ���ַ�������z�᷽���ͨ������
fi = quad2d(matlabFunction(Bz), S_x(2), S_x(1), S_y(2), S_y(1));
fi = vpa(fi);

end




