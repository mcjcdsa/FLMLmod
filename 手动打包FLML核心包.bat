@echo off
chcp 65001 >nul
title FLML核心包手动打包工具

echo ==========================================
echo     自由之境FLML核心包手动打包工具
echo ==========================================
echo.

REM 检查Java环境
where java >nul 2>&1
if errorlevel 1 (
    echo [错误] 未找到Java环境，请先安装JDK 11+
    pause
    exit /b 1
)

echo [信息] 检测到Java环境
java -version
echo.

REM 设置目录变量
set MODS_DIR=..\GameCore\src\main\java\com\freedomland
set TARGET_DIR=temp_build_flml
set OUTPUT_JAR=flml-core-1.0.0.jar
set RELEASE_DIR=release

REM 清理临时目录
if exist "%TARGET_DIR%" (
    echo [信息] 清理临时目录...
    rmdir /s /q "%TARGET_DIR%"
)
mkdir "%TARGET_DIR%"

REM 创建包结构
mkdir "%TARGET_DIR%\com\freedomland\modloader"
mkdir "%TARGET_DIR%\com\freedomland\modloader\asm"
mkdir "%TARGET_DIR%\com\freedomland\modloader\registry"
mkdir "%TARGET_DIR%\com\freedomland\api\core"
mkdir "%TARGET_DIR%\com\freedomland\api\block"
mkdir "%TARGET_DIR%\com\freedomland\api\world"
mkdir "%TARGET_DIR%\com\freedomland\api\entity"
mkdir "%TARGET_DIR%\com\freedomland\api\player"
mkdir "%TARGET_DIR%\com\freedomland\api\event"
mkdir "%TARGET_DIR%\com\freedomland\api\resource"
mkdir "%TARGET_DIR%\com\freedomland\flml\loader"
mkdir "%TARGET_DIR%\META-INF"

echo [1/5] 编译Java源文件...

REM 检查是否已编译GameCore
if not exist "..\GameCore\target\classes\com\freedomland\modloader" (
    echo [警告] GameCore未编译，尝试编译...
    
    REM 检查Maven
    where mvn >nul 2>&1
    if errorlevel 1 (
        echo [错误] Maven未安装，无法自动编译
        echo [提示] 请先执行: cd ..\GameCore ^&^& mvn compile
        pause
        exit /b 1
    )
    
    cd ..\GameCore
    call mvn compile -Dmaven.test.skip=true
    if errorlevel 1 (
        echo [错误] GameCore编译失败
        cd ..\flml-core
        pause
        exit /b 1
    )
    cd ..\flml-core
)

REM 复制编译后的class文件
echo [2/5] 复制modloader包...
xcopy "..\GameCore\target\classes\com\freedomland\modloader\*" "%TARGET_DIR%\com\freedomland\modloader\" /E /I /Y >nul

echo [3/5] 复制api包...
xcopy "..\GameCore\target\classes\com\freedomland\api\*" "%TARGET_DIR%\com\freedomland\api\" /E /I /Y >nul

REM 复制Bootstrap类
echo [4/5] 复制FLML Bootstrap类...
if exist "src\main\java\com\freedomland\flml\loader\FLModLoaderBootstrap.java" (
    REM 需要先编译
    echo [信息] 编译Bootstrap类...
    javac -d "%TARGET_DIR%" -cp "..\GameCore\target\classes" "src\main\java\com\freedomland\flml\loader\FLModLoaderBootstrap.java" 2>nul
)

REM 复制META-INF文件
echo [5/5] 复制配置文件...
copy "src\main\resources\META-INF\MANIFEST.MF" "%TARGET_DIR%\META-INF\" >nul
copy "src\main\resources\META-INF\flml.properties" "%TARGET_DIR%\META-INF\" >nul

REM 打包为JAR
echo.
echo [打包] 正在打包JAR文件...

REM 创建release目录
if not exist "%RELEASE_DIR%" mkdir "%RELEASE_DIR%"

REM 使用jar命令打包
cd "%TARGET_DIR%"
jar cf "..\%RELEASE_DIR%\%OUTPUT_JAR%" *
cd ..

if errorlevel 1 (
    echo [错误] JAR打包失败，请检查jar命令是否可用
    echo [提示] jar命令通常在JDK的bin目录下
    pause
    exit /b 1
)

REM 验证JAR文件
if exist "%RELEASE_DIR%\%OUTPUT_JAR%" (
    echo.
    echo [成功] FLML核心包打包完成！
    echo [输出] %RELEASE_DIR%\%OUTPUT_JAR%
    echo [大小] 
    dir "%RELEASE_DIR%\%OUTPUT_JAR%" | findstr "%OUTPUT_JAR%"
    echo.
    echo [提示] 将JAR文件复制到游戏的mods目录即可使用
) else (
    echo [错误] JAR文件未找到，打包可能失败
    pause
    exit /b 1
)

REM 清理临时目录
echo.
echo [清理] 清理临时目录...
rmdir /s /q "%TARGET_DIR%"

echo.
echo [完成] 打包流程结束
pause

