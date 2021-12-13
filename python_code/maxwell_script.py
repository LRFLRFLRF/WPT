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

# 结果保存路径参数
csv_save_path = "E:/Desktop/WPT/python_code/data/"


def build_design(maxwell):
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
    # 选定坐标系
    maxwell.SetWCS_maxwell("Global")

    # 建立相对坐标系1  用于相交send1线圈 找到电流加载界面
    maxwell.CreateRelativeCS_maxwell(str(RelativeCS1_x) + " cm",
                                     str(RelativeCS1_y) + " cm",
                                     "0mm",
                                     "RelativeCS1")

    # 选定坐标系
    maxwell.SetWCS_maxwell("RelativeCS1")

    # 创建sand1线圈的外圈立方体   send1
    maxwell.createBox_maxwell(str(- rs - send_wire_r) + " cm",
                              str(- rs - send_wire_r) + " cm",
                              str(ps_z) + " cm",
                              str(2 * rs + send_wire_r * 2) + " cm",
                              str(2 * rs + send_wire_r * 2) + " cm",
                              str(2 * send_wire_r) + " cm",
                              send[0],
                              'copper')

    # 创建sand1线圈的内圈立方体  send1_cut
    maxwell.createBox_maxwell(str(- rs + send_wire_r) + " cm",
                              str(- rs + send_wire_r) + " cm",
                              str(ps_z) + " cm",
                              str(2 * rs - send_wire_r * 2) + " cm",
                              str(2 * rs - send_wire_r * 2) + " cm",
                              str(2 * send_wire_r) + " cm",
                              send[0] + "_cut",
                              'copper')

    # 用subtract剪切两个立方体   得到send1线圈
    maxwell.Subtract_maxwell(send[0],
                             send[0] + "_cut")

    # 用RelativeCS1与send1线圈section  找到电流加载界面
    maxwell.section_maxwell(send[0])

    # SeparateBody 并只保留一个电流加载面  并修改面名为send_p
    maxwell.SeparateBody_maxwell(send[0] + "_Section1")

    # 删除一个SeparateBody后多出来的面
    maxwell.Delete_maxwell(send[0] + "_Section1_Separate1")

    # 给剩下的加载面改名
    maxwell.rename_maxwell(send[0] + "_Section1",
                           send_p[0])

    ################################################################
    ################################创建aux线圈 以及加载面
    # 选定坐标系
    maxwell.SetWCS_maxwell("Global")

    # 建立相对坐标系2  用于相交aux线圈 找到电流加载界面
    maxwell.CreateRelativeCS_maxwell(str(RelativeCS2_x) + " cm",
                                     str(RelativeCS2_y) + " cm",
                                     "0mm",
                                     "RelativeCS2")

    # 选定坐标系
    maxwell.SetWCS_maxwell("RelativeCS2")

    # 创建aux线圈的外圈立方体   aux
    maxwell.createBox_maxwell(str(- ra - send_wire_r) + " cm",
                              str(- ra - send_wire_r) + " cm",
                              str(pa_z) + " cm",
                              str(2 * ra + send_wire_r * 2) + " cm",
                              str(2 * ra + send_wire_r * 2) + " cm",
                              str(2 * send_wire_r) + " cm",
                              aux[0],
                              'copper')

    # 创建aux线圈的内圈立方体  aux_cut
    maxwell.createBox_maxwell(str(- ra + send_wire_r) + " cm",
                              str(- ra + send_wire_r) + " cm",
                              str(pa_z) + " cm",
                              str(2 * ra - send_wire_r * 2) + " cm",
                              str(2 * ra - send_wire_r * 2) + " cm",
                              str(2 * send_wire_r) + " cm",
                              aux[0] + "_cut",
                              'copper')

    # 用subtract剪切两个立方体   得到aux线圈
    maxwell.Subtract_maxwell(aux[0],
                             aux[0] + "_cut")

    # 用RelativeCS2与aux线圈section  找到电流加载界面
    maxwell.section_maxwell(aux[0])

    # SeparateBody 并只保留一个电流加载面  并修改面名为aux_p
    maxwell.SeparateBody_maxwell(aux[0] + "_Section1")

    # 删除一个SeparateBody后多出来的面
    maxwell.Delete_maxwell(aux[0] + "_Section1_Separate1")

    # 给剩下的加载面改名
    maxwell.rename_maxwell(aux[0] + "_Section1",
                           aux_p[0])

    ################################################################
    ################################创建rec线圈 以及加载面
    # 选定坐标系
    maxwell.SetWCS_maxwell("Global")

    # 创建rec线圈的外圈立方体   rec1
    maxwell.createBox_maxwell(str(zu_width / 2 - rr - rec_wire_r) + " cm",
                              str(-rr - rec_wire_r) + " cm",
                              str(h) + " cm",
                              str(2 * rr + 2 * rec_wire_r) + " cm",
                              str(2 * rr + 2 * rec_wire_r) + " cm",
                              str(2 * rec_wire_r) + " cm",
                              rec[0],
                              'copper')

    # 创建rec1线圈的内圈立方体  rec1_cut
    maxwell.createBox_maxwell(str(zu_width / 2 - rr + rec_wire_r) + " cm",
                              str(-rr + rec_wire_r) + " cm",
                              str(h) + " cm",
                              str(2 * rr - 2 * rec_wire_r) + " cm",
                              str(2 * rr - 2 * rec_wire_r) + " cm",
                              str(2 * rec_wire_r) + " cm",
                              rec[0] + "_cut",
                              'copper')

    # 用subtract剪切两个立方体   得到rec1线圈
    maxwell.Subtract_maxwell(rec[0], rec[0] + "_cut")

    # 用Global与rec1线圈section  找到电流加载界面
    maxwell.section_maxwell(rec[0])

    # SeparateBody 并只保留一个电流加载面  并修改面名为rec_p
    maxwell.SeparateBody_maxwell(rec[0] + "_Section1")

    # 删除一个SeparateBody后多出来的面
    maxwell.Delete_maxwell(rec[0] + "_Section1_Separate1")

    # 给剩下的加载面改名
    maxwell.rename_maxwell(rec[0] + "_Section1",
                           rec_p[0])

    # 添加rec移动参数
    maxwell.Move_maxwell('mo_x' + " cm",
                         'mo_y' + " cm",
                         str(0) + " cm",
                         'rec1, rec1_p')

    ################################################################
    ########################### 沿Y轴复制send1线圈和加载面
    # 选定坐标系
    maxwell.SetWCS_maxwell("Global")

    # 沿Y轴复制
    maxwell.DuplicateAlongLine_maxwell("0mm",
                                       str(zu_width) + "cm",
                                       "0mm",
                                       str(Dup_num_y),
                                       send[0] + "," + send_p[0])

    # 修改沿y轴复制的线圈和负载面的名字
    for i in range(Dup_num_y - 1):
        maxwell.rename_maxwell(send[0] + "_" + str(i + 1), send[i + 1])
        maxwell.rename_maxwell(send_p[0] + "_" + str(i + 1), send_p[i + 1])

    # 沿x轴复制
    ob = ''
    for i in range(Dup_num_y):
        ob = ob + send[i] + ',' + send_p[i] + ','  # 选中一排线圈和加载面进行x方向复制

    maxwell.DuplicateAlongLine_maxwell(str(zu_width) + "cm",
                                       "0mm",
                                       "0mm",
                                       str(Dup_num_x),
                                       ob)

    # 修改沿x轴复制的线圈和负载面的名字
    for j in range(Dup_num_y):
        temp = send[j]
        temp1 = send_p[j]
        for i in range(Dup_num_x - 1):
            maxwell.rename_maxwell(temp + "_" + str(i + 1), send[Dup_num_y * (i + 1) + j])
            maxwell.rename_maxwell(temp1 + "_" + str(i + 1), send_p[Dup_num_y * (i + 1) + j])

    ########################### 沿Y轴复制aux线圈和加载面
    # 选定坐标系
    maxwell.SetWCS_maxwell("RelativeCS2")

    # 沿Y轴复制
    maxwell.DuplicateAlongLine_maxwell("0mm",
                                       str(zu_width) + "cm",
                                       "0mm",
                                       str(Dup_num_y - 1),
                                       aux[0] + "," + aux_p[0])

    # 修改复制的线圈和负载面的名字
    for i in range(Dup_num_y - 1 - 1):
        maxwell.rename_maxwell(aux[0] + "_" + str(i + 1), aux[i + 1])
        maxwell.rename_maxwell(aux_p[0] + "_" + str(i + 1), aux_p[i + 1])

    # 沿x轴复制
    ob = ''
    for i in range(Dup_num_y - 1):
        ob = ob + aux[i] + ',' + aux_p[i] + ','  # 选中一排线圈和加载面进行x方向复制
    maxwell.DuplicateAlongLine_maxwell(str(zu_width) + "cm",
                                       "0mm",
                                       "0mm",
                                       str(Dup_num_x - 1),
                                       ob)

    # 修改沿x轴复制的线圈和负载面的名字
    for j in range(Dup_num_y - 1):
        temp = aux[j]
        temp1 = aux_p[j]
        for i in range(Dup_num_x - 1 - 1):
            maxwell.rename_maxwell(temp + "_" + str(i + 1), aux[(Dup_num_y - 1) * (i + 1) + j])
            maxwell.rename_maxwell(temp1 + "_" + str(i + 1), aux_p[(Dup_num_y - 1) * (i + 1) + j])

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
    maxwell.createBox_maxwell(str(zu_width / 2 - rr - 2 * fer_coil_d) + " cm",
                              str(-rr - 2 * fer_coil_d) + " cm",
                              str(h + 2 * rec_wire_r + fer_coil_d) + " cm",
                              str(2 * rr + 2 * rec_wire_r + 2 * fer_coil_d) + " cm",
                              str(2 * rr + 2 * rec_wire_r + 2 * fer_coil_d) + " cm",
                              str(fer_thick) + " cm",
                              'rec_fer',
                              'ferrite')

    ################################################################
    ###########################加负载电流
    # 发射线圈加载
    for i in range(Dup_num_y*Dup_num_x):
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
                              [[0, Dup_num_y * zu_width, round(Dup_num_y * zu_width / 1, 2)],
                               [0, Dup_num_x * zu_width, round(Dup_num_x * zu_width / 1, 2)]])


rs_lim = [0.25 + 0.01, 10 - 0.25]

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
        #maxwell.AnalyzeAll_maxwell()

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
    build_design(maxwell)
    iter_cal(maxwell)


if __name__ == "__main__":
    main()
