// parity one => even
// parity zero => odd

module parityFSM (
    parity,
    data,
    clk
);
    input data, clk;
    output reg parity = 1;

    always @(posedge clk) begin
        if (parity == 1'b1) parity = data ? 0 : 1;
        else if (parity == 1'b0) parity = data ? 1 : 0;
    end
endmodule

module tb;
    parameter N = 8;
    reg [N-1:0] data;
    reg tempData = 0;
    reg clk;
    wire parity;
    parityFSM par (
        .parity(parity),
        .data(tempData),
        .clk(clk)
    );
    initial begin
        $dumpfile("parityFSM.vcd");
        $dumpvars(0, par);
        clk = 0;
        forever #5 clk = ~clk;
    end
    initial begin
        #150 $finish;
    end
    integer i;
    initial begin
        data = 8'd101;
        i = 0;
        #2;
        for (i = 0; i < N; i = i + 1) begin
            #10 tempData = data[i];
        end
        #10 $display("parity:%b, data:%b", parity, data);
    end
endmodule
