/*
Event-Based Timing Control
Event is a change in the value of reg or net, hence we can use event as a trigger
Four types of event control:
1. regular event control
2. named event control
3. event OR control
4. level-sensitive timing control
*/
// For regular event - We take @(event) event is posedge, negedge or something
// Named Event Control - With verilog we can use keyword event to store an event
// event can be triggered using ->
// Sensitive list can be separated using or or comma, comma is for edge-sensitive triggers
module regular_event_control;
reg clk = 0;
always #5 clk = ~clk;
reg a,b,c,d,q;
initial begin
    d = 0;
    @clk q = d;
    a = @(posedge clk) d;
    @(negedge clk) c = d;
end
endmodule

module named_event_control;
event event0;
reg clk = 0;
always #5 clk = ~clk;
initial begin
    $50;
    $finish;
end
initial begin
    #2 @clk ->event0;
end
always @event0 begin
    $display("I am working");
end
endmodule

module event_or_control;
reg reset,d;
reg clk = 0;
always #5 clk = ~clk;
always @(reset, clk, d) begin
if(reset) d <=0;
else if(clock) d <= 0;
end
endmodule


