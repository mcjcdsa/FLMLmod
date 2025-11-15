@echo off
chcp 65001 >nul
title 上传FLML核心包到GitHub仓库

echo ==========================================
echo   上传FLML核心包到 https://github.com/mcjcdsa/FLMLmod.git
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

REM 进入flml-core目录
cd /d "%~dp0"
echo [信息] 当前目录: %CD%
echo.

REM GitHub仓库URL
set REPO_URL=https://github.com/mcjcdsa/FLMLmod.git
set BRANCH=main

REM 检查是否已在Git仓库中
if exist ".git" (
    echo [信息] 检测到Git仓库
    echo.
    
    REM 检查远程仓库
    git remote get-url origin >nul 2>&1
    if %errorlevel% equ 0 (
        git remote get-url origin | findstr "%REPO_URL%" >nul
        if %errorlevel% equ 0 (
            echo [信息] 远程仓库已配置正确
        ) else (
            echo [信息] 更新远程仓库URL...
            git remote set-url origin %REPO_URL%
            echo [成功] 已更新远程仓库URL
        )
    ) else (
        echo [信息] 添加远程仓库...
        git remote add origin %REPO_URL%
        echo [成功] 已添加远程仓库
    )
) else (
    echo [信息] 初始化Git仓库...
    git init
    if %errorlevel% neq 0 (
        echo [错误] Git初始化失败
        pause
        exit /b 1
    )
    
    echo [信息] 添加远程仓库...
    git remote add origin %REPO_URL%
    if %errorlevel% neq 0 (
        echo [错误] 添加远程仓库失败
        pause
        exit /b 1
    )
    
    echo [成功] Git仓库初始化完成
)

echo.
echo [步骤1/4] 添加所有文件到Git...
git add .
if %errorlevel% neq 0 (
    echo [错误] 添加文件失败
    pause
    exit /b 1
)
echo [成功] 文件已添加

echo.
echo [步骤2/4] 检查更改状态...
git status --short
echo.

REM 检查是否有更改
git diff --cached --quiet
if %errorlevel% equ 0 (
    git diff --quiet
    if %errorlevel% equ 0 (
        echo [信息] 没有需要提交的更改
        echo.
        set /p SKIP_COMMIT="是否直接推送? (y/n): "
        if /i not "%SKIP_COMMIT%"=="y" (
            echo [信息] 已取消操作
            pause
            exit /b 0
        )
        goto :push
    )
)

echo.
echo [步骤3/4] 提交更改...
set COMMIT_MSG=Initial commit: FLML Core v1.0.0 - Official Mod Loader and API

REM 检查是否有之前的提交
git log --oneline -1 >nul 2>&1
if %errorlevel% neq 0 (
    echo [信息] 首次提交，使用默认消息: %COMMIT_MSG%
) else (
    set /p USER_MSG="请输入提交消息 (直接回车使用默认): "
    if not "%USER_MSG%"=="" set COMMIT_MSG=%USER_MSG%
)

git commit -m "%COMMIT_MSG%"
if %errorlevel% neq 0 (
    echo [错误] 提交失败
    pause
    exit /b 1
)
echo [成功] 更改已提交

:push
echo.
echo [步骤4/4] 推送到GitHub...
echo [信息] 仓库: %REPO_URL%
echo [信息] 分支: %BRANCH%
echo.

REM 检查分支是否存在
git branch --list %BRANCH% >nul 2>&1
if %errorlevel% neq 0 (
    echo [信息] 创建分支: %BRANCH%
    git branch -M %BRANCH%
)

echo [信息] 正在推送到 origin/%BRANCH%...
git push -u origin %BRANCH% --force

if %errorlevel% neq 0 (
    echo.
    echo [错误] 推送失败
    echo.
    echo [提示] 可能的原因:
    echo   1. GitHub认证失败（需要配置SSH密钥或Personal Access Token）
    echo   2. 网络连接问题
    echo   3. 没有仓库的写入权限
    echo.
    echo [解决方法]
    echo   1. 配置Git用户信息:
    echo      git config --global user.name "Your Name"
    echo      git config --global user.email "your.email@example.com"
    echo.
    echo   2. 使用Personal Access Token:
    echo      a. 访问: https://github.com/settings/tokens
    echo      b. 点击 "Generate new token (classic)"
    echo      c. 选择权限: repo (全部)
    echo      d. 生成并复制token
    echo      e. 推送时，用户名输入GitHub用户名，密码输入token
    echo.
    echo   3. 或配置SSH密钥:
    echo      a. 生成SSH密钥: ssh-keygen -t ed25519 -C "your.email@example.com"
    echo      b. 复制公钥: type %USERPROFILE%\.ssh\id_ed25519.pub
    echo      c. 添加到GitHub: https://github.com/settings/ssh/new
    echo      d. 使用SSH URL: git remote set-url origin git@github.com:mcjcdsa/FLMLmod.git
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
echo [信息] 仓库地址: https://github.com/mcjcdsa/FLMLmod
echo.
echo [下一步]
echo   1. 访问仓库: https://github.com/mcjcdsa/FLMLmod
echo   2. 检查上传的文件
echo   3. 创建Release发布版本（可选）
echo      - 点击 "Releases" → "Draft a new release"
echo      - 上传 flml-core-1.0.0.jar
echo.
pause

