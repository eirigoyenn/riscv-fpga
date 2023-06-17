/*
	Return Address Stack:
	inputs=> opcode 
	         imm_in
				rs1
				rd
				pc
				ras_en  , viene del decoder, si uso alguno de los registros x1 o x5 , entonces usare el ras y no el jmp control
				reset_in
				pcfromras => pc que viene del stack.
	outputs=> pc_jmp
	(TOmuxpc) sel_mux
	
	outputs => reset_out
	(TOras)    push
	           pop
				  pctoras
*/
module ras_ctrl (opcode,reset_in,imm_in,rs1,rd,pc,pcfromras,ras_en,pc_jmp,reset_out,push,pop,pctoras);
//INPUTS
input wire[6:0] opcode;
input wire[31:0] imm_in;
input wire[31:0] pc;
input wire[4:0] rs1;
input wire[4:0] rd;
input wire ras_en;
input wire reset_in;
input wire[31:0] pcfromras;
//OUTPUTS

output wire [31:0] pctoras;
output wire push;
output wire pop;
output wire reset_out;
output wire [31:0] pc_jmp; //Direccion a donde saltar.

reg [31:0] pc_to_ras;
reg [31:0] pc_jmp_;
reg push_flag;
reg pop_flag;
reg reset;

always @(posedge ras_en)
begin 
	if(ras_en)
	begin
		if (reset_in) 
			begin 
				reset=1;
				pop_flag=0;
				push_flag=0;
				pc_to_ras=32'hFFFFFFFF;
				pc_jmp_=pc+(32'h00000004);
			end
		else
			begin
				case(opcode)
					7'b1101111://JAL el decoder me pasa si uso los registro x1 o x5
						begin
							if(imm_in!=0)	//Logica de Push , solo si se usan los registros x1=1 y x5=5(por documentacion)
							begin
								pc_to_ras = pc+(32'h00000004); //guardo la direccion de retorno.
								push_flag=1;
								pop_flag=0;
								pc_jmp_=(pc+imm_in);			//mando al pc la nueva direccion.	
								reset=0;
							end
							else			// Logica de Pop , imm_in=0; 
							begin			
								pop_flag=1;
								push_flag=0;
								reset=0;
								pc_jmp_=pcfromras;
								pc_to_ras=32'hFFFFFFFF;
							end	
							
						end
					7'b1100111://JALR
						begin	
							if(((rs1==5'h01)||(rs1==5'h05))&&((rd!=5'h01)||(rd!=5'h05))) //pop
							begin
								pop_flag=1;
								push_flag=0;
								reset=0;
								pc_jmp_=pcfromras;
								pc_to_ras=32'hFFFFFFFF;
							end
							
							else if(((rd==5'h01)||(rd==5'h05))&&((rs1!=5'h01)||(rs1!=5'h05))) //push 
							begin
								pc_to_ras= pc+(32'h00000004); 
								push_flag=1;
								pop_flag=0;
								pc_jmp_=(pc+imm_in);				//VER BIEN COMO SE SUMA
								reset=0;
							end
							 
							else if(((rs1==5'h01)||(rs1==5'h05))&&((rd!=5'h01)||(rd!=5'h05))) 
							begin	
								if(rd==rs1)	//Push
								begin
									pc_to_ras = pc+(32'h00000004); 
									push_flag=1;
									pop_flag=0;
									pc_jmp_=(pc+imm_in);				
									reset=0;
								end
									
								else		//Pop , y push ,creo que en ese orden //NO ENTIENDO QUE HACE TODO
								begin	
									pop_flag=1;
									push_flag=0;
									reset=0;
									pc_jmp_=pcfromras;
									pc_to_ras = pc+(32'h00000004); 
								end
								
							end
							else
							begin
								pop_flag=0;
								push_flag=0;
								reset=0;
								pc_to_ras=32'hFFFFFFFF;
								pc_jmp_=pc+(32'h00000004);
							end
						end
					default:
						begin
							pop_flag=0;
							push_flag=0;
							reset=0;
							pc_to_ras=32'hFFFFFFFF;
							pc_jmp_=pc+(32'h00000004);
						end
				endcase
			end
	end
end
assign pctoras=pc_to_ras;
assign pc_jmp=pc_jmp_;
assign push=push_flag;
assign pop=pop_flag;
assign reset_out=reset;

endmodule