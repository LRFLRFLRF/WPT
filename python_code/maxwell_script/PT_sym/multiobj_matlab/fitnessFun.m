%% 由nsga函数调用  计算多部目标优化中适应度   该文件为中间件 用于解析传进来的参数   转换成func_cal1可用格式

function y = fitnessFun(x)

paralist.send_maxR = 15;%
paralist.send_tw = x(1);%
paralist.aux_tw = 0.27;%
paralist.overlay = x(2);
paralist.send_N = round(x(3));
paralist.aux_N = 0;
paralist.aux_maxR = 0;%
paralist.rec_maxR = 5;%
paralist.array_num_y = 2;


sweeplist.start_p = paralist.rec_maxR;
sweeplist.end_p = (paralist.send_maxR*4-paralist.overlay)/2;%
sweeplist.steps = 10;
sweeplist.start_z = 2;
sweeplist.end_z = 15;%
sweeplist.steps_z = 3;
sweeplist.fixed_x = 15;%

[y(1), y(2)] = func_cal1(sweeplist, paralist);

end



