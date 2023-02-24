module module_s(input logic a,b, output logic y1,y2,y3);

and U1(y1,a,b);	//And gate
or U2(y2,a,b);		//Or gate
xor U3(y3,a,b);	//Xor gate

endmodule

