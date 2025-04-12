// Booths multiplication

module boothMul (
    ldA,
    ldQ,
    ldM,
    clrA,
    clrQ,
    clrff,
    shftA,
    shftQ,
    addSub,
    decr,
    ldcnt,
    clk,
    dataIn,
    Q0,
    Qm,
    eqz
);
    input ldA, ldQ, ldM, clrA, clrQ, clrff, shftA, shftQ, addSub, decr, ldcnt, clk;
    input [15:0] dataIn;
    output eqz, Q0, Qm;
    assign Q0 = Q[0];
    wire [15:0] A, M, Q, Z;
    wire [4:0] count;
    assign eqz = ~|count;
    PIPO p1 (
        M,
        dataIn,
        ldM,
        clk
    );
    ALU alu (
        Z,
        A,
        M,
        addSub
    );
    counter CN (
        count,
        decr,
        ldcnt,
        clk
    );
    shiftReg AR (
        A,
        Z,
        A[15],
        ldA,
        clrA,
        shftA,
        clk
    );
    shiftReg QR (
        Q,
        dataIn,
        A[0],
        ldQ,
        clrQ,
        shftQ,
        clk
    );
    dff QM1 (
        Qm,
        Q[0],
        clrff,
        clk
    );

endmodule

module counter (
    output reg [4:0] result,
    input decr,
    ldcnt,
    clk
);
    always @(posedge clk) begin
        if (ldcnt) result <= 5'b10000;
        else if (decr) result = result - 1;
    end
endmodule
module ALU (
    output [15:0] result,
    input [15:0] a,
    input [15:0] b,
    input addSub
);
    assign result = addSub ? (a + b) : (a - b);
endmodule

module PIPO (
    output reg [15:0] dataOut,
    input [15:0] dataIn,
    input ld,
    clk
);
    always @(posedge clk) begin
        if (ld) dataOut <= dataIn;
    end
endmodule

module shiftReg (
    dataOut,
    dataIn,
    shiftIn,
    ld,
    clr,
    shft,
    clk
);
    input ld, clr, shft, shiftIn, clk;
    input [15:0] dataIn;
    output reg [15:0] dataOut;
    always @(posedge clk) begin
        if (clr) dataOut <= 0;
        else if (ld) dataOut <= dataIn;
        else if (shft) dataOut <= {shiftIn, dataOut[15:1]};
    end
endmodule

module dff (
    output reg q,
    input d,
    clr,
    clk
);
    always @(posedge clk) begin
        if (clr) q <= 0;
        else q <= d;
    end
endmodule

module controller (
    ldA,
    ldQ,
    ldM,
    clrA,
    clrQ,
    clrff,
    shftA,
    shftQ,
    addSub,
    clk,
    ldcnt,
    decr,
    start,
    done,
    Q0,
    Qm,
    eqz
);

    input Q0, Qm, start, clk, eqz;
    output reg ldA, ldQ, decr, ldcnt, ldM, clrA, clrQ, clrff, shftA, shftQ, addSub;
    output reg done;
    reg [2:0] state;
    parameter s0 = 0, s1 = 1, s2 = 2, s3 = 3, s4 = 4, s5 = 5, s6 = 6;
    always @(posedge clk) begin
        case (state)
            s0: begin
                if (start) state <= s1;
                else state <= s0;
            end
            s1: begin
                state <= 2;
            end
            s2: begin
                #2
                if ((Q0 == 1'b0 && Qm == 1'b0) || (Q0 == 1'b1 && Qm == 1'b1)) begin
                    state <= s5;
                end else if (Q0 == 1'b0 && Qm == 1'b1) state <= s3;
                else if (Q0 == 1'b1 && Qm == 1'b0) state <= s4;
            end
            s3: state = s5;
            s4: state = s5;
            s5: begin
                #2
                if ((Q0 == 1'b0 && Qm == 1'b1) && !eqz) state <= s3;
                else if ((Q0 == 1'b1 && Qm == 1'b0) && !eqz) state <= s4;
                else if (eqz) state <= s6;
            end
            s6: state = s6;
            default: state = s0;
        endcase
    end
    always @(state) begin
        case (state)
            s0: begin
                done  = 0;
                clrA  = 0;
                clrQ  = 0;
                clrff = 0;
                ldA   = 0;
                ldM   = 0;
                ldQ   = 0;
                shftA = 0;
                shftQ = 0;
            end
            s1: begin
                #1 clrA = 1;
                clrff = 1;
                ldM   = 1;
                ldcnt = 1;
                clrQ  = 0;
            end
            s2: begin
                #1 clrA = 0;
                clrff = 0;
                ldM   = 0;
                ldcnt = 0;
                ldQ   = 1;
            end
            s3: begin
                ldA = 1;
                addSub = 1;
                ldQ = 0;
                shftQ = 0;
                shftA = 0;
                decr = 0;
            end
            s4: begin
                ldA = 1;
                addSub = 0;
                ldQ = 0;
                shftA = 0;
                shftQ = 0;
                decr = 0;
            end
            s5: begin
                shftA = 1;
                shftQ = 1;
                ldA   = 0;
                ldQ   = 0;
                decr  = 1;
            end
            s6: begin
                done  = 1;
                decr  = 0;
                shftA = 0;
                shftQ = 0;
            end
            default: begin
                clrA  = 0;
                shftA = 0;
                ldQ   = 0;
                shftQ = 0;
            end
        endcase
    end
endmodule

module stimulus;
    reg clk = 0;
    reg start;
    reg [15:0] dataIn;
    wire done;
    boothMul booth (
        ldA,
        ldQ,
        ldM,
        clrA,
        clrQ,
        clrff,
        shftA,
        shftQ,
        addSub,
        decr,
        ldcnt,
        clk,
        dataIn,
        Q0,
        Qm,
        eqz
    );

    controller control (
        ldA,
        ldQ,
        ldM,
        clrA,
        clrQ,
        clrff,
        shftA,
        shftQ,
        addSub,
        clk,
        ldcnt,
        decr,
        start,
        done,
        Q0,
        Qm,
        eqz
    );

    always #5 clk = ~clk;
    initial begin
        start = 0;
        #2 start = 1;
        #350 $finish;
    end
    initial begin
        #25 dataIn = 16'd6;
        #5 dataIn = 16'd2;
    end
    initial
        $monitor(
            $time,
            " ,%d,%b %d ,%d done:%b %b",
            booth.M,
            booth.ldM,
            booth.Q,
            control.state,
            done,
            clk
        );


endmodule
