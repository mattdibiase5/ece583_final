`timescale 10us / 10ns
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/14/2020 10:49:20 AM
// Design Name: 
// Module Name: lock
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


module lock(input pswrdOK, output statusLED, input clk, output controlPin, output neoPin, output pcPin);
    reg locked;
    reg prevLocked;
    reg pcSwitch;
    reg [3:0] pcTimer;
    reg [9:0] pos;
    reg [31:0] grbw;
    wire [607:0]rainbowGRBW;
    wire [607:0]rainbowWBRG;
    reg [5:0] led;
    reg [11:0] step;
    reg [959:0] colors;
    wire [960:0] colorsWithStart;
    reg [31:0] unlockedGRBW;
    reg [31:0] lockedGRBW;
    reg [32:0] timer30x1200ns;
    reg hold;
    
    wire [31:0] wbrg;
    
    assign colorsWithStart = {colors,1'b0};
    
    servoPWM s(pos, clk, controlPin);
    altSendString neo(colorsWithStart, hold, clk, neoPin);
    
    revColor r(grbw, wbrg);
    
    genvar gi;
    generate
        for (gi = 0; gi <= 18; gi = gi + 1) begin
            ledRainbow lR(gi, step, rainbowGRBW[((gi*32)+31):gi*32]);
            revColor r(rainbowGRBW[((gi*32)+31):gi*32], rainbowWBRG[((gi*32)+31):gi*32]);
        end
    endgenerate
    
    
    initial begin
        locked = 1;
        prevLocked = 0;
        pos = 0;
        unlockedGRBW = 32'hff000500;
        lockedGRBW = 32'h00ff0000;
        hold = 1;
        step = 0;
        pcSwitch = 1;
    end
    
    always @(posedge clk) begin
        timer30x1200ns = timer30x1200ns + 1;
        
     if (locked != prevLocked)
        begin
            if (~locked) begin
                colors = 0;
                step = 0;
                grbw = unlockedGRBW;
                timer30x1200ns = 0;
            end else begin
                colors = 0;
                grbw = lockedGRBW;
                timer30x1200ns = 0;
            end
        prevLocked = locked;
        pcSwitch = 0;
        pcTimer = 0;
        end 
        
        
        if (pswrdOK) begin
            locked = 0;
        end else if (~pswrdOK) begin
            locked = 1;
        end
                    
        if (pcTimer >= 14) begin
            pcSwitch = 1;
        end
    
        if (timer30x1200ns > 460800) begin            
                step = (step + 1)%1530;
                timer30x1200ns = 0;
                pcTimer = pcTimer + 1;
        end else if (timer30x1200ns > 230400) begin
            hold = 1;
            if (~locked)
                begin
                    colors[0*32+31:0*32] = wbrg;
                    colors[1*32+31:1*32] = wbrg;
                    colors[2*32+31:2*32] = wbrg;
                    colors[3*32+31:3*32] = wbrg;
                    colors[4*32+31:4*32] = wbrg;
                    colors[5*32+31:5*32] = 32'hff000000;
                    colors[29*32+31:29*32] = wbrg;
                    colors[28*32+31:28*32] = wbrg;
                    colors[27*32+31:27*32] = wbrg;
                    colors[26*32+31:26*32] = wbrg;
                    colors[25*32+31:25*32] = 32'hff000000;
                    colors[6 *32+31:6 *32] = rainbowWBRG[0 *32+31:0 *32];
                    colors[7 *32+31:7 *32] = rainbowWBRG[1 *32+31:1 *32];
                    colors[8 *32+31:8 *32] = rainbowWBRG[2 *32+31:2 *32];
                    colors[9 *32+31:9 *32] = rainbowWBRG[3 *32+31:3 *32];
                    colors[10*32+31:10*32] = rainbowWBRG[4 *32+31:4 *32];
                    colors[11*32+31:11*32] = rainbowWBRG[5 *32+31:5 *32];
                    colors[12*32+31:12*32] = rainbowWBRG[6 *32+31:6 *32];
                    colors[13*32+31:13*32] = rainbowWBRG[7 *32+31:7 *32];
                    colors[14*32+31:14*32] = rainbowWBRG[8 *32+31:8 *32];
                    colors[15*32+31:15*32] = rainbowWBRG[9 *32+31:9 *32];
                    colors[16*32+31:16*32] = rainbowWBRG[10*32+31:10*32];
                    colors[17*32+31:17*32] = rainbowWBRG[11*32+31:11*32];
                    colors[18*32+31:18*32] = rainbowWBRG[12*32+31:12*32];
                    colors[19*32+31:19*32] = rainbowWBRG[13*32+31:13*32];
                    colors[20*32+31:20*32] = rainbowWBRG[14*32+31:14*32];
                    colors[21*32+31:21*32] = rainbowWBRG[15*32+31:15*32];
                    colors[22*32+31:22*32] = rainbowWBRG[16*32+31:16*32];
                    colors[23*32+31:23*32] = rainbowWBRG[17*32+31:17*32];
                    colors[24*32+31:24*32] = rainbowWBRG[18*32+31:18*32];
                end
            else
                begin
                    colors[0*32+31:0*32] = wbrg;
                    colors[1*32+31:1*32] = wbrg;
                    colors[2*32+31:2*32] = wbrg;
                    colors[3*32+31:3*32] = wbrg;
                    colors[4*32+31:4*32] = wbrg;
                    colors[5*32+31:5*32] = wbrg;
                    colors[29*32+31:29*32] = wbrg;
                    colors[28*32+31:28*32] = wbrg;
                    colors[27*32+31:27*32] = wbrg;
                    colors[26*32+31:26*32] = wbrg;
                    colors[25*32+31:25*32] = wbrg;
                    colors[6*32+31:6*32] = wbrg;
                    colors[7*32+31:7*32] = wbrg;
                    colors[8*32+31:8*32] = wbrg;
                    colors[9*32+31:9*32] = wbrg;
                    colors[10*32+31:10*32] = wbrg;
                    colors[11*32+31:11*32] = wbrg;
                    colors[12*32+31:12*32] = wbrg;
                    colors[13*32+31:13*32] = wbrg;
                    colors[14*32+31:14*32] = wbrg;
                    colors[15*32+31:15*32] = wbrg;
                    colors[16*32+31:16*32] = wbrg;
                    colors[17*32+31:17*32] = wbrg;
                    colors[18*32+31:18*32] = wbrg;
                    colors[19*32+31:19*32] = wbrg;
                    colors[20*32+31:20*32] = wbrg;
                    colors[21*32+31:21*32] = wbrg;
                    colors[22*32+31:22*32] = wbrg;
                    colors[23*32+31:23*32] = wbrg;
                    colors[24*32+31:24*32] = wbrg;
                end
        end else if (timer30x1200ns > 10) begin
            hold = 0;
        end 
    end
        
    always @(locked) begin
        if (locked)
            pos = 0;
        if (~locked)
            pos = 1000;
    end
    
    assign statusLED = ~locked;
    assign pcPin = pcSwitch;
    
endmodule

module revColor (input [31:0] in, output [31:0] out);
    genvar gi;
    generate
        for (gi = 0; gi < 32; gi = gi + 1) begin
            assign out[gi] = in[31-gi];
        end
    endgenerate
endmodule