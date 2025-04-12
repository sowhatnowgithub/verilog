// GCD computarion with repeated subtraction

module dataPath2 (
    ldA,
    ldB,
    sel1,
    sel2,
    sel_in,
    lt,
    gt,
    eq,
    dataIn,
    clk,
    Aout
);
    input ldA, ldB, sel1, sel2, sel_in, clk;
    wire [15:0] subOut, Bus, Bout, X, Y;
    output [15:0] Aout;
    input [15:0] dataIn;
    output lt, gt, eq;
    PIPO1 A (
        Aout,
        Bus,
        ldA,
        clk
    );
    PIPO1 B (
        Bout,
        Bus,
        ldB,
        clk
    );
    CMP cmp1 (
        lt,
        gt,
        eq,
        Aout,
        Bout
    );
    mux m1 (
        X,
        Aout,
        Bout,
        sel1
    );  // sel1:0 -> X -> Aout
    mux m2 (
        Y,
        Bout,
        Aout,
        sel2
    );  // sel2:0 -> Y -> Bout
    mux m3 (
        Bus,
        dataIn,
        subOut,
        sel_in
    );
    sub s1 (
        subOut,
        X,
        Y
    );
endmodule
module PIPO1 (
    output reg [15:0] out,
    input [15:0] in,
    input ld,
    input clk
);
    always @(posedge clk) begin
        if (ld) out <= in;
    end
endmodule
module sub (
    output reg [15:0] sub,
    input [15:0] a,
    input [15:0] b
);
    always @(*) sub = a - b;
endmodule
module CMP (
    output lt,
    gt,
    eq,
    input [15:0] Aout,
    input [15:0] Bout
);

    assign lt = (Aout < Bout);
    assign gt = (Aout > Bout);
    assign eq = (Aout == Bout);
endmodule
module mux (
    output [15:0] out,
    input [15:0] in0,
    input [15:0] in1,
    input sel
);
    assign out = sel ? in1 : in0;
endmodule
module controller1 ();
endmodule
module controller (
    ldA,
    ldB,
    sel1,
    sel2,
    sel_in,
    lt,
    gt,
    eq,
    start,
    done,
    clk
);
    output reg ldA, ldB, sel1, sel2, sel_in, done;
    input lt, gt, eq, start, clk;
    reg [2:0] state, nextState;
    parameter s0 = 3'b000, s1 = 3'b001, s2 = 3'b010, s3 = 3'b011, s4 = 3'b100, s5 = 3'b101;

    always @(posedge clk) begin
        case (state)
            s0: if (start) state <= s1;
            s1: state <= s2;
            s2:
            #2
            if (eq) state <= s5;
            else if (lt) state <= s3;
            else if (gt) state <= s4;
            s3:
            #2
            if (eq) state <= s5;
            else if (lt) state <= s3;
            else if (gt) state <= s4;
            s4:
            #2
            if (eq) state <= s5;
            else if (lt) state <= s3;
            else if (gt) state <= s4;
            s5: state <= s5;
            default: state <= s0;
        endcase
    end
    always @(state) begin
        case (state)
            s0: begin
                sel_in = 0;
                ldA = 1;
                ldB = 0;
                done = 0;
            end
            s1: begin
                sel_in = 0;
                ldA = 0;
                ldB = 1;
            end
            s2: begin
                if (eq) done = 1;
                else if (lt) begin
                    sel1   = 1;
                    sel2   = 1;
                    sel_in = 1;
                    #1 ldA = 0;
                    ldB = 1;
                end else if (gt) begin
                    sel1   = 0;
                    sel2   = 0;
                    sel_in = 1;
                    #1 ldA = 1;
                    ldB = 0;
                end
            end
            s3: begin
                if (eq) done = 1;
                else if (lt) begin
                    sel1   = 1;
                    sel2   = 1;
                    sel_in = 1;
                    #1 ldA = 0;
                    ldB = 1;
                end else if (gt) begin
                    sel1   = 0;
                    sel2   = 0;
                    sel_in = 1;
                    #1 ldA = 1;
                    ldB = 0;
                end
            end
            s4: begin
                if (eq) done = 1;
                else if (lt) begin
                    sel1   = 1;
                    sel2   = 1;
                    sel_in = 1;
                    #1 ldA = 0;
                    ldB = 1;
                end else if (gt) begin
                    sel1   = 0;
                    sel2   = 0;
                    sel_in = 1;
                    #1 ldA = 1;
                    ldB = 0;
                end
            end
            s5: begin
                done = 1;
                sel1 = 0;
                sel2 = 0;
                ldA  = 0;
                ldB  = 0;
            end
            default: begin
                ldA = 0;
                ldB = 0;
            end
        endcase
    end
endmodule


module stimulus;
    reg start;
    wire done;
    reg clk = 0;
    reg [15:0] dataIn;
    wire [15:0] Aout;
    wire ldA, ldB, sel1, sel2, sel_in;
    wire lt, gt, eq;

    controller control (
        ldA,
        ldB,
        sel1,
        sel2,
        sel_in,
        lt,
        gt,
        eq,
        start,
        done,
        clk
    );
    dataPath2 DP (
        ldA,
        ldB,
        sel1,
        sel2,
        sel_in,
        lt,
        gt,
        eq,
        dataIn,
        clk,
        Aout
    );
    always #5 clk = ~clk;
    initial begin
        $monitor($time, "clk:%b, %d %b, subOut:%d", clk, Aout, done, DP.Aout);
    end
    initial begin
        start = 0;
        #3 start = 1;
        #1000 $finish;
    end
    initial begin
        #10 dataIn = 143;
        #10 dataIn = 78;
    end
endmodule
