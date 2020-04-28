`timescale 10us / 10ns
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/07/2020 11:50:59 AM
// Design Name: 
// Module Name: servoPWM
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



module servoPWM(input wire [9:0] pos, input clk, output reg controlPin);
//module servoPWM(input clk, output reg controlPin);
  //pos is a value 0 - 1000
  //clk pulses every 10 ns
  
  /*
  reg [9:0] pos;
  reg direction;
  */
  reg [20:0] timer20ms; // 2 000 000
  reg [7:0] timer1us;   // 100
  wire [10:0] highTime;
  reg [14:0] currentTime;
  
  initial
    begin
      timer20ms = 0;
      timer1us = 0;
      currentTime = 0;
      /*
      pos = 0;
      direction = 1;
      */
    end
  
  always @(posedge clk) 
    begin
      timer20ms = timer20ms + 1;
      timer1us = timer1us + 1;
      
      if (timer20ms >= 2000000)
        begin
          timer20ms = 0;
          currentTime = 0;
          controlPin = 1;
          /*
          if (direction)
            pos = pos + 10;
          if (~direction)
            pos = pos - 10;
          if (pos > 1000)
             direction = 0;
          if (pos <= 0)
             direction = 1;
          */
        end
      
      if (timer1us >= 100)
        begin
          timer1us = 0;
          currentTime = currentTime + 1;
        end
      
      if (currentTime >= highTime)
        begin
          controlPin = 0;
        end
      
    end
  
  
    assign highTime = 1000 + pos;
    
  
endmodule
