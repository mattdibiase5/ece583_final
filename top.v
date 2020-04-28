`timescale 1ns / 1ps
`define FONT 12'hFFF
`define FONT0 12'hFFF
`define FONT1 12'hFFF
`define FONT2 12'hFFF
`define FONT3 12'hFFF
`define FONT4 12'hFFF
`define FONT5 12'hFFF
`define FONT6 12'hFFF
`define FONT7 12'hFFF
`define FONT8 12'hFFF
`define FONT9 12'hFFF
`define FONT10 12'hFFF
`define FONT11 12'hFFF
`define FONT12 12'hFFF
`define FONT13 12'hFFF
`define FONT14 12'hFFF
`define FONT15 12'hFFF
`define FONT16 12'hFFF
`define FONT17 12'hFFF
`define FONT18 12'hFFF
`define FONT19 12'hFFF

module top(
    input clk,
    input PS2_DATA,
    input PS2_CLK,
    output statusLED,
    output neoPin,
    output pcPin,
    output pw,
    output HS,
    output VS,
    output [3:0] R,
    output [3:0] G,
    output [3:0] B,
    output [8:1] LED,
    output controlPin
    );
    reg init = 0;

//    (* ram_style = "block" *)
//    reg [11:0] mem[0:18699]; // memory for frames
    wire [3:0] red;
    wire [3:0] green;
    wire [3:0] blue;
    wire [11:0] rgb;


    wire clk25;
    wire clk50;
    wire [15:0] HCV;
    wire [15:0] VCV;
    wire enVC;
    clk_div div25 (clk, clk50,clk25); //  clock divider
    h_c H_C (clk25,enVC,HCV); // horizontal count
    v_c V_C (clk25,enVC,VCV); // vertical count

    wire par;
    wire [7:0] scan_code;
    PS2_receive ps2 (PS2_CLK,PS2_DATA,par,scan_code); // ps/2 receive packet

//    assign LED[1] = scan_code[0];
//    assign LED[2] = scan_code[1];
//    assign LED[3] = scan_code[2];
//    assign LED[4] = scan_code[3];
//    assign LED[5] = scan_code[4];
//    assign LED[6] = scan_code[5];
//    assign LED[7] = scan_code[6];
//    assign LED[8] = scan_code[7];

    reg rw0= 0;
    reg rw1 = 0;
    reg [11:0] rgb_write0; // ((HCV-144) >> 2) % 170) + (((VCV-35) >> 2) * 170)
    reg [11:0] rgb_write1;

    video_ram vram (clk,v,h,VCV,HCV,init == 1 ? rgb_write1 : rgb_write0,init == 1 ? rw1 : rw0,rgb);

    wire [19:0] char;
    reg [8:0] ypos = 10;
    reg [8:0] xpos = 4;
    characters ch (scan_code,par,clk,char);
        // initialize memory to white screen
    always @(negedge clk) begin
        if (init  == 0) begin
            rw0 <= 1;
            rgb_write0 <= 12'h000;
        end
        if (VCV == 515 && HCV == 784)
            init <= 1;

    end

    reg [9:0] h;
    reg [9:0] v;
    reg [4:0] cnt = 0;
    
    reg [31:0] parcnt = 0;
    reg par_quick = 0;
    always @(negedge clk) begin
        if (par == 1) begin
            parcnt <= parcnt + 1;
            if (parcnt == 0) begin
                par_quick <= 1;
            end
            else if (parcnt == 1) begin
                par_quick <= 0;
            end
        end
        else begin
            parcnt <= 0;
        end
    end
    
    always @(posedge clk) begin

        if (parcnt == 1 && (cnt == 21 || cnt == 0)) begin
            cnt <= char != 20'hFFFFF ? 1 : 0;
            rw1 <= (char != 20'hFFFFF && scan_code != 8'hF0 && scan_code != 0) ? 1 : 0;
        end
        else if (cnt == 0 || cnt > 20) begin
            rw1 <= 0;
        end
        else if (cnt > 0) begin
            if (cnt == 20 && char != 20'hFFFFF) begin
                if (xpos >  275) begin
                    ypos <= (ypos < 200) ? ypos + 8 : 4;
                    xpos <= 4;
                end
                else begin
                     xpos = xpos + 6;
                end

            end
            cnt <= cnt != 21 ? (cnt + 1): cnt;
        end
       
    end
    always @(negedge clk) begin
        if (cnt > 0 && cnt < 21 && char != 20'hFFFFF) begin
            rgb_write1 <= (char[20-cnt] == 1) ? `FONT : 12'h000;
            h <= xpos + ((cnt-1) % 4);
            v <= ypos + ((cnt-1) / 4);
        end
    end



    assign red = {rgb[11],rgb[10],rgb[9],rgb[8]};
    assign green = {rgb[7],rgb[6],rgb[5],rgb[4]};
    assign blue = {rgb[3],rgb[2],rgb[1],rgb[0]};


    assign HS = (HCV < 96) ? 1 : 0;
    assign VS = (VCV < 2) ? 1 : 0;
    assign R = (HCV < 784 && HCV >= 144 && VCV < 515 && VCV >= 35) ? red : 4'h0;
    assign G = (HCV < 784 && HCV >= 144 && VCV < 515 && VCV >= 35) ? green : 4'h0;
    assign B = (HCV < 784 && HCV >= 144 && VCV < 515 && VCV >= 35) ? blue : 4'h0;

//    assign led = scan_code == 8'h5A;
    reg [7:0] sc;
    always @(posedge clk) begin
        sc <= scan_code;
    end
    reg [63:0] password = 64'h4d1c1b1b1d442d23;
    reg [63:0] password_in = 0;
    always @(posedge par) begin:brad
        if (sc != 0 && char != 20'hFFFFF) begin
            password_in <= (password_in << 8) | sc;
        end
    end
    assign pw = password == password_in;
    lock L(pw,statusLED,clk,controlPin,neoPin,pcPin);
endmodule
