def create_vacuum(maxwell):
    # 选定坐标系
    maxwell.rcs.SetWCS_maxwell(maxwell, "Global")
    # 创建vacuum
    maxwell.createBox_maxwell(str(-20) + " cm",
                              str(-20) + " cm",
                              str(-20) + " cm",
                              str(150) + " cm",
                              str(150) + " cm",
                              str(150) + " cm",
                              'vacuum',
                              'vacuum')

