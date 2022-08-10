%% ����һ�Ѿ�����Ȧ��ָ��λ�ô������Ĵų�ǿ��
function [B] = turn_mag_cal(P, L)

% �ֱ����ǰ�������ĸ����޳��ȵ�����ɵ�һ����Ȧ�����Ĵų�
B_R = line_mag_cal('x', P, L, L(1), 1);
B_L = line_mag_cal('x', P, L, -L(1), -1);
B_F = line_mag_cal('y', P, L, L(1), -1);
B_B = line_mag_cal('y', P, L, -L(1), 1);

% ��������γɵĴų�ʸ����
B = B_R + B_L + B_F + B_B;
B = double(B);

end


