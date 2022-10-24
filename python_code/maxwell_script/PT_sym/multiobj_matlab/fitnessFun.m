%% 由nsga函数调用  计算多部目标优化中适应度   该文件为中间件 用于解析传进来的参数   转换成func_cal1可用格式

function y = fitnessFun(x)
addpath('D:\works\WPT\python_code\maxwell_script\PT_sym\multiobj_matlab');
addpath('D:\works\WPT\python_code\maxwell_script\PT_sym\multiobj_matlab\cal_and_fig');
addpath('D:\works\WPT\python_code\maxwell_script\PT_sym\multiobj_matlab\cal_and_fig\xkcd_rgb_v1.5\XKCD_RGB');
paralist.send_maxR = 15;%
paralist.send_tw = round(x(1),2);%
paralist.aux_tw = 0;%
paralist.overlay = 0;
n = round(x(2)*paralist.send_maxR/paralist.send_tw);
paralist.send_N = n;
paralist.aux_N = 0;
paralist.aux_maxR = 0;%
paralist.rec_maxR = 5;%
paralist.array_num_y = 1;


sweeplist.start_p = paralist.rec_maxR;
sweeplist.end_p = (paralist.send_maxR*4-paralist.overlay)/2;%
sweeplist.steps = 10;
sweeplist.start_z = 2;
sweeplist.end_z = 8;%
sweeplist.steps_z = 3;
sweeplist.fixed_x = 15;%


[y(1), y(2)] = single_unit_plot(round(x(1),2), 0, n, round(x(1),2)*n/15);
%[y(1), y(2)] = func_cal1(sweeplist, paralist);

end



