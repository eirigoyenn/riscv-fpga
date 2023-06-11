//PRIMERA IMPLEMENTACION DECODER PARA RISC V 32I
// DECODER
module Decoder ( instruccion ,rs1,rs2,rd,funct3,imm_out,opcode);	//PEnsar como afecta si es litle/big endian
//input
 input[31:0] instruccion;
 //output
 output reg [4:0] rs1;//rs1;
 output reg [4:0] rs2; //rs2
 output reg [4:0] rd; //rd
 output reg [2:0] funct3; //control de la alu
 output reg [31:0] imm_out;	// IMM,a chequear ... no se bien cuantos bits tienen que salir
 output reg[6:0] opcode;
 always @(instruccion) // creo que aca tendria que poner el flanco de algun clock
 
 begin 
	case (instruccion[6:0]) //falta  nop => addi rs1=0 y rd=0
		//Interger RegisterImmediate Instructinon
		7'b0010011: begin  							
							 rs1=instruccion[19:15];
							 rs2=4'b0000;
							 rd=instruccion[11:7];		
							 funct3=instruccion[14:12];
							 opcode=7'b0010011;
							 case (instruccion[14:12])
							  3'b000:begin
											if(instruccion[31]==1'b1)
											begin //veo signo
												imm_out={20'hFFFFF,instruccion[31:25],instruccion[24:20]};
											end
											else begin
												imm_out={20'h00000,instruccion[31:25],instruccion[24:20]};
											end
										end
							  3'b010:begin
											if(instruccion[31]==1'b1)
											begin //veo signo
												imm_out={20'hFFFFF,instruccion[31:25],instruccion[24:20]};
											end
											else begin
												imm_out={20'h00000,instruccion[31:25],instruccion[24:20]};
											end
										end
							  3'b100:begin
											if(instruccion[31]==1'b1)
											begin //veo signo
												imm_out={20'hFFFFF,instruccion[31:25],instruccion[24:20]};
											end
											else begin
												imm_out={20'h00000,instruccion[31:25],instruccion[24:20]};
											end
										end
							  3'b110:begin
											if(instruccion[31]==1'b1)
											begin //veo signo
												imm_out={20'hFFFFF,instruccion[31:25],instruccion[24:20]};
											end
											else begin
												imm_out={20'h00000,instruccion[31:25],instruccion[24:20]};
											end
										end
							  3'b111:begin
											if(instruccion[31]==1'b1)
											begin //veo signo
												imm_out={20'hFFFFF,instruccion[31:25],instruccion[24:20]};
											end
											else begin
												imm_out={20'h00000,instruccion[31:25],instruccion[24:20]};
											end
										end
							  default: begin 
												imm_out={20'h00000,instruccion[31:25],instruccion[24:20]};
											end
								endcase
							end  
		7'b0110111:begin		//LUI?
							rd=instruccion[11:7];
							imm_out={instruccion[31:12],12'h000};
							rs1=0;
							rs2=0;
							funct3=0;
							opcode=7'b0110111; //grupo de instruccion
						end
		7'b0010111:begin		//AUIPC?
							rd=instruccion[11:7];
							imm_out={instruccion[31:12],12'b000000000000};
							rs1=0;
							rs2=0;
							funct3=0;
							opcode=7'b0010111; //grupo de instruccion
						end
		//Integer Register-Register Operations
		7'b0110011: begin //creo que no hace falta
							 rs1=instruccion[19:15];
							 rs2=instruccion[24:20];
							 rd=instruccion[11:7];
							 funct3=instruccion[14:12];		
							 imm_out={25'b0000000000000000000000000,instruccion[31:25]};
							 opcode=7'b0110011;
						end 	
		7'b1101111:begin  //JAL
							rd=instruccion[11:7];
							rs1=0;
							rs2=0;
							funct3=0;
							opcode=7'b1101111;
							if(instruccion[31]==1'b1)
							begin //veo signo
								imm_out={11'b11111111111,instruccion[31],instruccion[19:12],instruccion[20],instruccion[30:21],1'b0};
							end
							else begin
								imm_out={11'b00000000000,instruccion[31],instruccion[19:12],instruccion[20],instruccion[30:21],1'b0};
							end
						end
		7'b1100111:begin  //JALR
							rd=instruccion[11:7];
							rs1=instruccion[19:15];
							rs2=0;
							funct3=0;
							opcode=7'b1100111;
							if(instruccion[31]==1'b1)
							begin //veo signo
								imm_out={20'hFFFFF,instruccion[31:20]};
							end
							else begin
								imm_out={20'h00000,instruccion[31:20]};
							end
						end						
		7'b1100011:begin //Branches
							funct3=instruccion[14:12];
							rs1=instruccion[19:15];
							rs2=instruccion[24:20];
							rd=0;
							opcode=7'b1100011;
							case (instruccion[14:12])
								3'b000:begin
											if(instruccion[31]==1'b1)
											begin //veo signo
												imm_out={20'hFFFF,instruccion[31],instruccion[7],instruccion[30:25],instruccion[11:8],1'b0};
											end
											else begin
												imm_out={20'h00000,instruccion[31],instruccion[7],instruccion[30:25],instruccion[11:8],1'b0};
											end
									    end
								3'b001:begin
											if(instruccion[31]==1'b1)
											begin //veo signo
												imm_out={20'hFFFF,instruccion[31],instruccion[7],instruccion[30:25],instruccion[11:8],1'b0};
											end
											else begin
												imm_out={20'h00000,instruccion[31],instruccion[7],instruccion[30:25],instruccion[11:8],1'b0};
											end
										end
								3'b100:begin
											if(instruccion[31]==1'b1)
											begin //veo signo
												imm_out={20'hFFFF,instruccion[31],instruccion[7],instruccion[30:25],instruccion[11:8],1'b0};
											end
											else begin
												imm_out={20'h00000,instruccion[31],instruccion[7],instruccion[30:25],instruccion[11:8],1'b0};
											end
										end
								3'b101:begin
											if(instruccion[31]==1'b1)
											begin //veo signo
												imm_out={20'hFFFF,instruccion[31],instruccion[7],instruccion[30:25],instruccion[11:8],1'b0};
											end
											else begin
												imm_out={20'h00000,instruccion[31],instruccion[7],instruccion[30:25],instruccion[11:8],1'b0};
											end
										end
								default:begin
										imm_out={20'h00000,instruccion[31],instruccion[7],instruccion[30:25],instruccion[11:8],1'b0};
									end
								endcase
						end
		//Memory access , LOAD
		7'b0000011: begin
							 rs1=instruccion[19:15];		//entre A y immout forman el efective address =>17bits,lugar a donde ir a buscar un dato
							 rd=instruccion[11:7];			//regitro al que se le carga un dato de la memoria
							 funct3=instruccion[14:12];		//ojo que esto no iria a la alu, xq indica el ancho de la palabra
							 opcode=7'b0000011;
							 rs2=0;
							 if(instruccion[31]==1'b1)
							 begin //veo signo
								imm_out={20'hFFFFF,instruccion[31:20]};
							 end
							 else begin
								imm_out={20'hFFFFF,instruccion[31:20]};
							end
						end	// de memo carga en rd
		
		//Memory Access , STORE
		7'b0100011: begin 
							 rd=instruccion[11:7];	//usados para indicar el efective address =>17bits, lugar a donde ir a guardar
							 rs1=instruccion[19:15];		
							 rs2=instruccion[24:20];	 	//registro del cual se va a guarda el dato que posee en memoria
							 funct3=instruccion[14:12];		//usados pa distinguir el largo del dato
							 opcode=7'b0100011;
							 if(instruccion[31]==1'b1)
							 begin //veo signo
									imm_out={20'hFFFFF,instruccion[31:25],instruccion[11:7]};
							 end
							 else begin
									imm_out={20'h00000,instruccion[31:25],instruccion[11:7]};
							 end	 
						end	//de rs2=> memo		
		

		default: begin				//en caso de que pase algo , mando una instruccion NOP
						rd=5'b00000;
						funct3=3'b000;
						rs1=5'b00000;
						imm_out={25'b0000000000000000000000000,instruccion[31:25]};
						opcode=7'b0110011;
					end
	endcase
end
	
endmodule






	