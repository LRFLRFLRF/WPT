%% ������Ȧ�ṹ�����ĵ�λת��

function [paralist,sweeplist] = transform_para(para,sweep)
%% һЩ�ߴ������Ҫ����100  ʵ��m��cm����
paralist = para;
sweeplist = sweep;
paralist.send_maxR = double(paralist.send_maxR/100);%
paralist.send_tw = double(paralist.send_tw/100);%
paralist.aux_tw = double(paralist.aux_tw/100);%
paralist.overlay = double(paralist.overlay/100);
paralist.aux_maxR = double(paralist.aux_maxR/100);%
paralist.rec_maxR = double(paralist.rec_maxR/100);%
sweeplist.start_p = double(sweeplist.start_p/100);
sweeplist.end_p = double(sweeplist.end_p/100);%
sweeplist.start_z = double(sweeplist.start_z/100);
sweeplist.end_z = double(sweeplist.end_z/100);%
sweeplist.fixed_x = double(sweeplist.fixed_x/100);

% ����ɨ�貽��
sweeplist.lens = (sweeplist.end_p-sweeplist.start_p)/sweeplist.steps;
sweeplist.lens_z = (sweeplist.end_z-sweeplist.start_z)/sweeplist.steps_z;
end

