module reg_bank(
  input wire [4:0] readPort1, readPort2, writePort,
  input wire [31:0] wBus,
  input wire regWrite,
  input wire clk,
  output wire [31:0] busA, busB,
  output wire [31:0] reg_cinco,
  output wire [31:0] reg_seis,
  output wire [31:0] reg_siete
);

  reg [31:0] registers [31:0];  // Declaración de los registros

  always @(negedge clk) begin //wBus lo elimine, trae problemas al escribir dos veces seguidas un registro la segunda no se escribe!
    if (regWrite && (writePort != 5'b00000)) begin  // Si quiero escribir (no se puede escribir el registro 0)
      registers[writePort] <= wBus;  // Escritura en el registro seleccionado
    end
  end
  
  
  assign busA = (readPort1 != 5'b00000) ? registers[readPort1] : 32'b0;  // Lectura del primer registro seleccionado
  assign busB = (readPort2 != 5'b00000) ? registers[readPort2] : 32'b0;  // Lectura del segundo registro seleccionado
  assign reg_cinco = registers[5];
  assign reg_seis = registers[6];
  assign reg_siete = registers[7];
  
endmodule