// 4 -> 7 -> 0 -> 5 -> 1 -> 4, usign JK and D

module masterSlaveDFF (
    output q,
    qBar,
    input  D,
    clk,
    clear
);
    wire a, b, y, yBar, c, d;

    assign a = ~(D & clk & clear);
    assign b = ~(~D & clk);
    assign y = ~(a & yBar);
    assign yBar = ~(b & y & clear);
    assign c = ~(y & ~clk & clear);
    assign d = ~(~y & ~clk);
    assign q = ~(c & qBar);
    assign qBar = ~(d & q & clear);

endmodule

module JKFF (
    output q,
    qBar,
    input  J,
    K,
    clk,
    clear
);
    assign D = (J & qBar) | (~K & q);
    masterSlaveDFF DFF (
        q,
        qBar,
        D,
        clk,
        clear
    );

endmodule

module arbitarySeqCntr (
    output [2:0] q,
    output [2:0] qBar,
    input clk,
    clear
);

    wire [2:0] J;
    wire [2:0] K;
    assign J[2] = 1;
    assign K[2] = q[0];
    assign J[1] = q[2] & ~q[0];
    assign K[1] = 1;
    assign J[0] = (~q[1] & ~q[0]);
    assign K[0] = (~q[2] & q[0]) | q[1];
    JKFF jk1 (
        q[0],
        qBar[0],
        J[0],
        K[0],
        clk,
        clear
    );
    JKFF jk2 (
        q[1],
        qBar[1],
        J[1],
        K[1],
        clk,
        clear
    );
    JKFF jk3 (
        q[2],
        qBar[2],
        J[2],
        K[2],
        clk,
        clear
    );

endmodule

module stimulus;
    reg clk, clear;
    wire [2:0] q;
    wire [2:0] qBar;

    arbitarySeqCntr cntr (
        q,
        qBar,
        clk,
        clear
    );

    always #5 clk = ~clk;
    initial begin
        $monitor("q:%b, clk:%b, clear:%b", q, clk, clear);
    end

    initial begin
        clk   = 0;
        clear = 1;
        #2 clear = 0;
        #2 clear = 1;
        #100;
        $finish;
    end
endmodule
