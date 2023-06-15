module reg_bank(
  input wire [4:0] readPort1, readPort2, writePort,
  input wire [31:0] wBus,
  input wire regWrite,
  output wire [31:0] busA, busB
);

  reg [31:0] registers [31:0];  // Declaración de los registros

  always @(*) begin
    if (regWrite && (writePort != 5'b00000)) begin  // Si quiero escribir (no se puede escribir el registro 0)
      registers[writePort] <= wBus;  // Escritura en el registro seleccionado
    end
    registers[1] = 32'h00000001;
    registers[2] = 32'h00000002;
  end
  
  
  assign busA = (readPort1 != 5'b00000) ? registers[readPort1] : 32'b0;  // Lectura del primer registro seleccionado
  assign busB = (readPort2 != 5'b00000) ? registers[readPort2] : 32'b0;  // Lectura del segundo registro seleccionado
endmodule