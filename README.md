# FLML - Freedom Land Mod Loader Core

[![Version](https://img.shields.io/badge/version-1.0.0-blue.svg)](https://github.com/mcjcdsa/FLMLmod)
[![Java](https://img.shields.io/badge/Java-11+-orange.svg)](https://www.java.com/)
[![License](https://img.shields.io/badge/license-MIT-green.svg)](LICENSE)

《自由之境》游戏的官方模组加载器与API核心包（必装）。

## 项目说明

此模块用于打包官方模组加载器（FLML）和API的核心包，生成`flml-core-1.0.0.jar`文件。

## 打包方式

### 方法一：使用Maven命令行

**前提条件**：
- 已安装JDK 11+
- 已安装Maven 3.6+

**打包步骤**：

1. **先构建父项目和GameCore模块**（flml-core依赖GameCore）：
```bash
# 在项目根目录执行
mvn clean install -Dmaven.test.skip=true
```

2. **构建FLML核心包**：
```bash
cd flml-core
mvn clean package -Dmaven.test.skip=true
```

3. **获取输出**：
打包完成后，JAR文件位于：
```
flml-core/release/flml-core-1.0.0.jar
```

### 方法二：使用打包脚本

**Windows**：
```bash
cd flml-core
build_flml_core.bat
```

**Linux/Mac**：
```bash
cd flml-core
chmod +x build_flml_core.sh
./build_flml_core.sh
```

### 方法三：使用Gradle

如果使用Gradle：

```bash
cd flml-core
./gradlew clean build
```

输出目录：`build/libs/flml-core-1.0.0.jar`

## 打包内容

FLML核心包包含：

1. **FLML加载器核心**（`com.freedomland.modloader`包）：
   - ModLoader - 模组加载器核心
   - ModScanner - 模组扫描器
   - DependencyResolver - 依赖解析器
   - PermissionManager - 权限管理器
   - ResourceInjector - 资源注入器
   - ModClassLoader - 模组类加载器
   - EventBus - 事件总线
   - 等等...

2. **FLAPI接口**（`com.freedomland.api`包）：
   - core - 核心接口（IModEntry, ModContext等）
   - block - 方块系统接口
   - world - 世界生成接口
   - event - 事件系统接口
   - player - 玩家接口
   - 等等...

3. **依赖库**（已重命名避免冲突）：
   - ASM → `com.freedomland.flml.shaded.asm`
   - SLF4J → `com.freedomland.flml.shaded.slf4j`
   - Gson → 包含在JAR中

4. **配置文件**：
   - `META-INF/MANIFEST.MF` - JAR清单文件
   - `META-INF/flml.properties` - FLML配置文件

## 验证打包结果

打包完成后，检查：

1. **文件是否存在**：
```
flml-core/release/flml-core-1.0.0.jar
```

2. **JAR包结构**（用压缩软件打开检查）：
```
flml-core-1.0.0.jar
├─ META-INF/
│  ├─ MANIFEST.MF
│  └─ flml.properties
├─ com/
│  └─ freedomland/
│     ├─ modloader/  # FLML加载器核心
│     ├─ api/        # FLAPI接口
│     └─ flml/       # Bootstrap类
└─ 依赖库（重命名后）
```

3. **清单文件内容**：
- `Main-Class`: `com.freedomland.flml.loader.FLModLoaderBootstrap`
- `FLML-Official`: `true`
- `Game-Version`: `1.0.0`
- `API-Version`: `1.0.0`

## 部署

将打包好的JAR文件复制到游戏的`mods/`目录：

```
GameCore/mods/flml-core-1.0.0.jar
```

游戏启动时会自动校验并加载此核心包。

## 注意事项

1. **必须先构建GameCore模块**：flml-core依赖GameCore模块，需要先执行`mvn install`安装GameCore到本地仓库。

2. **版本一致性**：FLML核心包版本必须与游戏版本一致（当前为1.0.0）。

3. **依赖隔离**：打包后的JAR包含所有依赖，无需额外依赖文件。

4. **不要修改JAR内容**：修改JAR包可能导致游戏无法识别为官方核心包。

## 故障排除

### 打包失败：找不到GameCore模块

**解决方法**：
```bash
# 在项目根目录先构建并安装GameCore
mvn clean install -Dmaven.test.skip=true
```

### 打包失败：找不到类

**解决方法**：
- 检查GameCore模块是否已编译
- 检查`target/classes`目录下是否有modloader和api包

### JAR文件过大

**原因**：可能包含了不必要的依赖或资源文件。

**解决方法**：
- 检查filters配置是否正确
- 确认只包含了modloader和api包

## 下载

从 [Releases](https://github.com/mcjcdsa/FLMLmod/releases) 下载最新版本的JAR文件。

## 许可证

[LICENSE](LICENSE)（待定）

## 链接

- [问题反馈](https://github.com/mcjcdsa/FLMLmod/issues)
- [官方文档](docs/)
- [模组开发指南](../../mods/模组开发指南.md)

---

更多信息请参考：`docs/FLML_官方核心包打包及部署规范.md`

