`timescale 1ns/10ps
module testbench ();
logic [1:0] a2, b2, s2;
logic [7:0] a8, b8, s8;
logic       co2, co8;
cla_adder #(
.N(2)
) UUT2 (
a2,
b2,
0,
s2,
co2
);
cla_adder #(
.N(8)
) UUT8 (
a8,
b8,
0,
s8,
co8
);
initial begin
a2 = 0;
forever
#10 a2++;
end
initial begin
b2 = 0;
forever
#40 b2++;
end
initial begin
a8 = 0;
forever
#10 a8 = a8 + 3;
end
initial begin
b8 = 0;
forever
#10 b8 = b8 + 5;
end
initial begin
#320 $finish();
end
endmodule
