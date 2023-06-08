module decoder ( instruccion ,A,B,C,ALU,imm_out);	
 input[31:0] instruccion;
 //input wire clk,  
 output reg [4:0] A;//rs1;
 output reg [4:0] B; //rs2
 output reg [4:0] C; //rd
 output reg [2:0] ALU; //control de la alu
 output reg [11:0] imm_out;	// IMM,a chequear ... no se bien cuantos bits tienen que salir
 always @(instruccion) // creo que aca tendria que poner el flanco de algun clock
 
 begin 
	case (instruccion[6:0]) //falta  nop => addi rs1=0 y rd=0
		//Memory access , LOAD
		7'b0000011: begin
							 A=instruccion[19:15];		//entre A y immout forman el efective address =>17bits,lugar a donde ir a buscar un dato
							 imm_out=instruccion[31:20];
							 C=instruccion[11:7];			//regitro al que se le carga un dato de la memoria
							 ALU=instruccion[14:12];		//ojo que esto no iria a la alu, xq indica el ancho de la palabra
							 
							end	// de memo carga en rd
		
		//Interger RegisterImmediate Instructinon
		7'b0010011: begin  							
							 A=instruccion[19:15];
							 C=instruccion[11:7];		
							 ALU=instruccion[14:12];
							 imm_out=instruccion[31:20];
							end  	
				  
		//Memory Access , STORE
		7'b0100011: begin 
							 C=instruccion[11:7];	//usados para indicar el efective address =>17bits, lugar a donde ir a guardar
							 A=instruccion[19:15];		
							 imm_out=instruccion[31:25];
							 B=instruccion[24:20];	 	//registro del cual se va a guarda el dato que posee en memoria
							 ALU=instruccion[14:12];		//usados pa distinguir el largo del dato
							 
							end	//de rs2=> memo		
		
		//Integer Register-Register Operations
		7'b0110011: begin //creo que no hace falta
							 A=instruccion[19:15];
							 B=instruccion[24:20];
							 C=instruccion[11:7];
							 ALU=instruccion[14:12];		
							 imm_out=instruccion[31:25];
							end 
		default: begin				//en caso de que pase algo , mando una instruccion NOP
						C=5'b00000;
						ALU=3'b000;
						A=5'b00000;
						imm_out=12'b000000000000;
					end
	endcase
end
	
endmodule