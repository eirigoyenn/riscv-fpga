/*RAS, only stack*/
/*INPUTS=> Reset
			  push
			  pop
			  pc_in(return)
  OUTPUTS => pc_out()
			    
*/
module ras_stack (reset, push, pop, pc_in, pc_out);

  input wire reset;
  input wire push;
  input wire pop;
  input wire[31:0] pc_in;
  
  output wire [31:0] pc_out;
  
  reg [31:0] stack [0:31];
  reg [4:0] tos;
  reg [31:0] pc_out_;


  always @(*)
  begin
    if (reset)
	 begin
      tos = 0;
		pc_out_=32'hFFFFFFFF;
     
    end 
	 else 
	 begin
		if(push)
		begin
			stack[tos]=pc_in;
			pc_out_=stack[tos];
		end
		else if(pop)
		begin
			pc_out_=stack[tos-5'b00001];
		end
		tos=(push ? tos + 5'b00001 : (pop && tos > 0 ? tos - 5'b00001 : tos));
		//tos = next_tos;
    end
  end
  
assign pc_out=pc_out_;

endmodule
