`include "instructionDecode.v"

module registerFile(ldData,clrData,readData1,readData2,writeData,sr1Addr,sr2Addr,drAddr, wr,clk,rst);
input [3:0]sr1Addr,sr2Addr,drAddr;
input wr,clk,rst,ldData,clrData;
output  [31:0]readData1,readData2;
wire [31:0]temp_readData1,temp_readData2;
input [31:0]writeData;
reg [31:0]regFile[0:15];
integer i;
assign temp_readData2 = regFile[sr2Addr];
assign temp_readData1 = regFile[sr1Addr];
dff d1(.q(readData1),.d(temp_readData1),.ld(ldData),.clr(clrData),.clk(clk));
dff d2(.q(readData2),.d(temp_readData2),.ld(ldData),.clr(clrData),.clk(clk));

always @(posedge clk) begin
    if(rst) for(i=0;i<16;i=i+1) regFile[i] <= 0;
    else if(wr) regFile[drAddr] <= writeData;
end
endmodule

module operandFetchUnit(isRet,isSt, rs1,rs2,rd,ra, output1,output2);
output [3:0]output1,output2;
input isRet,isSt;
input [3:0]rs1,rs2,rd,ra;
mux2to1 mux2(.out(output1),.in0(rs1),.in1(ra),.sel(isRet) );
mux2to1 mux3(.out(output2),.in0(rs2),.in1(rd),.sel(isSt) );
endmodule
