// generate conditionals => you can pass only parameters into these conditionals

module add_or_sub #(parameter MODE = 1)(result, sel,in0,in1);

input [3:0]in0;
input [3:0]in1;
output [3:0]result;
input sel;
generate
    if(MODE) assign result = in0 + in1;
    else assign result = in0 - in1;
endgenerate

endmodule

module tb;
reg [3:0]in0;
reg [3:0]in1;
reg sel;
wire [3:0]result;
add_or_sub #(.MODE(0)) a(result, sel, in0,in1);
initial begin
    in0 = 4'b0110;
    in1 = 4'b0010;
    #1;
    $display("in0:%b, in1:%b, result:%b",in0,in1,result);
end
endmodule
