// make a counter that starts from 5 and 67
// use forever, named block, disabling of named block
// The clock has time period of 10 units

module counter(out, clk);
output reg [7:0]out;
input clk;
integer i;
initial begin: counter_loop
    i =4;
    forever begin
        i = i+1;

        @(posedge clk) out = i;
        if(i == 67) disable counter_loop;
    end
end
endmodule

module stimulus;
reg clk = 0;
wire [7:0]out;
counter cntr(out, clk);
always #5 clk = ~clk;
initial begin
    $monitor("clk:%b , out:%b , out:%d", clk, out, out);
end
initial #1000 $finish;
endmodule
