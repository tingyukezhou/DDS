# ModelSim一键仿真脚本
# 使用方法: do run_all.do
# 或在ModelSim命令行输入: do run_all.do

echo "======================================"
echo "  DDS波形发生器ModelSim仿真脚本"
echo "======================================"

# 设置工作目录
set script_dir [file dirname [info script]]
cd $script_dir

echo ""
echo "=== 步骤1: 编译设计 ==="
do compile.do

if {[catch {do compile.do} error_msg]} {
    echo "编译失败: $error_msg"
    exit 1
}

echo ""
echo "=== 步骤2: 运行仿真 ==="
do simulate.do

if {[catch {do simulate.do} error_msg]} {
    echo "仿真失败: $error_msg"
    exit 1
}

echo ""
echo "======================================"
echo "  仿真流程完成!"
echo "======================================"
echo "  波形窗口已打开，可查看仿真结果"
echo "======================================"
