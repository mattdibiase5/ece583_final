`timescale 1ns / 1ps

module h_c(
    input clk25,
    output reg enVC = 0,
    output reg [15:0] HCV = 0
);
    always @(posedge clk25) begin
        HCV <= (HCV < 799) ? HCV + 1 : 0;
        enVC <= (HCV < 799) ? 0 : 1;
    end
endmodule