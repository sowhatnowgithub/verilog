// $readmemb (filename, arrayName, startAdrees, Endaddress)
//
module memory_model;
reg [7:0] mem[0:1023];
initial begin
    $readmemb ("mem.dat", mem,200,50); // 200 199 198 ...
end
// synchronous
module ram_1(addr, data, clk, rd, wr, cs);
input [9:0]addr;
inout [7:0]data;
input clk, rd, wr,cs;
reg [7:0] mem[0:1023];
reg [7:0]d_out;
assign data = (cs && rd) ? d_out : 8'bz;
always @(posedge clk) if(cs && wr && !rd) mem[addr] = data;
always @(posedge clk) if(cs && rd && !wr) d_out = mem[addr];
endmodule

// Asynchronous

module ram_2(addr, data, rd, wr, cs);
input [9:0]addr;
inout [7:0]data;
input  rd, wr,cs;
reg [7:0] mem[0:1023];
reg [7:0]d_out;
assign data = (cs && rd) ? d_out : 8'bz;
always @(*) if(cs && wr && !rd) mem[addr] = data;
always @(*) if(cs && rd && !wr) d_out = mem[addr];
endmodule

// ROM or EPROM

module rom(addr, data, rd_en, cs);
input [2:0]addr;
input rd_en, cs;
output reg[7:0] data;
always @(addr or rd_en or cs)
case(addr)
0: data = 22;
1: data = 45;
// and so on
endcase
endmodule

// We use tristate buffer is used in place of inout as inout is not a always synthesised predictably by verilog
