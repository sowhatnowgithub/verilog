// making or not and gate via nand

module my_or (
    output out,
    input  a,
    b
);
    wire w1, w2;
    nand n1 (w1, a, a);
    nand n2 (w2, b, b);
    nand n3 (out, w1, w2);
endmodule
module my_and (
    output out,
    input  a,
    b
);
    wire w;
    nand n1 (w, a, b);
    nand n2 (out, w, w);
endmodule
module my_not (
    output out,
    input  a
);
    nand n (out, a, a);
endmodule

module stimulus1;
    reg a, b;
    wire out_or, out_and, out_not;
    my_or a1 (
        out_or,
        a,
        b
    );
    my_and a2 (
        out_and,
        a,
        b
    );
    my_not a3 (
        out_not,
        a
    );
    initial begin
        a = 1'b0;
        b = 1'b0;
        #5;
        $display("a:%b, b:%b, Or:%b, And:%b, Not a:%b", a, b, out_or, out_and, out_not);
        a = 1'b0;
        b = 1'b1;
        #5;
        $display("a:%b, b:%b, Or:%b, And:%b, Not a:%b", a, b, out_or, out_and, out_not);
        a = 1'b1;
        b = 1'b0;
        #5;
        $display("a:%b, b:%b, Or:%b, And:%b, Not a:%b", a, b, out_or, out_and, out_not);
        a = 1'b1;
        b = 1'b1;
        #5;
        $display("a:%b, b:%b, Or:%b, And:%b, Not a:%b", a, b, out_or, out_and, out_not);
    end

endmodule
// implementation done

module my_xor (
    output out,
    input  a,
    b
);
    wire aBar, bBar;
    wire w1, w2;
    my_not not1 (
        aBar,
        a
    );
    my_not not2 (
        bBar,
        b
    );
    my_and and1 (
        w1,
        a,
        bBar
    );
    my_and and2 (
        w2,
        b,
        aBar
    );
    my_or or1 (
        out,
        w1,
        w2
    );
endmodule

module stimulus2;
    reg a, b;
    wire out;
    my_xor xor1 (
        out,
        a,
        b
    );
    initial begin
        a = 1'b0;
        b = 1'b0;
        #1;
        $display("a:%b, b:%b, out_xor:%b", a, b, out);
        a = 1'b0;
        b = 1'b1;
        #1;
        $display("a:%b, b:%b, out_xor:%b", a, b, out);
        a = 1'b1;
        b = 1'b0;
        #1;
        $display("a:%b, b:%b, out_xor:%b", a, b, out);
        a = 1'b1;
        b = 1'b1;
        #1;
        $display("a:%b, b:%b, out_xor:%b", a, b, out);
    end
endmodule

module fullAddr (
    output sum,
    carrhOut,
    input  a,
    b,
    carryIn
);
    wire [3:0] w_and;
    wire [6:0] w_or;
    wire [2:0] w;

    wire aBar, bBar, carryInBar;
    my_not not1 (
        aBar,
        a
    );
    my_not not2 (
        bBar,
        b
    );
    my_not not3 (
        carryInBar,
        carryIn
    );
    my_and and1 (
        w_and[0],
        a,
        b
    );
    my_and and2 (
        w_or[0],
        w_and[0],
        carryIn
    );
    my_and and3 (
        w_and[1],
        aBar,
        b
    );
    my_and and4 (
        w_or[1],
        w_and[1],
        carryInBar
    );
    my_and and5 (
        w_and[2],
        aBar,
        bBar
    );
    my_and and6 (
        w_or[2],
        w_and[2],
        carryIn
    );
    my_and and7 (
        w_and[3],
        a,
        bBar
    );
    my_and and8 (
        w_or[3],
        w_and[3],
        carryInBar
    );

    my_or or1 (
        w[0],
        w_or[0],
        w_or[1]
    );
    my_or or2 (
        w[1],
        w_or[2],
        w[0]
    );
    my_or or3 (
        sum,
        w[1],
        w_or[3]
    );

    my_and and9 (
        w_or[4],
        a,
        b
    );
    my_and and10 (
        w_or[5],
        b,
        carryIn
    );
    my_and and11 (
        w_or[6],
        a,
        carryIn
    );
    my_or or4 (
        w[2],
        w_or[4],
        w_or[5]
    );
    my_or or5 (
        carrhOut,
        w_or[6],
        w[2]
    );
