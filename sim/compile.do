# ModelSim编译脚本
# 使用方法: do compile.do

# 清理旧的编译结果
if {[file exists work]} {
    vdel -lib work -all
}

# 创建工作库
vlib work
vmap work work

# 设置Verilog标准
set verilog_std "verilog2001"

# 编译源文件
echo "=== 开始编译源文件 ==="

# 相位累加器
vlog -sv -work work "../src/phase_accumulator.v"
echo "编译 phase_accumulator.v 完成"

# 波形ROM
vlog -sv -work work "../src/wave_rom.v"
echo "编译 wave_rom.v 完成"

# 波形控制器
vlog -sv -work work "../src/wave_controller.v"
echo "编译 wave_controller.v 完成"

# 按键控制器
vlog -sv -work work "../src/key_controller.v"
echo "编译 key_controller.v 完成"

# 顶层模块
vlog -sv -work work "../src/dds_top.v"
echo "编译 dds_top.v 完成"

# 测试bench
vlog -sv -work work "dds_tb.v"
echo "编译 dds_tb.v 完成"

echo "=== 编译完成 ==="
