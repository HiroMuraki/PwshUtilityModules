# 便携应用管理

## 相关模块文件
1. [PortableAppManager.psm1](PortableAppManager.psm1)

## 可用函数
```powershell
Get-AppUpdateInfo
# 获取程序更新信息
# 别名：gaui
```

## 用途：
用于管理便携式应用程序的更新。

## 适用版本：
PowerShell 7.4+

## 使用方法：
在`$APP_CONTAINERS`填入存有便携式应用程序的目录路径，并在这些路径下各自放置一个名为`AppInfos.json`的文件，在其中填写形如如下的json文本：
```json
[
    {
        // 表示应用名称，建使用用户友好的名称
        "appName": "OBS Studio",
        // 表示应用的入口可执行程序文件名，使用相对于AppInfos.json所在目录的路径
        "entryName": "OBS-Studio/bin/64bit/obs64.exe"
    },
    // 更多应用信息
]
```
之后在命令行中运行如下命令即可获取程序的更新信息：
```powershell
Get-AppUpdateInfo
```

## 具体示例
在目录`D:/Software`下有便携式应用`OBS Studio`的目录，则：

**1.** 在`D:/Software`下创建文件`AppInfos.json`并写入如下内容：
```json
[
    {
        "appName": "OBS Studio",
        "entryName": "OBS-Studio/bin/64bit/obs64.exe"
    }
]
```
**2.** 将目录路径`D:/Software`添加到该模块的`$APP_CONTAINERS`数组中：
```powershell
$APP_CONTAINERS = @(
    "D:/Software"
)
```
**3.** 之后便可使用如下命令获取更新信息：
```powershell
Get-AppUpdateInfo
```