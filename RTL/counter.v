module counter (
    input wire clk,
    input wire reset,
    output reg [3:0] count
);

    always @(posedge clk) begin
        if (reset) begin
            count <= 4'd0;
        end else begin
            count <= count + 1'b1;
        end
    end

endmodule
