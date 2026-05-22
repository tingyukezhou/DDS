`timescale 1ns / 1ps

module key_controller(
    input           clk,
    input           rst_n,
    
    input   [4:0]   key,
    
    output  reg [1:0]   wave_sel,
    output  reg [31:0]  freq_word,
    output  reg [11:0]  phase_offset
);

reg [4:0] key_sync;
reg [4:0] key_edge;

always @(posedge clk) begin
    key_sync <= key;
    key_edge <= key_sync & ~key;
end

reg [19:0] debounce_cnt;
reg debounce_done;

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        debounce_cnt <= 20'd0;
        debounce_done <= 1'b0;
    end else if(|key_edge) begin
        debounce_cnt <= 20'd0;
        debounce_done <= 1'b0;
    end else if(debounce_cnt < 20'd1000000) begin
        debounce_cnt <= debounce_cnt + 1'b1;
        debounce_done <= 1'b0;
    end else begin
        debounce_done <= 1'b1;
    end
end

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        wave_sel <= 2'd0;
        freq_word <= 32'd1000000;
        phase_offset <= 12'd0;
    end else if(debounce_done && |key_edge) begin
        case(key_edge)
            5'b00001: begin
                wave_sel <= wave_sel + 1'b1;
            end
            5'b00010: begin
                if(freq_word < 32'd100000000)
                    freq_word <= freq_word + 32'd100000;
            end
            5'b00100: begin
                if(freq_word > 32'd1000000)
                    freq_word <= freq_word - 32'd100000;
            end
            5'b01000: begin
                phase_offset <= phase_offset + 12'd1024;
            end
            5'b10000: begin
                if(phase_offset >= 12'd1024)
                    phase_offset <= phase_offset - 12'd1024;
                else
                    phase_offset <= 12'd4095 - (12'd1024 - phase_offset);
            end
        endcase
    end
end

endmodule