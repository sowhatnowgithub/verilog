module fullSubtr (
    output D,
    B,
    input  x,
    y,
    z
);
    assign D = (~x & ~y & z) | (~x & y & ~z) | (x & ~y & ~z) | (x & y & z);
    assign B = (~x & y) | (~x & z) | (y & z);
endmodule

module stimulus;
    reg x, y, z;
    wire D, B;
    fullSubtr sub1 (
        D,
        B,
        x,
        y,
        z
    );
    integer count = 0;
    initial begin
        for (count = 0; count < 8; count++) begin
            {x, y, z} = count;
            #1;
        end
    end
    initial begin
        $monitor("x:%b, y:%b,z:%b  - B:%b, D:%b", x, y, z, B, D);
    end
endmodule
