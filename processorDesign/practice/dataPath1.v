// Multiplication by repeated Addition
/*
What do we need?
1. adder
2. Down Conuter
3. Comparator
*/
module dataPath1 (
    eqz,
    ldA,
    ldB,
    ldP,
    clrP,
    decB,
    data_in,
    clk
);
    input ldA, ldB, ldP, clrP, decB, clk;
    input [15:0] data_in;
    output eqz;
    wire [15:0] X, Y, Z, Bout, Bus;
    assign Bus = data_in;
    PIPO1 A (
        X,
        Bus,
        ldA,
        clk
    );
    PIPO2 P (
        Y,
        Z,
        ldP,
        clrP,
        clk
    );
    CNTR B (
        Bout,
        Bus,
        ldB,
        decB,
        clk
    );
    ADD AD (
        Z,
        X,
        Y
    );
    EQZ comp (
        eqz,
        Bout
    );
endmodule

module PIPO1 (
    output reg [15:0] dOut,
    input [15:0] dIn,
    input ld,
    clk
);

    always @(posedge clk) begin
        if (ld) dOut = dIn;
    end
endmodule

module PIPO2 (
    output reg [15:0] dOut,
    input [15:0] dIn,
    input ldB,
    clr,
    clk
);

    always @(posedge clk) begin
        if (clr) dOut = 16'b0;
        else begin
            if (ldB) dOut = dIn;
        end
    end
endmodule

module ADD (
    output reg [15:0] Sum,
    input [15:0] in1,
    input [15:0] in2
);
    always @(*) Sum = in1 + in2;
endmodule

module EQZ (
    output eqz,
    input [15:0] data
);
    assign eqz = (data == 0);
endmodule
module CNTR (
    output reg [15:0] out,
    input [15:0] dataIn,
    input ld,
    dec,
    clk
);
    always @(posedge clk) begin
        if (ld) out <= dataIn;
        else if (dec) out <= out - 1;
    end
endmodule

module controller (
    ldA,
    ldB,
    ldP,
    clrP,
    decB,
    done,
    clk,
    eqz,
    start
);
    reg [2:0] state;
    input start, clk, eqz;
    output reg ldA, ldB, ldP, clrP, decB, done;
    parameter s0 = 3'b000, s1 = 3'b001, s2 = 3'b010, s3 = 3'b011, s4 = 3'b100;

    /*
     */
    always @(posedge clk) begin
        case (state)
            s0: if (start) state <= s1;
            s1: state <= s2;
            s2: state <= s3;
            s3:
            #2
            if (eqz) state <= s4;
            else state = s3;
            s4: state <= s4;
            default: state <= 0;
        endcase
    end
    always @(state) begin
        case (state)
            s0: begin
                #1 ldA = 0;
                ldB  = 0;
                ldP  = 0;
                clrP = 0;
                decB = 0;
            end
            s1: begin
                #1 ldA = 1;
            end
            s2: begin
                #1 ldA = 0;
                ldB  = 1;
                clrP = 1;
            end
            s3: begin
                #1 ldB = 0;
                clrP = 0;
                ldP  = 1;
                decB = 1;
            end
            s4: begin
                #1 done = 1;
                ldB  = 0;
                ldP  = 0;
                decB = 0;
            end
            default: begin
                #1 ldA = 0;
                ldB  = 0;
                ldP  = 0;
                clrP = 0;
                decB = 0;
            end
        endcase
    end
endmodule

module tb;
    reg [15:0] dataIn;
    reg start;
    wire done;
    reg clk;
    dataPath1 dP1 (
        eqz,
        ldA,
        ldB,
        ldP,
        clrP,
        decB,
        dataIn,
        clk
    );
    controller control (
        ldA,
        ldB,
        ldP,
        clrP,
        decB,
        done,
        clk,
        eqz,
        start
    );

    initial begin
        clk = 1'b0;
        #3 start = 1'b1;
        #500 $finish;
    end
    always #5 clk = ~clk;

    initial begin
        #17 dataIn = 17;
        #10 dataIn = 5;
    end

    initial begin
        $monitor($time, " %d %b", dP1.Y, done);
    end
endmodule
