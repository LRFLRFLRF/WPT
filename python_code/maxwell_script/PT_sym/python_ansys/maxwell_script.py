'''
配合 createModel.py 和 func_lib.py 实现Ansys Maxwell中的阵列线圈自动建模与仿真流程
其中main 函数中paralist为接口    matlab或python可调用
'''

from func_lib import Maxwell
from createModel import build_model_param, build_model, ansys_setup, handle_result, ansys_sweep
#import numpy as np


# 结果保存路径参数
csv_save_path = "D:/works/WPT/python_code/data/"

def loadpara(maxwell, paralist):

    ################################################################ 下面这些变量不需要迭代
    # 加载设计的全局变量
    maxwell.send_tw = paralist['send_tw']  # 匝间距

    # 电流加载参数
    maxwell.I_send = 1
    maxwell.I_rec = 0

    # 发射线圈参数
    maxwell.send_N = int(paralist['send_N'])

    maxwell.send_maxR = paralist['send_maxR']
    maxwell.send_wire_r = 0.05 / 2  # 发射线圈导线半径
    maxwell.Rcs_send_x = maxwell.send_maxR
    maxwell.Rcs_send_y = maxwell.send_maxR
    maxwell.Rcs_send_z = 0  # 发射线圈底部z坐标高度
    maxwell.Rcs_send_name = 'RelativeCS_send'

    temp = maxwell.send_maxR*2 - paralist['overlay']  #根据设定的重叠大小计算阵列距离
    maxwell.dupli_dis = temp

    # 辅助线圈参数
    maxwell.aux_N = int(paralist['aux_N'])
    maxwell.aux_maxR = paralist['aux_maxR']
    #maxwell.aux_maxR = 15 / 2
    maxwell.a_wire_r = maxwell.send_wire_r
    maxwell.Rcs_aux_x = maxwell.send_maxR
    maxwell.Rcs_aux_y = maxwell.send_maxR
    maxwell.Rcs_aux_z = 0  # 附加线圈底部z坐标高度
    maxwell.Rcs_aux_name = 'RelativeCS_aux'

    # 接收线圈参数
    maxwell.rec_N = 1
    maxwell.rec_wire_r = 0.05 / 2  # 接收线圈导线半径
    maxwell.mo_x = 0  # 设定模型初始显示位置
    maxwell.mo_y = 0
    maxwell.mo_z = 5
    maxwell.rec_maxR = 10 / 2  # 接收线圈半径
    maxwell.Rcs_rec_name = 'RelativeCS_rec'

    # 线圈阵列参数
    maxwell.Dup_num_y = 1  # 沿y方向复制的线圈数量
    maxwell.Dup_num_x = 1  # 沿x方向复制的线圈数量

    # 铁氧体参数
    maxwell.fer_coil_d = 0.25  # 铁氧体板与线圈间距
    maxwell.fer_thick = 0.5  # 铁氧体厚度
    maxwell.fer_overlong = 1  # 铁氧体外沿超出线圈边界的距离

    # 计算阵列最大宽度和长度 (仅线圈范围)
    maxwell.array_max_width = maxwell.send_maxR * 2 + maxwell.dupli_dis * (maxwell.Dup_num_y - 1)


def startmaxwell(maxwell):
    ################################################################
    # 发射线圈匝半径列表
    rs_list = maxwell.cal_r_list(maxwell.send_N, maxwell.send_maxR, maxwell.send_tw, maxwell.send_wire_r)
    # 辅助线圈匝半径列表
    ra_list = maxwell.cal_r_list(maxwell.aux_N, maxwell.aux_maxR, maxwell.mindis, maxwell.a_wire_r)
    # 辅助线圈匝半径列表
    rr_list = maxwell.cal_r_list(maxwell.rec_N, maxwell.rec_maxR, maxwell.mindis, maxwell.rec_wire_r)

    # 加载当前迭代下的maxwell模型参数
    build_model_param(maxwell, rs_list, ra_list, rr_list)
    # 根据加载的参数创建对应几何模型
    build_model(maxwell)
    # 设置maxwell仿真参数
    ansys_setup(maxwell)
    # 设置扫描参数
    ansys_sweep(maxwell)
    # 启动本次仿真
    #maxwell.AnalyzeAll_maxwell()
    # 结果处理
    #handle_result(maxwell)


def run(paralist):

    # 创建项目
    maxwell = Maxwell()
    # 加载仿真参数
    loadpara(maxwell, paralist)
    # 仿真迭代参数
    startmaxwell(maxwell)



def main():
    paralist = {'send_maxR': 15, 'send_tw': 1, 'overlay': 4.5, 'send_N': 5, 'aux_N': 0, 'aux_maxR': 0}
    run(paralist)

if __name__ == "__main__":
    main()






