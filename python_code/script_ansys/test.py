# ----------------------------------------------
# Script Recorded by ANSYS Electronics Desktop Version 2018.0.0
# 14:11:34  12月 09, 2021
# ----------------------------------------------
#import ScriptEnv
from win32com import client
oAnsoftApp = client.Dispatch("Ansoft.ElectronicsDesktop")
oDesktop = oAnsoftApp.getAppDesktop()
#ScriptEnv.Initialize("Ansoft.ElectronicsDesktop")
oDesktop.RestoreWindow()
oProject = oDesktop.SetActiveProject("coil_array")
oProject.InsertDesign("Maxwell 3D", "Maxwell3DDesign3", "Magnetostatic", "")
oDesign = oProject.SetActiveDesign("Maxwell3DDesign3")
oEditor = oDesign.SetActiveEditor("3D Modeler")
oEditor.CreateBox(
	[
		"NAME:BoxParameters",
		"XPosition:="		, "0mm",
		"YPosition:="		, "0mm",
		"ZPosition:="		, "0mm",
		"XSize:="		, "0.9mm",
		"YSize:="		, "0.9mm",
		"ZSize:="		, "0.3mm"
	], 
	[
		"NAME:Attributes",
		"Name:="		, "Box1",
		"Flags:="		, "",
		"Color:="		, "(143 175 143)",
		"Transparency:="	, 0,
		"PartCoordinateSystem:=", "Global",
		"UDMId:="		, "",
		"MaterialValue:="	, "\"vacuum\"",
		"SurfaceMaterialValue:=", "\"\"",
		"SolveInside:="		, True,
		"IsMaterialEditable:="	, True,
		"UseMaterialAppearance:=", False
	])
oDesign.ChangeProperty(
	[
		"NAME:AllTabs",
		[
			"NAME:LocalVariableTab",
			[
				"NAME:PropServers", 
				"LocalVariables"
			],
			[
				"NAME:NewProps",
				[
					"NAME:rs",
					"PropType:="		, "VariableProp",
					"UserDef:="		, True,
					"Value:="		, "9"
				],
				[
					"NAME:zu_width",
					"PropType:="		, "VariableProp",
					"UserDef:="		, True,
					"Value:="		, "20"
				],
				[
					"NAME:mo",
					"PropType:="		, "VariableProp",
					"UserDef:="		, True,
					"Value:="		, "0"
				]
			],
			[
				"NAME:ChangedProps",
				[
					"NAME:rs",
					"Sweep:="		, False
				],
				[
					"NAME:zu_width",
					"Sweep:="		, False
				]
			]
		]
	])
oEditor.ChangeProperty(
	[
		"NAME:AllTabs",
		[
			"NAME:Geometry3DAttributeTab",
			[
				"NAME:PropServers", 
				"Box1"
			],
			[
				"NAME:ChangedProps",
				[
					"NAME:Material",
					"Value:="		, "\"copper\""
				]
			]
		]
	])
oEditor.ChangeProperty(
	[
		"NAME:AllTabs",
		[
			"NAME:Geometry3DAttributeTab",
			[
				"NAME:PropServers", 
				"Box1"
			],
			[
				"NAME:ChangedProps",
				[
					"NAME:Name",
					"Value:="		, "send1"
				]
			]
		]
	])
oDesign.ChangeProperty(
	[
		"NAME:AllTabs",
		[
			"NAME:LocalVariableTab",
			[
				"NAME:PropServers", 
				"LocalVariables"
			],
			[
				"NAME:NewProps",
				[
					"NAME:ps_z",
					"PropType:="		, "VariableProp",
					"UserDef:="		, True,
					"Value:="		, "0"
				]
			]
		]
	])
oEditor.ChangeProperty(
	[
		"NAME:AllTabs",
		[
			"NAME:Geometry3DCmdTab",
			[
				"NAME:PropServers", 
				"send1:CreateBox:1"
			],
			[
				"NAME:ChangedProps",
				[
					"NAME:Position",
					"X:="			, "(zu_width/2-rs-0.25) cm",
					"Y:="			, "(zu_width/2-rs-0.25) cm",
					"Z:="			, "ps_z cm"
				]
			]
		]
	])
oEditor.ChangeProperty(
	[
		"NAME:AllTabs",
		[
			"NAME:Geometry3DCmdTab",
			[
				"NAME:PropServers", 
				"send1:CreateBox:1"
			],
			[
				"NAME:ChangedProps",
				[
					"NAME:XSize",
					"Value:="		, "(2*rs+0.25*2) cm"
				]
			]
		]
	])
oEditor.ChangeProperty(
	[
		"NAME:AllTabs",
		[
			"NAME:Geometry3DCmdTab",
			[
				"NAME:PropServers", 
				"send1:CreateBox:1"
			],
			[
				"NAME:ChangedProps",
				[
					"NAME:YSize",
					"Value:="		, "(2*rs+0.25*2) cm"
				]
			]
		]
	])
oEditor.ChangeProperty(
	[
		"NAME:AllTabs",
		[
			"NAME:Geometry3DCmdTab",
			[
				"NAME:PropServers", 
				"send1:CreateBox:1"
			],
			[
				"NAME:ChangedProps",
				[
					"NAME:ZSize",
					"Value:="		, "0.5cm"
				]
			]
		]
	])
