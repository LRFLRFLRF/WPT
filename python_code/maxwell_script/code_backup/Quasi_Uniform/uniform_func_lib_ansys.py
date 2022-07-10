from win32com import client


class coil_type:
    def __init__(self):
        self.coil = {}
        self.coil_array = {}

    # 创建一匝线圈
    def create_single_turn(self, maxwell, turn_param):
        # 建立相对坐标系  用于相交线圈 找到电流加载界面
        # 选定坐标系
        maxwell.rcs.SetWCS_maxwell(maxwell, turn_param['rcs_name'])

        # 加载坐标系参数
        rcs_x = maxwell.rcs.rcs_list[turn_param['rcs_name']]['rcs_x']
        rcs_y = maxwell.rcs.rcs_list[turn_param['rcs_name']]['rcs_y']
        rcs_z = maxwell.rcs.rcs_list[turn_param['rcs_name']]['rcs_z']

        # 加载线圈参数
        turn_r = turn_param['r']
        turn_tw = turn_param['tw']
        turn_name = turn_param['turn_name']
        turn_name_p = turn_param['turn_name_p']

        # 创建线圈的外圈立方体
        maxwell.createBox_maxwell(str(- turn_r) + " cm",
                                  str(- turn_r) + " cm",
                                  str(rcs_z) + " cm",
                                  str(2 * turn_r) + " cm",
                                  str(2 * turn_r) + " cm",
                                  str(turn_tw) + " cm",
                                  turn_name,
                                  'copper')

        # 创建线圈的内圈立方体  _cut
        maxwell.createBox_maxwell(str(- turn_r + turn_tw) + " cm",
                                  str(- turn_r + turn_tw) + " cm",
                                  str(rcs_z) + " cm",
                                  str(2 * (turn_r - turn_tw)) + " cm",
                                  str(2 * (turn_r - turn_tw)) + " cm",
                                  str(turn_tw) + " cm",
                                  turn_name + "_cut",
                                  'copper')

        # 用subtract剪切两个立方体   得到线圈
        maxwell.Subtract_maxwell(turn_name,
                                 turn_name + "_cut")

        # 用RelativeCS与线圈section  找到电流加载界面
        maxwell.section_maxwell(turn_name)

        # SeparateBody 并只保留一个电流加载面  并修改面名为coil_p
        maxwell.SeparateBody_maxwell(turn_name + "_Section1")

        # 删除一个SeparateBody后多出来的面
        maxwell.Delete_maxwell(turn_name + "_Section1_Separate1")

        # 给剩下的加载面改名
        maxwell.rename_maxwell(turn_name + "_Section1",
                               turn_name_p)

    # 创建一个线圈，包括多匝
    def create_single_coil(self, maxwell, coil_param):
        # 保存该线圈参数
        turn_name_list = []
        turn_namep_list = []
        for i in range(coil_param['N']):
            turn_name_list.append(coil_param['coil_id'] + '_turn' + str(i + 1))
            turn_namep_list.append(coil_param['coil_id'] + '_turn' + str(i + 1) + '_p')

        single_coil_param = {'coil_id': coil_param['coil_id'],
                             'rcs_name': coil_param['rcs_name'],
                             'r': coil_param['r'],
                             'tw': coil_param['tw'],
                             'ts': coil_param['ts'],
                             'turn_name_in_coil': turn_name_list,
                             'turn_name_p_in_coil': turn_namep_list,
                             'N': coil_param['N']}
        self.coil[coil_param['coil_id']] = single_coil_param

        # 创建该线圈
        for i in range(coil_param['N']):
            turn_param = {'rcs_name': coil_param['rcs_name'],
                          'r': coil_param['r'] - i * single_coil_param['ts'],
                          'tw': coil_param['tw'],
                          'turn_name': turn_name_list[i],
                          'turn_name_p': turn_namep_list[i]}
            self.create_single_turn(maxwell, turn_param)

    def select_ob(self, maxwell, param):
        coil_ob = param['id']  # 线圈的id
        p_or_not_p = param['ob']  # 是线圈名称 还是加载面  可以是turn_name_in_coil或turn_name_p_in_coil

        temp = ''
        for j in p_or_not_p:
            for i in maxwell.coil.coil[coil_ob][j]:
                temp = temp + i + ','
        return temp

    def creat_coil(self, maxwell, coil_array_param):
        # 保存阵列参数
        single_coil_array_param = {'coil_array_id': coil_array_param['coil_array_id'],
                                   'rcs_name': coil_array_param['rcs_name'],
                                   'dup_x': coil_array_param['dup_x'],
                                   'dup_y': coil_array_param['dup_y'],
                                   'dup_dx': coil_array_param['dup_dx'],
                                   'dup_dy': coil_array_param['dup_dy']}
        self.coil_array[coil_array_param['coil_array_id']] = single_coil_array_param

        # 首先创建一个基础线圈
        # 创建coil_array 的名称列表
        coil_name_list = []
        for j in range(coil_array_param['dup_x']):
            temp = []
            for i in range(coil_array_param['dup_y']):
                temp.append(coil_array_param['coil_array_id'] + str(j+1) + str(i+1))
            coil_name_list.append(temp)

        coil_param = {'coil_id': coil_array_param['coil_array_id'] + '11',
                      'rcs_name': coil_array_param['rcs_name'],
                      'r': coil_array_param['r'],
                      'tw': coil_array_param['tw'],
                      'ts': coil_array_param['ts'],
                      'N': coil_array_param['N'],
                      'array_name_in_coil': coil_name_list}
        self.create_single_coil(maxwell, coil_param)

        # 阵列复制该线圈
        # 阵列参数
        dup_x = coil_array_param['dup_x']
        dup_y = coil_array_param['dup_y']
        dup_dx = coil_array_param['dup_dx']
        dup_dy = coil_array_param['dup_dy']

        if dup_y != 1:
            # 选定坐标系
            print(coil_array_param['rcs_name'])
            maxwell.rcs.SetWCS_maxwell(maxwell, coil_array_param['rcs_name'])
            # 沿Y轴复制
            # 选中首个线圈和加载面
            select_parma = {'id': coil_param['coil_id'],
                            'ob': ['turn_name_in_coil', 'turn_name_p_in_coil']}
            temp = self.select_ob(maxwell, select_parma)
            maxwell.DuplicateAlongLine_maxwell("0mm",
                                               str(dup_dy) + "cm",
                                               "0mm",
                                               str(dup_y),
                                               temp)

            # 修改沿y轴复制的线圈和负载面的名字
            for i in range(dup_y - 1):

                old_name = maxwell.coil[coil_param['coil_id']]['turn_name_in_coil'][i] + '_1'
                coil_id = maxwell.coil_array[coil_array_param['coil_array_id']]['array_name_in_coil'][0][1]
                new_name = coil_id +
                maxwell.rename_maxwell()
                maxwell.rename_maxwell(coil_p[0] + "_" + str(i + 1), coil_p[i + 1])


