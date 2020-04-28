`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/27/2020 03:25:44 PM
// Design Name: 
// Module Name: PS2_receive
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


module PS2_receive(
    input PS2_CLK,
    input PS2_DATA,
    output reg par = 0,
    output reg [7:0] sc
    );
    reg [3:0] count = 0;
    reg start;
    reg [7:0] scan_code;
    always @(negedge PS2_DATA or posedge PS2_CLK) begin
        if (!PS2_DATA) begin
            if (count == 0) begin
                start <= 1;
            end
        end
        else if (PS2_DATA && PS2_CLK) begin
            if (count == 10) begin
                start <= 0;
            end
        end
    end
    
    always @(negedge PS2_CLK) begin
        if (count == 10 && !start) begin
                par <= 0;
                count <= 0;
        end
        else if (start) begin
            count <= (count == 0) ? (!PS2_DATA ? count + 1 : 0) : ((count == 10) ? 0 : count + 1);
            if (count == 10) begin
                par <= 0;
            end
            if (count > 0 && count < 9) begin
                scan_code[count-1] <= PS2_DATA;
            end
            else if (count == 9) begin
                par <= 1;
            end
        end
    end
    
    always @(posedge par) begin
        sc <= (sc != 8'hF0) ? scan_code : 0;
    end
    
endmodule
