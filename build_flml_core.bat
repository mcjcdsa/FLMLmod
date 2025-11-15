@echo off
chcp 65001 >nul
title FLML核心包打包工具

echo ==========================================
echo     自由之境FLML核心包打包工具
echo ==========================================
echo.

REM 检查Maven
where mvn >nul 2>&1
if errorlevel 1 (
    echo [错误] Maven未安装或不在PATH中
    echo [提示] 请安装Maven 3.6+或使用Gradle打包
    pause
    exit /b 1
)

echo [信息] 开始打包FLML核心包...
echo [信息] 使用Maven打包
echo.

REM 执行打包（跳过测试）
call mvn clean package -Dmaven.test.skip=true

if errorlevel 1 (
    echo.
    echo [错误] 打包失败，请检查错误信息
    pause
    exit /b 1
)

REM 检查输出文件
if exist "release\flml-core-1.0.0.jar" (
    echo.
    echo [成功] FLML核心包打包完成！
    echo [输出] release\flml-core-1.0.0.jar
    echo [大小] 
    dir "release\flml-core-1.0.0.jar" | findstr "flml-core"
    echo.
    echo [提示] 将JAR文件复制到游戏的mods目录即可使用
) else (
    echo.
    echo [错误] JAR文件未找到，打包可能失败
    echo [提示] 检查release目录
    pause
    exit /b 1
)

echo.
pause

