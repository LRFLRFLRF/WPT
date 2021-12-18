


def build_model_param(maxwell, rs_list, ra_list, rr_list):
    send_coil = []
    aux_coil = []
    rec_coil = []
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
                                                  rs_list[k]))

    maxwell.send_coil = send_coil
    ################################################################
    # 加载每匝辅助线圈结构参数
    for k in range(maxwell.aux_N):
        # 线圈命名列表 及 电流加载界面命名列表
        aux = []
        aux_p = []
        for i in range(maxwell.Dup_num_x - 1):
            for j in range(maxwell.Dup_num_y - 1):
                aux.append(str(k + 1) + 'aux' + str(i + 1) + str(j + 1))
                aux_p.append(str(k + 1) + 'aux' + str(i + 1) + str(j + 1) + '_p')

        aux_coil.append(maxwell.create_coil_type(aux,
                                                 aux_p,
                                                 ra_list[k]))
    maxwell.aux_coil = aux_coil
    ################################################################
    # 加载每匝接收线圈结构参数
    for k in range(maxwell.rec_N):
        # 线圈命名列表 及 电流加载界面命名列表
        rec = [str(k + 1) + 'rec1']
        rec_p = [str(k + 1) + 'rec1_p']

        rec_coil.append(maxwell.create_coil_type(rec,
                                                 rec_p,
                                                 rr_list[k]))
    maxwell.rec_coil = rec_coil
    ################################################################
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
                                            ['mo_x', str(maxwell.mo_x)],
                                            ['mo_y', str(maxwell.mo_y)],
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
        maxwell.creat_coil_array(maxwell.send_coil[i].coil,
                                 maxwell.send_coil[i].coil_p,
                                 maxwell.send_wire_r,
                                 maxwell.send_coil[i].coil_r,
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
        maxwell.creat_coil_array(maxwell.aux_coil[i].coil,
                                 maxwell.aux_coil[i].coil_p,
                                 maxwell.a_wire_r,
                                 maxwell.aux_coil[i].coil_r,
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
        maxwell.creat_coil_array(maxwell.rec_coil[i].coil,
                                 maxwell.rec_coil[i].coil_p,
                                 maxwell.rec_wire_r,
                                 maxwell.rec_coil[i].coil_r,
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
    for i in range(len(maxwell.rec_coil)):
        rr_list.append(maxwell.rec_coil[i].coil_r)
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
    rr_name_list = ''
    for i in range(len(maxwell.rec_coil)):
        for j in maxwell.rec_coil[i].coil:
            rr_name_list = rr_name_list + j + ', '
        for j in maxwell.rec_coil[i].coil_p:
            rr_name_list = rr_name_list + j + ', '
    rr_name_list = rr_name_list + 'rec_fer'
    maxwell.Move_maxwell('mo_x' + " cm",
                         'mo_y' + " cm",
                         str(0) + " cm",
                         rr_name_list)

def ansys_setup(maxwell):
    ###########################加负载电流
    # 发射线圈加载
    for k in range(maxwell.send_N):
        temp = maxwell.send_coil[k].coil_p
        # 发射线圈加载
        for i in range(maxwell.Dup_num_y * maxwell.Dup_num_x):
            maxwell.assignCurrent_maxwell(temp[i], maxwell.I_send, True)

    # 辅助线圈加载
    for k in range(maxwell.aux_N):
        temp = maxwell.aux_coil[k].coil_p
        # 辅助线圈加载
        for i in range((maxwell.Dup_num_y - 1) * (maxwell.Dup_num_x - 1)):
            maxwell.assignCurrent_maxwell(temp[i], maxwell.I_send, True)

    # 接收线圈加载
    for k in range(maxwell.rec_N):
        temp = maxwell.rec_coil[k].coil_p
        # 接收线圈加载
        maxwell.assignCurrent_maxwell(temp[0], maxwell.I_rec, True)

    ###########################加setup设置
    maxwell.AnalysisSetup_maxwell()

    ###########################加parameters  matrix
    # 分组列表
    gr1_list = []
    for k in range(maxwell.send_N):
        gr1_list = gr1_list + maxwell.send_coil[k].coil_p

    for k in range(maxwell.aux_N):
        gr1_list = gr1_list + maxwell.aux_coil[k].coil_p

    # 线圈列表
    gr2_list = []
    for k in range(maxwell.rec_N):
        gr2_list = maxwell.rec_coil[k].coil_p + gr2_list

    ob_list = gr1_list + gr2_list

    NumberOfTurns_list = [1] * ((maxwell.Dup_num_y * maxwell.Dup_num_x * maxwell.send_N) + (
            (maxwell.Dup_num_y - 1) * (maxwell.Dup_num_x - 1) * maxwell.aux_N) + len(maxwell.rec_coil))

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
                                round(maxwell.Dup_num_y * maxwell.zu_width / 1, maxwell.sweep_step_len)],
                               [0, maxwell.Dup_num_x * maxwell.zu_width,
                                round(maxwell.Dup_num_x * maxwell.zu_width / 1, maxwell.sweep_step_len)]])

def handle_result(maxwell):
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