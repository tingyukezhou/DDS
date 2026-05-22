`timescale 1ns / 1ps

module dds_tb;

reg clk;
reg rst_n;
reg [4:0] key;
wire [11:0] wave_out;

wire [1:0] wave_sel;
wire [31:0] freq_word;
wire [11:0] phase_offset;

dds_top dds_inst(
    .clk(clk),
    .rst_n(rst_n),
    .key(key),
    .wave_out(wave_out)
);

initial begin
    clk = 1'b0;
    forever #5 clk = ~clk;
end

initial begin
    rst_n = 1'b0;
    key = 5'b11111;
    #100 rst_n = 1'b1;
    
    #1000000;
    
    $display("=== 测试按键0: 波形切换到方波 ===");
    key = 5'b11110;
    #2000000;
    key = 5'b11111;
    
    #5000000;
    
    $display("=== 测试按键0: 波形切换到三角波 ===");
    key = 5'b11110;
    #2000000;
    key = 5'b11111;
    
    #5000000;
    
    $display("=== 测试按键0: 波形切换到锯齿波 ===");
    key = 5'b11110;
    #2000000;
    key = 5'b11111;
    
    #5000000;
    
    $display("=== 测试按键1: 频率增加 ===");
    key = 5'b11101;
    #2000000;
    key = 5'b11111;
    
    #5000000;
    
    $display("=== 测试按键1: 继续频率增加 ===");
    key = 5'b11101;
    #2000000;
    key = 5'b11111;
    
    #5000000;
    
    $display("=== 测试按键2: 频率减少 ===");
    key = 5'b11011;
    #2000000;
    key = 5'b11111;
    
    #5000000;
    
    $display("=== 测试按键3: 相位增加 (+90度) ===");
    key = 5'b10111;
    #2000000;
    key = 5'b11111;
    
    #5000000;
    
    $display("=== 测试按键4: 相位减少 (-90度) ===");
    key = 5'b01111;
    #2000000;
    key = 5'b11111;
    
    #5000000;
    
    $display("=== 测试按键0: 波形切换回正弦波 ===");
    key = 5'b11110;
    #2000000;
    key = 5'b11111;
    
    #5000000;
    
    $display("=== 仿真结束 ===");
    $finish;
end

initial begin
    $dumpfile("dds_tb.vcd");
    $dumpvars(0, dds_tb);
end

endmodule