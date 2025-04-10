module masterSlaveDFF (
    output q,
    input  data,
    clk,
    clear
);
    wire a, b, y, yBar, c, d, qBar;
    assign a = ~(clk & data);
    assign b = ~(clk & ~data);
    assign y = ~(a & yBar);
    assign yBar = ~(b & y);
    assign c = ~(y & clear & ~clk);
    assign d = ~(~y & ~clk);
    assign q = ~(c & qBar);
    assign qBar = ~(d & q & clear);
endmodule

module stimulus;
    reg d, clk, clear;
    wire q, qBar;
    masterSlaveDFF mSDFF (
        q,

        d,
        clk,
        clear
    );
    always #5 clk = ~clk;
    initial begin
        clk   = 1'b0;
        clear = 1;
        #2 clear = 0;
        #2 clear = 1;
        d = 1'b0;
        #10;
        d = 1'b1;
        #10;
        d = 1'b0;
        #10;
        clear = 0;
        #10;
        clear = 1;
        d = 1'b1;
        #20;
        $finish;
    end
    initial begin
        $monitor("d:%b, clk:%b, clear:%b, q:%b", d, clk, clear, q);
    end
endmodule
