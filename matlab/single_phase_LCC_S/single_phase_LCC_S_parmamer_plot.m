function single_phase_LCC_S_parmamer_plot(func, var, var_list, x, x_lim, resol)  
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