


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
        for i in range(maxwell.Dup_num_x):
            for j in range(maxwell.Dup_num_y):
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
    # for i in range(len(send_coil)):
    #     param.append(['rs' + str(i + 1), send_coil[i].coil_r])
    #     param1.append(['rs' + str(i + 1), "Sweep:=", False])
    # 
    # for i in range(len(aux_coil)):
    #     param.append(['ra' + str(i + 1), aux_coil[i].coil_r])
    #     param1.append(['ra' + str(i + 1), "Sweep:=", False])
    # 
    # for i in range(len(rec_coil)):
    #     param.append(['rr' + str(i + 1), rec_coil[i].coil_r])
    #     param1.append(['rr' + str(i + 1), "Sweep:=", False])

    # maxwell.ChangeProperty_maxwell(tab_type="LocalVariableTab",
    #                                ob="LocalVariables",
    #                                oprate=["NewProps",
    #                                        param])

    maxwell.ChangeProperty_maxwell(tab_type="LocalVariableTab",
                                   ob="LocalVariables",
                                   oprate=["NewProps",
                                           [['mo_x', str(maxwell.mo_x)],
                                            ['mo_y', str(maxwell.mo_y)],
                                            ['mo_z', str(maxwell.mo_z)]]])

    # 只sweep 变量mo_x mo_z
    maxwell.ChangeProperty_maxwell(tab_type="LocalVariableTab",
                                   ob="LocalVariables",
                                   oprate=['ChangedProps',
                                           [['mo_x', "Sweep:=", False]
                                            ]])

    # maxwell.ChangeProperty_maxwell(tab_type="LocalVariableTab",
    #                                ob="LocalVariables",
    #                                oprate=['ChangedProps',
    #                                        param1])


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
                                 maxwell.dupli_dis,
                                 maxwell.Dup_num_y,
                                 maxwell.Dup_num_x)

        # 发射线圈各单元错开一定位置，保证重叠时不会碰撞
        for n in range(maxwell.Dup_num_x * maxwell.Dup_num_y):
            ob = maxwell.send_coil[i].coil[n] + ',' + maxwell.send_coil[i].coil_p[n]
            maxwell.Move_maxwell(str(0)+ " cm", str(0)+ " cm", str(n*(maxwell.send_wire_r*2+maxwell.mindis)) + " cm", ob)


        

    # 选定坐标系
    maxwell.SetWCS_maxwell("Global")

    # # 创建send铁氧体
    # maxwell.createBox_maxwell(str(-maxwell.fer_overlong) + " cm",
    #                           str(-maxwell.fer_overlong) + " cm",
    #                           str(-maxwell.fer_coil_d) + " cm",
    #                           str(maxwell.array_max_width+2*maxwell.fer_overlong) + " cm",
    #                           str(maxwell.array_max_width+2*maxwell.fer_overlong) + " cm",
    #                           str(-maxwell.fer_thick) + " cm",
    #                           'send_fer',
    #                           'ferrite')

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
                                 maxwell.dupli_dis,
                                 maxwell.Dup_num_y,
                                 maxwell.Dup_num_x)
        
        # 辅助线圈各单元错开一定位置，保证重叠时不会碰撞
        for n in range(maxwell.Dup_num_x * maxwell.Dup_num_y):
            ob = maxwell.aux_coil[i].coil[n] + ',' + maxwell.aux_coil[i].coil_p[n]
            maxwell.Move_maxwell(str(0) + " cm", str(0) + " cm",
                                 str(n * (maxwell.a_wire_r * 2 + maxwell.mindis)) + " cm", ob)

    ################################################################
    ################################创建rec线圈 铁氧体 以及加载面
    for i in range(maxwell.rec_N):
        maxwell.creat_coil_array(maxwell.rec_coil[i].coil,
                                 maxwell.rec_coil[i].coil_p,
                                 maxwell.rec_wire_r,
                                 maxwell.rec_coil[i].coil_r,
                                 0,
                                 0,
                                 0,
                                 maxwell.Rcs_rec_name,
                                 0,
                                 1,
                                 1)

    # 选定坐标系
    maxwell.SetWCS_maxwell("Global")

    # # 创建rec铁氧体
    # rr_list = []
    # for i in range(len(maxwell.rec_coil)):
    #     rr_list.append(maxwell.rec_coil[i].coil_r)
    # rr_max = maxwell.rec_maxR
    # maxwell.createBox_maxwell(str(- rr_max - maxwell.fer_overlong) + " cm",
    #                           str(- rr_max - maxwell.fer_overlong) + " cm",
    #                           str(maxwell.mo_y + maxwell.fer_coil_d + maxwell.rec_wire_r) + " cm",
    #                           str(2 * rr_max +  2 * maxwell.fer_overlong) + " cm",
    #                           str(2 * rr_max + 2 * maxwell.fer_overlong) + " cm",
    #                           str(maxwell.fer_thick) + " cm",
    #                           'rec_fer',
    #                           'ferrite')

    # 添加rec线圈和铁氧体移动参数
    rr_name_list = ''
    for i in range(len(maxwell.rec_coil)):
        for j in maxwell.rec_coil[i].coil:
            rr_name_list = rr_name_list + j + ','
        
        for j in maxwell.rec_coil[i].coil_p:
            rr_name_list = rr_name_list + j + ','
    rr_name_list = rr_name_list + 'rec_fer'
    maxwell.Move_maxwell('mo_x' + " cm",
                         'mo_y' + " cm",
                         "mo_z" + " cm",
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
        for i in range(maxwell.Dup_num_y* maxwell.Dup_num_x):
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
            (maxwell.Dup_num_y) * (maxwell.Dup_num_x) * maxwell.aux_N) + len(maxwell.rec_coil))

    # 加Matrix参数 并指定group
    maxwell.AssignMatrix_maxwell(ob_list,
                                 NumberOfTurns_list,
                                 [gr1_list, gr2_list])



