module rippleCntr (
    output [3:0] q,
    input clk,
    input clear
);
    ngtvTrigTFF TFF1 (
        q[0],
        clk
        clear
    );
    ngtvTrigTFF TFF2 (
        q[1],
        q[0],
        clear
    );
    ngtvTrigTFF TFF3 (
        q[2],
        q[1],
        clear
    );
    ngtvTrigTFF TFF4 (
        q[3],
        q[2],
        clear
    );
endmodule

module ngtvTrigTFF (
    output q,
    input  clk,
    input  clear
);
    // Use D flip-flop with inverted feedback
    wire q_int = ~q;
    ngtvTrigDFF DFF (
        .q(q),
        .qBar(),
        .d(q_int),  // Direct inversion of output
        .clk(clk),
        .clear(clear)
    );
endmodule

module ngtvTrigDFF (
    output q,
    output qBar,
    input  d,
    input  clk,
    input  clear
);
    wire sBar, rBar;
    wire clkBar, cBar;
    wire dBar;

    not (clkBar, clk);
    not #1 (cBar, clear);
    not (dBar, d);

    nand #1 (sBar, d, clkBar, cBar);
    nand #1 (rBar, dBar, clkBar);
    nand #1 (q, qBar, sBar);
    nand #1 (qBar, q, rBar, cBar);
endmodule

module stimulus;
    wire [3:0] q;
    reg clk, clear;

    rippleCntr r (
        q,
        clk,
        clear
    );

    always #5 clk = ~clk;

    initial begin
        clk   = 0;
        clear = 0;
        #2 clear = 1;
        #5 clear = 0;  // Longer clear pulse
        #100;  // Run longer to see behavior
        $finish;
    end

    initial begin
        $monitor($time, " q:%b, clk:%b, clear:%b", q, clk, clear);
    end
endmodule
