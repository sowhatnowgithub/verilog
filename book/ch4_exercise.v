//Parallel 4-bit Shift register
module parallel_shft_reg (
    output reg [3:0] reg_out,
    input [3:0] reg_in,
    input clk,
    input nrst
);
    wire [3:0] w;
    dff dff1 (
        w[0],
        reg_in[0],
        clk,
        nrst
    );
    dff dff2 (
        w[1],
        reg_in[1],
        clk,
        nrst
    );
    dff dff3 (
        w[2],
        reg_in[2],
        clk,
        nrst
    );
    dff dff4 (
        w[3],
        reg_in[3],
        clk,
        nrst
    );
    always @(*) begin

        reg_out[0] = w[0];
        reg_out[1] = w[1];
        reg_out[2] = w[2];
        reg_out[3] = w[3];
    end
endmodule
module dff (
    output reg q,
    input d,
    clk,
    nrst
);
    always @(posedge clk) begin
        if (nrst) q <= d;
        else q <= 0;
    end
endmodule

module test;
    reg clk, nrst;
    reg  [3:0] reg_in;
    wire [3:0] reg_out;
    reg  [3:0] counter;

    parallel_shft_reg p1 (
        reg_out[3:0],
        reg_in[3:0],
        clk,
        nrst
    );

    initial $monitor("Out: %b, In: %b , clk: %b, nrst:%b", reg_out[3:0], reg_in[3:0], clk, nrst);
    initial begin
        clk  = 'b0;
        nrst = 1;
        for (counter = 0; counter < 16; counter++) begin
            #5;
            reg_in = counter;
        end

    end
    initial begin
        #95;
        $finish;
    end
    always #5 clk = ~clk;
endmodule

//End of parallel shift register
