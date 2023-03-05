module cla_adder #(
  parameter N = 8
  ) (
    input logic [N-1:0] a, [N-1:0] b, c_in,
    output logic [N-1:0] s, c_out
  );
  logic [N-1:0] p, g;
  logic [N:0]   c;
  assign p = a ^ b;
  assign g =  a & b;
  for (genvar i = 0; i <= N; i++) begin
    if (i == 0)
      assign c[i] = c_in;
    else
      assign c[i] = g[i-1] | (p[i-1] & c[i-1]);
  end
  assign s = p ^ c;
  assign c_out = c[N];
endmodule