class rcs_type:
    def __init__(self):
        self.rcs_list = {}

    def create_rcs(self, maxwell, param):
        self.rcs_list[param['rcs_name']] = param
        self.CreateRelativeCS_maxwell(maxwell,
                                      param['rcs_x'],
                                      param['rcs_y'],
                                      param['rcs_z'],
                                      param['rcs_name'])

    def CreateRelativeCS_maxwell(self, maxwell, OX, OY, OZ, name):
        maxwell.oEditor.CreateRelativeCS(
            [
                "NAME:RelativeCSParameters",
                "Mode:=", "Axis/Position",
                "OriginX:=", str(OX) + " cm",
                "OriginY:=", str(OY) + " cm",
                "OriginZ:=", str(OZ) + " cm",
                "XAxisXvec:=", "1mm",
                "XAxisYvec:=", "0mm",
                "XAxisZvec:=", "0mm",
                "YAxisXvec:=", "0mm",
                "YAxisYvec:=", "1mm",
                "YAxisZvec:=", "0mm"
            ],
            [
                "NAME:Attributes",
                "Name:=", name
            ])

    def SetWCS_maxwell(self, maxwell, wcs):
        maxwell.oEditor.SetWCS(
            [
                "NAME:SetWCS Parameter",
                "Working Coordinate System:=", wcs,
                "RegionDepCSOk:=", False
            ])


