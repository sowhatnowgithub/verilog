`include "registerFile.v"
`include "alu.v"
module branchPCGen(branchTarget,op1,isRet,branchPC);
input isRet;
output [31:0]branchPC;
input [31:0]branchTarget,op1;
mux2to1 mux5(.out(branchPC),.in0(branchTarget),.in1(op1), .sel(isRet));
endmodule
