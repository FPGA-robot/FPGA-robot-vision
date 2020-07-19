module engine_driver(
								clk,
								rst_n,
								angle_setting,
								pwm
						   ); 
	
	input clk;
	input rst_n;
	input [7:0] angle_setting;
	output pwm;
	
	wire clk;
	wire rst_n;
	wire [7:0] angle_setting; //1011 0100 180度
	
	reg pwm; 
	reg	[31:0]	cnt_r;	
	reg	[31:0]	cnt;	
	
	parameter      s=1000_000,//周期
						s0=125_000,//180角度
						s1=100_000,//135
						s2=75_000,//90
						s3=50_000,//45
						s4=25_000;//0
					
	
	
	always@(posedge clk or negedge rst_n)begin
		if(!rst_n)
			cnt_r <= s4;
		else if(angle_setting < 8'd180 && angle_setting > 8'd0)
			cnt_r <= angle_setting*555 + 25000;
		else
			cnt_r <= 0;
	end

	always@(posedge clk or negedge rst_n)begin
		if(!rst_n)
			pwm <= 1'b0;
		else if(cnt < cnt_r)
			pwm <= 1'b1;
		else
			pwm <= 1'b0;
	end
	
	always@(posedge clk or negedge rst_n)begin
		if(!rst_n)
			cnt <= 31'd0;
		else if(cnt >= s)
			cnt <= 31'd0;
		else
			cnt <= cnt + 1'b1;
	end
			
endmodule






