module stage_mawb
(
 input wire[31:0] data_in,
 input wire[31:0] busc_in,
 input wire write_ena_in,
 input wire[4:0] rd_in,
 input wire clk,
 input wire ena_mawb,
 input wire [1:0] wrn_in,
 output wire[31:0] data_out,
 output wire write_ena_out,
 output wire[4:0] rd_out,
 output wire[31:0] busc_out,
 output wire [1:0] wrn_out
 );
	
	reg[31:0] data,busc;
	reg[4:0] rd;
	reg write_ena;
	reg[1:0] wrn;
	
	
	initial begin 
		data = 32'h00000000;
		busc = 32'h00000000;
		rd = 5'b00000;
		write_ena = 1'b0;
		wrn= 2'b00;
	end
	
	always @(posedge clk) begin
			if (ena_mawb) begin
				data = data_in;
				rd = rd_in;
				write_ena = write_ena_in;
				busc= busc_in;
				wrn = wrn_in;
			end
	end
	
	assign write_ena_out = write_ena;
	assign rd_out = rd;
	assign data_out = data;
	assign busc_out=busc;
	assign wrn_out = wrn;


endmodule