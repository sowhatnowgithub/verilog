`include "registerFile.v"
`include "controlUnit.v"
module branchPCGen(branchTarget,op1,isRet,branchPC);
input isRet;
output [31:0]branchPC;
input [31:0]branchTarget,op1;
mux2to1 mux5(.out(branchPC),.in0(branchTarget),.in1(op1), .sel(isRet));
endmodule

module tb;
reg [31:0]mem[0:10];
wire ldPC,
clrPC,
ldInst,
clrInst,
ldNPC
,clrNPC,
ldDecodeInst,
clrDecodeInst,
isSt,
isRet,
rstRegFile,
ldRegOutputData,
clrOutputRegData,isBranchTaken;
reg clk = 0;
reg start;
wire [31:0]currentPC,readInst;
wire [31:0]branchPC,branchTarget;
reg[31:0] writeInstData,writeInstAddr;
reg wrInstMem,resetInstMem;
wire [31:0]fetchedInst;
wire[3:0] output1,output2,drAddr;
wire [3:0]rs1,rs2,ra,rd;
wire [1:0]modifier;
wire [4:0]opcode;
wire flagE,flagGt,isEq,isGt,wrFlag,rstFlag;
wire iOrReg;
wire [31:0]readRegData1,readRegData2;
wire [31:0]writeRegData;
wire [15:0]imm;
wire ldBrnchTarget,clrBrnchTarger;
wire ldResult,
clrResult,
ldA,
ldB,
clrA,
clrB,
aluSel,
isAdd,
isCmp,
isSub,
isMul,
isDiv,
isMod,
isLsl,
isLsr,
isAsr,
isOr,
isNot,
isAnd,
isMov;


alu alu1(ldResult,clrResult,ldA,ldB,clrA,clrB,aluSel,aluResult,iOrReg,isAdd,isCmp,isSub,isMul,isDiv,isMod,isLsl,isLsr,isAsr,isOr,isNot,isAnd,isMov,op1,op2,imm,isEq,isGt,isCmp,clk);
flags flagReg(flagE,flagGt,isEq,isGt,wrFlag,clk,rstFlag);
branchPCGen branchpcgen1(.branchTarget(branchTarget),.op1(readRegData1),.isRet(isRet),.branchPC(branchPC));
registerFile regFile1(ldRegOutputData,clrOutputRegData,readRegData1,readRegData2,writeRegData,output1,output2,drAddr, wrRegister,clk,rstRegFile);
operandFetchUnit operandFetch(isRet,isSt, rs1,rs2,rd,ra, output1,output2);
decodeInstruction decode(isBranchTaken,clrBrnchTarger,ldDecodeInst,ldDecodeInst,clrDecodeInst,clrDecodeInst,opcode, iOrReg,imm,modifier,rs1,rs2,rd,fetchedInst,currentPC,branchTarget,clk);
fetchUnit fetch(ldPC,ldNPC,clrNPC,ldInst,clrInst,clrPC,isBranchTaken,readInst,currentPC,fetchedInst ,branchPC,clk); // ldPC, clrPC, isBranchTaken, outPC,branchPC
instructionMem mem1(currentPC, readInst, writeInstAddr, writeInstData, wrInstMem,clk, resetInstMem);
controlUnit cntrlUnit(
    ldResult,
    clrResult,
    ldA,
    ldB,
    clrA,
    clrB,
    aluSel,
    isAdd,
    isCmp,
    isSub,
    isMul,
    isDiv,
    isMod,
    isLsl,
    isLsr,
    isAsr,
    isOr,
    isNot,
    isAnd,
    isMov,
    ldBrnchTarget,
    clrBrnchTarger,
    ldPC,
    clrPC,
    ldInst,
    clrInst,
    ldNPC,
    isBranchTaken
    , clrNPC,
    ldDecodeInst,
    clrDecodeInst,
    isSt,
    isRet,
    rstRegFile,
    ldRegOutputData,
    clrOutputRegData,
    isEq,
    isGt,
    wrFlag,
    rstFlag,
    clk,
    start,
    flagE,
    flagGt,
    opcode,
    iOrReg,
    modifier);

always #5 clk = ~clk;

initial begin
    #380 $finish;
end
integer i;
initial begin
    wrInstMem = 0;
    writeInstAddr = 0;
    writeInstData = 0;
   // readAddr = 0;
    resetInstMem = 0;
    #10 resetInstMem = 1;
    #10 resetInstMem = 0;
end
initial begin
    #30;
    $readmemb("data.bin", mem);
    wrInstMem = 1;
    for (i=0;i<6;i=i+1) begin
        writeInstAddr = i*4;
        writeInstData = mem[i];
        #10;
        $display("Wrote: Addr[%0d] = %08h",writeInstAddr,writeInstData);
    end
    wrInstMem = 0;
    #10;
    start = 1;
