%% ����x yƽ�������޳��ȵ�����P������Ĵų�ǿ��   
%type��Ϊ'x'(��ʾ����ƽ��x�����)  ��'y' (��ʾ����ƽ��y�����)
%P = [x0, y0, z0]   Ϊ���������
%L = [a, b]Ϊ������ʼ����ֹ�㵽�����  
%t Ϊ������ƽ�е�������ľ���  
%I ������С   ��ֵ��ʾ����  ��ֵ����
function [res] = line_mag_cal(type, P, L, t, I)     
syms x y 
syms u0

x0 = P(1);
y0 = P(2);
z0 = P(3);

r = sqrt((x0-x)^2+(y0-y)^2+z0^2); %P���dl��ռ����
R_hat = [x0-x; y0-y; z0]/r; %dlָ��P��ĵ�λʸ��

l = [x; y; 0];
if type == 'x'   %���Ƕ�x��������֣���������ƽ��x�����  ����dl��yΪ0
    l = subs(l, [y], [0]);
elseif type == 'y'
    l = subs(l, [x], [0]);
end
dl = diff(l); %dl�ռ�ʸ��

% ����õ�dB = u0/(4*pi) * IdlxR/r^2
dB = u0/(4*pi)*I*cross(R_hat, dl)/(r^2);

% ����I,u0���Լ�P��x0��y0, z0����
dB = simplify(subs(dB, {u0}, {pi*4E-7}));

if type == 'x'  
    % �Ա���x���л���dB�õ�P��Ĵų�ǿ�ȷ���  LΪ���߰볤
    B = int(dB, x, L(2), L(1));
    % ���뵼��y����λ����Ϣ  ���P��ų�ǿ����ֵ
    B = simplify(subs(B, {y}, {t}));
    res = vpa(B);
elseif type == 'y'
    % �Ա���y���л���dB�õ�P��Ĵų�ǿ�ȷ���  LΪ���߰볤
    B = int(dB, y, L(2), L(1));
    % ���뵼��x����λ����Ϣ  ���P��ų�ǿ����ֵ
    B = simplify(subs(B, {x}, {t}));
    res = vpa(B);
end



