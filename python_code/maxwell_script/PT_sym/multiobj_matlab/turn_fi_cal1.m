%% ����һ�Ѿ�����Ȧ��ָ��λ�ô������Ĵ�ͨ��С
% SΪ������Ȧ���� ���line_mag_cal1  
% S = {[4, 0],[4,0],1};  %��ֻ��һ�����ӱ��ڵ���  xΪ0-4  yΪ0-4  ��Ϊ1�Ľ�����Ȧ
% LΪ���߲���
function [Fi] = turn_fi_cal1(S, L, I)

% �ֱ����ǰ�������ĸ����޳��ȵ�����ɵ�һ����Ȧ�����Ĵ�ͨ
%  ԭ����line_fi_cal1����    ���ڸĳ�line_fi_cal1_new  ��������ٶ�
fi_R = line_fi_cal1_new('x', S, L, L(1), I);
fi_L = line_fi_cal1_new('x', S, L, -L(1), -I);
fi_F = line_fi_cal1_new('y', S, L, L(1), -I);
fi_B = line_fi_cal1_new('y', S, L, -L(1), I);

% ��������ڽ�����Ȧ�������γɵĴ�ͨ����
Fi = fi_R + fi_L + fi_F + fi_B;
Fi = double(Fi);

end


