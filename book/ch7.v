// Behavioural Modeling
/*
    Structured Procedure: 
    1. initial 
    2. Always
    Procedural Assignements
    1. Blocking 
    2. Non Blocking

    We should note that blocking statements gets executed first within a individual procedural block at a given scheduling, at end of a time step the non-blocking are executed.
    Meaning blocking statements in that time stamp are always executed first
    Hence it is suggested not to use blocking and non-blocking in alway
*/

// applictions of non-blocking assignments


/*
How does non-blocking statements gets executed?
Ans: 
First a read operations in a particual procedural block. of all the non-blocking RHS is done, then 
Second: Write the read data from above step to all the LHS respectively.
*/

// The main disadvantage of using non-blocking is memory usage and simulation time taking long
 

module case1;
reg reg1, reg2, reg3;
reg clk = 0;
initial begin
    reg1 = 0;
    reg2 = 1;
    reg3 = 1;
    reg1 <= #1 reg2;
    reg2 <= @(posedge clk) reg2;
    reg3 <= #1 reg1;
    #5;
    $display("reg1:%b, reg2:%b, reg3:%b", reg1, reg2, reg3); // the output will be reg1:1, reg2:1, reg3=0
end

always #5 clk = ~clk;

reg a = 0;
reg b = 1;
initial $display("a:%b, b:%b", a, b);
// With non-blocking, the previous values are read and then writen so no problem 
always @(posedge clk) b <= a;
always @(posedge clk) a <= b; 
initial  begin
#15;
$display("a:%b, b:%b", a, b);
end
initial $display("a:%b, b:%b", a, b);
// with blocking we cannot say what the output will be it depends upon the simulation
always @(posedge clk) b = a;
always @(posedge clk) a = b; 
initial  begin
#15;
$display("a:%b, b:%b", a, b);
end

// we can simulate the behaviour of non-blocking by blokcing by storing in temp variables
reg temp_a;
reg temp_b;
always @(posedge clk)
begin
temp_a = a;
temp_b = b;
a = temp_b;
b = temp_a;
end
initial begin
#30;
$finish;
end
endmodule