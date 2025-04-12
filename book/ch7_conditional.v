// if else if else
// Multiway branching
// case statement using concatenation with in these () is useful
// casex, casez -> these are the  variations of case statement
module case0;
reg a = 0;
initial begin
    case(a)
        1'b0: a = 1;
        1'b1: a = 0;
        default: $display("This is invalid");
    endcase
end
endmodule
module mux4to1(output reg out, input i0, i1,i2,i3, s1,s0);

always @(*) begin
    case({s1, s0})
    2'd0: out = i0;
    2'd1: out = i1;
    2'd2: out = i2;
    2'd3: out = i3;
    default: $display("Not possible");
    endcase
end
endmodule

module demux1to4(output reg out0, out1, out2, out3, input in, s0,s1);

always @(s0 or s1 or in) begin
    case ({s1,s0})
        2'd0: begin out0 = in; out1 = 1'bz; out2 = 1'bz;out3 = 1'bz; end
        2'd1: begin out0 = 1'bz; out1 = in; out2 = 1'bz;out3 = 1'bz; end
        2'd2: begin out0 = 1'bz; out1 = 1'bz; out2 = in;out3 = 1'bz; end
        2'd3: begin out0 = 1'bz; out1 = 1'bz; out2 = 1'bz;out3 = in; end
        2'b0x, 2'bx0, 2'bxx, 2'b1x, 2'bx1, 2'bxz, 2'bzx: begin out0 = 1'bx; out1 = 1'bx; out2 = 1'bx; out3 = 1'bx;  end
        2'b0z, 2'bz0, 2'b1z, 2'bz1: begin out0 = 1'bz; out1 = 1'bz; out2 = 1'bz; out3 = 1'bz; end
        default: $display("Not possible");
    endcase
end
endmodule

module casex0;
reg [3:0]encoding;
integer state;
initial begin
    encoding = 4'b01zz;
    casex(encoding)
    4'b1xxx: state = 3;
    4'bx1xx: state = 2;
    4'bxx1x: state = 1;
    4'bxxx1: state = 0;
    default: $display("I don't care");
    endcase
    #1;
    $display("encoding:%b, state:%b", encoding, state);
end

endmodule
module casez0;
reg [3:0]encoding;
integer state;
initial begin
    encoding = 4'bzzzz;
    casez(encoding)
    4'b100z: state = 3;
    4'b01z0: state = 2;
    4'bzz10: state = 1;
    4'bzz01: state = 0;
    default: $display("I don't care");
    endcase
    #1;
    $display("encoding:%b, state:%b", encoding, state);
end
endmodule
