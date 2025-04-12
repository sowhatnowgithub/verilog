// detect a sequence 0110 in a input bit stream

module sequenceDetector (
    z,
    x,
    clk
);
    output reg z;
    input x, clk;
    reg [2:0] PS = 3'b000;
    parameter state0 = 3'b000;
    parameter state1 = 3'b001;
    parameter state2 = 3'b010;
    parameter state3 = 3'b011;

    always @(posedge clk) begin

        if (PS == state0) begin
            PS = (x == 0) ? state1 : state0;  // X
            z  = 0;
        end else if (PS == state1) begin
            PS = (x == 1) ? state2 : state1;  // 0X
            z  = 0;
        end else if (PS == state2) begin
            PS = (x == 1) ? state3 : state1;  //01X
            z  = 0;
        end else if (PS == state3) begin
            z  = (x == 0) ? 1 : 0;
            PS = (x == 0) ? state1 : state0;  // 011X
        end

    end

endmodule

module tb;
    reg clk;
    parameter N = 16;
    reg [N-1:0] x;
    wire z;
    reg data;
    sequenceDetector detect (
        .z  (z),
        .x  (data),
        .clk(clk)
    );
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end
    integer i;
    initial begin
        $dumpfile("sequenceDetector.vcd");
        $dumpvars(0, tb);
        x = 16'b0000_0110_0000_0110;
        data = 0;
        #2;
        for (i = 0; i < N; i++) begin
            #10 data = x[i];
        end
        #10 $finish;
    end
    initial $monitor("z:%b, data:%b, clk:%b", z, data, clk);
endmodule
