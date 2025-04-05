/*
Gate Delays
We have three types of delays
1. Rise Delay from (0,x,z)-> 1
2. Fall Delay from (1,x,z)->0
3. Turn-Off Delay from (1,0,x)->z

We can have a more control outlook, with help of
min typ max -> these delays are choosen by the designer and verilog assigns any of the one during runtime
*/
module delay_ex1;
    reg i1, i2;
    wire o1, o2;
    and #(5, 5) i (o1, i1, i2);
    and #(5: 4: 6, 5: 4: 6) i3 (o2, i1, i2);
    // 5:4:6 min:typ:max
    initial begin
        // $dumpfile("item.vcd");
        // $dumpvars(0, delay_ex1);
        i1 = 0;
        i2 = 0;
        #20;
        i1 = 1;
        i2 = 1;
        #20;
        i1 = 1;
        i2 = 0;
        #20;
        i1 = 1;
        i2 = 1;
        #20;
    end
endmodule

module ex2 (
    output out,
    input  a,
    b,
    c
);
    wire w;
    and #(5) (w, a, b);
    or #(4) (out, w, c);
endmodule
module ex2_Stimulus;
    reg A, B, C;
    wire OUT;
    ex2 ex (
        OUT,
        A,
        B,
        C
    );
    initial begin
        $dumpfile("item2.vcd");
        $dumpvars(0, ex2_Stimulus);
        A = 1'b0;
        B = 1'b0;
        C = 1'b0;
        #(3: 5: 7) A = 1'b1;
        B = 1'b1;
        C = 1'b1;
        #(3: 5: 7) A = 1'b1;
        B = 1'b0;
        C = 1'b0;
        #(10: 13: 20);
    end

endmodule
