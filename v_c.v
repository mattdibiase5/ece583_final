`timescale 1ns / 1ps

module v_c(
    input clk25,
    input enVC,
    output reg [15:0] VCV = 0
);
    always @(posedge clk25) begin
        VCV <= (enVC == 1) ? ((VCV < 524) ? VCV + 1 : 0) : VCV;
    end

endmodule


