module haltnpipe_control(
  input wire clk,
  input wire [4:0] rs1_ID,
  input wire [4:0] rs2_ID,
  input wire [4:0] rd_ID,
  //input wire [31:0] jmp_pc_ID,
  //input wire ena_jmp_pc,
  input wire [4:0] rd_WB, //revisar que se cumplan la cantidad de NOPs
  //output wire [31:0] new_PC,
  //output reg ena_new_PC,
  output reg ena_fetch,
  output reg ena_ifid,
  output reg ena_idex,
  output reg ena_exma,
  output reg ena_mawb
);

	 reg [4:0] used_regs [2:0]; 
    integer counter;
    integer i;

    initial begin
        counter = 0;
		  i=0;
    end

	always @ (negedge clk) begin 
        //chequeo si quieren usar un reg que todavia no se hizo WB
        if( (rs2_ID == used_regs[0] || rs2_ID == used_regs[1] || rs2_ID == used_regs[2]) && rs2_ID != 5'b00000) begin
            ena_fetch = 0;
            ena_ifid = 0;
            ena_idex = 0;
            ena_exma = 1;
            ena_mawb = 1;
        end
        else if((rs1_ID == used_regs[0] || rs1_ID == used_regs[1] || rs1_ID == used_regs[2]) && rs1_ID != 5'b00000) begin
            ena_fetch = 0;
            ena_ifid = 0;
            ena_idex = 0;
            ena_exma = 1;
            ena_mawb = 1;
        end
        else begin 
            ena_fetch = 1;
            ena_ifid = 1;
            ena_idex = 1;
            ena_exma = 1;
            ena_mawb = 1;
        end
			
			//guardo rd que me entra.
        used_regs[counter] = rd_ID;
        if(counter == 2) begin
            counter = 0;
        end 
        else begin
            counter = counter + 1;
        end

        //borro el registro donde ya se hizo WB
        for(i=0 ; i< 3 ; i= i+1 ) begin 
            if(rd_WB == used_regs[i]) begin
                used_regs[i]=5'b00000;
            end
        end

    end
 
	
endmodule
