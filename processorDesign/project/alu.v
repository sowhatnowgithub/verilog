
// the alu will have an adder, multiplier, Divider, Shift Unit, Logical Unit, mov


module alu(ldResult,clrResult,ldA,ldB,clrA,clrB,aluResult,isAdd,isCmp,isSub,isMul,isDiv,isMod,isLsl,isLsr,isAsr,isOr,isNot,isAnd,isMov,AIn,BIn,Eq,Gt,clk);
input ldResult,clrResult,ldA,ldB,clrA,clrB,isAdd,isCmp,isSub,isMul,isDiv,isMod,isLsl,isLsr,isAsr,isOr,isNot,isAnd,isMov,clk;
input [31:0]AIn,BIn;
output [31:0]aluResult;
wire [31:0]temp_aluResult;
output Eq,Gt;
wire [31:0]A,B;
dff dff1(.q(A),.d(AIn),.ld(ldA),.clr(clrA),.clk(clk) );
dff dff2(.q(B),.d(BIn),.ld(ldB),.clr(clrB),.clk(clk) );
dff dff3(.q(aluResult),.d(aluResult),.ld(ldResult),.clr(clrResult),.clk(clk) );
adder add();
endmodule


module flags(output flagE,flagGt,input isEq,isGt,wr,clk);
reg [1:0]flagRegister; // flagRegister[0] is Equal
assign flagE = flagRegister[0];
assign flagGt = flagRegister[1];
always @(posedge clk) begin
    if(wr)
    begin
        flagRegister[0] = isEq;
        flagRegister[1] = isGt;
    end

end
endmodule

module adder(output reg [31:0]result,output reg Eq,output reg Gt ,input [31:0]A,input [31:0]B, input isAdd,isSub,isCmp);
always @(*) begin
    if(isAdd) result = A + B;
    else if(isSub) result = A-B;
    else if(isCmp) begin
        if(A==B) Eq = 1;
        else if(A>B)Gt=1;
        if(A!=B) Eq=0;
        if(A<B) Gt = 0;
    end
end
endmodule

module mul(output  [31:0]result ,input [31:0]A,input [31:0]B, input isMul);
assign result = isMul ? A*B : 0;
endmodule

module div(output  [31:0]result ,input [31:0]A,input [31:0]B, input isDiv,isMod);
assign result = isDiv ? A/B : (isMod ? A%B : 0);
endmodule

module mov(output  [31:0]result ,input [31:0]B, input isMov);
assign result =isMov? B:0;;
endmodule

module logicUnit(output reg [31:0]result,input [31:0]A,input [31:0]B, input isOr,isNot,isAnd);
always @(*) begin
    if(isOr) result = A|B;
    else if(isNot) result = ~B;
    else if(isAnd) result = A&B;
end
endmodule

module shiftUnit(output reg [31:0]result,input [31:0]A,input [31:0]B, input isLsl,isLsr,isAsr);
always @(*) begin
    if(isLsl) result = A<<B;
    else if(isLsr) result =A>>B;
    else if(isAsr) result =A>>>B;

end
endmodule
