// We have to light a three leds based upon the state
// Moore FSM is used
// S0 -> RED (100)
// S1 -> Green (010)
// S2 -> Yellow (001)
// S0 -> S1 -> S2-> S0
// This means that when my present state is S0 meaning RED is on and other off, and in the next clock
// I will go to S1 and green is on and other is off

module FSM_led (
    output reg [2:0] o,
    input clk
);
    reg [1:0] PS = 2'b00;

    always @(posedge clk) begin
        if (PS == 2'b00) begin
            PS <= 2'b01;
        end
        if (PS == 2'b01) begin
            PS <= 2'b10;
        end
        if (PS == 2'b10) begin
            PS <= 2'b00;
        end
    end
    always @(PS) begin
        case (PS)
            2'b00:   o = 3'b100;
            2'b01:   o = 3'b010;
            2'b10:   o = 3'b001;
            default: o = 3'b100;
        endcase
    end
endmodule

module tb;
    reg clk = 0;
    wire [2:0] o;
    FSM_led led (
        .o  (o),
        .clk(clk)
    );
    always #5 clk = ~clk;
    initial begin
        #100 $finish;
    end
    initial begin
        $dumpfile("fsm_led.vcd");
        $dumpvars(0, led);
        $monitor($time, " o:%b", o);
    end
endmodule
