from win32com import client


class Maxwell:
    def __init__(self, ):
        oAnsoftApp = client.Dispatch("Ansoft.ElectronicsDesktop")
        oDesktop = oAnsoftApp.getAppDesktop()
        oDesktop.RestoreWindow()
        oProject = oDesktop.SetActiveProject("coil_array")
        oProject.InsertDesign("Maxwell 3D", "test", "Magnetostatic", "")
        self.oDesign = oProject.SetActiveDesign("test")
        self.oEditor = self.oDesign.SetActiveEditor("3D Modeler")

        self.BoundaryoModule = self.oDesign.GetModule("BoundarySetup")
        self.AnalysisoModule = self.oDesign.GetModule("AnalysisSetup")
        self.ParameteroModule = self.oDesign.GetModule("MaxwellParameterSetup")

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
                if j != len(group_list[i])-1:
                    name_str = name_str + ","

            Group.append(["NAME:MatrixGroup",
                          "GroupName:=",
                          "Group"+str(i+1),
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

    def assignCurrent_maxwell(self, ob_name, I_set, direction):
        self.BoundaryoModule.AssignCurrent(
            [
                "NAME: " + ob_name,
                "Objects:=", [ob_name],
                "Current:=", str(I_set) + "A",
                "IsSolid:=", True,
                "Point out of terminal:=", direction
            ])

    def InsertSetup_maxwell(self):
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

    def createBox_maxwell(self, XP, YP, ZP, XS, YS, ZS, name):
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
                "Transparency:=", 0,
                "PartCoordinateSystem:=", "Global",
                "UDMId:=", "",
                "MaterialValue:=", "\"copper\"",
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