endmodule

module stimulus3;
    reg a, b, carryIn;
    wire sum, carrhOut;
    fullAddr fAddr (
        sum,
        carrhOut,
        a,
        b,
        carryIn
    );
    initial begin
        #15;
        a = 1'b0;
        b = 1'b0;
        carryIn = 1'b0;
        #1;
        $display("a:%b, b:%b, carryIn:%b, sum:%b, carrhOut:%b", a, b, carryIn, sum, carrhOut);
        a = 1'b0;
        b = 1'b0;
        carryIn = 1'b1;
        #1;
        $display("a:%b, b:%b, carryIn:%b, sum:%b, carrhOut:%b", a, b, carryIn, sum, carrhOut);
        a = 1'b0;
        b = 1'b1;
        carryIn = 1'b0;
        #1;
        $display("a:%b, b:%b, carryIn:%b, sum:%b, carrhOut:%b", a, b, carryIn, sum, carrhOut);
        a = 1'b0;
        b = 1'b1;
        carryIn = 1'b1;
        #1;
        $display("a:%b, b:%b, carryIn:%b, sum:%b, carrhOut:%b", a, b, carryIn, sum, carrhOut);
        a = 1'b1;
        b = 1'b0;
        carryIn = 1'b0;
        #1;
        $display("a:%b, b:%b, carryIn:%b, sum:%b, carrhOut:%b", a, b, carryIn, sum, carrhOut);
        a = 1'b1;
        b = 1'b0;
        carryIn = 1'b1;
        #1;
        $display("a:%b, b:%b, carryIn:%b, sum:%b, carrhOut:%b", a, b, carryIn, sum, carrhOut);
        a = 1'b1;
        b = 1'b1;
        carryIn = 1'b0;
        #1;
        $display("a:%b, b:%b, carryIn:%b, sum:%b, carrhOut:%b", a, b, carryIn, sum, carrhOut);
        a = 1'b1;
        b = 1'b1;
        carryIn = 1'b1;
        #1;
        $display("a:%b, b:%b, carryIn:%b, sum:%b, carrhOut:%b", a, b, carryIn, sum, carrhOut);
    end
endmodule
// RS latch using nor gates

module rs_nor (
    output q,
    output qBar,
    input  reset,
    set
);
    nor #1 n1 (q, reset, qBar);
    nor #1 n2 (qBar, set, q);
endmodule

module stimulus4;
    reg reset, set;
    wire q, qBar;
    rs_nor rs1 (
        q,
        qBar,
        reset,
        set
    );
    initial begin
        reset = 1'b0;
        set   = 1'b1;
        #40;
        $display("Reset:%b, Set:%b, Q:%b", reset, set, q);
        reset = 1'b0;
        set   = 1'b0;
        #5;
        $display("Reset:%b, Set:%b, Q:%b", reset, set, q);
        reset = 1'b1;
        set   = 1'b0;
        #5;
        $display("Reset:%b, Set:%b, Q:%b", reset, set, q);
        reset = 1'b1;
        set   = 1'b1;
        #5;
        $display("Reset:%b, Set:%b, Q:%b", reset, set, q);
    end
endmodule
// Making mux 2 to 1, using bufif0 and bufif1
module mux2to1 (
    output out,
    input  in1,
    in0,
    S
);
    wire w1, w2;
    bufif0 #(1: 2: 3, 3: 4: 5, 5: 6: 7) b1 (w1, in0, S);
    bufif1 #(1: 2: 3, 3: 4: 5, 5: 6: 7) b2 (w2, in1, S);
    assign out = (S == 0) ? w1 : w2;
endmodule

module stimulus5;
    reg in0, in1, S;
    wire out;

    mux2to1 m1 (
        out,
        in1,
        in0,
        S
    );
    initial begin
        in0 = 1'b0;
        in1 = 1'b1;
        S   = 1'b1;
        #60;
        $display("in1:%b, in0:%b, S=%b, Out:%b", in1, in0, S, out);
        S = 1'b0;
        #5;
        $display("in1:%b, in0:%b, S=%b, Out:%b", in1, in0, S, out);
    end
endmodule

// implemented
