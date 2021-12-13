from func_lib_ansys import Maxwell
import numpy as np

# 创建工程变量
send_wire_r = 0.25  # 发射线圈导线半径
rec_wire_r = 0.25  # 接收线圈导线半径

fer_coil_d = 0.25  # 铁氧体板与线圈间距
fer_thick = 0.5  # 铁氧体厚度

rs = 10
ra = 5
rr = 5
mo_x = 0
mo_y = 0
zu_width = 30
h = 5
ps_z = 0  # 发射线圈底部z坐标高度
pa_z = send_wire_r * 2 + 0.1  # 附加线圈底部z坐标高度

# 相对坐标系参数
RelativeCS1_x = zu_width / 2
RelativeCS1_y = zu_width / 2
RelativeCS2_x = zu_width
RelativeCS2_y = zu_width

# 线圈阵列参数
Dup_num_y = 3  # 沿y方向复制的线圈数量
Dup_num_x = 3  # 沿x方向复制的线圈数量

# 线圈命名列表 及 电流加载界面命名列表
send = []
send_p = []
for i in range(Dup_num_x):
    for j in range(Dup_num_y):
        send.append('send' + str(i + 1) + str(j + 1))
        send_p.append('send' + str(i + 1) + str(j + 1) + '_p')

rec = ['rec1']
rec_p = ['rec1_p']

aux = []
aux_p = []
for i in range(Dup_num_x - 1):
    for j in range(Dup_num_y - 1):
        aux.append('aux' + str(i + 1) + str(j + 1))
        aux_p.append('aux' + str(i + 1) + str(j + 1) + '_p')

# 电流加载参数
I_send = 1
I_rec = 0

# 扫描参数
sweep_step_len = 2  # 步长

# 结果保存路径参数
csv_save_path = "E:/Desktop/WPT/python_code/data/"


def build_model(maxwell):
    ################################################################
    # 创建工程变量
    maxwell.ChangeProperty_maxwell(tab_type="LocalVariableTab",
                                   ob="LocalVariables",
                                   oprate=["NewProps",
                                           [['rs', str(rs)],
                                            ['zu_width', str(zu_width)],
                                            ['mo_x', str(mo_x)],
                                            ['mo_y', str(mo_y)],
                                            ['rr', str(rr)],
                                            ['h', str(h)],
                                            ['ps_z', str(ps_z)]]])

    # 只sweep 变量mo_x mo_y
    maxwell.ChangeProperty_maxwell(tab_type="LocalVariableTab",
                                   ob="LocalVariables",
                                   oprate=['ChangedProps',
                                           [['rs', "Sweep:=", False],
                                            ['zu_width', "Sweep:=", False],
                                            ['rr', "Sweep:=", False],
                                            ['h', "Sweep:=", False],
                                            ['ps_z', "Sweep:=", False]]])

    ################################################################
    ################################创建vacuum
    # 选定坐标系
    maxwell.SetWCS_maxwell("Global")

    # 创建vacuum
    maxwell.createBox_maxwell(str(-20) + " cm",
                              str(-20) + " cm",
                              str(-20) + " cm",
                              str(150) + " cm",
                              str(150) + " cm",
                              str(150) + " cm",
                              'vacuum',
                              'vacuum')

    ################################################################
    ################################创建send1线圈 以及加载面
    maxwell.creat_coil_array(send,
                             send_p,
                             send_wire_r,
                             rs,
                             RelativeCS1_x,
                             RelativeCS1_y,
                             ps_z,
                             'RelativeCS_send')

    ################################################################
    ################################创建aux线圈 以及加载面
    maxwell.creat_coil_array(aux,
                             aux_p,
                             send_wire_r,
                             ra,
                             RelativeCS2_x,
                             RelativeCS2_y,
                             pa_z,
                             'RelativeCS_aux')


    ################################################################
    ################################创建rec线圈 以及加载面
    maxwell.creat_coil_array(rec,
                             rec_p,
                             rec_wire_r,
                             rr,
                             0,
                             0,
                             h,
                             'RelativeCS_rec')

    # 添加rec移动参数
    maxwell.Move_maxwell('mo_x' + " cm",
                         'mo_y' + " cm",
                         str(0) + " cm",
                         'rec1, rec1_p')

    ################################################################
    ########################### 沿Y轴复制send1线圈和加载面
    maxwell.Duplicate_coil(zu_width,
                           Dup_num_y,
                           Dup_num_x,
                           send,
                           send_p)

    ########################### 沿Y轴复制aux线圈和加载面
    maxwell.Duplicate_coil(zu_width,
                           Dup_num_y - 1,
                           Dup_num_x - 1,
                           aux,
                           aux_p)

    ################################################################
    ###########################创建铁氧体板
    # 选定坐标系
    maxwell.SetWCS_maxwell("Global")

    # 创建send铁氧体
    maxwell.createBox_maxwell(str(0) + " cm",
                              str(0) + " cm",
                              str(-fer_coil_d) + " cm",
                              str(zu_width * Dup_num_x + 2 * fer_coil_d) + " cm",
                              str(zu_width * Dup_num_y + 2 * fer_coil_d) + " cm",
                              str(-fer_thick) + " cm",
                              'send_fer',
                              'ferrite')

    # 创建rec铁氧体
    maxwell.createBox_maxwell(str(- rr - 2 * fer_coil_d) + " cm",
                              str(- rr - 2 * fer_coil_d) + " cm",
                              str(h + 2 * rec_wire_r + fer_coil_d) + " cm",
                              str(2 * rr + 2 * rec_wire_r + 2 * fer_coil_d) + " cm",
                              str(2 * rr + 2 * rec_wire_r + 2 * fer_coil_d) + " cm",
                              str(fer_thick) + " cm",
                              'rec_fer',
                              'ferrite')


