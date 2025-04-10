module rippleCntr (
    output [3:0] q,
    input clk,
    clear
);
    ngtvTrigTFF TFF1 (
        q[0],
        clk,
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
    clear
);
    wire q_internal = q;
    ngtvTrigDFF DFF (
        .q(q),
        .qBar(),
        .d(~q_internal),
        .clk(clk),
        .clear(clear)
    );
endmodule

module ngtvTrigDFF (
    output q,
    output qBar,
    input  d,
    clk,
    clear
);
    wire s, r, sBar, rBar, cBar;

    // I don't why behavioural logic is working but data flow is failed
    assign cBar = ~clear;
    assign clkBar = ~clk;
    assign q = ~(s & qBar);
    assign qBar = ~(r & q & cBar);
    assign sBar = ~(s & rBar);
    assign rBar = ~(r & d & cBar);
    assign s = ~(sBar & cBar & clkBar);
    assign r = ~(rBar & s & clkBar);
    /*
    always @(negedge clk or posedge clear) begin
        if (clear) q <= 0;
        else q <= d;
    end
    */



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
        clear = 1'b1;
        #2 clear = 0;
        #150;
        $finish;
    end
    initial begin
        $monitor(" q:%b ,clk:%b", q, clk);
    end
endmodule
