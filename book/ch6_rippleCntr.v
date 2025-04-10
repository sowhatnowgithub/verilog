module rippleCntr (
    output [3:0] q,
    input clk,
    clear
);

    ngtvTrigTFF tff0 (
        q[0],
        clk,
        clear
    );
    ngtvTrigTFF tff1 (
        q[1],
        q[0],
        clear
    );
    ngtvTrigTFF tff2 (
        q[2],
        q[1],
        clear
    );
    ngtvTrigTFF tff3 (
        q[3],
        q[2],
        clear
    );

endmodule

module ngtvTrigTFF (
    output q,
    input  clk,
    clear
);
    wire qBar;
    ngtvTrigDFF df (
        q,
        qBar,
        ~q,
        clk,
        clear
    );
endmodule

module ngtvTrigDFF (
    output q,
    qBar,
    input  d,
    clk,
    clear
);
    wire sBar, rBar;
    wire s, r;
    wire cBar, clkBar;
    assign clkBar = ~clk;
    assign cBar = ~clear;
    assign q = ~(s & qBar);
    assign qBar = ~(r & q & cBar);
    assign s = ~(sBar & cBar & clkBar);
    assign r = ~(rBar & s & clkBar);
    assign sBar = ~(s & rBar);
    assign rBar = ~(r & d & cBar);
endmodule

module stimulus;
    wire [3:0] q;
    reg clk, clear;
    rippleCntr rCntr (
        q,
        clk,
        clear
    );
    always #5 clk = ~clk;
    initial begin
        clk   = 0;
        clear = 0;
        #2 clear = 1;
        #2 clear = 0;
        #200;
        $finish;
    end
    initial begin
        $monitor("q:%b , clk:%b", q, clk);
    end
endmodule
