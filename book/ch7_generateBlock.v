//generate allows verilog code to be generated dynamically at elaborative time, before the simulation begins,
// This facilates the creation of parametrized models
// we use generate endgenerate to make these blocks
/*
The generator blocks are used to instantiate modules, user defined primitives,
verilog gate primitices and continous assignments, initial and always block

The the three methods to create generate statements:
1. Generate Loop
2. Generate Conditional
3. Generate Case

// We use "genvar" to create varibles for generator blocks
*/
// Generate Loop

module bitwiseXor(out, in1,in2);
parameter N = 32;
output [N-1:0] out;
input [N-1:0] in1,in2;

genvar j;
generate for (j=0;j<N;j=j+1) begin: xor_loop // this will set the heirarchial array like xor_loop[0].g1, xor_loop[1].g1 ...
    xor g1(out[j], in1[j], in2[j]);
end
endgenerate
endmodule

module bitwiseXor1(out, in0, in1);
parameter N = 32;
output reg [N-1:0]out;
input [N-1:0]in0,in1;

genvar j;

generate for(j=0;j<N;j=j+1) begin: bit
    always @(in0[j] or in1[j] ) out[j] = in0[j] ^ in1[j];
end
endgenerate
endmodule

module rippleAdder(sum,cout ,in0, in1, cin );
parameter N = 4; // 4 bit adder

output [N-1:0]sum;
output cout;
input [N-1:0]in0, in1;
input cin;

wire [N:0]carry;
assign carry[0] = cin;
genvar j;
assign cout = carry[4];
generate for (j=0;j<N;j=j+1) begin:loop
    wire t1,t2,t3;
    xor g1(t1,in0[j],in1[j]);
    xor g2(sum[j], t1, carry[j]);
    and g3(t2,in0[j], in1[j]);
    and g4(t3, t1, carry[j]);
    or g5(carry[j+1], t3,t2);
end

endgenerate

endmodule

module tb;
reg [3:0]in0,in1;
reg cin;
wire [3:0]sum;
wire cout;

rippleAdder adder(sum,cout ,in0, in1, cin );

initial begin
    in0 = 4'b0110;
    in1 = 4'b0001;
    cin = 1'b1;
    #1;
    $display("sum:%b, cout:%b, in0:%b, in1:%b, cin:%b ", sum,cout, in0,in1, cin);
end
endmodule
