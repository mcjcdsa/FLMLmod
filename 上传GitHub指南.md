# FLML官方模组加载器 - GitHub上传指南

## 项目概述

**FLML (Freedom Land Mod Loader)** 是《自由之境》游戏的官方模组加载器与API核心包。

- **项目名称**: Freedom Land Mod Loader Core
- **版本**: 1.0.0
- **许可证**: 待定
- **官方仓库**: GitHub

## 上传到GitHub步骤

### 方法一：创建新仓库并上传（推荐）

#### 1. 在GitHub上创建新仓库

1. 登录GitHub账号
2. 点击右上角 "+" → "New repository"
3. 填写仓库信息：
   - **Repository name**: `flml-core` 或 `FreedomLand-ModLoader-Core`
   - **Description**: `《自由之境》官方模组加载器与API核心包（必装）`
   - **Visibility**: Public（公开）或 Private（私有）
   - **不要**勾选 "Initialize this repository with a README"
4. 点击 "Create repository"

#### 2. 在本地初始化Git仓库

```bash
# 进入flml-core目录
cd flml-core

# 初始化Git仓库
git init

# 添加所有文件
git add .

# 提交文件
git commit -m "Initial commit: FLML Core v1.0.0"

# 添加远程仓库（替换YOUR_USERNAME为你的GitHub用户名）
git remote add origin https://github.com/YOUR_USERNAME/flml-core.git

# 推送到GitHub
git branch -M main
git push -u origin main
```

#### 3. 如果仓库已存在，强制推送（可选）

```bash
git push -u origin main --force
```

### 方法二：使用GitHub CLI（gh命令）

如果已安装GitHub CLI：

```bash
# 登录GitHub
gh auth login

# 在flml-core目录创建仓库并推送
cd flml-core
gh repo create flml-core --public --source=. --remote=origin --push
```

### 方法三：使用GitHub Desktop

1. 下载并安装 [GitHub Desktop](https://desktop.github.com/)
2. 登录GitHub账号
3. 在GitHub上创建新仓库
4. 在GitHub Desktop中：
   - File → Add Local Repository
   - 选择 `flml-core` 目录
   - 提交所有更改
   - 发布到GitHub

## 需要上传的文件

以下文件**应该**上传到GitHub：

```
flml-core/
├── .gitignore                 # Git忽略规则
├── pom.xml                    # Maven配置文件
├── build.gradle               # Gradle配置文件
├── README.md                  # 项目说明文档
├── 打包说明.txt               # 打包说明
├── build_flml_core.bat        # Windows打包脚本
├── build_flml_core.sh         # Linux/Mac打包脚本
├── 手动打包FLML核心包.bat      # 手动打包脚本
└── src/                       # 源代码
    ├── main/
    │   ├── java/              # Java源代码
    │   └── resources/         # 资源文件
    └── test/                  # 测试代码（如果有）
```

以下文件**不应**上传（已通过.gitignore排除）：

- `target/` - Maven构建输出
- `build/` - Gradle构建输出
- `release/` - 打包输出
- `*.jar` - JAR文件
- `.idea/` - IDE配置
- `.class` - 编译文件

## 推荐的仓库结构

### 基本结构

```
flml-core/
├── README.md              # 项目主说明文档
├── LICENSE                # 许可证文件（建议添加）
├── .gitignore            # Git忽略规则
├── pom.xml               # Maven配置
├── build.gradle          # Gradle配置
├── CHANGELOG.md          # 更新日志（建议添加）
├── src/                  # 源代码
│   ├── main/
│   │   ├── java/
│   │   └── resources/
│   └── test/
├── docs/                 # 文档目录（可选）
│   └── 开发指南.md
└── scripts/              # 脚本目录（可选）
    ├── build.bat
    └── build.sh
```

### 建议添加的文件

1. **LICENSE** - 添加开源许可证
   - MIT License
   - Apache License 2.0
   - GPL v3

2. **CHANGELOG.md** - 更新日志
   ```markdown
   # 更新日志

   ## [1.0.0] - 2025-11-15
   - 初始版本发布
   - 实现FLML核心加载器
   - 实现FLAPI接口
   ```

3. **CONTRIBUTING.md** - 贡献指南
   ```markdown
   # 贡献指南

   ## 如何贡献

   ### 报告问题
   - 使用Issues报告Bug
   - 提供详细的复现步骤

   ### 提交代码
   - Fork仓库
   - 创建功能分支
   - 提交Pull Request
   ```

## README.md模板

创建或更新 `README.md` 文件：

```markdown
# FLML - Freedom Land Mod Loader Core

[![Version](https://img.shields.io/badge/version-1.0.0-blue.svg)](https://github.com/YOUR_USERNAME/flml-core)
[![License](https://img.shields.io/badge/license-MIT-green.svg)](LICENSE)
[![Java](https://img.shields.io/badge/Java-11+-orange.svg)](https://www.java.com/)

《自由之境》游戏的官方模组加载器与API核心包。

## 特性

- 🚀 高性能模组加载系统
- 🔌 丰富的API接口
- 🛡️ 安全的权限管理
- 📦 依赖自动解析
- 🎯 事件驱动架构

## 快速开始

### 安装

将 `flml-core-1.0.0.jar` 复制到游戏的 `mods/` 目录。

### 开发模组

参考 [模组开发指南](docs/开发指南.md)

## 构建

```bash
mvn clean package
```

## 许可证

[LICENSE](LICENSE)

## 链接

- [官方文档](https://github.com/YOUR_USERNAME/flml-core/wiki)
- [问题反馈](https://github.com/YOUR_USERNAME/flml-core/issues)
```

## 提交规范

### 提交消息格式

```
<类型>: <简短描述>

[详细描述（可选）]

[相关Issue（可选）]
```

类型：
- `feat`: 新功能
- `fix`: 修复Bug
- `docs`: 文档更新
- `style`: 代码格式
- `refactor`: 重构
- `test`: 测试
- `chore`: 构建/工具

示例：
```
feat: 添加模组依赖解析功能

实现了自动依赖解析和循环依赖检测

Closes #123
```

## 发布版本

### 创建Release

1. 在GitHub上点击 "Releases" → "Draft a new release"
2. 填写版本信息：
   - **Tag**: `v1.0.0`
   - **Title**: `FLML Core v1.0.0`
   - **Description**: 版本说明
3. 上传 `flml-core-1.0.0.jar` 到 Assets
4. 点击 "Publish release"

### 使用Git标签

```bash
# 创建标签
git tag -a v1.0.0 -m "Release version 1.0.0"

# 推送标签
git push origin v1.0.0
```

## 保护主分支

建议在GitHub设置中：

1. Settings → Branches → Add rule
2. 保护 `main` 分支：
   - ✅ Require pull request reviews
   - ✅ Require status checks to pass
   - ✅ Require branches to be up to date

## 常见问题

### Q: 如何更新仓库？

```bash
git add .
git commit -m "更新说明"
git push origin main
```

### Q: 如何回退版本？

```bash
git log                    # 查看提交历史
git reset --hard <commit>  # 回退到指定提交
git push origin main --force
```

### Q: 如何添加协作者？

1. Settings → Collaborators
2. Add people
3. 输入用户名或邮箱

---

**需要帮助？** 请在 [Issues](https://github.com/YOUR_USERNAME/flml-core/issues) 中提问。

