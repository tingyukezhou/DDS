# ModelSim仿真运行脚本
# 使用方法: do simulate.do

echo "=== 开始仿真 ==="

# 设置仿真时间单位
set simulation_time_unit "1ns"
set simulation_time_precision "1ps"

# 创建仿真对象
vsim -t $simulation_time_precision -lib work dds_tb

# 添加波形
echo "=== 添加波形信号 ==="
add wave -noupdate -divider {=== 时钟与复位 ===}
add wave -noupdate /dds_tb/clk
add wave -noupdate /dds_tb/rst_n

add wave -noupdate -divider {=== 按键输入 ===}
add wave -noupdate /dds_tb/key

add wave -noupdate -divider {=== 控制信号 ===}
add wave -noupdate /dds_tb/dds_inst/key_ctrl/wave_sel
add wave -noupdate /dds_tb/dds_inst/key_ctrl/amplitude
add wave -noupdate /dds_tb/dds_inst/key_ctrl/freq_word
add wave -noupdate /dds_tb/dds_inst/key_ctrl/phase_offset

add wave -noupdate -divider {=== DDS内部信号 ===}
add wave -noupdate /dds_tb/dds_inst/phase_acc/phase_acc
add wave -noupdate /dds_tb/dds_inst/phase_out
add wave -noupdate /dds_tb/dds_inst/rom/wave_data

add wave -noupdate -divider {=== 输出波形 ===}
add wave -noupdate /dds_tb/wave_out

# 设置波形显示格式
echo "=== 设置波形显示格式 ==="
configure wave -signalnamewidth 1
configure wave -timelineunits ns

# 时钟信号以方波显示
set wave [find signals /dds_tb/clk]
if {[llength $wave] > 0} {
    wave format logic $wave
}

# 数据信号以十进制显示
set wave [find signals /dds_tb/wave_out]
if {[llength $wave] > 0} {
    wave format unsigned $wave
}

set wave [find signals /dds_tb/dds_inst/key_ctrl/amplitude]
if {[llength $wave] > 0} {
    wave format unsigned $wave
}

set wave [find signals /dds_tb/dds_inst/key_ctrl/freq_word]
if {[llength $wave] > 0} {
    wave format unsigned $wave
}

# 运行仿真
echo "=== 运行仿真 ==="
run 50ms

echo "=== 仿真完成 ==="

# 打开波形窗口
view wave
wave zoom full
