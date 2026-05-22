`timescale 1ns / 1ps

module uart_controller(
    input           clk,
    input           rst_n,
    
    input           uart_rx,
    output          uart_tx,
    
    output  reg [1:0]   wave_sel,
    output  reg [7:0]   amplitude,
    output  reg [31:0]  freq_word,
    output  reg [11:0]  phase_offset,
    output  reg         uart_valid
);

localparam BAUD_RATE = 9600;
localparam CLK_FREQ = 100000000;
localparam BAUD_CNT = CLK_FREQ / BAUD_RATE;

reg [7:0] tx_data;
reg tx_en;
wire tx_busy;

uart_rx uart_rx_inst(
    .clk(clk),
    .rst_n(rst_n),
    .rx(uart_rx),
    .data_out(rx_data),
    .data_valid(rx_valid)
);

uart_tx uart_tx_inst(
    .clk(clk),
    .rst_n(rst_n),
    .data_in(tx_data),
    .tx_en(tx_en),
    .tx(uart_tx),
    .tx_busy(tx_busy)
);

reg [7:0] rx_data;
reg rx_valid;
reg [3:0] cmd_state;
reg [7:0] cmd_buffer[3:0];

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        cmd_state <= 4'd0;
        wave_sel <= 2'd0;
        amplitude <= 8'd0;
        freq_word <= 32'd0;
        phase_offset <= 12'd0;
        uart_valid <= 1'b0;
    end else begin
        if(rx_valid) begin
            case(cmd_state)
                4'd0: begin
                    if(rx_data == 8'h53)
                        cmd_state <= 4'd1;
                end
                4'd1: begin
                    cmd_buffer[0] <= rx_data;
                    cmd_state <= 4'd2;
                end
                4'd2: begin
                    cmd_buffer[1] <= rx_data;
                    cmd_state <= 4'd3;
                end
                4'd3: begin
                    cmd_buffer[2] <= rx_data;
                    cmd_state <= 4'd4;
                end
                4'd4: begin
                    cmd_buffer[3] <= rx_data;
                    case(cmd_buffer[0])
                        8'h57: begin
                            wave_sel <= cmd_buffer[1][1:0];
                            uart_valid <= 1'b1;
                        end
                        8'h41: begin
                            amplitude <= cmd_buffer[1];
                            uart_valid <= 1'b1;
                        end
                        8'h46: begin
                            freq_word <= {cmd_buffer[3], cmd_buffer[2], cmd_buffer[1], cmd_buffer[0]};
                            uart_valid <= 1'b1;
                        end
                        8'h50: begin
                            phase_offset <= {cmd_buffer[2], cmd_buffer[1]};
                            uart_valid <= 1'b1;
                        end
                    endcase
                    cmd_state <= 4'd0;
                end
            endcase
        end
    end
end

endmodule

module uart_rx(
    input           clk,
    input           rst_n,
    input           rx,
    output  reg [7:0]   data_out,
    output  reg         data_valid
);

reg [12:0] baud_cnt;
reg [3:0] bit_cnt;
reg [7:0] shift_reg;
reg rx_sync;

always @(posedge clk) begin
    rx_sync <= rx;
end

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        baud_cnt <= 13'd0;
        bit_cnt <= 4'd0;
        data_out <= 8'd0;
        data_valid <= 1'b0;
    end else begin
        data_valid <= 1'b0;
        if(bit_cnt == 4'd0) begin
            if(!rx_sync) begin
                baud_cnt <= 13'd0;
                bit_cnt <= 4'd1;
            end
        end else begin
            if(baud_cnt == 13'd5207) begin
                baud_cnt <= 13'd0;
                if(bit_cnt <= 4'd8) begin
                    shift_reg <= {rx_sync, shift_reg[7:1]};
                    bit_cnt <= bit_cnt + 1'b1;
                end else begin
                    data_out <= shift_reg;
                    data_valid <= 1'b1;
                    bit_cnt <= 4'd0;
                end
            end else begin
                baud_cnt <= baud_cnt + 1'b1;
            end
        end
    end
end

endmodule

module uart_tx(
    input           clk,
    input           rst_n,
    input   [7:0]   data_in,
    input           tx_en,
    output  reg     tx,
    output  reg     tx_busy
);

reg [12:0] baud_cnt;
reg [3:0] bit_cnt;
reg [7:0] shift_reg;

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        tx <= 1'b1;
        tx_busy <= 1'b0;
        baud_cnt <= 13'd0;
        bit_cnt <= 4'd0;
    end else begin
        if(!tx_busy && tx_en) begin
            shift_reg <= data_in;
            tx <= 1'b0;
            tx_busy <= 1'b1;
            bit_cnt <= 4'd1;
            baud_cnt <= 13'd0;
        end else if(tx_busy) begin
            if(baud_cnt == 13'd5207) begin
                baud_cnt <= 13'd0;
                if(bit_cnt <= 4'd8) begin
                    tx <= shift_reg[0];
                    shift_reg <= {1'b0, shift_reg[7:1]};
                    bit_cnt <= bit_cnt + 1'b1;
                end else begin
                    tx <= 1'b1;
                    tx_busy <= 1'b0;
                    bit_cnt <= 4'd0;
                end
            end else begin
                baud_cnt <= baud_cnt + 1'b1;
            end
        end
    end
end

endmodule