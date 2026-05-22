`timescale 1ns / 1ps

module dds_tb;

reg clk;
reg rst_n;
reg [3:0] key;
reg uart_rx;
wire [11:0] wave_out;
wire uart_tx;

dds_top dds_inst(
    .clk(clk),
    .rst_n(rst_n),
    .key(key),
    .uart_rx(uart_rx),
    .uart_tx(uart_tx),
    .wave_out(wave_out)
);

initial begin
    clk = 1'b0;
    forever #5 clk = ~clk;
end

initial begin
    rst_n = 1'b0;
    key = 4'b1111;
    uart_rx = 1'b1;
    #100 rst_n = 1'b1;
    
    #1000000;
    
    key = 4'b1110;
    #2000000;
    key = 4'b1111;
    
    #5000000;
    
    key = 4'b1101;
    #2000000;
    key = 4'b1111;
    
    #5000000;
    
    key = 4'b1011;
    #2000000;
    key = 4'b1111;
    
    #5000000;
    
    key = 4'b0111;
    #2000000;
    key = 4'b1111;
    
    #5000000;
    
    $finish;
end

initial begin
    $dumpfile("dds_tb.vcd");
    $dumpvars(0, dds_tb);
end

endmodule