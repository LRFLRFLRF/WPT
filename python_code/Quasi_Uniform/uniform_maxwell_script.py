from uniform_func_lib_ansys import Maxwell
from uniform_create_maxwell_model import create_vacuum
import numpy as np

# 结果保存路径参数
csv_save_path = "E:/Desktop/WPT/python_code/data/"

send_coil_ob = []
aux_coil_ob = []
rec_coil_ob = []


def init_design_param(maxwell):
    ################################################################ 下面这些变量不需要迭代
    # 加载设计的全局变量
    maxwell.zu_width = 30
    maxwell.rec_N = 2  # 接收线圈匝数
    maxwell.aux_N = 2
    maxwell.send_N = 2

    # 电流加载参数
    maxwell.I_send = 1
    maxwell.I_rec = 0

    # maxwell.sweep_step_len = 2  # mo的扫描步长
    #
    # # 接收线圈参数     这些参数应该固定
    # maxwell.mo_x = maxwell.zu_width/2
    # maxwell.mo_y = maxwell.zu_width/2

    # 创建真空
    create_vacuum(maxwell)

    # 创建线圈坐标系
    param = {'rcs_x': maxwell.zu_width / 2,
             'rcs_y': maxwell.zu_width / 2,
             'rcs_z': 0,
             'rcs_name': 'rcs_send'}
    maxwell.rcs.create_rcs(maxwell, param)

    param = {'dup_x': maxwell.dup_x,
             'dup_y': maxwell.dup_y,'rcs_x': maxwell.zu_width / 2,
             'rcs_y': maxwell.zu_width / 2,
             'rcs_z': 5,
             'rcs_name': 'rcs_rec'}
    maxwell.rcs.create_rcs(maxwell, param)

    # 创建发射线圈
    # 发射线圈
    param = {'coil_array_id': 'send',
             'N': maxwell.send_N,
             'ts': 0.25,
             'tw': 0.25,
             'rcs_name': 'rcs_send',
             'r': 30,
             'dup_x': 2,
             'dup_y': 2,
             'dup_dx': 30,
             'dup_dy': 30
             }
    maxwell.coil.creat_coil(maxwell, param)




def main():
    # 创建项目
    maxwell = Maxwell()
    # 初始化工程参数
    init_design_param(maxwell)


if __name__ == "__main__":
    main()
