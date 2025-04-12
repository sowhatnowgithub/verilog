// ITs the traffics signal with a more refined approach
`define TRUE 1'b1;
`define FALSE 1'b0;
//Delays
`define Y2RDELAY 3
`define R2GDELAY 2

module trafficSignal1(hwg, cntry, X, clk, clear);
output reg [1:0]hwg, cntry;
input X,clk, clear;
//parameters definition for lights
parameter RED = 2'd0, YELLOW = 2'd1, GREEN = 2'd2;
// parameters defintion for states
parameter s0 = 3'd0, s1 = 3'd1, s2 = 3'd2,
s3 = 3'd3, s4 = 3'd4;
reg [2:0]presetState;
reg [2:0]nextState;


always @(posedge clk) begin
    if(clear) presetState <= s0;
    else presetState <= nextState;
end

always @(presetState) begin
    hwg = GREEN;
    cntry = RED;
    case(presetState)
    s0: ;
    s1: hwg = YELLOW;
    s2: hwg = RED;
    s3:begin
        cntry = GREEN;
        hwg = RED;
    end
    s4: begin
        cntry = YELLOW;
        hwg  =  RED;
    end
    endcase
end

always @(presetState or X) begin
    case(presetState)
    s0: if(X) nextState = s1; else nextState = s0;
    s1: begin
        repeat(`Y2RDELAY) @(posedge clk);
        nextState = s2;
    end
    s2: begin
        repeat(`R2GDELAY) @(posedge clk);
        nextState = s3;
    end
    s3: if(X) nextState = s3; else nextState = s4;
    s4: begin
        repeat (`Y2RDELAY) @(posedge clk);
        nextState = s0;
    end
    endcase

end
endmodule

module stimulus;
reg X;
reg clk = 0;
reg clear;
wire [1:0]hwg, cntry;
trafficSignal1 signal(hwg, cntry, X, clk, clear);
always #5 clk = ~clk;
initial begin
    clear = `TRUE;
    repeat (5) @(posedge clk);
    clear = `FALSE;
end
initial begin
    X = 0;
    repeat(5) @(posedge clk);
    X = 1;
    repeat(15) @(posedge clk);
    X = 0;
    repeat (20) @(posedge clk);
    $finish;
end
initial $monitor("X:%b,clk:%b, clear:%b, hwg:%b, cntry:%b, state:%b", X,clk,clear, hwg, cntry,stimulus.signal.presetState);

endmodule
