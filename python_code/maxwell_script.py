
from func_lib_ansys import Maxwell
import numpy as np

# 线圈命名列表
send = ['send11', 'send12', 'send13', 'send14']
rec = ['rec1']
# 电流加载界面命名列表
send_p = ['send11_p', 'send12_p', 'send13_p', 'send14_p']
rec_p = ['rec1_p']

# 创建工程变量
rs = 9
rs1 = 2
rr = 2
mo = 0
zu_width = 20
h = 10
ps_z = 0

# 相对坐标系参数
RelativeCS1_y = zu_width / 2

# 线圈阵列参数
Dup_num_y = 4  # 沿y方向复制的线圈数量

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
                                            ['mo', str(mo)],
                                            ['rr', str(rr)],
                                            ['h', str(h)],
                                            ['ps_z', str(ps_z)]]])

    # 只sweep 变量mo
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

    # 创建sand1线圈的外圈立方体   send1
    maxwell.createBox_maxwell(str(zu_width / 2 - rs - 0.25) + " cm",
                              str(zu_width / 2 - rs - 0.25) + " cm",
                              str(ps_z) + " cm",
                              str(2 * rs + 0.25 * 2) + " cm",
                              str(2 * rs + 0.25 * 2) + " cm",
                              "0.5mm",
                              send[0],
                              'copper')

    # 创建sand1线圈的内圈立方体  send1_cut
    maxwell.createBox_maxwell(str(zu_width / 2 - rs + 0.25) + " cm",
                              str(zu_width / 2 - rs + 0.25) + " cm",
                              str(ps_z) + " cm",
                              str(2 * rs - 0.25 * 2) + " cm",
                              str(2 * rs - 0.25 * 2) + " cm",
                              "0.5mm",
                              send[0] + "_cut",
                              'copper')

    # 用subtract剪切两个立方体   得到send1线圈
    maxwell.Subtract_maxwell(send[0],
                             send[0] + "_cut")

    # 建立相对坐标系1  用于相交send1线圈 找到电流加载界面
    maxwell.CreateRelativeCS_maxwell("0mm",
                                     str(RelativeCS1_y) + " cm",
                                     "0mm",
                                     "RelativeCS1")

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
    ################################创建rec线圈 以及加载面
    # 选定坐标系
    maxwell.SetWCS_maxwell("Global")

    # 创建rec线圈的外圈立方体   rec1
    maxwell.createBox_maxwell(str(zu_width / 2 - rr - 0.25) + " cm",
                              str(-rr - 0.25) + " cm",
                              str(h) + " cm",
                              str(2 * rr + 2 * 0.25) + " cm",
                              str(2 * rr + 2 * 0.25) + " cm",
                              "0.5mm",
                              rec[0],
                              'copper')

    # 创建rec1线圈的内圈立方体  rec1_cut
    maxwell.createBox_maxwell(str(zu_width / 2 - rr + 0.25) + " cm",
                              str(-rr + 0.25) + " cm",
                              str(h) + " cm",
                              str(2 * rr - 2 * 0.25) + " cm",
                              str(2 * rr - 2 * 0.25) + " cm",
                              "0.5mm",
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
    maxwell.Move_maxwell(str(0) + " cm",
                         'mo' + " cm",
                         str(0) + " cm",
                         'rec1, rec1_p')

    ################################################################
    ########################### 沿Y轴复制send1线圈和加载面
    # 沿Y轴复制
    maxwell.DuplicateAlongLine_maxwell("0mm",
                                       str(zu_width) + "cm",
                                       "0mm",
                                       str(Dup_num_y),
                                       send[0] + "," + send_p[0])

    # 修改复制的线圈的名字
    for i in range(Dup_num_y - 1):
        maxwell.rename_maxwell(send[0] + "_" + str(i + 1), send[i + 1])

    # 修改复制的负载面的名字
    for i in range(Dup_num_y - 1):
        maxwell.rename_maxwell(send_p[0] + "_" + str(i + 1), send_p[i + 1])

    ################################################################
    ###########################加负载电流
    # 发射线圈加载
    for i in range(Dup_num_y):
        maxwell.assignCurrent_maxwell(send_p[i], I_send, True)

    # 接收线圈加载
    maxwell.assignCurrent_maxwell(rec_p[0], I_rec, True)

    ###########################加setup设置
    maxwell.AnalysisSetup_maxwell()

    ###########################加parameters  matrix
    ob_list = rec_p + send_p
    NumberOfTurns_list = [1, 1, 1, 1, 1]

    maxwell.AssignMatrix_maxwell(ob_list,
                                 NumberOfTurns_list,
                                 [send_p])

    ###########################加optimetrics 指定扫描设置
    maxwell.OptiParametricSetup_maxwell(['mo', ],
                                        [[0, Dup_num_y * zu_width, round(Dup_num_y * zu_width / 1, 2)], ])



rs_lim = [0.25 + 0.01, 10-0.25]
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
        maxwell.AnalyzeAll_maxwell()

        ###########################results设置
        # 创建plot
        plot_name = 'table_mo_'+str(i)

        maxwell.CreateReport_maxwell("Data Table",
                                     'mo',
                                     'mo',
                                     "Matrix1.L(rec1_p,Group1)",
                                     plot_name)

        # 导出plot结果至csv
        maxwell.ExportToFile_maxwell(plot_name,
                                     csv_save_path + plot_name + '.csv')

def main():
    # 创建项目
    maxwell = Maxwell()
    build_design(maxwell)
    iter_cal(maxwell)

if __name__ == "__main__":
    main()



