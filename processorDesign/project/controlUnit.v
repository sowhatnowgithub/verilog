module controlUnit (
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
    modifier
);
    output reg ldResult,
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
    isMov,ldPC,
clrPC,
ldInst,
clrInst,
ldNPC
,clrNPC,
ldDecodeInst,
clrDecodeInst,
isSt,rstFlag,
isRet,
rstRegFile,
ldRegOutputData,
clrOutputRegData,isBranchTaken,isEq,isGt,wrFlag,ldBrnchTarget,clrBrnchTarger;

    input [1:0] modifier;
    input [4:0] opcode;
    input clk, start, flagE, flagGt, iOrReg;
    parameter s0 = 0,s1=1,s2=2,s3=3,s4=4,s5=5,s6=6,s7=7,s8=8,s9=9,s10=10
    ,s11=11,s12=12,s13=13,s14=14,s15=15,s16=16,s17=17,s18=18;
    reg [4:0] state;

    always @(opcode) begin
        if (opcode == 5'b10010 || opcode == 5'b10011 || opcode == 5'b10100) begin
            isBranchTaken <= 1'b1;
        end else if ((opcode == 5'b10000) && flagE) isBranchTaken <= 1'b1;
        else if ((opcode == 5'b10001) && flagGt) isBranchTaken <= 1'b1;
        else begin
            if (isBranchTaken) begin
                ldPC <= 1;
                isBranchTaken <= 1'b0;
            end

        end
    end

    always @(posedge clk) begin
        case (state)
            s0: begin
                if (start) state <= s1;
                else state <= s0;
            end
            s1: begin
                isRet <= 0;
                isSt <= 0;
                rstFlag <= 1;
                clrOutputRegData <= 1;
                clrBrnchTarger <= 1;
                isBranchTaken <= 0;
                ldDecodeInst <= 0;
                ldPC <= 0;
                ldNPC <= 0;
                ldInst <= 0;
                clrDecodeInst <= 1;
                clrPC <= 1;
                clrNPC <= 1;
                clrInst <= 1;
                clrOutputRegData <= 1;
                state <= s2;
            end
            s2: begin
                clrBrnchTarger <= 0;
                ldNPC <= 1;
                ldInst <= 1;
                rstFlag <= 0;
                ldBrnchTarget <= 1;
                clrOutputRegData <= 0;
                clrDecodeInst <= 0;
                clrPC <= 0;
                clrNPC <= 0;
                clrInst <= 0;
                clrOutputRegData <= 0;
                state <= s3;
            end
            s3: begin
                ldPC <= 0;
                ldDecodeInst <= 1;
                state <= s4;
            end
            s4: begin
                ldRegOutputData <= 1;
                state <= s5;
            end
            s5: begin
                ldPC  <= 1;
                state <= s6;
            end
            s6: begin
                ldPC  <= 0;
                state <= s7;
            end
            s7: begin
                state <= s8;
            end
            s8: begin
                state <= s9;
            end
            s9: begin
                ldPC  <= 1;
                state <= s10;
            end
            s10: begin
                ldPC  <= 0;
                state <= s11;
            end
            s11: begin
                state <= s12;
            end
            s12: begin
                state <= s13;
            end
            s13: begin
                ldPC  <= 1;

                state <= s14;
            end
            s14: begin
                ldPC  <= 0;

                state <= s15;
            end
            s15: begin
                state <= s16;
            end
            s16: begin
                state <= s17;
            end
            s17: begin
                ldPC  <= 1;

                state <= s18;
            end
            s18: begin
                ldPC  <= 1;
                state <= s3;
            end

            default: begin
                state <= s0;
            end
        endcase
    end

endmodule
