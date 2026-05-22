`timescale 1ns / 1ps

module phase_accumulator(
    input           clk,
    input           rst_n,
    input   [31:0]  freq_word,
    input   [11:0]  phase_offset,
    output  [11:0]  phase_out
);

reg [31:0] phase_acc;

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        phase_acc <= 32'd0;
    end else begin
        phase_acc <= phase_acc + freq_word;
    end
end

assign phase_out = phase_acc[31:20] + phase_offset;

endmodule