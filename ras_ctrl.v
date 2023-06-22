/*
	Return Address Stack:
	inputs=> opcode 
	         imm_in
				rs1
				rd
				pc_in
				ras_en  , viene del decoder, si uso alguno de los registros x1 o x5 , entonces usare el ras y no el jmp control
				pcfromras => pc que viene del stack.
	outputs=> pc_jmp
	(TOmuxpc) sel_mux
	
*/
module ras_ctrl (opcode,imm_in,rs1,rd,pc_in,ras_en,pc_jmp,muxras);
//INPUTS
input wire[6:0] opcode;
input wire[31:0] imm_in;
input wire[31:0] pc_in;
input wire[4:0] rs1;
input wire[4:0] rd;
input wire ras_en;



//output wire en_ras;
output wire [31:0] pc_jmp; //Direccion a donde saltar.
output wire muxras;

//cosas pal manejo del stack
 reg [31:0] stack [0:31];
 integer tos=0;
 

reg [31:0] pc_to_ras;
reg [31:0] pc_jmp_;
reg [31:0] aux=32'h00000000;

reg muxrasreg=0;

always @(ras_en)
begin 
	if(ras_en == 1'b1) begin 
		muxrasreg=0;
		begin
				case(opcode)
					7'b1101111://JAL el decoder me pasa si uso los registro x1 o x5
						begin
							if(imm_in!=0)	//Logica de Push , solo si se usan los registros x1=1 y x5=5(por documentacion)
							begin						
								
								pc_jmp_ <= (pc_in+imm_in);			//mando al pc la nueva direccion.	
								stack[tos]= pc_in+(32'h00000004);  //guardo la direccion de retorno.
								tos = tos + 1;
								muxrasreg=1'b1;
							end
							else			// Logica de Pop , imm_in=0; 
							begin			
								muxrasreg=1'b1;
								tos = tos - 1;
								pc_jmp_ = stack[tos];
								end	
						end
					7'b1100111://JALR
						begin	
							if(rd==rs1)	//Push
							begin				
								aux=pc_in+(imm_in+rs1);
								pc_jmp_={aux[31:1],1'b0};	//mando al pc la nueva direccion.	
								stack[tos]= pc_in+(32'h00000004);  //guardo la direccion de retorno.
								tos = tos + 1;
								muxrasreg=1'b1;
							end
							
							else if(( (rs1==5'b00001) || (rs1==5'b00101) )&&( (rd!=5'b00001) && (rd!=5'b00101) )) //pop
							begin

								muxrasreg=1'b1;
								tos = tos - 1;
								pc_jmp_ = stack[tos];
							end
							
							else if(( (rd==5'b00001) || (rd==5'b00101) )&&( (rs1!=5'b00001)&&(rs1!=5'b00101) )) //push 
							begin
								
								aux=pc_in+(imm_in+rs1);
								pc_jmp_={aux[31:1],1'b0};	//mando al pc la nueva direccion.	
								stack[tos]= pc_in+(32'h00000004);  //guardo la direccion de retorno.
								tos = tos + 1;
								muxrasreg=1'b1;
							end
						
								
							else if (( (rd==5'b00001)||(rd==5'b00101) )&&( (rs1==5'b00001)||(rs1==5'b00101) )) 	//Pop , y push 
							begin	

								aux=(imm_in+rs1);
								pc_jmp_=(pc_in+{aux[31:1],1'b0}); 
								tos=tos-1;
								stack[tos]= pc_in+(32'h00000004);
								muxrasreg=1'b1;
								
							end
								
						end
					default:
						begin

							pc_jmp_=pc_in+(32'h00000004);
							muxrasreg=1'b1;
						end
				endcase
			end
	end 
	else begin 
		muxrasreg = 1'b0;
	end
end

assign pc_jmp = pc_jmp_;

assign muxras = muxrasreg;

endmodule