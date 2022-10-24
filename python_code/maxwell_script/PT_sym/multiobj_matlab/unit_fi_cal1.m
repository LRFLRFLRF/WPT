
%% ������һ����Ԫ��Ȧ�Ĵ�ͨ����С����
function [Fi, record_new] = unit_fi_cal1(paralist, S, I, record)%

send_tw = paralist.send_tw;
aux_tw = paralist.aux_tw;
send_N = paralist.send_N;
aux_N = paralist.aux_N;
aux_maxR = paralist.aux_maxR;
send_maxR = paralist.send_maxR;



% ���㷢����Ȧ
send_fi_M = 0;
record_new = [];
parfor i=1:send_N
    % ����ÿ�Ѳ����Ļ��д�ͨ����
    a = send_maxR-(i-1)*send_tw;  %���ݷ�����Ȧ���뾶���Ѽ�����ÿ�ѵľ���뾶��С
    L = [a, -a];
    [Fi, b] = turn_fi_cal1(S, L, I, record);
    send_fi_M = send_fi_M + Fi;
    record_new = [record_new; b];
    
    
end

% ���㸨����Ȧ
aux_fi_M = 0;
parfor i=1:aux_N
    % ����ÿ�Ѳ����Ļ��д�ͨ����
    a = aux_maxR-(i-1)*aux_tw;  %���ݷ�����Ȧ���뾶���Ѽ�����ÿ�ѵľ���뾶��С
    L = [a, -a];
    [Fi, b] = turn_fi_cal1(S, L, I, record);
    aux_fi_M = aux_fi_M + Fi;
    record_new = [record_new; b];
    
end

Fi = send_fi_M + aux_fi_M;

end






