
%% ������һ����Ԫ��Ȧ�Ĵ�ͨ����С����
function [Fi] = unit_fi_cal1(paralist, S, I)%

send_tw = paralist.send_tw;
aux_tw = paralist.aux_tw;
send_N = paralist.send_N;
aux_N = paralist.aux_N;
aux_maxR = paralist.aux_maxR;
send_maxR = paralist.send_maxR;


% ���㷢����Ȧ
send_fi_M = 0;
for i=1:send_N
    % ����ÿ�Ѳ����Ļ��д�ͨ����
    a = send_maxR-(i-1)*send_tw;  %���ݷ�����Ȧ���뾶���Ѽ�����ÿ�ѵľ���뾶��С
    L = [a, -a];
    send_fi_M = send_fi_M + turn_fi_cal1(S, L, I);
    
end

% ���㸨����Ȧ
aux_fi_M = 0;
for i=1:aux_N
    % ����ÿ�Ѳ����Ļ��д�ͨ����
    a = aux_maxR-(i-1)*aux_tw;  %���ݷ�����Ȧ���뾶���Ѽ�����ÿ�ѵľ���뾶��С
    L = [a, -a];
    aux_fi_M = aux_fi_M + turn_fi_cal1(S, L, I);
end

Fi = send_fi_M + aux_fi_M;

end






