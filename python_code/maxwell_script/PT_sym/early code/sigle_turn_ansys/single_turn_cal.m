
%% ���һ����Ȧ�ڿռ��еĴų��ֲ����з���
function [Fi] = single_turn_cal()%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%��ʼ���������
paralist.send_maxR = 15;%
paralist.overlay = 1.63;
paralist.send_N = 1;
paralist.rec_maxR = 5;
paralist.array_num_y = 2;

sweeplist.start_p = paralist.rec_maxR;
sweeplist.end_p = (paralist.send_maxR*4-paralist.overlay)/2;
sweeplist.steps = 10;
sweeplist.start_z = 2;
sweeplist.end_z = 15;
sweeplist.steps_z = 3;
sweeplist.fixed_x = 15;

I = 1;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
send_tw = paralist.send_tw;
send_N = paralist.send_N;
send_maxR = paralist.send_maxR;


% ���㷢����Ȧ
send_fi_M = 0;
parfor i=1:send_N
    % ����ÿ�Ѳ����Ļ��д�ͨ����
    a = send_maxR-(i-1)*send_tw;  %���ݷ�����Ȧ���뾶���Ѽ�����ÿ�ѵľ���뾶��С
    L = [a, -a];
    send_fi_M = send_fi_M + turn_fi_cal1(S, L, I);
end

end






