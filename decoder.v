module Decoder ( inst ,rs1,rs2,rd,funct3,funct7,imm_out,op);	

 input wire [31:0] inst;
 output reg [4:0] rs1;
 output reg [4:0] rs2; 
 output reg [4:0] rd; 
 output reg [2:0] funct3; //control de la alu
 output reg [6:0] funct7;
 output reg [6:0] op;
 output reg [11:0] imm_out;	//Saco 20 bits , a veces uso menos.
 
 always @(inst)
 
 begin 
	case (inst[6:0]) //falta  nop => addi rs1=0 y rd=0
		//Memory access , LOAD
		7'b0000011: begin
							 rs1=inst[19:15];		//entre A y immout forman el efective address =>17bits,lugar a donde ir a buscar un dato
							 imm_out=inst[31:20];
							 rd=inst[11:7];			//regitro al que se le carga un dato de la memoria
							 funct3=inst[14:12];		//ojo que esto no iria a la alu, xq indica el ancho de la palabra
							 rs2 = 5'b00000;
							end	// de memo carga en rd
		
		//Interger RegisterImmediate Instructinon
		7'b0010011: begin  							
							 rs1=inst[19:15];
							 rd=inst[11:7];		
							 funct3=inst[14:12];
							 imm_out=inst[31:20];
							 rs2=5'b00000;
							end  	
				  
		//Memory Access , STORE
		7'b0100011: begin 
							 rd=inst[11:7];	//usados para indicar el efective address =>17bits, lugar a donde ir a guardar
							 rs1=inst[19:15];		
							 imm_out=inst[31:25];
							 rs2=inst[24:20];	 	//registro del cual se va a guarda el dato que posee en memoria
							 funct3=inst[14:12];		//usados pa distinguir el largo del dato
							 
							end	//de rs2=> memo		
		
		//Integer Register-Register Operations
		7'b0110011: begin //creo que no hace falta
							 rs1=inst[19:15];
							 rs2=inst[24:20];
							 rd=inst[11:7];
							 funct3=inst[14:12];		
							 imm_out=inst[31:25];
							end 
		default: begin				//en caso de que pase algo , mando una instruccion NOP
						rd=5'b00000;
						funct3=3'b000;
						rs1=5'b00000;
						imm_out=12'b000000000000;
						rs2 = 5'b00000;
					end
	endcase
	op = inst[6:0];
end
	
endmodule






	