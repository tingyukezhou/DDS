# ModelSim仿真测试脚本 - 实现计划

## [x] Task 1: 更新测试bench，移除UART相关代码
- **Priority**: P0
- **Depends On**: None
- **Description**: 
  - 修改dds_tb.v，移除uart_rx和uart_tx信号
  - 更新顶层模块实例化，不连接UART端口
  - 保留按键控制逻辑用于验证
- **Acceptance Criteria Addressed**: AC-2
- **Test Requirements**:
  - `programmatic` TR-1.1: 编译无错误
  - `human-judgment` TR-1.2: 测试bench仅包含按键控制相关代码
- **Notes**: 需要保持原有按键测试序列

## [x] Task 2: 创建ModelSim编译脚本(compile.do)
- **Priority**: P0
- **Depends On**: None
- **Description**: 
  - 创建编译脚本，定义库和编译顺序
  - 编译src目录下所有Verilog源文件
  - 编译sim目录下测试文件
- **Acceptance Criteria Addressed**: AC-1
- **Test Requirements**:
  - `programmatic` TR-2.1: 执行脚本后无编译错误
  - `programmatic` TR-2.2: 所有模块成功编译到work库
- **Notes**: 需要按依赖顺序编译模块

## [x] Task 3: 创建仿真运行脚本(simulate.do)
- **Priority**: P0
- **Depends On**: Task 2
- **Description**: 
  - 创建仿真运行脚本
  - 设置仿真时长和波形文件
  - 运行仿真并自动打开波形查看器
- **Acceptance Criteria Addressed**: AC-4
- **Test Requirements**:
  - `programmatic` TR-3.1: 仿真能够正常启动
  - `human-judgment` TR-3.2: 波形查看器自动打开并显示信号
- **Notes**: 需要配置正确的仿真时长

## [x] Task 4: 创建波形配置脚本(wave.do)
- **Priority**: P1
- **Depends On**: Task 3
- **Description**: 
  - 创建波形配置脚本
  - 组织关键信号到波形窗口
  - 设置信号显示格式和颜色
- **Acceptance Criteria Addressed**: AC-3
- **Test Requirements**:
  - `human-judgment` TR-4.1: 关键信号正确分组显示
  - `human-judgment` TR-4.2: 信号显示格式清晰可读
- **Notes**: 显示clk、rst_n、key、wave_sel、amplitude、freq_word、wave_out等信号

## [x] Task 5: 创建主脚本(run_all.do)
- **Priority**: P1
- **Depends On**: Task 2, Task 3, Task 4
- **Description**: 
  - 创建一键运行脚本
  - 依次调用编译、仿真、波形配置脚本
  - 提供完整的自动化仿真流程
- **Acceptance Criteria Addressed**: AC-4
- **Test Requirements**:
  - `programmatic` TR-5.1: 执行脚本后完成整个仿真流程
  - `human-judgment` TR-5.2: 用户只需执行一个脚本即可完成所有操作
- **Notes**: 添加清理和日志输出功能
