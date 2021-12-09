# ----------------------------------------------
# Script Recorded by ANSYS Electronics Desktop Version 2018.0.0
# 15:09:00  12月 09, 2021
# ----------------------------------------------
import ScriptEnv
ScriptEnv.Initialize("Ansoft.ElectronicsDesktop")
oDesktop.RestoreWindow()
oProject = oDesktop.SetActiveProject("coil_array")
oDesign = oProject.SetActiveDesign("test")
oEditor = oDesign.SetActiveEditor("3D Modeler")
oEditor.ChangeProperty(
	[
		"NAME:AllTabs",
		[
			"NAME:Geometry3DAttributeTab",
			[
				"NAME:PropServers", 
				"send11_Section1"
			],
			[
				"NAME:ChangedProps",
				[
					"NAME:Name",
					"Value:="		, "send11_p"
				]
			]
		]
	])
oModule = oDesign.GetModule("BoundarySetup")
oModule.AssignCurrent(
	[
		"NAME:send11",
		"Objects:="		, ["send11_p"],
		"Current:="		, "1A",
		"IsSolid:="		, True,
		"Point out of terminal:=", True
	])
