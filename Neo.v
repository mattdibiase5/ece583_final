`timescale 10us / 10ns
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/14/2020 12:26:15 PM
// Design Name: 
// Module Name: sendNeoBit
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


module sendNeoBit(input wire [1:0] bitToSend, input clk, output reg controlPin, output reg timer1200nsOut);
  //bitToSend 0: 0, 1: 1, 2: RESET
  //clk pulses every 10 ns
  
  reg [6:0] timer1200ns;  // 120
  reg [3:0] timer100ns;   // 10
  wire [2:0] highTime;
  reg [3:0] currentTime;
  
  initial
    begin
      timer1200ns = 0;
      timer100ns = 0;
      currentTime = 0;
      controlPin = 0;
    end
  
  always @(posedge clk) 
    begin
      timer100ns = timer100ns + 1;
      timer1200ns = timer1200ns + 1;
      
      if (timer1200ns >= 120)
        begin
          timer1200ns = 0;
          timer1200nsOut = 1;
          currentTime = 0;
          controlPin = 1;
        end
      
      if (timer100ns >= 10)
        begin
          timer100ns = 0;
          currentTime = currentTime + 1;
          timer1200nsOut = 0;
          //timer1200ns = timer1200ns + 10;
        end
      
      if (currentTime > highTime)
        begin
          controlPin = 0;
        end
      
    end
  

  assign highTime = (bitToSend == 0) ? 3 : (bitToSend == 1) ? 6 : 0;
  
endmodule

module sendNeoWord(input wire [31:0] grbw, input hold, input clk, output controlPin); //, output [1:0] bitToSend);
    //wire timer1200nsA;  // 120
    reg [6:0] timer1200nsB; 
    reg [5:0] curBit;
    reg [1:0] bitToSend;
    
    sendNeoBit s(bitToSend, clk, controlPin, timer1200nsA);

    initial
      begin
        bitToSend = 2;
        curBit = 0;
        timer1200nsB = 0;
      end

    always @(posedge clk) 
      begin
        timer1200nsB = timer1200nsB + 1;
        
        if (timer1200nsB >= 120) begin
            bitToSend = (hold) ? 2 : grbw[31-curBit];
            curBit = curBit + 1;
            timer1200nsB = 0;
        end
        
        if (curBit >= 32 || hold)
          begin
          	curBit = 0;
          end
              
      end
  
endmodule

module altSendString(input [960:0] colors, input hold, input clk, output controlPin); //, output [1:0] bitToSend);
    wire timer1200nsA;  // 120
    reg [6:0] timer1200nsB; 
  	reg [10:0] curBit;
    reg [1:0] bitToSend;
    
    sendNeoBit s(bitToSend, clk, controlPin, timer1200nsA);

    initial
      begin
        bitToSend = 2;
        curBit = 0;
        timer1200nsB = 0;
      end

    always @(posedge clk) 
      begin
        timer1200nsB = timer1200nsB + 1;
        
        if (timer1200nsB >= 120) begin
          	bitToSend = (hold) ? 2 : colors[curBit];//(curBit/32)*32 + (31-(curBit%32))];
            curBit = curBit + 1;
            timer1200nsB = 0;
        end
        
        if (hold)
          begin
          	curBit = 0;
          end
              
      end
  
endmodule

module send30NeoString(input [29:0][31:0] colors, input send, input clk, output controlPin);
    
  reg [32:0] timer30x1200nsC;
  reg hold;
  wire [31:0] curGRBW;
  reg [4:0] led;
    
  sendNeoWord n(curGRBW, hold, clk, neoPin);


  initial begin
    hold = 1;
    timer30x1200nsC = 0;
    led = 0;
  end

  always @(negedge clk) begin
    timer30x1200nsC = timer30x1200nsC + 1;
    
    if (((timer30x1200nsC-11) % (120*32) == 0) && timer30x1200nsC > 120)
      led = led + 1;
      
    if (send && timer30x1200nsC > 116000)
      timer30x1200nsC = 0;
    
    if (timer30x1200nsC > 115220) begin // extra 10 just to be sure
      hold = 1;
    end else if (timer30x1200nsC == 10) begin
      hold = 0;
      led = 0;
    end
  end
  
  assign curGRBW = colors[led];
  	

endmodule

// Code your design here
module ledRainbow(input [5:0] led, input [11:0] step, output [31:0] color);
  
  wire [7:0] green;
  wire [7:0] red;
  wire [7:0] blue;
  
  assign color[31:24] = green;
  assign color[23:16] = red;
  assign color[15:8] = blue;
  assign color[7:0] = 0;
  
  wire [11:0] x;
  assign x = ((led*85)+step)%1530;
  
  assign red = (x >= 0 && x <= 255) ? 255 : (x >= 256 && x <= 511) ? (255 - (x - 255)) : (x >= 512 && x <= 767) ? 0 : (x >= 768 && x <= 1023) ? 0 : (x >= 1024 && x <= 1279) ? (x-1023) : (x >= 1280 && x <= 1529) ? 255 : 0;
  
  
  
  assign green = (x >= 0 && x <= 255) ? x : (x >= 256 && x <= 511) ? 255 : (x >= 512 && x <= 767) ? 255 : (x >= 768 && x <= 1023) ? (255-(x-768)) : (x >= 1024 && x <= 1279) ? 0 : (x >= 1280 && x <= 1529) ? 0 : 0;
  
  
  
  assign blue = (x >= 0 && x <= 255) ? 0 : (x >= 256 && x <= 511) ? 0 : (x >= 512 && x <= 767) ? (x-512) : (x >= 768 && x <= 1023) ? 255 : (x >= 1024 && x <= 1279) ? 255 : (x >= 1280 && x <= 1529) ? (255-(x-1278)) : 0;
  
endmodule