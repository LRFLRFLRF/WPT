# ----------------------------------------------
# Script Recorded by ANSYS Electronics Desktop Version 2018.0.0
# 14:49:12  12月 09, 2021
# ----------------------------------------------
import ScriptEnv
ScriptEnv.Initialize("Ansoft.ElectronicsDesktop")
oDesktop.RestoreWindow()
oProject = oDesktop.SetActiveProject("coil_array")
oDesign = oProject.SetActiveDesign("test")
oEditor = oDesign.SetActiveEditor("3D Modeler")
oEditor.Subtract(
	[
		"NAME:Selections",
		"Blank Parts:="		, "send1",
		"Tool Parts:="		, "send1_cut"
	], 
	[
		"NAME:SubtractParameters",
		"KeepOriginals:="	, False
	])
oEditor.CreateRelativeCS(
	[
		"NAME:RelativeCSParameters",
		"Mode:="		, "Axis/Position",
		"OriginX:="		, "0mm",
		"OriginY:="		, "0mm",
		"OriginZ:="		, "0mm",
		"XAxisXvec:="		, "1mm",
		"XAxisYvec:="		, "0mm",
		"XAxisZvec:="		, "0mm",
		"YAxisXvec:="		, "0mm",
		"YAxisYvec:="		, "1mm",
		"YAxisZvec:="		, "0mm"
	], 
	[
		"NAME:Attributes",
		"Name:="		, "RelativeCS1"
	])
oEditor.ChangeProperty(
	[
		"NAME:AllTabs",
		[
			"NAME:Geometry3DCSTab",
			[
				"NAME:PropServers", 
				"RelativeCS1"
			],
			[
				"NAME:ChangedProps",
				[
					"NAME:Origin",
					"X:="			, "0cm",
					"Y:="			, "zu_width/2 cm",
					"Z:="			, "0cm"
				]
			]
		]
	])
oEditor.ChangeProperty(
	[
		"NAME:AllTabs",
		[
			"NAME:Geometry3DCSTab",
			[
				"NAME:PropServers", 
				"RelativeCS1"
			],
			[
				"NAME:ChangedProps",
				[
					"NAME:Origin",
					"X:="			, "0cm",
					"Y:="			, "(zu_width/2) cm",
					"Z:="			, "0cm"
				]
			]
		]
	])
oEditor.Section(
	[
		"NAME:Selections",
		"Selections:="		, "send1",
		"NewPartsModelFlag:="	, "Model"
	], 
	[
		"NAME:SectionToParameters",
		"CreateNewObjects:="	, True,
		"SectionPlane:="	, "ZX",
		"SectionCrossObject:="	, False
	])
oEditor.SeparateBody(
	[
		"NAME:Selections",
		"Selections:="		, "send1_Section1",
		"NewPartsModelFlag:="	, "Model"
	], 
	[
		"CreateGroupsForNewObjects:=", False
	])
oEditor.Delete(
	[
		"NAME:Selections",
		"Selections:="		, "send1_Section1_Separate1"
	])
