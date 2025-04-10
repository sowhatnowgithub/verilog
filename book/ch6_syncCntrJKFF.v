module masterSlaveJFF (
    output q,
    qBar,
    input  J,
    K,
    clk,
    clear
);
    wire a, b, y, yBar, c, d;
    assign a = ~(J & clk & qBar & clear);
    assign b = ~(K & clk & q);
    assign y = ~(a & yBar);
    assign yBar = ~(b & y & clear);
    assign c = ~(y & ~clk);
    assign d = ~(yBar & ~clk);
    assign q = ~(c & qBar);
    assign qBar = ~(d & q & clear);
endmodule


module counter (
    output [3:0] q,
    input clk,
    clear,
    count_enable
);
    wire [3:0] qBar;
    wire [3:0] w;
    assign w[0] = 1'b1 & count_enable;
    assign w[1] = q[0] & w[0];
    assign w[2] = q[0] & q[1] & w[1];
    assign w[3] = q[0] & q[1] & q[2] & w[2];
    masterSlaveJFF mSJFF1 (
        q[0],
        qBar[0],
        w[0],
        w[0],
        clk,
        clear
    );
    masterSlaveJFF mSJFF2 (
        q[1],
        qBar[1],
        w[1],
        w[1],
        clk,
        clear
    );
    masterSlaveJFF mSJFF3 (
        q[2],
        qBar[2],
        w[2],
        w[2],
        clk,
        clear
    );
    masterSlaveJFF mSJFF4 (
        q[3],
        qBar[3],
        w[3],
        w[3],
        clk,
        clear
    );
endmodule
/*
module stimulus;
    reg J, K, clk, clear;
    wire q, qBar;
    masterSlaveJFF mSJFF (
        q,
        qBar,
        J,
        K,
        clk,
        clear
    );
    always begin
         #5 clk = ~clk;
    end
    initial begin
        clk   = 0;
        clear = 1;
        #2 clear = 0;
        #2 clear = 1;
        J = 0;
        K = 0;
        #10;
        J = 0;
        K = 0;
        #10;
        J = 1;
        K = 0;
        #10;
        J = 1;
        K = 1;
        #10;
        J = 1;
        K = 0;
        #10;
        J = 0;
        K = 0;
        #10;
        $finish;
    end
    initial begin
        $monitor("J:%b, K:%b, clk:%b, clear:%b, q:%b", J, K, clk, clear, q);
    end
endmodule

*/

module stimulus1;
    reg clk, clear, count_enable;
    wire [3:0] q;
    counter c1 (
        q,
        clk,
        clear,
        count_enable
    );
    initial begin
        clk = 0;
        forever #5 clk = ~clk;  // Clock toggles every 5 time units
    end
    initial begin
        #80;
        $monitor("q:%b, clk:%b, clear:%b, count_enable:%b", q, clk, clear, count_enable);
    end
    initial begin
        #80;
        clear = 1;
        count_enable = 1;
        clk = 0;
        #2 clear = 0;
        #2 clear = 1;
        #100;
        count_enable = 0;
        #20;
        count_enable = 1;
        #30;
        clear = 0;
        #10;
        clear = 1;
        #20;
        $finish;
    end
endmodule
