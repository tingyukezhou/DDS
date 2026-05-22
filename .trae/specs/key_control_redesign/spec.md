# 按键控制功能重新设计规范

## Why
当前按键控制器仅支持4个按键，且功能包括幅值调节。用户希望简化为专注于波形选择和频率/相位调节的控制系统，以更好地适配实际应用需求。

## What Changes
- 将按键输入从4位扩展为5位（key[4:0]）
- 重新定义按键功能：
  - key[0]: 波形切换（4种波形循环）
  - key[1]: 频率增加
  - key[2]: 频率减少
  - key[3]: 相位增加
  - key[4]: 相位减少
- **移除幅值调节功能**，简化控制逻辑
- 更新顶层模块端口连接
- 更新测试bench适配新按键配置

## Impact
- Affected specs: remove_uart_code, modelsim_sim_scripts
- Affected code:
  - `src/key_controller.v` - 按键逻辑重新设计
  - `src/dds_top.v` - 端口扩展
  - `sim/dds_tb.v` - 测试用例更新

## ADDED Requirements
### Requirement: 波形切换功能
系统应提供通过按键循环切换4种波形的功能。

#### Scenario: 波形切换
- **WHEN** 按下key[0]且消抖完成
- **THEN** wave_sel在{00, 01, 10, 11}之间循环递增（00→01→10→11→00）

#### Scenario: 频率增加
- **WHEN** 按下key[1]且消抖完成
- **THEN** freq_word按设定步长增加，最大值限制在合理范围

#### Scenario: 频率减少
- **WHEN** 按下key[2]且消抖完成
- **THEN** freq_word按设定步长减少，最小值限制在合理范围

#### Scenario: 相位增加
- **WHEN** 按下key[3]且消抖完成
- **THEN** phase_offset增加90度对应值，达到最大值后归零

#### Scenario: 相位减少
- **WHEN** 按下key[4]且消抖完成
- **THEN** phase_offset减少90度对应值，达到最小值后跳到最大值

## MODIFIED Requirements
### Requirement: 按键输入位宽
**原需求**: 4位按键输入
**新需求**: 5位按键输入（key[4:0]）

### Requirement: 输出信号
**原需求**: 包含amplitude幅值控制信号
**新需求**: 移除amplitude输出，仅保留wave_sel、freq_word、phase_offset

## REMOVED Requirements
### Requirement: 幅值调节功能
**Reason**: 用户需求变更，当前应用场景不需要幅值调节
**Migration**: 已移除amplitude相关代码
