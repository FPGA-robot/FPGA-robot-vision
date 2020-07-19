module time_delay_2s(
							clk,
							rstn,
							sign
							);
							
	input clk,rstn;
	output sign;
	
	reg sign;
	
	reg [25:0] cont;

	always@(posedge clk or negedge rstn)
	begin
		if(!rstn) begin 
			cont <= 0;
			sign <= 0;
			end 
		else 
		begin 
			if(cont == 25'd24999999) begin
				sign <= 1;
				cont = 25'd0;
			end
			
			else begin
				cont <= cont +25'd1;
				sign <= 0;
			end 
		end
	end
	
endmodule

