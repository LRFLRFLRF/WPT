# -*- coding: utf-8 -*-
"""
量子粒子群优化算法
"""
import numpy as np
import random
import math
import matplotlib.pyplot as plt
from maxwell_script import run
#import matlab
import matlab.engine

## 1.加载数据
def load_data(data_file):
    '''导入训练数据
    input:  data_file(string):训练数据所在文件
    output: data(mat):训练样本的特征
            label(mat):训练样本的标签
    '''
    data = []
    label = []
    f = open(data_file)
    for line in f.readlines():
        lines = line.strip().split(' ')

        # 提取得出label
        label.append(float(lines[0]))
        # 提取出特征，并将其放入到矩阵中
        index = 0
        tmp = []
        for i in range(1, len(lines)):
            li = lines[i].strip().split(":")
            if int(li[0]) - 1 == index:
                tmp.append(float(li[1]))
            else:
                while (int(li[0]) - 1 > index):
                    tmp.append(0)
                    index += 1
                tmp.append(float(li[1]))
            index += 1
        while len(tmp) < 13:
            tmp.append(0)
        data.append(tmp)
    f.close()
    return np.array(data), np.array(label).T


## 2. QPSO算法
class QPSO(object):
    def __init__(self, particle_num, particle_dim, alpha, iter_num, max_value, min_value):
        '''定义类参数
        particle_num(int):粒子群大小
        particle_dim(int):粒子维度，对应待寻优参数的个数
        alpha(float):控制系数
        iter_num(int):最大迭代次数
        max_value(float):参数的最大值
        min_value(float):参数的最小值
        '''
        self.particle_num = particle_num
        self.particle_dim = particle_dim
        self.iter_num = iter_num
        self.alpha = alpha
        self.max_value = max_value
        self.min_value = min_value

    ### 2.1 粒子群初始化
    def swarm_origin(self):
        '''初始化粒子群中的粒子位置
        input:self(object):QPSO类
        output:particle_loc(list):粒子群位置列表
        '''
        particle_loc = []
        for i in range(self.particle_num):
            tmp1 = []
            for j in range(self.particle_dim):
                a = random.random()
                tmp1.append(a * (self.max_value[j] - self.min_value[j]) + self.min_value[j])
            particle_loc.append(tmp1)

        return particle_loc

    ### 2.2 计算适应度函数数值列表
    def fitness(self, particle_loc, eng):
        '''计算适应度函数值
        input:self(object):PSO类
              particle_loc(list):粒子群位置列表
        output:fitness_value(list):适应度函数值列表
        '''
        fitness_value = []

        ### 1.适应度函数为RBF_SVM的3_fold交叉校验平均值
        for i in range(self.particle_num):
            '''
            采用ansys仿真方法  运行maxwell仿真程序  run
            '''
            # # 设定粒子参数
            # paralist = {'send_maxR': 15,
            #             'send_tw': particle_loc[i][0],
            #             'overlay': particle_loc[i][1],
            #             'send_N': particle_loc[i][2],
            #             'aux_N': particle_loc[i][3],
            #             'aux_maxR': particle_loc[i][4]}
            paralist = {'send_maxR': 15*100,
                        'send_tw': 0.27*100,
                        'overlay': 0,
                        'send_N': 1,
                        'aux_N': 1,
                        'aux_maxR': 5*100,
                        'rec_maxR': 4*100,
                        'array_num_y': 1}

            # 匝数进行取整优化 匝数必须为整数
            paralist['send_N'] = round(paralist['send_N'], 0)
            paralist['aux_N'] = round(paralist['aux_N'], 0)
            run(paralist)


            """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
            '''
            采用matlab  理论计算方法计算阵列不同位置B值
            '''
            # # 设定粒子参数
            paralist = {'send_maxR': 15,
                        'send_tw': particle_loc[i][0],
                        'overlay': particle_loc[i][1],
                        'send_N': particle_loc[i][2],
                        'aux_N': particle_loc[i][3],
                        'aux_maxR': particle_loc[i][4]}
            # 匝数进行取整优化 匝数必须为整数
            paralist['send_N'] = round(paralist['send_N'], 0)
            paralist['aux_N'] = round(paralist['aux_N'], 0)


            paralist = {'send_maxR': 15,
                        'send_tw': 0.27,
                        'overlay': 0,
                        'send_N': 1,
                        'aux_N': 1,
                        'aux_maxR': 5,
                        'rec_maxR': 4,
                        'array_num_y': 2}

            sweeplist = {'start_p': 0,
                         'end_p': 20,
                         'steps': 4,
                         'fixed_x': 15,
                         'fixed_z': 5}
            res = eng.array_fi_cal1(sweeplist, paralist)
            print(res)





            #rbf_svm = svm.SVC(kernel='rbf', C=particle_loc[i][0], gamma=particle_loc[i][1])
            #cv_scores = cross_validation.cross_val_score(rbf_svm, trainX, trainY, cv=3, scoring='accuracy')
            fitness_value.append(cv_scores.mean())

        ### 2. 当前粒子群最优适应度函数值和对应的参数
        current_fitness = 0.0
        current_parameter = []
        for i in range(self.particle_num):
            if current_fitness < fitness_value[i]:
                current_fitness = fitness_value[i]
                current_parameter = particle_loc[i]

        return fitness_value, current_fitness, current_parameter

    ### 2.3 粒子位置更新
    def updata(self, particle_loc, gbest_parameter, pbest_parameters):
        '''粒子位置更新
        input:self(object):QPSO类
              particle_loc(list):粒子群位置列表
              gbest_parameter(list):全局最优参数
              pbest_parameters(list):每个粒子的历史最优值
        output:particle_loc(list):新的粒子群位置列表
        '''
        Pbest_list = pbest_parameters
        #### 2.3.1 计算mbest
        mbest = []
        total = []
        for l in range(self.particle_dim):
            total.append(0.0)
        total = np.array(total)

        for i in range(self.particle_num):
            total += np.array(Pbest_list[i])
        for j in range(self.particle_dim):
            mbest.append(list(total)[j] / self.particle_num)

        #### 2.3.2 位置更新
        ##### Pbest_list更新
        for i in range(self.particle_num):
            a = random.uniform(0, 1)
            Pbest_list[i] = list(
                np.array([x * a for x in Pbest_list[i]]) + np.array([y * (1 - a) for y in gbest_parameter]))
        ##### particle_loc更新
        for j in range(self.particle_num):
            mbest_x = []  ## 存储mbest与粒子位置差的绝对值
            for m in range(self.particle_dim):
                mbest_x.append(abs(mbest[m] - particle_loc[j][m]))
            u = random.uniform(0, 1)
            if random.random() > 0.5:
                particle_loc[j] = list(
                    np.array(Pbest_list[j]) + np.array([self.alpha * math.log(1 / u) * x for x in mbest_x]))
            else:
                particle_loc[j] = list(
                    np.array(Pbest_list[j]) - np.array([self.alpha * math.log(1 / u) * x for x in mbest_x]))

        #### 2.3.3 将更新后的量子位置参数固定在[min_value,max_value]内
        ### 每个参数的取值列表
        parameter_list = []
        for i in range(self.particle_dim):
            tmp1 = []
            for j in range(self.particle_num):
                tmp1.append(particle_loc[j][i])
            parameter_list.append(tmp1)
        ### 每个参数取值的最大值、最小值、平均值
        value = []
        for i in range(self.particle_dim):
            tmp2 = []
            tmp2.append(max(parameter_list[i]))
            tmp2.append(min(parameter_list[i]))
            value.append(tmp2)

        for i in range(self.particle_num):
            for j in range(self.particle_dim):
                particle_loc[i][j] = (particle_loc[i][j] - value[j][1]) / (value[j][0] - value[j][1]) * (
                            self.max_value[j] - self.min_value[j]) + self.min_value[j]

        return particle_loc

    ## 2.4 画出适应度函数值变化图
    def plot(self, results):
        '''画图
        '''
        X = []
        Y = []
        for i in range(self.iter_num):
            X.append(i + 1)
            Y.append(results[i])
        plt.plot(X, Y)
        plt.xlabel('Number of iteration', size=15)
        plt.ylabel('Value of CV', size=15)
        plt.title('QPSO_RBF_SVM parameter optimization')
        plt.show()

    ## 2.5 主函数
    def main(self, eng):
        results = []
        best_fitness = 0.0
        ## 1、粒子群初始化
        particle_loc = self.swarm_origin()
        ## 2、初始化gbest_parameter、pbest_parameters、fitness_value列表
        ### 2.1 gbest_parameter
        gbest_parameter = []
        for i in range(self.particle_dim):
            gbest_parameter.append(0.0)
        ### 2.2 pbest_parameters
        pbest_parameters = []
        for i in range(self.particle_num):
            tmp1 = []
            for j in range(self.particle_dim):
                tmp1.append(0.0)
            pbest_parameters.append(tmp1)
        ### 2.3 fitness_value
        fitness_value = []
        for i in range(self.particle_num):
            fitness_value.append(0.0)

        ## 3、迭代
        for i in range(self.iter_num):
            ### 3.1 计算当前适应度函数值列表
            current_fitness_value, current_best_fitness, current_best_parameter = self.fitness(particle_loc, eng)
            ### 3.2 求当前的gbest_parameter、pbest_parameters和best_fitness
            for j in range(self.particle_num):
                if current_fitness_value[j] > fitness_value[j]:
                    pbest_parameters[j] = particle_loc[j]
            if current_best_fitness > best_fitness:
                best_fitness = current_best_fitness
                gbest_parameter = current_best_parameter

            print('iteration is :', i + 1, ';Best parameters:', gbest_parameter, ';Best fitness', best_fitness)
            results.append(best_fitness)
            ### 3.3 更新fitness_value
            fitness_value = current_fitness_value
            ### 3.4 更新粒子群
            particle_loc = self.updata(particle_loc, gbest_parameter, pbest_parameters)
        ## 4.结果展示
        results.sort()
        self.plot(results)
        print('Final parameters are :', gbest_parameter)


if __name__ == '__main__':
    # 启动matlab引擎
    eng = matlab.engine.start_matlab()

    print('----------------1.Load Data-------------------')
    #trainX, trainY = load_data('rbf_data')
    print('----------------2.Parameter Seting------------')
    particle_num = 10
    particle_dim = 5
    iter_num = 10
    alpha = 0.6
    max_value = [3, 5, 7, 5, 5]
    min_value = [0.001, 0, 1, 1, 1]
    print('----------------3.PSO_RBF_SVM-----------------')
    qpso = QPSO(particle_num, particle_dim, alpha, iter_num, max_value, min_value)
    qpso.main(eng)

    # 关闭matlab引擎
    eng.exit()



















