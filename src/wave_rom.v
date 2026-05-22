`timescale 1ns / 1ps

module wave_rom(
    input           clk,
    input   [11:0]  addr,
    input   [1:0]   wave_sel,
    output  [11:0]  wave_data
);

reg [11:0] sine_rom[0:4095];
reg [11:0] square_rom[0:4095];
reg [11:0] triangle_rom[0:4095];
reg [11:0] sawtooth_rom[0:4095];

integer i;

initial begin
    for(i = 0; i < 4096; i = i + 1) begin
        sine_rom[i] = 12'd2048 + ($sin(2.0 * 3.1415926 * i / 4096.0) * 2047.0);
        square_rom[i] = (i < 2048) ? 12'd4095 : 12'd0;
        if(i < 1024)
            triangle_rom[i] = i * 4;
        else if(i < 3072)
            triangle_rom[i] = 4092 - (i - 1024) * 4;
        else
            triangle_rom[i] = (i - 3072) * 4;
        sawtooth_rom[i] = i;
    end
end

reg [11:0] data_out;

always @(posedge clk) begin
    case(wave_sel)
        2'd0: data_out <= sine_rom[addr];
        2'd1: data_out <= square_rom[addr];
        2'd2: data_out <= triangle_rom[addr];
        2'd3: data_out <= sawtooth_rom[addr];
    endcase
end

assign wave_data = data_out;

endmodule