/*RAS, only stack*/
/*INPUTS=> Reset
			  push
			  pop
			  pc_in(return)
  OUTPUTS => pc_out()
			    sel_mux
*/
module ras_stack (input wire reset,input wire push,input wire pop,input wire [31:0] pc_in,output reg [31:0] pc_out);

  reg [31:0] stack [0:31];
  reg [4:0] tos;
  wire [2:0] next_tos;
  wire [7:0] next_data_out;
  //wire next_empty;
  //wire next_full;

  always @(*)
  begin
    if (reset)
	 begin
      tos = 0;
		pc_out=32'hFFFFFFFF;
     
    end 
	 else 
	 begin
		if(push)
		begin
			stack[tos]=pc_in;
			pc_out=stack[tos];
		end
		else if(pop)
		begin
			pc_out=stack[tos-5'b00001];
		end
		tos=(push ? tos + 5'b00001 : (pop && tos > 0 ? tos - 5'b00001 : tos));
		//tos = next_tos;
    end
  end

 // assign next_tos = push ? top + 1 : (pop && top > 0 ? top - 1 : top);
  //assign next_pc_out = stack[tos-1];
  //assign pc_out = next_data_out;
  //assign next_empty = (top == 0);
  //assign next_full = (top == 7);
  //assign empty = next_empty;
  //assign full = next_full;

endmodule
