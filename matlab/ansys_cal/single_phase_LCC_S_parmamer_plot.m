function single_phase_LCC_S_parmamer_plot(func, var, var_list, x, x_lim, resol, parmamer_list, newparmamer_list)  
%parmamer_list, newparmamer_list是 电路全部变量名称和带入值
%func 是功能函数
%var是参数名，var_list参数列表，x是横轴变量名，x_lim是横轴坐标范围, resols是横轴分辨率（点数）
par = parmamer_verification([var, x], parmamer_list, newparmamer_list);
f = subs(func, par.Par, par.newPar);
func_plot(f, var, var_list, x, x_lim, resol)
end


function [parm] = parmamer_verification(x, var, var_new)  
%x 参数排除列表， 表内的参数将不被带入       var 变量名列表    var_new 变量替换值
parmamer = [];
parmamer_new = [];
for i = 1:length(var)
    flg = 0;
    for j = 1:length(x)
        if var(i) == x(j)
            flg = 1;
        end
    end
    
    if(flg == 0)
        parmamer = [parmamer, var(i)];
        parmamer_new = [parmamer_new, var_new(i)];
    end
    
end
parm = struct('Par', {parmamer}, 'newPar', {parmamer_new});
end


function func_plot(func, var, var_list, x, x_lim, resol)
%var是参数名，var_list参数列表，x是横轴变量名，x_lim是横轴坐标范围, resols是横轴分辨率（点数）
figure();
color=linspace(0.1,1,length(var_list));
c_index = 1;
for i=var_list
    func_temp = simplify(subs(func, var, i));
    
    resolution = (x_lim(2)-x_lim(1))/resol;
    x_list = x_lim(1):resolution:x_lim(2);
    y_list = [];
    for j=x_list
        y_list = [y_list, subs(func_temp, x, j)];
    end

    plot(x_list, y_list, 'color',[color(c_index) 0 0]);
    c_index = c_index +1;
    hold on;
end
end