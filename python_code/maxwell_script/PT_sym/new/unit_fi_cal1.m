
%% ������һ����Ԫ��Ȧ�Ĵ�ͨ����С����
function [Fi] = unit_fi_cal1(paralist, S, I)%

send_tw = paralist.send_tw;
send_N = paralist.send_N;
aux_N = paralist.aux_N;
aux_maxR = paralist.aux_maxR;
send_maxR = paralist.send_maxR;


% ���㷢����Ȧ
send_fi = 0;
for i=1:send_N
    % ����n����P������Ĵ�ͨ����
    a = send_maxR-(i-1)*send_tw;  %���ݷ�����Ȧ���뾶���Ѽ�����ÿ�ѵľ���뾶��С
    L = [a, -a];
    send_fi = send_fi + turn_fi_cal1(S, L, I);
end

% ���㸨����Ȧ
aux_fi = 0;
for i=1:aux_N
    % ����n����P������Ĵ�ͨ����
    a = aux_maxR-(i-1)*0.25;  %���ݷ�����Ȧ���뾶���Ѽ�����ÿ�ѵľ���뾶��С
    L = [a, -a];
    aux_fi = aux_fi + turn_fi_cal1(S, L, I);
end

Fi = send_fi + aux_fi;

end






