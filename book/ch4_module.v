/*
    The way the module is build up internally is
    1. Data varaiables declaration
    2. Data Flow Statements (assign)
    3. Instantiation of lower modules
    4. Always and initial Blocks
    5. Tasks and Functions
*/

// `include "ch_3.v"

module SR_latch(output q,qbar,input sbar, rbar);
nand n1(q,sbar,qbar);
nand n2(qbar, rbar, q);
endmodule

module Top;
wire q, qbar;
reg set, reset;
SR_latch sr1(q, qbar, set, reset);


initial
begin
$monitor("Q : %b, Set : %b, Reset : %b", q, set, reset);
    set = 0;
    reset = 0;
    #5 reset = 1;
    #5 set = 1;
   // #5 $stop;
    #5 reset = 0;
end

endmodule
