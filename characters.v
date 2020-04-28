`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 03/28/2020 01:39:11 PM
// Design Name:
// Module Name: characters
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


module characters(
    input [7:0] scan_code,
    input par,
    input clk,
    output reg [19:0] char = 0
);
    reg [19:0] A = 20'hF9F99;
    reg [19:0] B = 20'hE9E9E;
    reg [19:0] C = 20'hF888F;
    reg [19:0] D = 20'hE999E;
    reg [19:0] E = 20'hF8E8F;
    reg [19:0] F = 20'hF8E88;
    reg [19:0] G = 20'hF8B9F;
    reg [19:0] H = 20'h99F99;
    reg [19:0] I = 20'hE444E;
    reg [19:0] J = 20'h1119F;
    reg [19:0] K = 20'h9ACA9;
    reg [19:0] L = 20'h8888F;
    reg [19:0] M = 20'hFF999;
    reg [19:0] N = 20'h9DFB9;
    reg [19:0] O = 20'hF999F;
    reg [19:0] P = 20'hF9F88;
    reg [19:0] Q = 20'h699B7;
    reg [19:0] R = 20'hE9E99;
    reg [19:0] S = 20'hF8F1F;
    reg [19:0] T = 20'hE4444;
    reg [19:0] U = 20'h9999F;
    reg [19:0] V = 20'hAAA44;
    reg [19:0] W = 20'h999FF;
    reg [19:0] X = 20'h96699;
    reg [19:0] Y = 20'h99F44;
    reg [19:0] Z = 20'hF36CF;
    reg [19:0] _tilde = 20'h005A0;
    reg [19:0] _1 = 20'hC444E;
    reg [19:0] _2 = 20'hE1F8F;
    reg [19:0] _3 = 20'hF1F1F;
    reg [19:0] _4 = 20'h99F11;
    reg [19:0] _5 = 20'hF8F1E;
    reg [19:0] _6 = 20'hF8F9F;
    reg [19:0] _7 = 20'hF1111;
    reg [19:0] _8 = 20'hF9F9F;
    reg [19:0] _9 = 20'hF9F11;
    reg [19:0] _0 = 20'hFD9BF;
    reg [19:0] _dash = 20'h00700;
    reg [19:0] _plus = 20'h02720;
    reg [19:0] _space = 20'h00000;
    reg [19:0] _period = 20'h00066;
    reg [19:0] _comma = 20'h00062;
    reg [19:0] _bracketL = 20'hC888C;
    reg [19:0] _bracketR = 20'h31113;
    reg [19:0] _slashF = 20'h136C8;
    reg [19:0] _slashB = 20'h8C631;
    reg [19:0] _semicolon = 20'h66062;
    reg [19:0] _colon = 20'h66066;
    reg [19:0] _backspace = 0;
    reg [19:0] INVALID = 20'hFFFFF;


    always @(scan_code) begin
//        if (par == 1) begin
            case (scan_code)
                8'h1C: char <= A;
                8'h32: char <= B;
                8'h21: char <= C;
                8'h23: char <= D;
                8'h24: char <= E;
                8'h2B: char <= F;
                8'h34: char <= G;
                8'h33: char <= H;
                8'h43: char <= I;
                8'h3B: char <= J;
                8'h42: char <= K;
                8'h4B: char <= L;
                8'h3A: char <= M;
                8'h31: char <= N;
                8'h44: char <= O;
                8'h4D: char <= P;
                8'h15: char <= Q;
                8'h2D: char <= R;
                8'h1B: char <= S;
                8'h2C: char <= T;
                8'h3C: char <= U;
                8'h2A: char <= V;
                8'h1D: char <= W;
                8'h22: char <= X;
                8'h35: char <= Y;
                8'h1A: char <= Z;
                8'h0E: char <= _tilde;
                8'h16: char <= _1;
                8'h1E: char <= _2;
                8'h26: char <= _3;
                8'h25: char <= _4;
                8'h2E: char <= _5;
                8'h36: char <= _6;
                8'h3D: char <= _7;
                8'h3E: char <= _8;
                8'h46: char <= _9;
                8'h45: char <= _0;
                8'h4E: char <= _dash;
                8'h55: char <= _plus;
                8'h29: char <= _space;
                8'h49: char <= _period;
                8'h41: char <= _comma;
                8'h54: char <= _bracketL;
                8'h5B: char <= _bracketR;
                8'h4A: char <= _slashF;
                8'h5D: char <= _slashB;
                8'h4C: char <= _colon;
                8'h66: char <= _backspace;
                default: char <= INVALID;
            endcase
//        end

    end
endmodule
