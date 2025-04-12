// repeat - is a loop statement which takes a number and just repeats that many times
// forever loop

module count;
parameter s = 10;
initial begin
    repeat(s) begin
        $display("I don't care");
    end
end
endmodule

module foreverLoop;
reg clock;
initial begin
    clock = 0;
    forever #5 clock = ~clock;
end
initial begin
    #100 $finish;
end
endmodule

module data_buffer(data_start, data, clock);
parameter cycles = 8;
input [15:0]data;
input data_start;
input clock;

reg [15:0]buffer[0:7];
integer i;

always @(posedge clock) begin
    if(data_start) begin
       i = 0;
        repeat(cycles) begin
            @(posedge clock) buffer[i] = data;
            i = i + 1;
        end
    end
end
endmodule
