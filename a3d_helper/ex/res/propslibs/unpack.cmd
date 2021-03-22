set tara=%1
set folder=%tara:.tara=%
if not exist %folder% mkdir %folder%
java -jar %~dp0UnpackTara.jar %tara% %folder%