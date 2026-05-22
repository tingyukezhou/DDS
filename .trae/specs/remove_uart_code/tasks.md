# 剔除UART相关代码 - 实现计划

## [x] Task 1: 删除uart_controller.v文件
- **Priority**: P0
- **Depends On**: None
- **Description**: 
  - 删除/workspace/src/uart_controller.v文件
- **Acceptance Criteria Addressed**: AC-1
- **Test Requirements**:
  - `programmatic` TR-1.1: 文件不存在于src目录
- **Notes**: 此文件包含uart_controller、uart_rx、uart_tx三个模块

## [x] Task 2: 修改dds_top.v移除UART相关代码
- **Priority**: P0
- **Depends On**: None
- **Description**: 
  - 移除uart_rx和uart_tx端口声明
  - 移除UART相关的wire声明（wave_sel_uart, amplitude_uart, freq_word_uart, phase_offset_uart, uart_valid）
  - 移除uart_controller实例化
  - 修改控制信号赋值，直接使用按键控制器输出
- **Acceptance Criteria Addressed**: AC-2
- **Test Requirements**:
  - `programmatic` TR-2.1: 编译无错误
  - `programmatic` TR-2.2: 文件中不包含uart关键字
- **Notes**: 需要保持按键控制信号直接连接到后续模块

## [x] Task 3: 修改dds_tb.v移除UART端口连接
- **Priority**: P0
- **Depends On**: Task 2
- **Description**: 
  - 修改dds_top实例化，移除uart_rx和uart_tx端口连接
- **Acceptance Criteria Addressed**: AC-3
- **Test Requirements**:
  - `programmatic` TR-3.1: 编译无错误
  - `programmatic` TR-3.2: 文件中不包含uart关键字
- **Notes**: 测试bench应仅保留按键控制测试序列

## [x] Task 4: 修改compile.do移除UART控制器编译
- **Priority**: P0
- **Depends On**: None
- **Description**: 
  - 删除uart_controller.v的编译命令
- **Acceptance Criteria Addressed**: AC-3
- **Test Requirements**:
  - `programmatic` TR-4.1: 文件中不包含uart_controller编译命令
- **Notes**: 保持其他模块编译顺序不变

## [x] Task 5: 验证编译和仿真
- **Priority**: P0
- **Depends On**: Task 1, Task 2, Task 3, Task 4
- **Description**: 
  - 执行编译脚本验证代码可编译
  - 运行仿真验证按键控制功能正常
- **Acceptance Criteria Addressed**: AC-4, AC-5
- **Test Requirements**:
  - `programmatic` TR-5.1: 编译脚本执行成功，无错误
  - `human-judgment` TR-5.2: 仿真波形显示按键控制功能正常
- **Notes**: 使用ModelSim执行仿真验证