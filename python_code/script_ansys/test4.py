# ----------------------------------------------
# Script Recorded by ANSYS Electronics Desktop Version 2018.0.0
# 19:16:36  12月 09, 2021
# ----------------------------------------------
import ScriptEnv
ScriptEnv.Initialize("Ansoft.ElectronicsDesktop")
oDesktop.RestoreWindow()
oProject = oDesktop.SetActiveProject("coil_array")
oDesign = oProject.SetActiveDesign("test")
oModule = oDesign.GetModule("MaxwellParameterSetup")
oModule.AssignMatrix(
	[
		"NAME:Matrix1",
		[
			"NAME:MatrixEntry",
			[
				"NAME:MatrixEntry",
				"Source:="		, "rec1_p",
				"NumberOfTurns:="	, "1"
			],
			[
				"NAME:MatrixEntry",
				"Source:="		, "send11_p",
				"NumberOfTurns:="	, "1"
			],
			[
				"NAME:MatrixEntry",
				"Source:="		, "send12_p",
				"NumberOfTurns:="	, "1"
			],
			[
				"NAME:MatrixEntry",
				"Source:="		, "send13_p",
				"NumberOfTurns:="	, "1"
			],
			[
				"NAME:MatrixEntry",
				"Source:="		, "send14_p",
				"NumberOfTurns:="	, "1"
			]
		],
		[
			"NAME:MatrixGroup",
			[
				"NAME:MatrixGroup",
				"GroupName:="		, "Group1",
				"NumberOfBranches:="	, "1",
				"Sources:="		, "send11_p,send12_p,send13_p,send14_p"
			]
		]
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
oModule = oDesign.GetModule("Optimetrics")
oModule.InsertSetup("OptiParametric", 
	[
		"NAME:ParametricSetup1",
		"IsEnabled:="		, True,
		[
			"NAME:ProdOptiSetupDataV2",
			"SaveFields:="		, False,
			"CopyMesh:="		, False,
			"SolveWithCopiedMeshOnly:=", True
		],
		[
			"NAME:StartingPoint"
		],
		"Sim. Setups:="		, ["Setup1"],
		[
			"NAME:Sweeps",
			[
				"NAME:SweepDefinition",
				"Variable:="		, "mo",
				"Data:="		, "LIN 0 100 5",
				"OffsetF1:="		, False,
				"Synchronize:="		, 0
			]
		],
		[
			"NAME:Sweep Operations"
		],
		[
			"NAME:Goals"
		]
	])