class Maxwell:
    def __init__(self, ):
        self.rcs = rcs_type()
        self.coil = coil_type()

        oAnsoftApp = client.Dispatch("Ansoft.ElectronicsDesktop")
        oDesktop = oAnsoftApp.getAppDesktop()
        oDesktop.RestoreWindow()
        oProject = oDesktop.SetActiveProject("coil_array")

        # 获取工程内设计 列表
        flag = 0
        name_list = oProject.GetTopDesignList()
        for i in name_list:
            if i == 'test':
                flag = 1

        if flag == 1:
            oProject.DeleteDesign("test")
            oProject.Save()

        oProject.InsertDesign("Maxwell 3D", "test", "Magnetostatic", "")
        self.oDesign = oProject.SetActiveDesign("test")
        self.oEditor = self.oDesign.SetActiveEditor("3D Modeler")
        self.BoundaryoModule = self.oDesign.GetModule("BoundarySetup")
        self.AnalysisoModule = self.oDesign.GetModule("AnalysisSetup")
        self.ParameteroModule = self.oDesign.GetModule("MaxwellParameterSetup")
        self.OptiParaoModule = self.oDesign.GetModule("Optimetrics")
        self.ReportoModule = self.oDesign.GetModule("ReportSetup")

        self.zu_width = 0
        self.rec_N = 0
        self.aux_N = 0
        self.send_N = 0
        self.I_send = 0
        self.I_rec = 0
        self.dup_x = 0
        self.dup_y = 0
        self.dup_dx = 0
        self.dup_dy = 0

    def createBox_maxwell(self, XP, YP, ZP, XS, YS, ZS, name, mater):
        if mater == 'vacuum':
            Transparency = 1
        else:
            Transparency = 0
        self.oEditor.CreateBox(
            [
                "NAME:BoxParameters",
                "XPosition:=", XP,
                "YPosition:=", YP,
                "ZPosition:=", ZP,
                "XSize:=", XS,
                "YSize:=", YS,
                "ZSize:=", ZS
            ],
            [
                "NAME:Attributes",
                "Name:=", name,
                "Flags:=", "",
                "Color:=", "(143 175 143)",
                "Transparency:=", Transparency,
                "PartCoordinateSystem:=", "Global",
                "UDMId:=", "",
                "MaterialValue:=", "\"" + mater + "\"",
                "SurfaceMaterialValue:=", "\"\"",
                "SolveInside:=", True,
                "IsMaterialEditable:=", True,
                "UseMaterialAppearance:=", False
            ])

    def Subtract_maxwell(self, ob, ob_tool):
        self.oEditor.Subtract(
            [
                "NAME:Selections",
                "Blank Parts:=", ob,
                "Tool Parts:=", ob_tool
            ],
            [
                "NAME:SubtractParameters",
                "KeepOriginals:=", False
            ])

    def section_maxwell(self, ob):
        self.oEditor.Section(
            [
                "NAME:Selections",
                "Selections:=", ob,
                "NewPartsModelFlag:=", "Model"
            ],
            [
                "NAME:SectionToParameters",
                "CreateNewObjects:=", True,
                "SectionPlane:=", "ZX",
                "SectionCrossObject:=", False
            ])

    def SeparateBody_maxwell(self, ob):
        self.oEditor.SeparateBody(
            [
                "NAME:Selections",
                "Selections:=", ob,
                "NewPartsModelFlag:=", "Model"
            ],
            [
                "CreateGroupsForNewObjects:=", False
            ])

    def Delete_maxwell(self, ob):
        self.oEditor.Delete(
            [
                "NAME:Selections",
                "Selections:=", ob
            ])

    def rename_maxwell(self, odd_name, new_name):
        self.oEditor.ChangeProperty(
            [
                "NAME:AllTabs",
                [
                    "NAME:Geometry3DAttributeTab",
                    [
                        "NAME:PropServers",
                        odd_name
                    ],
                    [
                        "NAME:ChangedProps",
                        [
                            "NAME:Name",
                            "Value:=", new_name
                        ]
                    ]
                ]
            ])

    def DuplicateAlongLine_maxwell(self, XC, YC, ZC, num, ob):
        self.oEditor.DuplicateAlongLine(
            [
                "NAME:Selections",
                "Selections:=", ob,
                "NewPartsModelFlag:=", "Model"
            ],
            [
                "NAME:DuplicateToAlongLineParameters",
                "CreateNewObjects:=", True,
                "XComponent:=", XC,
                "YComponent:=", YC,
                "ZComponent:=", ZC,
                "NumClones:=", num
            ],
            [
                "NAME:Options",
                "DuplicateAssignments:=", False
            ],
            [
                "CreateGroupsForNewObjects:=", False
            ])


