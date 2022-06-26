from func_lib_ansys1 import Maxwell
import numpy as np



# 电流加载参数
I_send = 1
I_rec = 0



# 结果保存路径参数
csv_save_path = "E:/Desktop/WPT/python_code/data/"

send_coil = []
aux_coil = []
rec_coil = []


def build_model_param(maxwell):
    ################################################################
    # 加载设计的全局变量
    zu_width = 30
    send_N = 2  # 发射线圈匝数
    aux_N = 2  # 辅助线圈匝数
    rec_N = 18  # 接收线圈匝数

    # 发射线圈参数
    send_wire_r = 0.25/2  # 发射线圈导线半径
    Rcs_send_x = zu_width / 2
    Rcs_send_y = zu_width / 2
    Rcs_send_z = 0  # 发射线圈底部z坐标高度
    Rcs_send_name = 'RelativeCS_send'

    # 辅助线圈参数
    a_wire_r = 0.25/2
    ra = zu_width / 2  # 辅助线圈半径  赋一个初值
    Rcs_aux_x = zu_width
    Rcs_aux_y = zu_width
    Rcs_aux_z = a_wire_r * 2 + 0.1  # 附加线圈底部z坐标高度
    Rcs_aux_name = 'RelativeCS_aux'

    # 接收线圈参数     这些参数应该固定
    rec_wire_r = 0.25/2  # 接收线圈导线半径
    h = 5
    rr = 7.5  # 接收线圈半径
    Rcs_rec_name = 'RelativeCS_rec'

    # 线圈阵列参数
    Dup_num_y = 3  # 沿y方向复制的线圈数量
    Dup_num_x = 3  # 沿x方向复制的线圈数量
    # 铁氧体参数
    fer_coil_d = 0.25  # 铁氧体板与线圈间距
    fer_thick = 0.5  # 铁氧体厚度

    # 创建模型的工程参数
    maxwell.create_design_parma(send_N,
                                aux_N,
                                rec_N,
                                send_wire_r,
                                Rcs_send_x,
                                Rcs_send_y,
                                Rcs_send_z,
                                Rcs_send_name,
                                a_wire_r,
                                Rcs_aux_x,
                                Rcs_aux_y,
                                Rcs_aux_z,
                                Rcs_aux_name,
                                rec_wire_r,
                                h,
                                Rcs_rec_name,
                                zu_width,
                                Dup_num_y,
                                Dup_num_x,
                                fer_coil_d,
                                fer_thick)

    ################################################################
    # 加载每匝发射线圈结构参数
    for k in range(maxwell.send_N):
        # 线圈命名列表 及 电流加载界面命名列表
        send = []
        send_p = []
        for i in range(maxwell.Dup_num_x):
            for j in range(maxwell.Dup_num_y):
                send.append(str(k + 1) + 'send' + str(i + 1) + str(j + 1))
                send_p.append(str(k + 1) + 'send' + str(i + 1) + str(j + 1) + '_p')

        send_coil.append(maxwell.create_coil_type(send,
                                                  send_p,
                                                  rs - 2 * k))

    ################################################################
    # 加载每匝辅助线圈结构参数
    for k in range(maxwell.aux_N):
        # 线圈命名列表 及 电流加载界面命名列表
        aux = []
        aux_p = []
        for i in range(Dup_num_x - 1):
            for j in range(Dup_num_y - 1):
                aux.append(str(k + 1) + 'aux' + str(i + 1) + str(j + 1))
                aux_p.append(str(k + 1) + 'aux' + str(i + 1) + str(j + 1) + '_p')

        aux_coil.append(maxwell.create_coil_type(aux,
                                                 aux_p,
                                                 ra - 2 * k))

    ################################################################
    # 加载每匝接收线圈结构参数
    for k in range(maxwell.rec_N):
        # 线圈命名列表 及 电流加载界面命名列表
        rec = [str(k + 1) + 'rec1']
        rec_p = [str(k + 1) + 'rec1_p']

        rec_coil.append(maxwell.create_coil_type(rec,
                                                 rec_p,
                                                 rr - 2 * k))

    ################################################################
    # 根据线圈结构参数创建工程变量
    param = []
    param1 = []
    for i in range(len(send_coil)):
        param.append(['rs' + str(i + 1), send_coil[i].coil_r])
        param1.append(['rs' + str(i + 1), "Sweep:=", False])

    for i in range(len(aux_coil)):
        param.append(['ra' + str(i + 1), aux_coil[i].coil_r])
        param1.append(['ra' + str(i + 1), "Sweep:=", False])

    for i in range(len(rec_coil)):
        param.append(['rr' + str(i + 1), rec_coil[i].coil_r])
        param1.append(['rr' + str(i + 1), "Sweep:=", False])

    maxwell.ChangeProperty_maxwell(tab_type="LocalVariableTab",
                                   ob="LocalVariables",
                                   oprate=["NewProps",
                                           param])

    maxwell.ChangeProperty_maxwell(tab_type="LocalVariableTab",
                                   ob="LocalVariables",
                                   oprate=["NewProps",
                                           [['zu_width', str(maxwell.zu_width)],
                                            ['mo_x', str(mo_x)],
                                            ['mo_y', str(mo_y)],
                                            ['h', str(maxwell.h)]]])

    # 只sweep 变量mo_x mo_y
    maxwell.ChangeProperty_maxwell(tab_type="LocalVariableTab",
                                   ob="LocalVariables",
                                   oprate=['ChangedProps',
                                           [['zu_width', "Sweep:=", False],
                                            ['h', "Sweep:=", False]]])

    maxwell.ChangeProperty_maxwell(tab_type="LocalVariableTab",
                                   ob="LocalVariables",
                                   oprate=['ChangedProps',
                                           param1])


