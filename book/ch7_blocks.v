// Blocks - Sequential Block and Parallel Blocks

// Sequential Blocks  => they are between begin and end terms, unless non-blocking assignment are specified with intra assignment delays, they are executed in serial

// Sequential blocks are Sequentially executed in nature

// Parallel Blocks are specified by fork and join like begin and end

// Statements in parallel blocks are executed concurrently

// When declaring Parallel Statements we have to be carefull about implicit race conditions

// The problem with fork and joinn is that CPU simulation limitation

// The interesting thing about the blocks is that we have nested Blocks
// We can have named blocks, and disabling these blocks
module Parallel0;

reg x,y;
reg [1:0] z,w;

initial fork
    x = 1'b0;
    #5 y = 1'b1;
    #10 z = {x,y};
    #15 w = {y,x};
join
endmodule

module blcoks1;
reg x,y;
reg [1:0]z,w;
initial begin
    x = 1'b0;
    fork
    #5 y = 1'b1;
    #10 z = {x,y};
    join
    #20 w = {y,x};
end
endmodule

module namedBlocks;
reg [15:0]flag;
integer i;
initial begin
    flag = 16'b 0010_0000_0000_0000;
    i = 0;
    begin :block1
        while (i < 16) begin
            if(flga[i]) begin
                $display("Encoutered a flag bit");
                disable block1; // when you disable essentially meaning exit the block1 execution
            end
            i = i + 1;
        end
    end
end
endmodule
