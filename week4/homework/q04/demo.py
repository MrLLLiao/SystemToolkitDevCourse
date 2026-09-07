# 危险调用演示样例（含三种形态）
import subprocess
import os

# 形态1：单行 Popen，shell=True
subprocess.Popen("ls -la", shell=True)

# 形态2：多行 Popen，shell=True（单行正则漏报）
subprocess.Popen(
    "rm -rf /tmp/x",
    shell=True,
)

# 形态3：os.system + 行续接符（\bsystem\s*\( 漏报）
os.system \
    ("echo injected")

# 安全调用：shell=False（破坏正则后误报）
subprocess.Popen(["ls", "-la"], shell=False)
