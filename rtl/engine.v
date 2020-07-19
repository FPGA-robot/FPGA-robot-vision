module engine(
					clk, //系统时钟50MHz
					rst_n, //系统复位信号

					pwm, //PWM输出IO
					pwm1, //PWM输出IO
					pwm2, //PWM输出IO
					
					key1,
					key2
				); 

	input clk; //系统时钟50MHz
	input rst_n; //系统复位信号
	output pwm; //PWM输出IO
	output pwm1; //PWM输出IO
	output pwm2; //PWM输出IO
	
	input key1;
	input key2;
	
	wire clk;
	wire rst_n;
	
	wire pwm;
	wire pwm1;
	wire pwm2;
	
	wire key1;
	wire key2;
	
	
	reg  [27:0] cnt_f; //用来产生延时信号的加法器寄存器
	reg [7:0] angle; //用来产生角度控制信号
	
	//角度控制模块 设计ok
	engine_driver engine_driver(
											.clk(clk),
											.rst_n(rst_n),
											.angle_setting(angle),
											.pwm(pwm)
										); 
										
	//角度控制模块 设计ok
	engine_driver engine_driver1(
											.clk(clk),
											.rst_n(rst_n),
											.angle_setting(angle),
											.pwm(pwm1)
										); 
										
	//角度控制模块 设计ok
	engine_driver engine_driver2(
											.clk(clk),
											.rst_n(rst_n),
											.angle_setting(angle),
											.pwm(pwm2)
										); 
	
	always@(posedge clk or negedge rst_n) begin
		if(!rst_n)
			angle <= 0;
		else if(key1 == 1)
			angle <= angle + 8'd10;
		else if(angle == 180)
			angle <=  0;
	end
		/*
	//产生0.5秒钟延时
	always@(posedge clk or negedge rst_n) begin
		if(!rst_n)
			cnt_f <= 0;
		else if(cnt_f == 28'd12999999)
			cnt_f <= 0;
		else
			cnt_f <= cnt_f + 1'b1;
	end
	
	//定时增加角度
	always@(posedge clk or negedge rst_n) begin
		if(!rst_n)
			angle <= 0;
		else if(cnt_f == 28'd12999999)
			angle <= angle + 8'd10;
		else if(angle == 180)
			angle <=  0;
	end
		*/
		
endmodule






