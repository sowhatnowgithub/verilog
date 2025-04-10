/*
    Timing Controls 
    Types of timing controls:
    1. Delay-Based Timing Control
    2. Event-Based Timing Control
    3. Level-sensitive Timing Control
*/


/* 
Delay-Based Timing Control
These are for the delay between statements
1. Intra-Statement  delay Control
2. Inter-Statement delay Control
3. zero-delay statement
*/

/*
The procedural statements initial-always may have to simulated at 0, but this leads to non-deterministic execution,
So, we use #0 to specify this to be executed last at the time stamp,
If multiple #0 are there then its non-deterministic
So, #0 is not used in practical
*/
module regular_delay_based;
parameter latency = 20;
parameter delta = 2;
reg x,y,z,p,q;

initial begin
    x = 0;
    y = 0;
    #delta;
    y = 1;
    #y;
    y = 0;
    #latency y = 1;
end
initial begin
$monitor("time:%d - y:%b", $time,y);
end

endmodule

module intra_delay_based;
reg x ;
reg y ;
reg z;

initial begin 
#30;
y = 0;
z = 0;
#1 x = #8 y+z;
end

initial begin
#20;
$monitor("time:%d - x:%b", $time,x);
end
endmodule


module zero_delay_control;
reg x,y;
initial begin
x  = 0;
y = 0;
end
initial begin
#0 x = 1;
#0 y = 1; 
end
endmodule
