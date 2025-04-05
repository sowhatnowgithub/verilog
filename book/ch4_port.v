/*
ports allows the modules to communicate with other modules

Inputs ports can only be continous assignment types, since they just pass the values
but external input ports like instantiation, can pass reg, since wire can take reg
Where as Output ports can be storage type like reg and wire internally,
but external Output ports has to be a wire;
where as inout has to be wire, internally and externally
You have to know that width of the input ports that are internal and external has to match in width, or else warning will be issued
You don't have to assign value to the ports, its not an error, but the value will z


You can connect the external ports by two ways, connecting by port names and connecting by ordered list

You can access the internal variables and ports of an modules, based on heirarchial naming and order, from top or root module
If stimulus is root module, root module meaning it is not instantiated anywhere else, and lets stimulus has q, qbar, set, reset, now you can access them like
stimulus.q and so
Each identifiere has a unique heirarchial name
Ex: <top_module>.<submodule>.<identifier>

*/

module submodule(output reg u1);
endmodule

module top;
wire w;
submodule sub1(w);
reg a;
initial begin
    a = w;
    top.sub1.u1 = 1'b1;
    $display("%b", w);
end
endmodule
