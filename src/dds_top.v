`timescale 1ns / 1ps

module dds_top(
    input           clk,
    input           rst_n,
    
    input   [3:0]   key,
    
    output  [11:0]  wave_out
);

key_controller key_ctrl(
    .clk(clk),
    .rst_n(rst_n),
    .key(key),
    .wave_sel(wave_sel),
    .amplitude(amplitude),
    .freq_word(freq_word),
    .phase_offset(phase_offset)
);

wire [1:0] wave_sel;
wire [7:0] amplitude;
wire [31:0] freq_word;
wire [11:0] phase_offset;

wire [11:0] phase_out;

phase_accumulator phase_acc(
    .clk(clk),
    .rst_n(rst_n),
    .freq_word(freq_word),
    .phase_offset(phase_offset),
    .phase_out(phase_out)
);

wire [11:0] wave_raw;

wave_rom rom(
    .clk(clk),
    .addr(phase_out),
    .wave_sel(wave_sel),
    .wave_data(wave_raw)
);

wave_controller wave_ctrl(
    .clk(clk),
    .rst_n(rst_n),
    .wave_sel(wave_sel),
    .amplitude(amplitude),
    .wave_raw(wave_raw),
    .wave_out(wave_out)
);

endmodule