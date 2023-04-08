module gen_alu #(
    parameter N = 8
) (
    input  logic [N-1:0] a, b,
    input  logic   [1:0] f,
    output logic [N-1:0] s,
    output logic         co
);

    logic [N:0] c;

alu_slice U[N-1:0] (a, b, c[N-1:0], f, s, c[N:1]);
    assign c[0] = 0;
    assign co = c[N];
    endmodule

