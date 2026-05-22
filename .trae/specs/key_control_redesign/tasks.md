# 按键控制功能重新设计 - 实现计划

## [x] Task 1: 修改key_controller.v按键逻辑
- **Priority**: P0
- **Depends On**: None
- **Description**:
  - 将输入端口从`input [3:0] key`改为`input [4:0] key`
  - 移除amplitude输出和amplitude相关逻辑
  - 重新定义按键功能：
    - key[0]: wave_sel循环递增
    - key[1]: freq_word增加
    - key[2]: freq_word减少
    - key[3]: phase_offset增加
    - key[4]: phase_offset减少
- **Acceptance Criteria Addressed**: AC-1, AC-2, AC-3, AC-4
- **Test Requirements**:
  - `programmatic` TR-1.1: 代码编译通过
  - `programmatic` TR-1.2: 功能仿真波形正确

## [x] Task 2: 修改dds_top.v端口连接
- **Priority**: P0
- **Depends On**: Task 1
- **Description**:
  - 将key输入端口从[3:0]扩展为[4:0]
  - 更新key_controller实例化连接
  - 移除内部wire amplitude声明（如有）
- **Acceptance Criteria Addressed**: AC-5
- **Test Requirements**:
  - `programmatic` TR-2.1: 编译无错误
  - `programmatic` TR-2.2: 端口连接正确

## [x] Task 3: 修改dds_tb.v测试用例
- **Priority**: P0
- **Depends On**: Task 1, Task 2
- **Description**:
  - 将key信号扩展为5位
  - 更新测试序列覆盖新按键功能
  - 添加频率增减和相位增减测试
- **Acceptance Criteria Addressed**: AC-6
- **Test Requirements**:
  - `programmatic` TR-3.1: 编译无错误
  - `human-judgment` TR-3.2: 仿真波形显示所有按键功能正常

## [x] Task 4: 验证完整仿真
- **Priority**: P0
- **Depends On**: Task 3
- **Description**:
  - 执行编译脚本验证代码可编译
  - 运行仿真验证所有按键功能
- **Acceptance Criteria Addressed**: AC-7
- **Test Requirements**:
  - `programmatic` TR-4.1: 编译执行成功
  - `human-judgment` TR-4.2: 波形功能验证通过
