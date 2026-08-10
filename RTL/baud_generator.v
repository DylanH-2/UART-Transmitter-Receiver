module baud_generator #(
    parameter CLKS_PER_BIT = 8
) (
    input wire clk,
    input wire reset,
    output reg tick
);

    reg [15:0] counter;

    always @(posedge clk) begin
        if (reset) begin
            counter <= 0;
            tick    <= 0;
        end else begin
            if (counter == CLKS_PER_BIT - 1) begin
                counter <= 0;
                tick    <= 1;
            end else begin
                counter <= counter + 1;
                tick    <= 0;
            end
        end
    end

endmodule
