module xora(a, b, s, f);
    input a, b, s;
    output f;

    wire w1, w2, w3;
    not(w1, s);
    and(w2, s, a);
    and(w3, w1, b);
    or(f, w3, w2);
endmodule

module xorb(a, b, s, f);
    input a, b, s;
    output f;

    assign f = (s&a)|((~s)&b);
endmodule

module xorc(a, b, s, f);
    input a, b, s;
    output reg f;

    always@(*)
        begin
            if (s)
                f=a;
            else if (~s)
             // redundant written to show else if clause
                f=b;
            else
                f=b;
        end

endmodule