def build_model(maxwell):
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
    ################################创建发射线圈 以及加载面 并且阵列
    # 创建每匝线圈
    for i in range(maxwell.send_N):
        maxwell.creat_coil_array(send_coil[i].coil,
                                 send_coil[i].coil_p,
                                 maxwell.send_wire_r,
                                 send_coil[i].coil_r,
                                 maxwell.Rcs_send_x,
                                 maxwell.Rcs_send_y,
                                 maxwell.Rcs_send_z,
                                 maxwell.Rcs_send_name,
                                 maxwell.zu_width,
                                 maxwell.Dup_num_y,
                                 maxwell.Dup_num_x)

    # 选定坐标系
    maxwell.SetWCS_maxwell("Global")

    # 创建send铁氧体
    maxwell.createBox_maxwell(str(0) + " cm",
                              str(0) + " cm",
                              str(-maxwell.fer_coil_d) + " cm",
                              str(maxwell.zu_width * maxwell.Dup_num_x + 2 * maxwell.fer_coil_d) + " cm",
                              str(maxwell.zu_width * maxwell.Dup_num_y + 2 * maxwell.fer_coil_d) + " cm",
                              str(-maxwell.fer_thick) + " cm",
                              'send_fer',
                              'ferrite')

    ################################################################
    ################################创建aux线圈 以及加载面 并且阵列
    for i in range(maxwell.aux_N):
        maxwell.creat_coil_array(aux_coil[i].coil,
                                 aux_coil[i].coil_p,
                                 maxwell.a_wire_r,
                                 aux_coil[i].coil_r,
                                 maxwell.Rcs_aux_x,
                                 maxwell.Rcs_aux_y,
                                 maxwell.Rcs_aux_z,
                                 maxwell.Rcs_aux_name,
                                 maxwell.zu_width,
                                 maxwell.Dup_num_y - 1,
                                 maxwell.Dup_num_x - 1)

    ################################################################
    ################################创建rec线圈 铁氧体 以及加载面
    for i in range(maxwell.rec_N):
        maxwell.creat_coil_array(rec_coil[i].coil,
                                 rec_coil[i].coil_p,
                                 maxwell.rec_wire_r,
                                 rec_coil[i].coil_r,
                                 0,
                                 0,
                                 maxwell.h,
                                 maxwell.Rcs_rec_name,
                                 maxwell.zu_width,
                                 1,
                                 1)

    # 选定坐标系
    maxwell.SetWCS_maxwell("Global")

    # 创建rec铁氧体
    rr_list = []
    for i in range(len(rec_coil)):
        rr_list.append(rec_coil[i].coil_r)
    rr_max = max(rr_list)
    maxwell.createBox_maxwell(str(- rr_max - 2 * maxwell.fer_coil_d) + " cm",
                              str(- rr_max - 2 * maxwell.fer_coil_d) + " cm",
                              str(maxwell.h + 2 * maxwell.rec_wire_r + maxwell.fer_coil_d) + " cm",
                              str(2 * rr_max + 2 * maxwell.rec_wire_r + 2 * maxwell.fer_coil_d) + " cm",
                              str(2 * rr_max + 2 * maxwell.rec_wire_r + 2 * maxwell.fer_coil_d) + " cm",
                              str(maxwell.fer_thick) + " cm",
                              'rec_fer',
                              'ferrite')

    # 添加rec线圈和铁氧体移动参数
    maxwell.Move_maxwell('mo_x' + " cm",
                         'mo_y' + " cm",
                         str(0) + " cm",
                         'rec1, rec1_p， rec_fer')


