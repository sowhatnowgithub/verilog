module fulladd4 (
    output sum,
    output carryOut,
    input [3:0] a,
    input [3:0] b,
    input carryIn
);
    assign {carryOut, sum} = a + b + carryIn;

endmodule

module stimulus;
    reg [3:0] a;
    reg [3:0] b;
    reg carryIn;
    wire carryOut;
    wire [3:0] sum;
    fulladd4 f1 (
        sum,
        carryOut,
        a,
        b,
        carryIn
    );
    initial begin
        a = 4'd13;
        b = 4'd1;
        carryIn = 1'b0;
        #1;
        $display("a:%b, b:%b, carryIn:%b, sum:%b, carryOut:%b", a, b, carryIn, sum, carryOut);
    end
endmodule
