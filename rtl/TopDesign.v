module TopDesign(
						clk,
						rst_n,
						TX,
						tx2,
						RX,
						led,
						dht11_wire,
						scl,
						sda,
						beep_pin,//蜂鸣器的引脚
						
						pwm, //PWM输出IO
						pwm1, //PWM输出IO
						pwm2 //PWM输出IO
						);

	//输入输出定义
	input clk;
	input rst_n;
	input RX;
	output TX;
	output tx2;
	output [3:0]led;
	
	inout dht11_wire;
	
	output scl;   // i2c时钟线
   inout sda ;   // i2c数据线
	
	output beep_pin; //蜂鸣器的引脚
	
	output pwm; //PWM输出IO
	output pwm1; //PWM输出IO
	output pwm2; //PWM输出IO
	
	wire clk;
	wire rst_n;
	wire TX;
	wire tx2;
	wire RX;
	wire [3:0]led;
	wire [11:0] conter_data;      //三种模式下输出不同的数据，第一种模式输出0至256 第二种模式输出0至1M 第三种是2M
	wire tx_down;          //串口发送完成一个字节的高电平脉冲
	reg[7:0] target_data; //串口要发送的实际数据
	
	wire [31:0] data_valid; //有效输出数据
	
	wire [19:0] num;
	
	wire [7:0] data_ASCII_0;
	wire [7:0] data_ASCII_1;
	wire [7:0] data_ASCII_2;
	wire [7:0] data_ASCII_3;
	wire [7:0] data_ASCII_4;
	wire [7:0] data_ASCII_5;
	
	wire [7:0] humidity_data_ASCII_0;
	wire [7:0] humidity_data_ASCII_1;
	wire [7:0] humidity_data_ASCII_2;
	wire [7:0] humidity_data_ASCII_3;
	wire [7:0] humidity_data_ASCII_4;
	wire [7:0] humidity_data_ASCII_5;
	 
	wire key_value; //从ESP8266串口接收到的值
	wire beep_pin;//蜂鸣器的引脚
	
	wire pwm;
	wire pwm1;
	wire pwm2;
	
	time_delay_2s time_delay_2s(
							.clk(clk),
							.rstn(rst_n),
							.sign()
							);
	
	main main(
				.clk(clk),
				.rst_n(rst_n),
				.TX(TX),
				.tx2(tx2),
				.RX(RX),
				.led(led),
				.choose_data_length(0),    //选择发送模式，在256字节发送模式，1M字节和256字节之间选择 0 1 2 3分别代表三种模式和停止发送
				.conter_data(conter_data), //输出 三种模式下输出不同的数据，第一种模式输出0至256 第二种模式输出0至1M 第三种是2M
				//.tx_down(tx_down),         //串口发送完成一个字节的高电平脉冲
				.target_data(target_data),        //串口要发送的实际数据
				.Data_received(key_value) //串口的数输出
				);	
	
	beep	beep(
					.clk(clk), //系统时钟50MHz
					.rst_n(rst_n), //系统复位信号
					.beep_pin(beep_pin), //蜂鸣器的引脚
					.key(key_value) //按键或者一个少于1秒的高电平脉冲
				);
	
	engine engine(
						.clk(clk), //系统时钟50MHz
						.rst_n(rst_n), //系统复位信号

						.pwm(pwm), //PWM输出IO
						.pwm1(pwm1), //PWM输出IO
						.pwm2(pwm2), //PWM输出IO
						
						.key1(key_value),
						.key2()
					); 
				
	dht11_drive dht11_drive(
									.sys_clk(clk),   //系统时钟
									.rst_n(rst_n),   //系统复位             
									.dht11(dht11_wire),   //dht11温湿度传感器单总线
									.data_valid(data_valid)     //有效输出数据
									);  
	
	dht11_key   dht11_key(
									.sys_clk(clk),
									.sys_rst_n(rst_n),

									.data_valid(data_valid),

									.data_ASCII_0(data_ASCII_0),
									.data_ASCII_1(data_ASCII_1),
									.data_ASCII_2(data_ASCII_2),
									.data_ASCII_3(data_ASCII_3),
									.data_ASCII_4(data_ASCII_4),
									.data_ASCII_5(data_ASCII_5),
									
									.humidity_data_ASCII_0(humidity_data_ASCII_0),
									.humidity_data_ASCII_1(humidity_data_ASCII_1),
									.humidity_data_ASCII_2(humidity_data_ASCII_2),
									.humidity_data_ASCII_3(humidity_data_ASCII_3),
									.humidity_data_ASCII_4(humidity_data_ASCII_4),
									.humidity_data_ASCII_5(humidity_data_ASCII_5),
									.sign(),
									.point(),
								);								
	adda_top adda_top(   
								.sys_clk(clk)    ,    // 系统时钟
								.sys_rst_n(rst_n)  ,    // 系统复位
								.scl(scl)        ,    // i2c时钟线
								.sda(sda)        ,    // i2c数据线
								.num(num)
							);


	always@(posedge clk or negedge rst_n)begin
		if(!rst_n)
			target_data <= 8'h00;
		else begin
			case(conter_data)
					12'd0 : target_data<= 8'h28;
					12'd1 : target_data<= data_valid[31:24]; //有用 湿度的第一位
					12'd2 : target_data<= data_valid[23:16];
					12'd3 : target_data<= data_valid[15:8];
					12'd4 : target_data<= data_valid[7:0]; 
					12'd5 : target_data<= 8'h29;
					12'd6 : target_data<= 8'h28;
					12'd7 : target_data<= data_ASCII_5;
					12'd8 : target_data<= data_ASCII_4;
					12'd9 : target_data<= data_ASCII_3;
					12'd10: target_data<= data_ASCII_2;
					12'd11: target_data<= 8'h2E; //小数点的位置
					12'd12: target_data<= data_ASCII_1;
					12'd13: target_data<= data_ASCII_0;
					12'd14 : target_data<= 8'h29;
					12'd15 : target_data<= 8'h28;
					12'd16 : target_data<= humidity_data_ASCII_5;
					12'd17 : target_data<= humidity_data_ASCII_4;
					12'd18 : target_data<= humidity_data_ASCII_3;
					12'd19 : target_data<= humidity_data_ASCII_2;
					12'd20 : target_data<= 8'h2E; //小数点的位置
					12'd21 : target_data<= humidity_data_ASCII_1;
					12'd22 : target_data<= humidity_data_ASCII_0;
					12'd23 :target_data<= 8'h29;
					12'd24 :target_data<= 8'h23;
				default	: target_data<= 8'h21;
			endcase
		end
	end

endmodule 