end
initial begin
    $monitor($time," ,PC:%0d Ins:%08h start:%0d \n Inst:%08h - opcode:%b rs1:%b rs2:%b rd:%b imm:%b \n output1:%b output2:%b branchPC:%0d \n modifier:%0d iOrReg:%b \n flagE:%b, flagGt:%b isBranchTaken:%b",
        currentPC, fetchedInst,cntrlUnit.state,
        decode.currentInst,decode.opcode,decode.rs1,
        decode.rs2,decode.rd,decode.imm,operandFetch.output1,
        operandFetch.output2,
        branchPC ,cntrlUnit.modifier, iOrReg ,flagE,flagGt, isBranchTaken);
end

endmodule



/*
module tb;
reg[31:0] readAddr, writeAddr;
wire [31:0]readData;
reg [31:0]writeData;
reg wrInstMem,resetInstMem;
reg clk = 0;
reg [31:0]mem[0:255];
reg ldPC, ldInst, ldNPC,clrNPC,clrInst, clrPC,isBranchTaken;
wire [31:0]branchPC ;
wire  [31:0]outPC, outInst,readInst;
wire [4:0]opcode;
reg clrDecodeInst,ldDecodeInst;
reg wrRegister,rstRegFile;
reg isSt,isRet;
wire [3:0]rs1,rs2,ra,rd;
wire [31:0]readData1,readData2;
reg[31:0] writeRegData;
wire [3:0]output1,output2;
wire [31:0]readRegData1,readRegData2;
reg ldRegOutputData,clrOutputRegData;
wire [31:0]branchTarget;
branchPCGen branchpcgen1(.branchTarget(branchTarget),.op1(readRegData1),.isRet(isRet),.branchPC(branchPC));
registerFile regFile1(ldRegOutputData,clrOutputRegData,readRegData1,readRegData2,writeRegData,output1,output2,drAddr, wrRegister,clk,rstRegFile);
operandFetchUnit operandFetch(isRet,isSt, rs1,rs2,rd,ra, output1,output2);
decodeInstruction decode(ldDecodeInst,ldDecodeInst,clrDecodeInst,clrDecodeInst,opcode, iOrReg,imm,modifier,rs1,rs2,rd,outInst,outPC,branchTarget,clk);
fetchUnit fetch(ldPC,ldNPC,clrNPC,ldInst,clrInst,clrPC,isBranchTaken,readInst,outPC,outInst ,branchPC,clk); // ldPC, clrPC, isBranchTaken, outPC,branchPC
instructionMem mem1(outPC, readInst, writeAddr, writeData, wrInstMem,clk, resetInstMem);
always #5 clk = ~clk;
initial begin
    wrInstMem = 0;
    writeAddr = 0;
    writeData = 0;
    readAddr = 0;
    resetInstMem = 0;
    #10 resetInstMem = 1;
    #10 resetInstMem = 0;
    #1500 $finish;
end
integer i;
initial begin
    #30;
    $readmemb("data.bin", mem);
    wrInstMem = 1;
    for (i=0;i<2;i=i+1) begin
        writeAddr = i*4;
        writeData = mem[i];
        #10;
        $display("Wrote: Addr[%0d] = %08h",writeAddr,writeData);
    end
    wrInstMem = 0;
    #10;
    clrDecodeInst = 1;
    ldDecodeInst = 0;
    isBranchTaken = 0;
    clrPC = 1;
    ldPC = 0;
    clrNPC = 1;
    ldNPC = 0;
    ldInst = 0;
    clrInst = 1;
    #10;
    ldPC = 1;
    clrInst = 0;
    ldNPC = 1;
    clrNPC = 0;
    ldInst = 1;

    #10;
    ldPC = 1;
    clrPC = 0;
    ldNPC = 1;
    $display("P:%b : Inst:%08h", fetch.outPC, fetch.outInst);
    clrDecodeInst = 0;
    ldDecodeInst = 1;
    isRet = 0;
    isSt = 0;
    rstRegFile = 1;
    wrRegister = 0;
    #10;
    rstRegFile = 0;
    ldRegOutputData = 1;
    #10;
    $display("PC:%b : Inst:%08h", fetch.outPC, fetch.outInst);
    $display("Inst:%08h - opcode:%b rs1:%b rs2:%b rd:%b imm:%b", decode.currentInst,decode.opcode,decode.rs1,decode.rs2,decode.rd,decode.imm);
    $display("output1:%b output2:%b",operandFetch.output1,operandFetch.output2 );
    $display("readData1:%b, readData2:%b",regFile1.readData1,regFile1.readData2 );
    #10;
    #10;
    $display("Inst:%08h - opcode:%b rs1:%b rs2:%b rd:%b imm:%b", decode.currentInst,decode.opcode,decode.rs1,decode.rs2,decode.rd,decode.imm);
    $display("output1:%b output2:%b",operandFetch.output1,operandFetch.output2 );
    $display("readData1:%b, readData2:%b",regFile1.readData1,regFile1.readData2 );
    $display("P:%b : Inst:%08h", decode.branchTarget, fetch.outInst);

end
endmodule

*/