def build_param(maxwell):
    ################################################################
    ###########################加负载电流
    # 发射线圈加载
    for i in range(Dup_num_y * Dup_num_x):
        maxwell.assignCurrent_maxwell(send_p[i], I_send, True)

    # 接收线圈加载
    maxwell.assignCurrent_maxwell(rec_p[0], I_rec, True)

    ###########################加setup设置
    maxwell.AnalysisSetup_maxwell()

    ###########################加parameters  matrix
    ob_list = rec_p + send_p
    NumberOfTurns_list = [1] * (len(send) + len(rec))

    maxwell.AssignMatrix_maxwell(ob_list,
                                 NumberOfTurns_list,
                                 [send_p])

    ###########################加optimetrics 指定扫描设置
    # 创建一个setup
    maxwell.OptiParametricSetup_maxwell()

    # 添加sweep参数
    maxwell.EditSetup_maxwell(['mo_y', 'mo_x'],
                              [[0, Dup_num_y * zu_width, round(Dup_num_y * zu_width / 1, sweep_step_len)],
                               [0, Dup_num_x * zu_width, round(Dup_num_x * zu_width / 1, sweep_step_len)]])


rs_lim = [send_wire_r + 0.01, zu_width / 2 - send_wire_r - 0.01]
ra_lim = [send_wire_r + 0.01, zu_width / 2 - send_wire_r - 0.01]


def iter_cal(maxwell):
    rs_sweep_list = np.arange(rs_lim[0], rs_lim[1], 0.5)

    for i in rs_sweep_list:
        # 修改rs长度
        maxwell.ChangeProperty_maxwell(tab_type="LocalVariableTab",
                                       ob="LocalVariables",
                                       oprate=['ChangedProps',
                                               [['rs', "Value:=", str(i)]]])

        ################################################################
        ###########################启动仿真
        # maxwell.AnalyzeAll_maxwell()

        ###########################results设置
        # 创建plot
        plot_name = 'table_mo_' + str(i)

        maxwell.CreateReport_maxwell("Data Table",
                                     'mo',
                                     'mo',
                                     "Matrix1.L(rec1_p,Group1)",
                                     plot_name)

        # 导出plot结果至csv
        maxwell.ExportToFile_maxwell(plot_name,
                                     csv_save_path + plot_name + '.csv')

        # 删除plot
        maxwell.DeleteReports_maxwell(plot_name)


def main():
    # 创建项目
    maxwell = Maxwell()
    # 创建几何模型
    build_model(maxwell)
    # 设置仿真参数
    build_param(maxwell)
    # 线圈优化仿真
    iter_cal(maxwell)


if __name__ == "__main__":
    main()
