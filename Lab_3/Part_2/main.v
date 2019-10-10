module main(input [8:0]SW, output [9:0]LEDR);
    wire c1, c2, c3;
    
    //             bit0, bit1, cin, sum, cout
    full_adder u1 (.bit0(SW[0]), .bit1(SW[4]), .cin(SW[8]), .sum(LEDR[0]), .cout(c1));
    full_adder u2 (.bit0(SW[1]), .bit1(SW[5]), .cin(c1), .sum(LEDR[1]), .cout(c2));
    full_adder u3 (.bit0(SW[2]), .bit1(SW[6]), .cin(c2), .sum(LEDR[2]), .cout(c3));
    full_adder u4 (.bit0(SW[3]), .bit1(SW[7]), .cin(c3), .sum(LEDR[3]), .cout(LEDR[9]));
endmodule

module full_adder(input bit0, bit1, cin,
                  output sum, cout);
    assign sum = bit0^bit1^cin;
    assign cout = (bit0&bit1)|(bit0&cin)|(bit1&cin);
endmodule
