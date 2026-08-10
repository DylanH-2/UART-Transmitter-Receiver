module uart_tx (
    input wire clk,
    input wire reset,
    input wire tick,
    input wire tx_start,
    input wire [7:0] tx_data,
    output reg tx,
    output reg busy
);

    //==================================================
    // State Definitions
    //==================================================
    localparam IDLE  = 2'd0;
    localparam START = 2'd1;
    localparam DATA  = 2'd2;
    localparam STOP  = 2'd3;

    //==================================================
    // Internal Registers
    //==================================================
    reg [1:0] state;
    reg [2:0] bit_index;
    reg [7:0] data_reg;

    //==================================================
    // State Machine
    //==================================================
    always @(posedge clk) begin
        if (reset) begin
            state     <= IDLE;
            bit_index <= 3'd0;
            data_reg  <= 8'd0;

            tx   <= 1'b1;  // UART line idles high
            busy <= 1'b0;
        end else begin
            case (state)
                // ---------------------------------------------
                // IDLE
                // ---------------------------------------------
                IDLE: begin
                    tx   <= 1'b1;
                    busy <= 1'b0;

                    if (tx_start) begin
                        data_reg  <= tx_data;
                        bit_index <= 3'd0;

                        busy  <= 1'b1;
                        state <= START;
                    end
                end

                // ---------------------------------------------
                // START
                // ---------------------------------------------
                START: begin
                    tx   <= 1'b0;  // Hold the start bit on the line
                    busy <= 1'b1;

                    if (tick) begin
                        state <= DATA;
                    end
                end

                // ---------------------------------------------
                // DATA
                // ---------------------------------------------
                DATA: begin
                    busy <= 1'b1;

                    // Continuously drive the current data bit
                    tx <= data_reg[bit_index];

                    // Only advance on a baud tick
                    if (tick) begin
                        if (bit_index == 3'd7) begin
                            state <= STOP;
                        end else begin
                            bit_index <= bit_index + 1'b1;
                        end
                    end
                end

                // ---------------------------------------------
                // STOP
                // ---------------------------------------------
                STOP: begin
                    // We'll implement this later
                end
            endcase
        end
    end

endmodule