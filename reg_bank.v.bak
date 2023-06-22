module RegisterBank(
  input wire clk,
  input wire [4:0] readPort1, readPort2, writePort,
  input wire [31:0] busC,
  input wire regWrite,
  output reg [31:0] busA, busB
);

  reg [31:0] registers [31:0];  // Declaración de los registros
  initial begin
    registers[0] = 32'h00000000;
  end
  always @(posedge clk) begin
    if (regWrite && writePort) begin	//Si quiero escribir (no se puede escribir el reg 0)
      registers[writePort] <= busC;  // Escritura en el registro seleccionado
    end else begin
		 busA <= registers[readPort1];  // Lectura del primer registro seleccionado
		 busB <= registers[readPort2];  // Lectura del segundo registro seleccionado
	 end
  end

endmodule