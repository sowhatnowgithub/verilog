module and_self(input a, b, output reg c);
always @(*) begin
    c = a & b;
end
endmodule

module or_self(input a, b, output reg c);
always @(*) begin
    c = a | b;
    c = ~c; 
end
endmodule

module xor_self(input a, b, output reg c);
always @(*) begin
    c = a & ~b | ~a & b;
end
endmodule

module cir(input a, b, c, d, output wire o);
wire q[0:1];
and_self a1(a, b, q[0]);
or_self a2(c, d, q[1]);
xor_self a3(q[0], q[1], o);
endmodule

module tb_cir;
reg a,b,c,d;
wire o;
integer i;
cir test(a,b,c,d,o);
initial begin
    a <= 0;
    b <= 0;
    c <= 0;
    d <= 0;
    
    $monitor ("a = %b, b = %b, c = %b, d = %b, o = %b",a,b,c,d,o);
    for (i = 1; i < 16; i++)
    begin
    {a,b,c,d} = i;
        #10;

    end
    
end
endmodule
