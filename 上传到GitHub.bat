@echo off
chcp 65001 >nul
title 上传FLML核心包到GitHub

echo ==========================================
echo      上传FLML核心包到GitHub
echo ==========================================
echo.

REM 检查Git是否安装
where git >nul 2>&1
if %errorlevel% neq 0 (
    echo [错误] 未检测到Git，请先安装Git
    echo.
    echo [提示] 下载地址: https://git-scm.com/download/win
    echo.
    pause
    exit /b 1
)

echo [信息] 检测到Git环境
git --version
echo.

REM 检查是否已在Git仓库中
if exist ".git" (
    echo [信息] 检测到Git仓库
    echo.
) else (
    echo [信息] 初始化Git仓库...
    git init
    echo.
)

REM 检查远程仓库是否已配置
git remote get-url origin >nul 2>&1
if %errorlevel% equ 0 (
    echo [信息] 远程仓库已配置:
    git remote get-url origin
    echo.
    
    set /p CONFIRM="是否使用现有远程仓库? (y/n): "
    if /i not "%CONFIRM%"=="y" (
        echo.
        set /p REPO_URL="请输入新的GitHub仓库URL: "
        git remote set-url origin "%REPO_URL%"
        echo [成功] 已更新远程仓库URL
    )
) else (
    echo [信息] 未配置远程仓库
    echo.
    set /p REPO_URL="请输入GitHub仓库URL (例如: https://github.com/username/flml-core.git): "
    if "%REPO_URL%"=="" (
        echo [错误] 仓库URL不能为空
        pause
        exit /b 1
    )
    git remote add origin "%REPO_URL%"
    echo [成功] 已添加远程仓库
    echo.
)

REM 添加所有文件
echo [步骤1/3] 添加文件到Git...
git add .
if %errorlevel% neq 0 (
    echo [错误] 添加文件失败
    pause
    exit /b 1
)
echo [成功] 文件已添加

REM 检查是否有更改
git status --porcelain | findstr . >nul
if %errorlevel% neq 0 (
    echo [信息] 没有需要提交的更改
    echo.
    set /p SKIP_COMMIT="是否跳过提交，直接推送? (y/n): "
    if /i not "%SKIP_COMMIT%"=="y" (
        echo [信息] 已取消操作
        pause
        exit /b 0
    )
) else (
    echo.
    echo [步骤2/3] 提交更改...
    set /p COMMIT_MSG="请输入提交消息 (默认: Initial commit FLML Core v1.0.0): "
    if "%COMMIT_MSG%"=="" set COMMIT_MSG=Initial commit FLML Core v1.0.0
    
    git commit -m "%COMMIT_MSG%"
    if %errorlevel% neq 0 (
        echo [错误] 提交失败
        pause
        exit /b 1
    )
    echo [成功] 更改已提交
)

REM 推送到GitHub
echo.
echo [步骤3/3] 推送到GitHub...
echo.
set /p BRANCH="请输入分支名 (默认: main): "
if "%BRANCH%"=="" set BRANCH=main

REM 检查分支是否存在
git branch --list %BRANCH% >nul 2>&1
if %errorlevel% neq 0 (
    echo [信息] 创建分支: %BRANCH%
    git branch -M %BRANCH%
)

echo [信息] 正在推送到 origin/%BRANCH%...
git push -u origin %BRANCH%

if %errorlevel% neq 0 (
    echo.
    echo [错误] 推送失败
    echo.
    echo [提示] 可能的原因:
    echo   1. GitHub认证失败（需要配置SSH密钥或Personal Access Token）
    echo   2. 网络连接问题
    echo   3. 仓库不存在或无权限
    echo.
    echo [解决方法]
    echo   1. 配置GitHub认证:
    echo      git config --global user.name "Your Name"
    echo      git config --global user.email "your.email@example.com"
    echo   2. 使用Personal Access Token:
    echo      访问: https://github.com/settings/tokens
    echo      创建token，推送时使用token作为密码
    echo   3. 或使用SSH密钥:
    echo      ssh-keygen -t ed25519 -C "your.email@example.com"
    echo      添加公钥到GitHub: Settings → SSH and GPG keys
    echo.
    pause
    exit /b 1
)

echo.
echo ==========================================
echo         上传成功！
echo ==========================================
echo.
echo [信息] 文件已上传到GitHub
echo [信息] 仓库URL: %REPO_URL%
echo.
echo [下一步]
echo   1. 访问GitHub仓库查看上传的文件
echo   2. 创建Release发布版本（可选）
echo   3. 添加README.md文档（如果还没有）
echo.
pause

