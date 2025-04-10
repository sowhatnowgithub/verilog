// Dataflow modelling
// logic synthesis by dataflow modelling became famous approach
// The CAD tools became more sophisticated by data flow method
// RTL is combination of dataflow modelling and behavioral modelling

// Continous Assignment

// assign => RHS can be anything but LHS can be scalar/vector net
// As soon as operands on RHS changes it is assigned to the LHS
// You can give strength to the assign and delay as well, the default value is strong0 and strong1

module assign_i (
    output out,
    input  i1,
    i2
);
    assign out = i1 & i2;  // this is explicit assignment
    wire #10 out1 = i1 | i2;  // this is implicit assignment
    // Net declaration delay
    wire out2;  // everytime out2 is assign it will have a delay of 20, implicit delay
    assign out2 = i1 ^ i2;
endmodule

module concept2 ();
    // Operands -> they can be any Data Types like net, const, real, times, bit-select, part-select, memories and function
    integer count, final_count;
    real a, b, c;
    reg [15:0] reg1, reg2;
    reg [3:0] reg_out;
    // Operators -> these act on the operands to produce desired results

    /*
        Logical => && || !
        Arithmatic => * / % + - **
        Relational => <= >= < >
        Equality => == != === !==
        Bitwise => ~ | & ^ ~^ ^~
       Shift => >> << >>> <<<
       Conditonal => ?:
       Concatenation => {}
       Replication => { { } }
       // === triple Equality is for x and z, while == won't check for x and z
    */
    // Expressions -> combines operands and operators
endmodule

module muxLogicBased (
    output out,
    input [3:0] in,
    input [1:0] sel
);
    assign out = (in[0] & ~sel[0] & ~sel[1]) | (in[1] & sel[0] & ~sel[1]) | (in[2] & ~sel[0] & sel[1])
| (in[3] & sel[0] & sel[1]);
endmodule
module muxConditionalBased (
    output out,
    input [3:0] in,
    input [1:0] sel
);
    assign out = sel[0] ? (sel[1] ? in[3] : in[1]) : (sel[1] ? in[2] : in[0]);
endmodule

module stimulus;
    reg [3:0] in;
    reg [1:0] sel;
    wire out1, out2;
    muxLogicBased m1 (
        out1,
        in,
        sel
    );
    muxConditionalBased m2 (
        out2,
        in,
        sel
    );

    initial begin
        in  = 4'd11;
        sel = 2'b00;
        #1;
        $display("Input:%b, Sel:%b, Out_logic:%b", in, sel, out1);
        sel = 2'b01;
        #1;
        $display("Input:%b, Sel:%b, Out_logic:%b", in, sel, out1);
        sel = 2'b10;
        #1;
        $display("Input:%b, Sel:%b, Out_logic:%b", in, sel, out1);
        sel = 2'b11;
        #1;
        $display("Input:%b, Sel:%b, Out_logic:%b", in, sel, out1);
        sel = 2'b00;
        #1;
        $display("Input:%b, Sel:%b, Out_condn:%b", in, sel, out2);
        sel = 2'b01;
        #1;
        $display("Input:%b, Sel:%b, Out_condn:%b", in, sel, out2);
        sel = 2'b10;
        #1;
        $display("Input:%b, Sel:%b, Out_condn:%b", in, sel, out2);
        sel = 2'b11;
        #1;
        $display("Input:%b, Sel:%b, Out_condn:%b", in, sel, out2);
    end
endmodule
