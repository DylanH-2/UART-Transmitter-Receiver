module uart_rx (
    input wire clk,
    input wire reset,
    input wire tick,
    input wire rx,
    output reg [7:0] rx_data,
    output reg rx_done
);

    localparam IDLE  = 2'd0;
    localparam START = 2'd1;
    localparam DATA  = 2'd2;
    localparam STOP  = 2'd3;

    reg [1:0] state;
    reg [2:0] bit_index;
    reg [7:0] shift_reg;

    always @(posedge clk) begin
        if (reset) begin
            state     <= IDLE;
            bit_index <= 3'd0;
            shift_reg <= 8'd0;

            rx_data <= 8'd0;
            rx_done <= 1'b0;
        end else begin
            rx_done <= 1'b0;

            case (state)
                IDLE: begin
                    if (rx == 1'b0) begin
                        state <= START;
                    end
                end

                START: begin
                    if (tick) begin
                        bit_index <= 3'd0;
                        state     <= DATA;
                    end
                end

                DATA: begin
                    if (tick) begin
                        shift_reg[bit_index] <= rx;

                        if (bit_index == 3'd7) begin
                            state <= STOP;
                        end else begin
                            bit_index <= bit_index + 1'b1;
                        end
                    end
                end

                STOP: begin
                    if (tick) begin
                        rx_data <= shift_reg;
                        rx_done <= 1'b1;
                        state   <= IDLE;
                    end
                end
            endcase
        end
    end

endmodule
