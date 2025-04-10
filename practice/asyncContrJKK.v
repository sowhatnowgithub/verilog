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
    assign b = ~(K & q & clk & preset);
    assign y = ~(a & yBar & preset);
    assign yBar = ~(b & y & clear);
    assign c = ~(y & ~clk & clear);
    assign d = ~(yBar & ~clk & preset);
    assign q = ~(c & qBar & preset);
    assign qBar = ~(d & q & clear);
endmodule

module asyncCntr (
    output [3:0] q,
    output [3:0] qBar,
    input clk,
    clear
);
    wire condn;
    wire preset;
    assign #1 condn = ~((~q[0] & q[1] & ~q[2] & ~q[3]) || (q[0] & q[1] & q[2] & q[3]));
    assign preset = 1'b1;
    masterSlaveJFF mSJFF1 (
        q[0],
        qBar[0],
        1'b1,
        1'b1,
        clk,
        clear,
        preset & condn
    );
    masterSlaveJFF mSJFF2 (
        q[1],
        qBar[1],
        1'b1,
        1'b1,
        qBar[0],
        clear & condn,
        preset
    );
    masterSlaveJFF mSJFF3 (
        q[2],
        qBar[2],
        1'b1,
        1'b1,
        qBar[1],
        clear & condn,
        preset
    );
    masterSlaveJFF mSJFF4 (
        q[3],
        qBar[3],
        1'b1,
        1'b1,
        qBar[2],
        clear,
        preset & condn
    );

endmodule

module stimulus;
    reg clk, clear;
    wire [3:0] q;
    wire [3:0] qBar;
    asyncCntr cntr (
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
        #500;
        $finish;
    end
endmodule
