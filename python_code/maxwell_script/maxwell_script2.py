from func_lib_ansys2 import Maxwell
from create_maxwell_model2 import build_model_param, build_model, ansys_setup, handle_result
import numpy as np

# 结果保存路径参数
csv_save_path = "E:/Desktop/WPT/python_code/data/"

def iter_param(maxwell):
    ################################################################ 下面这些变量不需要迭代
    # 加载设计的全局变量
    maxwell.zu_width = 30
    maxwell.rec_N = 1  # 接收线圈匝数
    maxwell.aux_N = 0

    maxwell.tw = 0.27  # 匝间距

    # 电流加载参数
    maxwell.I_send = 1
    maxwell.I_rec = 0

    maxwell.sweep_step_len = 2  # mo的扫描步长

    # 发射线圈参数
    maxwell.send_wire_r = 0.25 / 2  # 发射线圈导线半径
    maxwell.Rcs_send_x = maxwell.zu_width / 2
    maxwell.Rcs_send_y = maxwell.zu_width / 2
    maxwell.Rcs_send_z = 0  # 发射线圈底部z坐标高度
    maxwell.Rcs_send_name = 'RelativeCS_send'

    # 辅助线圈参数
    maxwell.a_wire_r = 0.25 / 2
    maxwell.Rcs_aux_x = maxwell.zu_width
    maxwell.Rcs_aux_y = maxwell.zu_width
    maxwell.Rcs_aux_z = maxwell.a_wire_r * 2 + 0.1  # 附加线圈底部z坐标高度
    maxwell.Rcs_aux_name = 'RelativeCS_aux'

    # 接收线圈参数     这些参数应该固定
    maxwell.rec_wire_r = 0.25 / 2  # 接收线圈导线半径
    maxwell.h = 5
    maxwell.rr = 7.5  # 接收线圈半径
    maxwell.Rcs_rec_name = 'RelativeCS_rec'
    maxwell.mo_x = maxwell.zu_width/2
    maxwell.mo_y = maxwell.zu_width/2

    # 线圈阵列参数
    maxwell.Dup_num_y = 3  # 沿y方向复制的线圈数量
    maxwell.Dup_num_x = 3  # 沿x方向复制的线圈数量
    # 铁氧体参数
    maxwell.fer_coil_d = 0.25  # 铁氧体板与线圈间距
    maxwell.fer_thick = 0.5  # 铁氧体厚度

    ################################################################ 下面这些变量需要迭代
    # 发射线圈 辅助线圈匝数
    send_n_lim = [1, 2, 1]
    aux_n_lim = [1, 20, 1]
    send_n_sweep_list = np.arange(send_n_lim[0], send_n_lim[1], send_n_lim[2])
    aux_n_sweep_list = np.arange(aux_n_lim[0], aux_n_lim[1], aux_n_lim[2])

    # 发射线圈半径
    rs_lim = [5, maxwell.zu_width / 2 - 5, 5]
    rs_sweep_list = np.arange(rs_lim[0], rs_lim[1], rs_lim[2])
    # 辅助线圈半径
    ra_lim = [5, maxwell.zu_width / 2 - 5, 5]
    ra_sweep_list = np.arange(ra_lim[0], ra_lim[1], ra_lim[2])

    for n in send_n_sweep_list:
        maxwell.send_N = n
        for r in rs_sweep_list:
            rs_list_temp = []
            for i in range(n):
                # 生成发射线圈各匝半径列表
                rs_list_temp.append(r - i * maxwell.tw)

            # 加载当前迭代下的maxwell模型参数
            build_model_param(maxwell, rs_list_temp, [0], [maxwell.rr])
            # 根据加载的参数创建对应几何模型
            build_model(maxwell)
            # 设置maxwell仿真参数
            ansys_setup(maxwell)
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
