`include "instructionFetch.v"

module decodeInstruction(ldInst,ldDecodeInst,ldBrnchTrgt,clrBrnchTrgt,clrInst,clrDecodeInst,opcode, iOrReg,imm,modifier,rs1,rs2,rd,readInst,presentPC,branchTarget,clk);
wire [31:0]currentInst,tempInst;
input ldInst,ldDecodeInst,clrDecodeInst, clrInst,ldBrnchTrgt,clrBrnchTrgt,clk;
input [31:0]readInst,presentPC;
wire [27:0]temp_branchTarget;
output [4:0]opcode;
output iOrReg;
output [15:0]imm;
output [1:0]modifier;
output [31:0]branchTarget;
output [3:0]rs1,rs2,rd;

assign opcode = currentInst[31:27];
assign iOrReg = currentInst[26];
assign rd = currentInst[25:22];
assign rs1 = currentInst[21:18];
assign rs2 = currentInst[17:14];
assign modifier = currentInst [17:16];
assign imm = currentInst[15:0];
assign temp_branchTarget = (currentInst[26:0]<<2) + presentPC;
dff dff2(.q(branchTarget),.d(temp_branchTarget),.ld(ldBrnchTrgt),.clr(clrBrnchTrgt),.clk(clk) );
dff dff3(.q(currentInst),.d(tempInst),.ld(ldDecodeInst),.clr(clrDecodeInst),.clk(clk) );
PIPO1 pipo3(.out(tempInst),.in(readInst),.ld(ldInst),.clr(clrInst),.clk(clk) );
endmodule
