module pc_mux(
  input wire alu_flag,
  input wire ras_flag,
  input wire [31:0] jmp_pc,
  input wire [31:0] ras_pc,
  input wire [31:0] ifu_pc,
  output wire [31:0] to_pc
);

  assign to_pc = (ras_flag) ? ras_pc : (alu_flag) ? jmp_pc : ifu_pc;

endmodule