`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/31/2020 12:41:50 PM
// Design Name: 
// Module Name: video_ram
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module video_ram(
        input clk,
        input [8:0] i,
        input [8:0] j,
        input [15:0] VCV,
        input [15:0] HCV,
        input [11:0] wval,
        input rw,
        output [11:0] rval
    );

    wire [9:0] hcv = (HCV-144)>>1;
    wire [9:0] vcv = (VCV-35)>>1;
    wire [16:0] w_addr = j + (i*320);
    wire [16:0] r_addr = ((HCV < 784 && HCV >= 144 && VCV < 515 && VCV >= 35)) ? hcv + (vcv*320) : 76801;
    (* ram_style = "block" *)
    reg [11:0] vram[1:76801]; // memory for frames
    reg[11:0] rv = 0;
    always @(negedge clk) begin
        if (rw) begin
            vram[w_addr] <= wval;
        end
       
    end
    always @(posedge clk) begin
        rv <= vram[r_addr];
    end
    assign rval = rv;
//    assign rval = rw ? wval : vram[r_addr+1];
endmodule
