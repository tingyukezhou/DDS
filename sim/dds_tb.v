`timescale 1ns / 1ps

module dds_tb;

reg clk;
reg rst_n;
reg [3:0] key;
wire [11:0] wave_out;

wire [1:0] wave_sel;
wire [7:0] amplitude;
wire [31:0] freq_word;
wire [11:0] phase_offset;

dds_top dds_inst(
    .clk(clk),
    .rst_n(rst_n),
    .key(key),
    .uart_rx(1'b1),
    .uart_tx(),
    .wave_out(wave_out)
);

initial begin
    clk = 1'b0;
    forever #5 clk = ~clk;
end

initial begin
    rst_n = 1'b0;
    key = 4'b1111;
    #100 rst_n = 1'b1;
    
    #1000000;
    
    $display("=== 测试按键1: 波形选择 ===");
    key = 4'b1110;
    #2000000;
    key = 4'b1111;
    
    #5000000;
    
    $display("=== 测试按键2: 增加幅值 ===");
    key = 4'b1101;
    #2000000;
    key = 4'b1111;
    
    #5000000;
    
    $display("=== 测试按键3: 减小幅值 ===");
    key = 4'b1011;
    #2000000;
    key = 4'b1111;
    
    #5000000;
    
    $display("=== 测试按键4: 相位偏移增加 ===");
    key = 4'b0111;
    #2000000;
    key = 4'b1111;
    
    #5000000;
    
    $display("=== 测试按键4: 相位偏移继续增加 ===");
    key = 4'b0111;
    #2000000;
    key = 4'b1111;
    
    #5000000;
    
    $display("=== 测试按键1: 切换到方波 ===");
    key = 4'b1110;
    #2000000;
    key = 4'b1111;
    
    #5000000;
    
    $display("=== 测试按键1: 切换到三角波 ===");
    key = 4'b1110;
    #2000000;
    key = 4'b1111;
    
    #5000000;
    
    $display("=== 测试按键1: 切换到锯齿波 ===");
    key = 4'b1110;
    #2000000;
    key = 4'b1111;
    
    #5000000;
    
    $display("=== 仿真结束 ===");
    $finish;
end

initial begin
    $dumpfile("dds_tb.vcd");
    $dumpvars(0, dds_tb);
end

endmodule
