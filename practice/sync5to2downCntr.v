module masterSlaveJFF (
    output q,
    qBar,
    input  J,
    K,
    clk,
    clear,
    preset
);
    wire a, b, y, yBar, c, d;
    assign a = ~(J & qBar & clk & clear);
    assign b = ~(K & q & clk);
    assign y = ~(a & yBar);
    assign yBar = ~(b & y & clear);
    assign c = ~(y & ~clk & clear);
    assign d = ~(yBar & ~clk);
    assign q = ~(c & qBar);
    assign qBar = ~(d & q & clear);
endmodule

module Cntr (
    output [2:0] q,
    output [2:0] qBar,
    input clk,
    clear
);
    wire [2:0] J;
    wire [2:0] K;

    assign J[2] = q[1] & ~q[0];
    assign K[2] = ~q[1] & ~q[0];
    assign J[1] = (~q[2] & q[0]) | (q[2] & ~q[0]);
    assign K[1] = q[1] & ~q[0];
    assign J[0] = 1'b1;
    assign K[0] = 1'b1;
    masterSlaveJFF mSJFF1 (
        q[0],
        qBar[0],
        J[0],
        K[0],
        clk,
        clear,
        preset
    );
    masterSlaveJFF mSJFF2 (
        q[1],
        qBar[1],
        J[1],
        K[1],
        clk,
        clear,
        preset
    );
    masterSlaveJFF mSJFF3 (
        q[2],
        qBar[2],
        J[2],
        K[2],
        clk,
        clear,
        preset
    );
endmodule

module stimulus;
    reg clk, clear;
    wire [2:0] q;
    wire [2:0] qBar;

    Cntr cntr (
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
        #150;
        $finish;
    end
endmodule
