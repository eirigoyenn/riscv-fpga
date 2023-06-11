module reg_bank(
  input wire [4:0] readPort1, readPort2, writePort,
  input wire [31:0] busC,
  input wire regWrite,
  output wire [31:0] busA, busB
);

  reg [31:0] registers [31:0];  // Declaración de los registros
  initial begin
    registers[0] = 32'h00000000;  // Inicialización de registro 0 32'h00000000
    
  end

  assign busA = registers[readPort1];  // Lectura del primer registro seleccionado
  assign busB = registers[readPort2];  // Lectura del segundo registro seleccionado

  always @(*) begin
    if (regWrite && (writePort != 5'b00000)) begin  // Si quiero escribir (no se puede escribir el registro 0)
      registers[writePort] = busC;  // Escritura en el registro seleccionado
    end
  end

endmodule
