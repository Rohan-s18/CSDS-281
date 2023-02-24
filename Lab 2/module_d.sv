module module_d(input logic a,b, output logic y1,y2,y3);

assign y1 = a & b;	//And gate
assign y2 = a | b;	//Or gate
assign y3 = a ^ b;	//Xor gate

endmodule

