module stage_latch(
  input wire [4:0] rs1, rs2, rd,
  input wire [31:0] imm,
  input wire clk,
  input wire en,
  // agregar flags que vengan dependiendo el stage
  output wire [4:0] rs1_out, rs2_out, rd_out,
  output wire [31:0] imm_out
);

  reg [4:0] rs1_reg;
  reg [4:0] rs2_reg;
  reg [4:0] rd_reg;
  reg [31:0] imm_reg;

  always @(posedge clk) begin
    if (en) begin
      rs1_reg <= rs1;
      rs2_reg <= rs2;
      rd_reg <= rd;
      imm_reg <= imm;
		// agregar flags
    end
	 else begin			//En caso de HALT (en = 0) mando todo en cero (sería cmo un NOP)
		rs1_reg = 0;
      rs2_reg = 0;
      rd_reg = 0;
      imm_reg = 0;
	 end
  end

  assign rs1_out = rs1_reg;
  assign rs2_out = rs2_reg;
  assign rd_out = rd_reg;
  assign imm_out = imm_reg;

endmodule
