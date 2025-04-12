// detect a sequence 101010

module sequenceDetector1 (
    z,
    x,
    clk
);

    input x, clk;
    output reg z;
    reg [2:0] PS = 3'b000;
    parameter state0 = 3'b000;
    parameter state1 = 3'b001;
    parameter state2 = 3'b010;
    parameter state3 = 3'b011;
    parameter state4 = 3'b100;
    parameter state5 = 3'b101;

    always @(posedge clk) begin
        if (PS == state0) begin
            PS <= (x == 1) ? state1 : state0;  // X
            z  <= 0;
        end else if (PS == state1) begin
            PS <= (x == 0) ? state2 : state0;  // 1X
            z  <= 0;
        end else if (PS == state2) begin
            PS <= (x == 1) ? state3 : state0;  // 10X
            z  <= 0;
        end else if (PS == state3) begin
            PS <= (x == 0) ? state4 : state0;  // 101X
            z  <= 0;
        end else if (PS == state4) begin
            PS <= (x == 1) ? state5 : state0;  // 1010X
            z  <= 0;
        end else if (PS == state5) begin
            PS <= (x == 0) ? state4 : state0;  // 10101X
            z  <= 1;
        end
    end
endmodule

module tb;
    parameter N = 16;
    reg [N-1:0] x;
    reg clk;
    wire z;
    reg data;
    sequenceDetector1 detect (
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
        x = 16'b0000_0000_0101_0101;
        #2;
        for (i = 0; i < 16; i++) begin
            data = x[i];
            #10;
        end
        #20 $finish;
    end
    initial $monitor("i:%d,data:%b, clk:%b, z:%b, state:%b", i, data, clk, z, tb.detect.PS);
endmodule
