module halfAdder (
    output sum,
    carry,
    input  a,
    b
);
    wire [2:0] w;
    nand n1 (w[0], a, b);
    nand n2 (w[1], w[0], a);
    nand n3 (w[2], w[0], b);
    nand n4 (sum, w[1], w[2]);
    nand n5 (carry, w[0]);
endmodule

module halfSub (
    output diff,
    borrow,
    input  a,
    b
);
    wire [2:0] w;
    nand n1 (w[0], a, b);
    nand n2 (w[1], w[0], a);
    nand n3 (w[2], w[0], b);
    nand n4 (diff, w[1], w[2]);
    nand n5 (borrow, w[2]);
endmodule

module stimulus;
    reg a, b;
    wire sum, carry, diff, borrow;
    halfAdder add (
        sum,
        carry,
        a,
        b
    );
    halfSub sub (
        diff,
        borrow,
        a,
        b
    );
    initial begin
        a = 1'b0;
        b = 1'b0;
        #1;
        $display("a:%b, b:%b, sum:%b, carry:%b", a, b, sum, carry);
        $display("a:%b, b:%b, diff:%b, borrow:%b", a, b, diff, borrow);
        a = 1'b0;
        b = 1'b1;
        #1;
        $display("a:%b, b:%b, sum:%b, carry:%b", a, b, sum, carry);
        $display("a:%b, b:%b, diff:%b, borrow:%b", a, b, diff, borrow);
        a = 1'b1;
        b = 1'b0;
        #1;
        $display("a:%b, b:%b, sum:%b, carry:%b", a, b, sum, carry);
        $display("a:%b, b:%b, diff:%b, borrow:%b", a, b, diff, borrow);
        a = 1'b1;
        b = 1'b1;
        #1;
        $display("a:%b, b:%b, sum:%b, carry:%b", a, b, sum, carry);
        $display("a:%b, b:%b, diff:%b, borrow:%b", a, b, diff, borrow);
    end
endmodule

module fullAdder (
    output sum,
    carry,
    input  a,
    b,
    cIn
);
    wire c1, c2;
    wire sum1;
    halfAdder ha1 (
        sum1,
        c1,
        a,
        b
    );
    halfAdder ha2 (
        sum,
        c2,
        sum1,
        cIn
    );
    or o1 (carry, c1, c2);
endmodule
module fullSub (
    output diff,
    borrow,
    input  a,
    b,
    cIn
);
    wire b1, b2;
    wire b1Bar, b2Bar;
    wire diff1;
    halfSub hs1 (
        diff1,
        b1,
        a,
        b
    );
    halfSub hs2 (
        diff,
        b2,
        diff1,
        cIn
    );
    not n1 (b1Bar, b1);
    not n2 (b2Bar, b2);
    nand o1 (borrow, b1Bar, b2Bar);
endmodule
module stimulus1;
    reg a, b, cIn;
    wire sum, carry, diff, borrow;

    fullAdder fa1 (
        sum,
        carry,
        a,
        b,
        cIn
    );
    fullSub fs1 (
        diff,
        borrow,
        a,
        b,
        cIn
    );

    initial begin
        #20;
        a   = 1'b0;
        b   = 1'b0;
        cIn = 1'b0;
        #1;
        $display("a:%b, b:%b, cIn:%b,sum:%b, carry:%b", a, b, cIn, sum, carry);
        $display("a:%b, b:%b,cIn:%b ,diff:%b, borrow:%b", a, b, cIn, diff, borrow);
        a   = 1'b0;
        b   = 1'b0;
        cIn = 1'b1;
        #1;
        $display("a:%b, b:%b, cIn:%b,sum:%b, carry:%b", a, b, cIn, sum, carry);
        $display("a:%b, b:%b,cIn:%b ,diff:%b, borrow:%b", a, b, cIn, diff, borrow);
        a   = 1'b0;
        b   = 1'b1;
        cIn = 1'b0;
        #1;
        $display("a:%b, b:%b, cIn:%b,sum:%b, carry:%b", a, b, cIn, sum, carry);
        $display("a:%b, b:%b,cIn:%b ,diff:%b, borrow:%b", a, b, cIn, diff, borrow);
        a   = 1'b0;
        b   = 1'b1;
        cIn = 1'b1;
        #1;
        $display("a:%b, b:%b, cIn:%b,sum:%b, carry:%b", a, b, cIn, sum, carry);
        $display("a:%b, b:%b,cIn:%b ,diff:%b, borrow:%b", a, b, cIn, diff, borrow);
        a   = 1'b1;
        b   = 1'b0;
        cIn = 1'b0;
        #1;
        $display("a:%b, b:%b, cIn:%b,sum:%b, carry:%b", a, b, cIn, sum, carry);
        $display("a:%b, b:%b,cIn:%b ,diff:%b, borrow:%b", a, b, cIn, diff, borrow);
        a   = 1'b1;
        b   = 1'b0;
        cIn = 1'b1;
        #1;
        $display("a:%b, b:%b, cIn:%b,sum:%b, carry:%b", a, b, cIn, sum, carry);
        $display("a:%b, b:%b,cIn:%b ,diff:%b, borrow:%b", a, b, cIn, diff, borrow);
        a   = 1'b1;
        b   = 1'b1;
        cIn = 1'b0;
        #1;
        $display("a:%b, b:%b, cIn:%b,sum:%b, carry:%b", a, b, cIn, sum, carry);
        $display("a:%b, b:%b,cIn:%b ,diff:%b, borrow:%b", a, b, cIn, diff, borrow);
        a   = 1'b1;
        b   = 1'b1;
        cIn = 1'b1;
        #1;
        $display("a:%b, b:%b, cIn:%b,sum:%b, carry:%b", a, b, cIn, sum, carry);
        $display("a:%b, b:%b,cIn:%b ,diff:%b, borrow:%b", a, b, cIn, diff, borrow);

    end
endmodule
