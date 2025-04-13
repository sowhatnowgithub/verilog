//Register Banks - 32 * 32, 32 register each with 32 bits width

module register(rdData1, rdData2, wrData, sr1, sr2, dr,write, clk, reset);
parameter totalReg = 32, widthReg = 32;
input clk,write,reset;
input [widthReg-1:0]rdData1,rdData2,wrData;
input [4:0]dr, sr1,sr2;
reg [widthReg-1:0]regFile[0:totalReg];
assign rdData1 = regFile[sr1];
assign rdData2 = regFile[sr2];

integer k;
always @(posedge clk) begin
    if(reset) begin
        for(k=0;k<totalReg;k=k+1) begin
            regFile[k] <= 0;
        end
    end
    else begin
        if(write) regFile[dr] <= wrData;
    end
end
endmodule
