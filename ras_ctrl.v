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
module ras_ctrl (opcode,reset_in,imm_in,rs1,rd,pc_in,pcfromras,ras_en,pc_jmp,reset_outras,pushras,popras,pctoras);
//INPUTS
input wire[6:0] opcode;
input wire[31:0] imm_in;
input wire[31:0] pc_in;
input wire[4:0] rs1;
input wire[4:0] rd;
input wire ras_en;
input wire reset_in;
input wire[31:0] pcfromras;
//OUTPUTS

output wire [31:0] pctoras;
output wire pushras;
output wire popras;
output wire reset_outras;
output wire [31:0] pc_jmp; //Direccion a donde saltar.

reg [31:0] pc_to_ras;
reg [31:0] pc_jmp_;
reg [31:0] aux=32'h00000000;
reg push_flag=0;
reg pop_flag=0;
reg reset=0;

always @(posedge ras_en)
begin 
	push_flag=0;
	pop_flag=0;
	reset=0;
	if (reset_in) 
		begin 
			reset=1'b1;
			pop_flag=1'b0;
			push_flag=1'b0;
			pc_to_ras=32'hFFFFFFFF;
			pc_jmp_=pc_in+(32'h00000004);
		end
	else
		begin
				case(opcode)
					7'b1101111://JAL el decoder me pasa si uso los registro x1 o x5
						begin
							if(imm_in!=0)	//Logica de Push , solo si se usan los registros x1=1 y x5=5(por documentacion)
							begin
								pc_to_ras <= pc_in+(32'h00000004); //guardo la direccion de retorno.
								push_flag <= 1'b1;
								pop_flag <= 1'b0;
								pc_jmp_ <= (pc_in+imm_in);			//mando al pc la nueva direccion.	
								reset <= 1'b0;
							end
							else			// Logica de Pop , imm_in=0; 
							begin			
								pop_flag=1'b1;
								push_flag=1'b0;
								reset=1'b0;
								pc_jmp_=pcfromras;
								pc_to_ras=32'hFFFFFFFF;
							end	
							
						end
					7'b1100111://JALR
						begin	
							if(rd==rs1)	//Push
							begin
								pc_to_ras = pc_in+(32'h00000004); 
								push_flag=1'b1;
								pop_flag=1'b0;
								aux=(imm_in+rs1);
								pc_jmp_=(pc_in+{aux[31:1],1'b0});				
								reset=1'b0;
							end
							
							else if(( (rs1==5'b00001) || (rs1==5'b00101) )&&( (rd!=5'b00001) && (rd!=5'b00101) )) //pop
							begin
								pop_flag=1'b1;
								push_flag=1'b0;
								reset=1'b0;
								pc_jmp_=pcfromras;
								pc_to_ras=32'hFFFFFFFF;
							end
							
							else if(( (rd==5'b00001) || (rd==5'b00101) )&&( (rs1!=5'b00001)&&(rs1!=5'b00101) )) //push 
							begin
								pc_to_ras= pc_in+(32'h00000004); 
								push_flag=1'b1;
								pop_flag=1'b0;
								aux=(imm_in+rs1);
								pc_jmp_=(pc_in+{aux[31:1],1'b0});				//VER BIEN COMO SE SUMA
								reset=1'b0;
							end
						
								
							else if (( (rd==5'b00001)||(rd==5'b00101) )&&( (rs1==5'b00001)||(rs1==5'b00101) )) 	//Pop , y push 
							begin	
								pop_flag=1'b1;	
								push_flag=1'b1;  //por el momento ,debug
								reset=1'b0;
								pc_jmp_=pcfromras;
								pc_to_ras = pc_in+(32'h00000004); 
							end
								
						end
					default:
						begin
							pop_flag=1'b0;
							push_flag=1'b0;
							reset=1'b0;
							pc_to_ras=32'hFFFFFFFF;
							pc_jmp_=pc_in+(32'h00000004);
						end
				endcase
			end
end
assign pctoras = pc_to_ras;
assign pc_jmp = pc_jmp_;
assign pushras = push_flag;
assign popras = pop_flag;
assign reset_outras = reset;

endmodule