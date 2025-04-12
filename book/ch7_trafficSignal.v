// There is a juction of main highway and country highway

// the main highway is given highest priority, and traffic signal is always green, only if the cars on country road then the signal turns green
// If the no car is present in the country road, then green -> yellow -> red
// Then red -> yellow -> green on the highway
// reg- orange - green : 100 - 010 - 001
module trafficSignal(x, hghwLght, cntrLght, clk);
input x;
input clk;
output reg [2:0] hghwLght, cntrLght;
reg [2:0]PS = 3'b000;
parameter state0 = 0;
parameter state1 = 1;
parameter state2 = 2;
parameter state3 = 3;
parameter state4 = 4;

always @(posedge clk) begin
    if ( PS == state0) begin
        PS <= (x==0) ? state0 : state1;
        hghwLght <= 3'b001;
        cntrLght <= 3'b100;
    end else if (PS == state1) begin
        PS <= state2 ;
        hghwLght <= 3'b010;
        cntrLght <= 3'b100;
    end else if (PS == state2) begin
        PS <=  state3 ;
        hghwLght <= 3'b100;
        cntrLght <= 3'b100;
    end else if (PS == state3) begin
        PS <= (x == 1)?state3 : state4;
        hghwLght <= 3'b100;
        cntrLght <= 3'b001;
    end else if (PS == state4) begin
        PS <= state0;
        hghwLght <= 3'b100;
        cntrLght <= 3'b010;
    end
end
endmodule

module tb;
reg clk = 0;
reg x;
wire [2:0]hghwLght, cntrLght;
trafficSignal lht(.x(x), .hghwLght(hghwLght), .cntrLght(cntrLght), .clk(clk) );
always #5 clk = ~clk;
initial begin
    x = 0 ;
    #25;
    x = 1;
    #40;
    x = 0;
    #25;
    $finish;
end
initial $monitor("clk:%b, x:%b, hghwLght:%b, cntrLght:%b",clk, x, hghwLght, cntrLght);
endmodule