def ansys_setup(maxwell):
    # 创建工程变量
    mo_x = 0
    mo_y = 0
    # 扫描参数
    sweep_step_len = 2  # 步长

    ###########################加负载电流
    # 发射线圈加载
    for k in range(maxwell.send_N):
        temp = send_coil[k].coil_p
        # 发射线圈加载
        for i in range(maxwell.Dup_num_y * maxwell.Dup_num_x):
            maxwell.assignCurrent_maxwell(temp[i], I_send, True)

    # 辅助线圈加载
    for k in range(maxwell.aux_N):
        temp = aux_coil[k].coil_p
        # 辅助线圈加载
        for i in range((maxwell.Dup_num_y - 1) * (maxwell.Dup_num_x - 1)):
            maxwell.assignCurrent_maxwell(temp[i], I_send, True)

    # 接收线圈加载
    for k in range(maxwell.rec_N):
        temp = rec_coil[k].coil_p
        # 接收线圈加载
        maxwell.assignCurrent_maxwell(temp[0], I_rec, True)

    ###########################加setup设置
    maxwell.AnalysisSetup_maxwell()

    ###########################加parameters  matrix
    # 分组列表
    gr1_list = []
    for k in range(maxwell.send_N):
        gr1_list = gr1_list + send_coil[k].coil_p

    for k in range(maxwell.aux_N):
        gr1_list = gr1_list + aux_coil[k].coil_p

    # 线圈列表
    gr2_list = []
    for k in range(maxwell.rec_N):
        gr2_list = rec_coil[k].coil_p + gr2_list

    ob_list = gr1_list + gr2_list

    NumberOfTurns_list = [1] * ((maxwell.Dup_num_y * maxwell.Dup_num_x * maxwell.send_N) + (
            (maxwell.Dup_num_y - 1) * (maxwell.Dup_num_x - 1) * maxwell.aux_N) + len(rec_coil))

    # 加Matrix参数 并指定group
    maxwell.AssignMatrix_maxwell(ob_list,
                                 NumberOfTurns_list,
                                 [gr1_list, gr2_list])


    ###########################加optimetrics 指定扫描设置
    # 创建一个setup
    maxwell.OptiParametricSetup_maxwell()

    # 添加sweep参数
    maxwell.EditSetup_maxwell(['mo_y', 'mo_x'],
                              [[0, maxwell.Dup_num_y * maxwell.zu_width,
                                round(maxwell.Dup_num_y * maxwell.zu_width / 1, sweep_step_len)],
                               [0, maxwell.Dup_num_x * maxwell.zu_width,
                                round(maxwell.Dup_num_x * maxwell.zu_width / 1, sweep_step_len)]])

def iter_param_setup(maxwell):
    # 匝数上下限 和 匝数扫描列表
    send_n_lim = [1, 1, 1]
    aux_n_lim = [1, 20, 1]
    send_n_sweep_list = np.arange(send_n_lim[0], send_n_lim[1], send_n_lim[2])
    aux_n_sweep_list = np.arange(aux_n_lim[0], aux_n_lim[1], aux_n_lim[2])

    rs_lim = [5, maxwell.zu_width / 2 - 5, 5]
    rs_sweep_list = np.arange(rs_lim[0], rs_lim[1], rs_lim[2])






def iter_cal(maxwell):

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
    # 仿真迭代参数设置
    iter_param_setup(maxwell)
    # 创建线圈结构参数
    build_model_param(maxwell)
    # 创建几何模型
    build_model(maxwell)
    # 设置仿真参数
    ansys_setup(maxwell)
    # 线圈优化仿真
    #iter_cal(maxwell)


if __name__ == "__main__":
    main()
