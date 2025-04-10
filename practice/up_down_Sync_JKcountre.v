module masterSlavejkJFF (
    output q,
    qBar,
    input  J,
    K,
    clk,
    clear
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

module upDownCntr (
    output [3:0] q,
    input clk,
    clear,
    up_or_DownBar
);
    wire [3:0] up;
    wire [3:0] down;
    wire [3:0] J;
    wire [3:0] qBar;
    assign J[0] = 1'b1;
    assign up[0] = q[0] & up_or_DownBar;
    assign down[0] = qBar[0] & ~up_or_DownBar;
    assign J[1] = up[0] | down[0];
    assign up[1] = q[1] & q[0] & up_or_DownBar;
    assign down[1] = qBar[1] & qBar[0] & ~up_or_DownBar;
    assign J[2] = up[1] | down[1];
    assign up[2] = q[2] & q[1] & q[0] & up_or_DownBar;
    assign down[2] = qBar[2] & qBar[1] & qBar[0] & ~up_or_DownBar;
    assign J[3] = up[2] | down[2];
    masterSlavejkJFF mSJFF1 (
        q[0],
        qBar[0],
        J[0],
        J[0],
        clk,
        clear
    );
    masterSlavejkJFF mSJFF2 (
        q[1],
        qBar[1],
        J[1],
        J[1],
        clk,
        clear
    );
    masterSlavejkJFF mSJFF3 (
        q[2],
        qBar[2],
        J[2],
        J[2],
        clk,
        clear
    );
    masterSlavejkJFF mSJFF4 (
        q[3],
        qBar[3],
        J[3],
        J[3],
        clk,
        clear
    );
endmodule

module stimulus;
    reg clk, clear, up_or_DownBar;
    wire [3:0] q;
    always #5 clk = ~clk;
    upDownCntr cntr (
        q,
        clk,
        clear,
        up_or_DownBar
    );
    initial begin
        clk = 0;
        clear = 1;
        up_or_DownBar = 0;
        #2 clear = 0;
        #2 clear = 1;
        #150;
        #2 clear = 0;
        #2 clear = 1;
        up_or_DownBar = 1;
        #150;

        $finish;
    end
    initial begin
        $monitor("Time=%0d | clk=%b clear=%b  Up/DownBar:%b :=> q=%b", $time, clk, clear,
                 up_or_DownBar, q);
    end

endmodule
