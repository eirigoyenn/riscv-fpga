module stage_mawb
(
 input wire[31:0] data_in,
 input wire write_ena_in,
 input wire[4:0] rd_in,
 input wire clk,
 input wire ena_mawb,
 output wire[31:0] data_out,
 output wire write_ena_out,
 output wire[4:0] rd_out
 );
	
	reg[31:0] data;
	reg[4:0] rd;
	reg write_ena;
	
	
	initial begin 
		data = 32'h00000000;
		rd = 5'b00000;
		write_ena = 1'b0;
	end
	
	always @(posedge clk) begin
			if (ena_mawb) begin
				data = data_in;
				rd = rd_in;
				write_ena = write_ena_in;
			end
	end
	
	assign write_ena_out = write_ena;
	assign rd_out = rd;
	assign data_out = data;


endmodule