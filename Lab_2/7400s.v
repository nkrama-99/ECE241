`timescale 1ns / 1ns

module mux (LEDR, SW);
	input [2:0]SW;
	output [1:0]LEDR;
	wire w1, w2, w3;
	
	v7404 u1(.pin1(SW[2]), .pin2(w1));
	v7408 u2(.pin1(SW[0]), .pin2(w1), .pin3(w2), .pin4(SW[1]), .pin5(SW[2]), .pin6(w3));
	v7432 u3(.pin1(w2), .pin2(w3), .pin3(LEDR[0]));
endmodule 

module v7404 (input pin1, pin3, pin5, pin7, pin9, pin11, 
              output pin2, pin4, pin6, pin8, pin10, pin12);
    assign pin2 = ~pin1;
    assign pin4 = ~pin3;
    assign pin6 = ~pin5;
    assign pin8 = ~pin7;
    assign pin10 = ~pin9;
    assign pin12 = ~pin11;
endmodule

module v7432 (input pin1, pin2, pin4, pin5, pin7, pin8, pin10, pin11,
              output pin3, pin6, pin9, pin12);
    assign pin3 = pin1|pin2;
    assign pin6 = pin4|pin5;
    assign pin9 = pin7|pin8;
    assign pin12 = pin10|pin11;
endmodule

module v7408 (input pin1, pin2, pin4, pin5, pin7, pin8, pin10, pin11,
              output pin3, pin6, pin9, pin12);
    assign pin3 = pin1&pin2;
    assign pin6 = pin4&pin5;
    assign pin9 = pin7&pin8;
    assign pin12 = pin10&pin11;
endmodule