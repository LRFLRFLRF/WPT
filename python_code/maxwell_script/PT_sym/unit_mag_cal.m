%% ������һ����Ԫ��Ȧ�Ĵų�ǿ�ȼ���
function [B] = unit_mag_cal(paralist, P)

send_tw = paralist.send_tw;
send_N = paralist.send_N;
aux_N = paralist.aux_N;
aux_maxR = paralist.aux_maxR;
send_maxR = paralist.send_maxR;

% ���㷢����Ȧ
send_B = 0;
for i=1:send_N
    % ����n����P������Ĵų�ʸ����
    a = send_maxR-i*send_tw;  %���ݷ�����Ȧ���뾶���Ѽ�����ÿ�ѵľ���뾶��С
    L = [a, -a];
    send_B = send_B + turn_mag_cal(P, L);
end

% ���㸨����Ȧ
aux_B = 0;
for i=1:aux_N
    % ����n����P������Ĵų�ʸ����
    a = aux_maxR-i*0.25;  %���ݷ�����Ȧ���뾶���Ѽ�����ÿ�ѵľ���뾶��С
    L = [a, -a];
    aux_B = aux_B + turn_mag_cal(P, L);
end

B = send_B + aux_B;

end




