`timescale 1ns / 1ps

module dds_top(
    input           clk,
    input           rst_n,
    
    input   [3:0]   key,
    
    input           uart_rx,
    output          uart_tx,
    
    output  [11:0]  wave_out
);

wire [1:0] wave_sel_key;
wire [7:0] amplitude_key;
wire [31:0] freq_word_key;
wire [11:0] phase_offset_key;

wire [1:0] wave_sel_uart;
wire [7:0] amplitude_uart;
wire [31:0] freq_word_uart;
wire [11:0] phase_offset_uart;

key_controller key_ctrl(
    .clk(clk),
    .rst_n(rst_n),
    .key(key),
    .wave_sel(wave_sel_key),
    .amplitude(amplitude_key),
    .freq_word(freq_word_key),
    .phase_offset(phase_offset_key)
);

uart_controller uart_ctrl(
    .clk(clk),
    .rst_n(rst_n),
    .uart_rx(uart_rx),
    .uart_tx(uart_tx),
    .wave_sel(wave_sel_uart),
    .amplitude(amplitude_uart),
    .freq_word(freq_word_uart),
    .phase_offset(phase_offset_uart)
);

wire [1:0] wave_sel = wave_sel_uart != 2'd0 ? wave_sel_uart : wave_sel_key;
wire [7:0] amplitude = amplitude_uart != 8'd0 ? amplitude_uart : amplitude_key;
wire [31:0] freq_word = freq_word_uart != 32'd0 ? freq_word_uart : freq_word_key;
wire [11:0] phase_offset = phase_offset_uart != 12'd0 ? phase_offset_uart : phase_offset_key;

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