module dff(input clk, rstn, d, output reg  q);
always @(posedge clk or negedge rstn) begin
    if(rstn)
        q <= d;    
    else
        q <= 0;
        
end
endmodule

module mux(input sel, a, b, output o );
wire [1:0]w;
    and(w[0], a, ~sel);
    and(w[1],b,sel);
    or(o, w[0],w[1]);
endmodule

module shft_reg(input [2:0]pipo,input clk, input rstn, input interrupt, output [2:0]o);
wire [5:0]w;
wire a = 1'b0;
mux m0(.sel(interrupt), .a(a),.b(pipo[0]), .o(w[0]));
dff d0(.clk(clk), .rstn(rstn), .d(w[0]), .q(w[1]));
mux m1(.sel(interrupt), .a(w[1]),.b(pipo[1]), .o(w[2]));
dff d1(.clk(clk), .rstn(rstn), .d(w[2]), .q(w[3]));
mux m2(.sel(interrupt), .a(w[3]),.b(pipo[2]), .o(w[4]));
dff d2(.clk(clk), .rstn(rstn), .d(w[4]), .q(w[5]));

assign o = {w[5],w[3],w[1]};
endmodule

module tb;

reg [2:0]pipo;
reg clk;
reg rstn;
reg interrupt;
wire [5:0]w;
wire [2:0]o;

shft_reg shft_reg0(.pipo(pipo),.clk(clk), .rstn(rstn),.interrupt(interrupt), .o(o));

always begin
#5 clk = ~clk; // 100MHz clocks
end

initial begin
     rstn = 1;
     clk = 0;
     interrupt = 1;
     pipo = 3'b001;
     #10;
     interrupt = 0;
     #30
     interrupt = 1;
     #10
    
    $finish;
end
initial begin 
    $monitor("Interrupt = %b, pipo = %b, Clk = %b, rstn = %b, Outut = %b",interrupt,pipo,clk,rstn,o);
end

endmodule




