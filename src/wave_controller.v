`timescale 1ns / 1ps

module wave_controller(
    input           clk,
    input           rst_n,
    
    input   [1:0]   wave_sel,
    input   [7:0]   amplitude,
    
    input   [11:0]  wave_raw,
    output  [11:0]  wave_out
);

reg [11:0] wave_scaled;

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        wave_scaled <= 12'd0;
    end else begin
        wave_scaled <= (wave_raw * amplitude) >> 8;
    end
end

assign wave_out = wave_scaled;

endmodule