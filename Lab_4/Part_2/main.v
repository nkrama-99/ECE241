`timescale 1ns / 1ns
module main(SW, KEY, LEDR, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5);
    input [9:0] SW;
    input [3:0] KEY;
    output [7:0] LEDR;
    output [6:0] HEX0;
    output [6:0] HEX1;
    output [6:0] HEX2;
    output [6:0] HEX3;
    output [6:0] HEX4;
    output [6:0] HEX5;

    seg7_HEX hex0 (.data(SW[3:0]), .HEX_display(HEX0));
    seg7_HEX hex1 (.data(4'b0000), .HEX_display(HEX2));
    seg7_HEX hex2 (.data(4'b0000), .HEX_display(HEX1));
    seg7_HEX hex3 (.data(4'b0000), .HEX_display(HEX3));

    ALU z(.a(SW[3:0]), .reset(SW[9]), .clk(~KEY[0]), .key(KEY[3:1]), .Rout(LEDR));

    seg7_HEX hex4 (.data(LEDR[3:0]), .HEX_display(HEX4));
    seg7_HEX hex5 (.data(LEDR[7:4]), .HEX_display(HEX5));

endmodule

module flip_flop(reset, clk, D, Q);
    input reset;
    input clk;
    input [7:0] D;
    output reg [7:0] Q;

    always@(posedge clk)//   triggered every time clock rises
        begin
            if (reset == 1'b1)//   when Reset  b is 1 (note this is tested on every rising clock edge)
                Q <= 0; // q is set to 0. Note that the assignment uses <= 
            else //   when Reset  b is not 0 
                Q <= D; //   value of d passes through to output q
    end

endmodule

module ALU(a, reset, clk, key, Rout);
    input [3:0] a;
    input [2:0] key;
    input clk;
    input reset;
    output [7:0] Rout;
    
    wire [7:0] adder_storage;
    reg [3:0] b;
    reg [7:0] ALUout;
    
    adder u1 (.a(a), .b(b), .ALUout(adder_storage));
    flip_flop u2 (.reset(reset), .clk(clk), .D(ALUout), .Q(Rout));

    always @(*)
    begin
        b = Rout[3:0];
        case(~key)
            3'b000: ALUout = adder_storage;
            3'b001: ALUout = a + b;
            3'b010: ALUout = {(~(a&b)), (~(a^b))}; // NAND(A, B), XNOR(A, B) concatenated
            3'b011: ALUout = a || b ? 8'b0001111: 8'b00000000;
            3'b100: ALUout = ((a[0] + a[1] + a[2] + a[3] == 1'b1) && (b[0] + b[1] + b[2] + b[3] == 2'b10)) ? 8'b1110000: 8'b00000000;
            3'b101: ALUout = {a, b};
            default: ALUout = 8'b00000000;
        endcase
    end

// The A and B inputs connect to switches SW 7−4 and SW 3−0 respectively.
// Use KEY 2−0 for the function inputs. Display ALU out[7:0] in binary on LEDR7−0;  
// have HEX0 and HEX2 display the values of B and A respectively and set HEX1 and HEX3 to 0. 
// HEX4 and HEX5 should display ALUout [3:0] and ALUout [7:4] respectively.
endmodule

module adder(a, b, ALUout);
    input [3:0] a;
    input [3:0] b;
    output [7:0] ALUout;
    wire c1, c2, c3;
    
    //             bit0, bit1, cin, sum, cout
    full_adder u1 (.bit0(a[0]), .bit1(b[0]), .cin(1'b0), .sum(ALUout[0]), .cout(c1));
    full_adder u2 (.bit0(a[1]), .bit1(b[1]), .cin(c1), .sum(ALUout[1]), .cout(c2));
    full_adder u3 (.bit0(a[2]), .bit1(b[2]), .cin(c2), .sum(ALUout[2]), .cout(c3));
    full_adder u4 (.bit0(a[3]), .bit1(b[3]), .cin(c3), .sum(ALUout[3]), .cout(ALUout[4]));
    assign ALUout[5] = 0;
    assign ALUout[6] = 0;
    assign ALUout[7] = 0;
endmodule

module full_adder(input bit0, bit1, cin,
                  output sum, cout);
    assign sum = bit0^bit1^cin;
    assign cout = (bit0&bit1)|(bit0&cin)|(bit1&cin);
endmodule

module seg7_HEX (data, HEX_display);
    input [0:3] data;
    output [6:0] HEX_display;

    assign HEX_display[0] = (~ data[0] & ~ data[1] & ~ data[2] & data[3]) | (~ data[0] & data[1] & ~ data[2] & ~ data[3]) | (data[0] & ~ data[1] & data[2] & data[3]) | (data[0] & data[1] & ~ data[2] & data[3]);
    assign HEX_display[1] = (data[0] & data[1] & data[2] & data[3]) | (data[0] & data[1] & data[2] & ~ data[3]) | (data[0] & data[1] & ~ data[2] & ~ data[3]) | (data[0] & ~ data[1] & data[2] & data[3]) | (~ data[0] & data[1] & data[2] & ~ data[3]) | (~ data[0] & data[1] & ~ data[2] & data[3]);
    assign HEX_display[2] = (data[0] & data[1] & data[2] & data[3]) | (data[0] & data[1] & data[2] & ~ data[3]) | (data[0] & data[1] & ~ data[2] & ~ data[3]) | (~ data[0] & ~ data[1] & data[2] & ~ data[3]);
    assign HEX_display[3] = (data[0] & data[1] & data[2] & data[3]) | (data[0] & ~ data[1] & data[2] & ~ data[3]) | (data[0] & ~ data[1] & ~ data[2] & data[3]) | (~ data[0] & data[1] & data[2] & data[3]) | (~ data[0] & data[1] & ~ data[2] & ~ data[3]) | (~ data[0] & ~ data[1] & ~ data[2] & data[3]);
    assign HEX_display[4] = (data[0] & ~ data[1] & ~ data[2] & data[3]) | (~ data[0] & data[1] & data[2] & data[3]) | (~ data[0] & data[1] & ~ data[2] & data[3]) | (~ data[0] & data[1] & ~ data[2] & ~ data[3]) | (~ data[0] & ~ data[1] & data[2] & data[3]) | (~ data[0] & ~ data[1] & ~ data[2] & data[3]);
    assign HEX_display[5] = (data[0] & data[1] & ~ data[2] & data[3]) | (~ data[0] & data[1] & data[2] & data[3]) | (~ data[0] & ~ data[1] & data[2] & data[3]) | (~ data[0] & ~ data[1] & data[2] & ~ data[3]) | (~ data[0] & ~ data[1] & ~ data[2] & data[3]);
    assign HEX_display[6] = (data[0] & data[1] & ~ data[2] & ~ data[3]) | (~ data[0] & data[1] & data[2] & data[3]) | (~ data[0] & ~ data[1] & ~ data[2] & data[3]) | (~ data[0] & ~ data[1] & ~ data[2] & ~ data[3]);
endmodule