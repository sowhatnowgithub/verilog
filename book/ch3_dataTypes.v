`define WORD 2*8
module ts;
    integer number = 8'b0111_1011;
    initial $display("Binary format %b", number);
    initial $display("Integer format %d", number);
    integer num = 4'b00??;  // ? can be used inplace of z
    initial $display("%b", num);
    wire bum;
    initial $display("%b", bum);
    reg unknown_number = 16'hxxxx;
    initial $display("%h", unknown_number);
    integer negative_two = -2;
    initial $display("%d", negative_two);
    reg signed [3:0] negative_two_reg = -4'd2;
    initial $display("%d", negative_two_reg);
    reg [15:0] unsized_hex = 'h1234;
    initial $display("Unsized Hex : %h", unsized_hex);
    wire a;
    always @(a) begin
        $display("%b", a);
    end
    reg [100*8:0] str = "Please ring a bell character ";
    initial $display("%s", str);
    wire [7:0] a_in;
    reg [31:0] address = 'd3;
    integer count;
    time snap_shot;
    initial begin
        $display("Current Simulation time");
        snap_shot = $time;
        $display("%d", snap_shot);
        #5 snap_shot = $time;
        $display("The Simulation time after using #5 %d", snap_shot);
    end
    reg [63:0] MEM[0:255];
    parameter cache_size = 'd512;
    initial $display("cache %d", cache_size);
    initial $display("define WORD %d", `WORD);
endmodule
