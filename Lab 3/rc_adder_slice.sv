module rc_adder_slice (input logic a,b,c_in, output logic s,c_out);

    logic p, g;

    assign p = a ^ b;
    assign g = a & b;

    assign s = p ^ c_in;
    assign c_out = (p & c_in) | g;

endmodule
