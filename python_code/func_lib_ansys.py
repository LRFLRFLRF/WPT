from win32com import client


class Maxwell:
    def __init__(self, ):
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

    def AnalyzeAll_maxwell(self):
        self.oDesign.AnalyzeAll()

    def CreateReport_maxwell(self, type, sweep_var, XC, YC, plot_name):
        self.ReportoModule.CreateReport(plot_name, "Magnetostatic", type, "Setup1 : LastAdaptive", [],
                                        [
                                            sweep_var + ":=", ["All"]
                                        ],
                                        [
                                            "X Component:=", XC,
                                            "Y Component:=", [YC]
                                        ], [])

    def ExportToFile_maxwell(self, plot_name, dir):
        self.ReportoModule.ExportToFile(plot_name, dir)

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

    def AssignMatrix_maxwell(self, ob_list, NumberOfTurns_list, group_list):
        Matrix = []
        Matrix.append("NAME:MatrixEntry")
        for i in range(len(ob_list)):
            Matrix.append(["NAME:MatrixEntry",
                           "Source:=",
                           ob_list[i],
                           "NumberOfTurns:=",
                           str(NumberOfTurns_list[i])])

        Group = []
        Group.append("NAME:MatrixGroup")
        for i in range(len(group_list)):
            name_str = ''
            for j in range(len(group_list[i])):
                name_str = name_str + group_list[i][j]
                if j != len(group_list[i]) - 1:
                    name_str = name_str + ","

            Group.append(["NAME:MatrixGroup",
                          "GroupName:=",
                          "Group" + str(i + 1),
                          "NumberOfBranches:=",
                          "1",
                          "Sources:=",
                          name_str])

        self.ParameteroModule.AssignMatrix(
            [
                "NAME:Matrix1",
                [
                    Matrix
                ],
                [
                    Group
                ]
            ])

    def OptiParametricSetup_maxwell(self):
        self.OptiParaoModule.InsertSetup("OptiParametric",
                                         [
                                             "NAME:ParametricSetup1",
                                             "IsEnabled:=", True,
                                             [
                                                 "NAME:ProdOptiSetupDataV2",
                                                 "SaveFields:=", False,
                                                 "CopyMesh:=", False,
                                                 "SolveWithCopiedMeshOnly:=", True
                                             ],
                                             [
                                                 "NAME:StartingPoint"
                                             ],
                                             "Sim. Setups:=", ["Setup1"],
                                             [
                                                 "NAME:Sweeps"
                                             ],
                                             [
                                                 "NAME:Sweep Operations"
                                             ],
                                             [
                                                 "NAME:Goals"
                                             ]
                                         ])

    def EditSetup_maxwell(self, sweep_list, sweep_set):
        sweep = []
        sweep.append("NAME:Sweeps")
        for i in range(len(sweep_list)):
            sweep.append(["NAME:SweepDefinition",
                          "Variable:=",
                          sweep_list[i],
                          "Data:=",
                          "LIN " + str(sweep_set[i][0]) + ' ' + str(sweep_set[i][1]) + ' ' + str(sweep_set[i][2]),
                          "OffsetF1:=",
                          False,
                          "Synchronize:=",
                          0])

        self.OptiParaoModule.EditSetup("ParametricSetup1",
                                       [
                                           "NAME:ParametricSetup1",
                                           "IsEnabled:=", True,
                                           [
                                               "NAME:ProdOptiSetupDataV2",
                                               "SaveFields:="	, False,
                                               "CopyMesh:="		, False,
                                               "SolveWithCopiedMeshOnly:=", True
                                           ],
                                           [
                                               "NAME:StartingPoint"
                                           ],
                                           "Sim. Setups:="		, ["Setup1"],
                                           [
                                               sweep
                                           ],
                                           [
                                               "NAME:Sweep Operations"
                                           ],
                                           [
                                               "NAME:Goals"
                                           ]
                                       ])

    def assignCurrent_maxwell(self, ob_name, I_set, direction):
        self.BoundaryoModule.AssignCurrent(
            [
                "NAME: " + ob_name,
                "Objects:=", [ob_name],
                "Current:=", str(I_set) + "A",
                "IsSolid:=", True,
                "Point out of terminal:=", direction
            ])

    def AnalysisSetup_maxwell(self):
        self.AnalysisoModule.InsertSetup("Magnetostatic",
                                         [
                                             "NAME:Setup1",
                                             "Enabled:=", True,
                                             "MaximumPasses:=", 10,
                                             "MinimumPasses:=", 2,
                                             "MinimumConvergedPasses:=", 1,
                                             "PercentRefinement:=", 30,
                                             "SolveFieldOnly:=", False,
                                             "PercentError:=", 1,
                                             "SolveMatrixAtLast:=", True,
                                             "PercentError:=", 1,
                                             "UseIterativeSolver:=", False,
                                             "RelativeResidual:=", 1E-006,
                                             "NonLinearResidual:=", 0.001,
                                             [
                                                 "NAME:MuOption",
                                                 "MuNonLinearBH:=", True
                                             ]
                                         ])

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

    def Move_maxwell(self, TX, TY, TZ, ob):
        self.oEditor.Move(
            [
                "NAME:Selections",
                "Selections:="	, ob,
                "NewPartsModelFlag:="	, "Model"
            ],
            [
                "NAME:TranslateParameters",
                "TranslateVectorX:="	, TX,
                "TranslateVectorY:="	, TY,
                "TranslateVectorZ:="	, TZ
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

    def CreateRelativeCS_maxwell(self, OX, OY, OZ, name):
        self.oEditor.CreateRelativeCS(
            [
                "NAME:RelativeCSParameters",
                "Mode:=", "Axis/Position",
                "OriginX:=", OX,
                "OriginY:=", OY,
                "OriginZ:=", OZ,
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

    def SetWCS_maxwell(self, wcs):
        self.oEditor.SetWCS(
            [
                "NAME:SetWCS Parameter",
                "Working Coordinate System:=", wcs,
                "RegionDepCSOk:=", False
            ])

    def ChangeProperty_maxwell(self, tab_type, ob, oprate):
        oprate_commend = []
        oprate_commend.append("NAME: " +oprate[0])
        # 创建工程变量
        if oprate[0] == 'NewProps' and ob == 'LocalVariables':
            for i in oprate[1]:
                oprate_commend.append(["NAME: " + i[0],
                                       "PropType:=",
                                       "VariableProp",
                                       "UserDef:=",
                                       True,
                                       "Value:=",
                                       i[1]])

        # 修改工程变量
        if oprate[0] == 'ChangedProps' and ob == 'LocalVariables':
            for i in oprate[1]:
                oprate_commend.append(["NAME: " + i[0],
                                       i[1],
                                       i[2]])

        self.oDesign.ChangeProperty(
            [
                "NAME:AllTabs",
                [
                    "NAME: " + tab_type,
                    [
                        "NAME:PropServers",
                        ob
                    ],
                    [
                        oprate_commend
                    ]
                ]
            ])

    # 删除plot
    def DeleteReports_maxwell(self, plot_name):
        self.ReportoModule.DeleteReports(plot_name)


    def Duplicate_coil(self, zu_width, Dup_num_y, Dup_num_x, coil, coil_p):
        ########################### 沿Y轴复制线圈和加载面
        # 选定坐标系
        self.SetWCS_maxwell("Global")

        # 沿Y轴复制
        self.DuplicateAlongLine_maxwell("0mm",
                                           str(zu_width) + "cm",
                                           "0mm",
                                           str(Dup_num_y),
                                           coil[0] + "," + coil_p[0])

        # 修改沿y轴复制的线圈和负载面的名字
        for i in range(Dup_num_y - 1):
            self.rename_maxwell(coil[0] + "_" + str(i + 1), coil[i + 1])
            self.rename_maxwell(coil_p[0] + "_" + str(i + 1), coil_p[i + 1])

        # 沿x轴复制
        ob = ''
        for i in range(Dup_num_y):
            ob = ob + coil[i] + ',' + coil_p[i] + ','  # 选中一排线圈和加载面进行x方向复制

        self.DuplicateAlongLine_maxwell(str(zu_width) + "cm",
                                           "0mm",
                                           "0mm",
                                           str(Dup_num_x),
                                           ob)

        # 修改沿x轴复制的线圈和负载面的名字
        for j in range(Dup_num_y):
            temp = coil[j]
            temp1 = coil_p[j]
            for i in range(Dup_num_x - 1):
                self.rename_maxwell(temp + "_" + str(i + 1), coil[Dup_num_y * (i + 1) + j])
                self.rename_maxwell(temp1 + "_" + str(i + 1), coil_p[Dup_num_y * (i + 1) + j])

    def creat_coil_array(self, coil, coil_p, wire_r, coil_r, p_x, p_y, p_z, RelativeCS_name):
        ################################创建初始线圈 以及加载面
        # 选定坐标系
        self.SetWCS_maxwell("Global")

        # 建立相对坐标系  用于相交线圈 找到电流加载界面
        self.CreateRelativeCS_maxwell(str(p_x) + " cm",
                                      str(p_y) + " cm",
                                      "0mm",
                                      RelativeCS_name)

        # 选定坐标系
        self.SetWCS_maxwell(RelativeCS_name)

        # 创建线圈的外圈立方体
        self.createBox_maxwell(str(- coil_r - wire_r) + " cm",
                               str(- coil_r - wire_r) + " cm",
                               str(p_z) + " cm",
                               str(2 * coil_r + wire_r * 2) + " cm",
                               str(2 * coil_r + wire_r * 2) + " cm",
                               str(2 * wire_r) + " cm",
                               coil[0],
                               'copper')

        # 创建线圈的内圈立方体  _cut
        self.createBox_maxwell(str(- coil_r + wire_r) + " cm",
                               str(- coil_r + wire_r) + " cm",
                               str(p_z) + " cm",
                               str(2 * coil_r - wire_r * 2) + " cm",
                               str(2 * coil_r - wire_r * 2) + " cm",
                               str(2 * wire_r) + " cm",
                               coil[0] + "_cut",
                               'copper')

        # 用subtract剪切两个立方体   得到线圈
        self.Subtract_maxwell(coil[0],
                              coil[0] + "_cut")

        # 用RelativeCS与线圈section  找到电流加载界面
        self.section_maxwell(coil[0])

        # SeparateBody 并只保留一个电流加载面  并修改面名为coil_p
        self.SeparateBody_maxwell(coil[0] + "_Section1")

        # 删除一个SeparateBody后多出来的面
        self.Delete_maxwell(coil[0] + "_Section1_Separate1")

        # 给剩下的加载面改名
        self.rename_maxwell(coil[0] + "_Section1",
                            coil_p[0])
