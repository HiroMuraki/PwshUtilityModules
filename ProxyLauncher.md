# 程序启动代理

## 相关模块文件
1. [ProxyLauncher.psm1](ProxyLauncher.psm1)

## 可用函数
```powershell
Start-ProgramProxy 
# 用于代理启动程序
# 别名：spp

Test-ProxyPaths
# 用于检测代理目录路径中是否存在无效路径/程序名称冲突
# 别名：tpp
```

## 用途：
有一些程序位于不需要也不想加到`PATH`环境变量的目录，但在使用时又不想`cd`过去或者使用其完整路径，此时可通过此模块的`Start-ProgramProxy`函数代理运行这些程序。 

## 适用版本：
PowerShell 7.0+

## 使用方法：
假设程序`prog.exe`位于目录`C:/My/Main/Path`下，程序`prog2.exe`位于目录`D:/My/Another/Path`下，则只需要将目录路径`C:/My/Main/Path`和`D:/My/Another/Path`添加到该模块代码开头定义的`$PATHS`数组中：
```powershell
$PATHS = @(
    "C:/My/Main/Path",
    "D:/My/Another/Path",
)

# 其他部分代码...
```
之后导入该模块后（无论是通过手动导入还是通过修改配置文件自动导入），在命令行即可通过如下命令调用`C:/My/Main/Path/prog.exe`并为其传递参数列表`<args...>`
```powershell
Start-ProgramProxy prog <args...> # 等同于在命令行使用prog <args...>
```
同理，以下命令调用`D:/My/Another/Path/prog2.exe`并为其传递参数列表`<args...>`
```powershell
Start-ProgramProxy prog2 <args...> # 等同于在命令行使用prog2 <args...>
```
（等同于只需要在原本的命令开头加个`Start-ProgramProxy`就行）

## 具体示例
在目录`D:\SteamLibrary\steamapps\common\Left 4 Dead 2\bin`下有`vpk.exe`程序，有时候需要用到它打包/解包vpk文件，但`cd`切过去或者打全路径都麻烦，并且也不想就为了这一个程序就把该目录路径加到用户/系统的`PATH`环境变量。则：

**1.** 将目录路径`D:\SteamLibrary\steamapps\common\Left 4 Dead 2\bin`添加到该模块的`$PATHS`数组中：
```powershell
$PATHS = @(
    "D:\SteamLibrary\steamapps\common\Left 4 Dead 2\bin"
)
```
**2.** 之后若要用该目录下的vpk.exe解包vpk文件`D:\L4D2-Mods\114514\1919810.vpk`，则只需要在命令行运行以下命令即可：
```powershell
Start-ProgramProxy vpk D:\L4D2-Mods\114514\1919810.vpk
```
如果你觉得`Start-ProgramProxy`写起来太长，也可以使用它的别名`spp`：
```powershell
spp vpk D:\L4D2-Mods\114514\1919810.vpk
```