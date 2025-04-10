module magCmp (
    output AgtB,
    AltB,
    AeqB,
    input [3:0] A,
    input [3:0] B
);
    wire [3:0] x;
    assign x = A ~^ B;
    assign AgtB = (A[3]&~B[3]) | (x[3]&A[2]&~B[2] ) | (x[3]&x[2]&A[1]&~B[1]) |
(x[3]&x[2]&x[1]&A[0]&~B[0]);
    assign AltB = (~A[3]&B[3]) | (x[3]&~A[2]&B[2] ) | (x[3]&x[2]&~A[1]&B[1]) |
(x[3]&x[2]&x[1]&~A[0]&B[0]);
    assign AeqB = x[3] & x[2] & x[1] & x[0];
endmodule

module stimulus;
    reg [3:0] A;
    reg [3:0] B;
    wire AgtB, AltB, AeqB;
    magCmp mC1 (
        AgtB,
        AltB,
        AeqB,
        A,
        B
    );
    initial begin
        A = 4'd8;
        B = 4'd8;
        #1;
        $display("A:%b, B:%b - AgtB:%b, AltB:%b, AeqB:%b", A, B, AgtB, AltB, AeqB);
        A = 4'd8;
        B = 4'd9;
        #1;
        $display("A:%b, B:%b - AgtB:%b, AltB:%b, AeqB:%b", A, B, AgtB, AltB, AeqB);
        A = 4'd10;
        B = 4'd8;
        #1;
        $display("A:%b, B:%b - AgtB:%b, AltB:%b, AeqB:%b", A, B, AgtB, AltB, AeqB);
    end
endmodule
