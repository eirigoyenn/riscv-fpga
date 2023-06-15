module ram_async(
  input wire [7:0] address,
  input wire [2:0] bytes_,
  input wire [31:0] wBus,
  input wire write_,
  input wire signed_,
  input wire clk, 
  output wire [31:0] q
);

	reg [31:0] q0;
	reg [7:0] memory_ram [255:0]; 
	initial begin
    $readmemh("raminit.hex", memory_ram);
   end

	always @ (posedge clk) begin 
	
		if (write_==1'b1) begin  
			case(bytes_)
				3'b001: begin
							if(signed_ == 1) begin 
								memory_ram[address] <= wBus[7:0];
								q0 <= 32'h0000000;
							end
							else begin
								memory_ram[address] <= wBus[7:0];
								q0 <= 32'h0000000;
							end
						end
				3'b010: begin
							if(signed_ == 1) begin 
								memory_ram[address] <= wBus[7:0];
								memory_ram[address+1] <= wBus[15:8];
								q0 <= 32'h0000000;
							end
							else begin
								memory_ram[address] <= wBus[7:0];
								memory_ram[address+1] <= wBus[15:8];
								q0 <= 32'h0000000;
							end
						end
				3'b100: begin
								memory_ram[address] <= wBus[7:0];
								memory_ram[address+1] <= wBus[15:8];
								memory_ram[address+2] <= wBus[23:16];
								memory_ram[address+3] <= wBus[31:24];
								q0 <= 32'h0000000;
						end
				default : q0 <= 32'h0000000;
			endcase
		end
		else begin
			case(bytes_)
				
				3'b001: begin
							if(signed_ == 1) begin 
								q0 <= {{24{memory_ram[address][7]}} , memory_ram[address]};
							end
							else begin
								q0 <= {24'h000000 , memory_ram[address]};
							end
						end
				3'b010: begin
							if(signed_ == 1) begin 
								q0 <= {{16{memory_ram[address+1][7]}} , memory_ram[address+1], memory_ram[address]};
							end
							else begin
								q0 <= {16'h0000 , memory_ram[address]};
							end
						end
				3'b100: begin
								q0 <= {memory_ram[address+3],memory_ram[address+2],memory_ram[address+1],memory_ram[address]};
						end
				default : q0 <= 32'hFFFFFFFF;
			endcase
		end
	end
 
	assign q = q0;
endmodule
