# ----------------------------------------------
# Script Recorded by ANSYS Electronics Desktop Version 2018.0.0
# 15:17:29  12月 09, 2021
# ----------------------------------------------
import ScriptEnv
ScriptEnv.Initialize("Ansoft.ElectronicsDesktop")
oDesktop.RestoreWindow()
oProject = oDesktop.SetActiveProject("coil_array")
oDesign = oProject.SetActiveDesign("test")
oEditor = oDesign.SetActiveEditor("3D Modeler")
oEditor.DuplicateAlongLine(
	[
		"NAME:Selections",
		"Selections:="		, "send11_p,send11",
		"NewPartsModelFlag:="	, "Model"
	], 
	[
		"NAME:DuplicateToAlongLineParameters",
		"CreateNewObjects:="	, True,
		"XComponent:="		, "0mm",
		"YComponent:="		, "750mm",
		"ZComponent:="		, "0mm",
		"NumClones:="		, "4"
	], 
	[
		"NAME:Options",
		"DuplicateAssignments:=", False
	], 
	[
		"CreateGroupsForNewObjects:=", False
	])
oModule = oDesign.GetModule("BoundarySetup")
oModule.AssignCurrent(
	[
		"NAME:Current1",
		"Objects:="		, ["send11_p_1"],
		"Current:="		, "0mA",
		"IsSolid:="		, True,
		"Point out of terminal:=", False
	])
oModule.AssignCurrent(
	[
		"NAME:Current2",
		"Objects:="		, ["send11_p_2"],
		"Current:="		, "0mA",
		"IsSolid:="		, True,
		"Point out of terminal:=", False
	])
oModule = oDesign.GetModule("AnalysisSetup")
oModule.InsertSetup("Magnetostatic", 
	[
		"NAME:Setup1",
		"Enabled:="		, True,
		"MaximumPasses:="	, 10,
		"MinimumPasses:="	, 2,
		"MinimumConvergedPasses:=", 1,
		"PercentRefinement:="	, 30,
		"SolveFieldOnly:="	, False,
		"PercentError:="	, 1,
		"SolveMatrixAtLast:="	, True,
		"PercentError:="	, 1,
		"UseIterativeSolver:="	, False,
		"RelativeResidual:="	, 1E-006,
		"NonLinearResidual:="	, 0.001,
		[
			"NAME:MuOption",
			"MuNonLinearBH:="	, True
		]
	])