def ansys_sweep(maxwell):
    ###########################加optimetrics 指定扫描设置
    # 创建一个setup
    maxwell.OptiParametricSetup_maxwell()
    # 添加sweep参数
    maxwell.sweep_steps_xy = 10  # mo的扫描步长
    maxwell.sweep_lim_xy = [0, maxwell.array_max_width/2]
    
    maxwell.sweep_steps_z = 3
    maxwell.sweep_lim_z = [2, 10]


    # xy两方向对称  因此只扫y和z方向即可  x对准单元中心   并令mo_z初始值为table内第一个值  避免ansys多计算一个点浪费时间
    maxwell.ChangeProperty_maxwell(tab_type="LocalVariableTab",
                                   ob="LocalVariables",
                                   oprate=['ChangedProps',
                                           [['mo_x', "Value:=", str(maxwell.send_maxR)],
                                            ['mo_z', "Value:=", str(maxwell.sweep_lim_z[0])]
                                            ]])



    maxwell.EditSetup_maxwell(['mo_y', 'mo_z'],
                              [[str(maxwell.sweep_lim_xy[0]), str(maxwell.sweep_lim_xy[1]),
                                str((maxwell.sweep_lim_xy[1]-maxwell.sweep_lim_xy[0])/maxwell.sweep_steps_xy)],
                               [str(maxwell.sweep_lim_z[0]), str(maxwell.sweep_lim_z[1]),
                                str((maxwell.sweep_lim_z[1] - maxwell.sweep_lim_z[0]) / maxwell.sweep_steps_z)]])

    # 增加输出变量：计算发射阵列和接收线圈的耦合系数
    formula = "Matrix1.L(Group1,Group2)/sqrt(Matrix1.L(Group1,Group1)*Matrix1.L(Group2,Group2))"
    maxwell.CreateoutputVar('coup', formula)


def handle_result(maxwell):
    ###########################results设置
    csv_save_path = 'D:\\works\\WPT\\python_code\\data\\'
    # 绘制收发线圈间耦合系数 并导出至csv
    plot_name = 'coup_'
    sweep_list = ['mo_y', 'mo_z']
    contain = ['coup']
    maxwell.CreateReport_maxwell("Rectangular Contour Plot",
                                 sweep_list,
                                 contain,
                                 plot_name)

    maxwell.ExportToFile_maxwell(plot_name,
                                 csv_save_path + plot_name + '.csv')

    #maxwell.DeleteReports_maxwell(plot_name)

    # 绘制收发线圈自感量互感量 并导出至csv
    plot_name = 'L_'
    sweep_list = ['mo_y', 'mo_z']
    contain = ["Matrix1.L(Group1,Group1)", "Matrix1.L(Group1,Group2)", "Matrix1.L(Group2,Group2)"]
    maxwell.CreateReport_maxwell("Rectangular Contour Plot",
                                 sweep_list,
                                 contain,
                                 plot_name)

    maxwell.ExportToFile_maxwell(plot_name,
                                 csv_save_path + plot_name + '.csv')

    # maxwell.DeleteReports_maxwell(plot_name)

