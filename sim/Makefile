SIM_DIR := .
SRC_DIR := ../src

VERILOG_FILES := \
    $(SRC_DIR)/dds_top.v \
    $(SRC_DIR)/phase_accumulator.v \
    $(SRC_DIR)/wave_rom.v \
    $(SRC_DIR)/wave_controller.v \
    $(SRC_DIR)/key_controller.v \
    $(SRC_DIR)/uart_controller.v \
    $(SIM_DIR)/dds_tb.v

TOP_MODULE := dds_tb
VCD_FILE := dds_tb.vcd

all: sim

sim:
	iverilog -o dds_tb $(VERILOG_FILES)
	vvp dds_tb

clean:
	rm -f dds_tb $(VCD_FILE)