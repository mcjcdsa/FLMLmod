#!/bin/bash

echo "=========================================="
echo "   自由之境FLML核心包打包工具"
echo "=========================================="
echo ""

# 检查Maven
if ! command -v mvn &> /dev/null; then
    echo "[错误] Maven未安装或不在PATH中"
    echo "[提示] 请安装Maven 3.6+或使用Gradle打包"
    exit 1
fi

echo "[信息] 开始打包FLML核心包..."
echo "[信息] 使用Maven打包"
echo ""

# 执行打包（跳过测试）
mvn clean package -Dmaven.test.skip=true

if [ $? -ne 0 ]; then
    echo ""
    echo "[错误] 打包失败，请检查错误信息"
    exit 1
fi

# 检查输出文件
if [ -f "release/flml-core-1.0.0.jar" ]; then
    echo ""
    echo "[成功] FLML核心包打包完成！"
    echo "[输出] release/flml-core-1.0.0.jar"
    echo "[大小] $(du -h release/flml-core-1.0.0.jar | cut -f1)"
    echo ""
    echo "[提示] 将JAR文件复制到游戏的mods目录即可使用"
else
    echo ""
    echo "[错误] JAR文件未找到，打包可能失败"
    echo "[提示] 检查release目录"
    exit 1
fi

echo ""

