module module_b(input logic a,b, output logic y1,y2,y3);

always_comb
begin
y1 = a & b;		//And gate
y2 = a | b;		//Or gate
y3 = a ^ b;		//Xor gate
end

endmodule

