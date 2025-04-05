// Gate Level Modeling
/*
    primitive
    and or nor nand xor xnor  - this has multiple inputs and one output
    buf not - multiple ouputs and one input
    bufif0 bufif1 notif0 notif1 - these are primitives which has a control signal, which determines the output

    Array of instances

*/
module nand_array_of_instances (
    output out,
    input  in1,
    in2
);
    // nand n_gate[0:8] (out, in1, in2);
endmodule
//Gate level Multiplexer
module mux42 (
    output out,
    input [3:0] in,
    input sel1,
    sel0
);
    wire [3:0] w;
    and (w[0], ~sel0, ~sel1, in[0]);
    and (w[1], sel0, ~sel1, in[1]);
    and (w[2], ~sel0, sel1, in[2]);
    and (w[3], sel0, sel1, in[3]);
    or (out, w[0], w[1], w[2], w[3]);
endmodule
module test;
    reg [3:0] in;
    wire out;
    reg [1:0] sel;
    mux42 m1 (
        out,
        in,
        sel[1],
        sel[0]
    );

    initial begin
        in  = 4'b1101;
        sel = 2'b00;
        $display("4 bit mux");
        #1;
        $display("sel1:%b, sel0:%b, Input:%b, Output:%b", sel[1], sel[0], in, out);
        sel = 2'b01;
        #1;
        $display("sel1:%b, sel0:%b, Input:%b, Output:%b", sel[1], sel[0], in, out);
        sel = 2'b10;
        #1;
        $display("sel1:%b, sel0:%b, Input:%b, Output:%b", sel[1], sel[0], in, out);
        sel = 2'b11;
        #1;
        $display("sel1:%b, sel0:%b, Input:%b, Output:%b", sel[1], sel[0], in, out);
    end
endmodule

//Over - Gate level Multiplexer
// 4 bit ripple carry full adder
module FullAdder (
    output sum,
    carryOut,
    input  in1,
    in2,
    carryIn
);
    // sum = in1 (xor) in2 (xor) carryIn
    // carryOut = in1*in2 + (in1(xor)in2)*carryIn;
    wire [2:0] w;
    xor (sum, in1, in2, carryIn);
    xor (w[0], in1, in2);
    and (w[1], in1, in2);
    and (w[2], w[0], carryIn);
    or (carryOut, w[2], w[1]);
endmodule
module fourBitFullAddr (
    output [3:0] sum,
    output carryOut,
    input [3:0] in1,
    input [3:0] in2
);
    wire [2:0] w;
    FullAdder faddr1 (
        sum[0],
        w[0],
        in1[0],
        in2[0],
        1'b0
    );
    FullAdder faddr2 (
        sum[1],
        w[1],
        in1[1],
        in2[1],
        w[0]
    );
    FullAdder faddr3 (
        sum[2],
        w[2],
        in1[2],
        in2[2],
        w[1]
    );
    FullAdder faddr4 (
        sum[3],
        carryOut,
        in1[3],
        in2[3],
        w[2]
    );
endmodule

module test1;
    reg [3:0] in1;
    wire [3:0] out;
    wire carryOut;
    reg [3:0] in2;
    fourBitFullAddr f1 (
        out,
        carryOut,
        in1,
        in2
    );
    initial begin
        $monitor("Input1:%b + Input2:%b : Output:%b and Carry:%b", in1, in2, out, carryOut);
    end
    initial begin
        in1 = 4'd15;
        in2 = 4'd15;
    end
endmodule
// over - 4 bit ripple carry full adder
