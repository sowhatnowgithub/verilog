// Level Sensitive Control Timing Control
// We use wait

module ch7_timingControl2;
reg count_enable = 0;
integer count;
always wait (count_enable) #10 count = count +1;
always #5 count_enable = ~count_enable;
initial $monitor("count:%d", count);
initial count = 0;
initial #150 $finish;
endmodule
