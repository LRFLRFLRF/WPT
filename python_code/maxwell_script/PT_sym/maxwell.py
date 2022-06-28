from func_lib import Maxwell
from createModel import build_model_param, build_model, ansys_setup, handle_result, ansys_sweep
import numpy as np

# 结果保存路径参数
csv_save_path = "D:/works/WPT/python_code/data/"

def iter_param(maxwell):
    ################################################################ 下面这些变量不需要迭代
    # 加载设计的全局变量
    maxwell.send_tw = 0.27  # 匝间距
    maxwell.dupli_dis = 25
    

    # 电流加载参数
    maxwell.I_send = 1
    maxwell.I_rec = 1


    # 发射线圈参数
    maxwell.send_N = 2
    maxwell.send_maxR = 30 / 2
    maxwell.send_wire_r = 0.25 / 2  # 发射线圈导线半径
    maxwell.Rcs_send_x = maxwell.send_maxR
    maxwell.Rcs_send_y = maxwell.send_maxR
    maxwell.Rcs_send_z = 0  # 发射线圈底部z坐标高度
    maxwell.Rcs_send_name = 'RelativeCS_send'

    # 辅助线圈参数
    maxwell.aux_N = 2
    maxwell.aux_maxR = 15 / 2
    maxwell.a_wire_r = maxwell.send_wire_r
    maxwell.Rcs_aux_x = maxwell.send_maxR
    maxwell.Rcs_aux_y = maxwell.send_maxR
    maxwell.Rcs_aux_z = 0  # 附加线圈底部z坐标高度
    maxwell.Rcs_aux_name = 'RelativeCS_aux'

    # 接收线圈参数
    maxwell.rec_N = 2
    maxwell.rec_wire_r = 0.25 / 2  # 接收线圈导线半径
    maxwell.mo_x = 0  # 设定模型初始显示位置
    maxwell.mo_y = 0
    maxwell.mo_z = 5
    maxwell.rec_maxR = 15 / 2  # 接收线圈半径
    maxwell.Rcs_rec_name = 'RelativeCS_rec'


    # 线圈阵列参数
    maxwell.Dup_num_y = 2  # 沿y方向复制的线圈数量
    maxwell.Dup_num_x = 2  # 沿x方向复制的线圈数量

    # 铁氧体参数
    maxwell.fer_coil_d = 0.25  # 铁氧体板与线圈间距
    maxwell.fer_thick = 0.5  # 铁氧体厚度
    maxwell.fer_overlong = 1   #铁氧体外沿超出线圈边界的距离

    # 计算阵列最大宽度和长度 (仅线圈范围)
    maxwell.array_max_width = maxwell.send_maxR * 2 + maxwell.dupli_dis * (maxwell.Dup_num_y - 1)

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
    handle_result(maxwell)



def main():
    # 创建项目
    maxwell = Maxwell()
    # 仿真迭代参数
    iter_param(maxwell)


if __name__ == "__main__":
    main()






