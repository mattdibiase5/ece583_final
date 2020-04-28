`timescale 1ns / 1ps


module clk_div(
    input clk,
    output reg _clk50 = 0,
    output reg _clk25 = 0
);

    always @(posedge clk) begin
        _clk50 = ~_clk50;      
    end
    always  @(posedge _clk50) begin
        _clk25 =  ~_clk25;
    end
endmodule