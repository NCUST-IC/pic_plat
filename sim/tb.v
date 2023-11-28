`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/11/23 20:31:06
// Design Name: 
// Module Name: tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module tb();

reg	clk 	;
reg rst_n 	;

//wire binarization_vsync ;
//wire binarization_hsync ;
//wire binarization_de    ;
//wire binarization_bit   ;
wire post_frame_vsync ;
wire post_frame_hsync ;
wire post_frame_de    ;
wire [7:0] post_rgb         ;


integer outfile;

initial begin
	clk 	= 0;	
    rst_n 	= 0;
	#20
	rst_n   = 1;
	
	outfile = $fopen("F:/FPGA/pic_plat/data/image_process_chuanA869UI.txt","w");
    //outfile = $fopen("../data/binarization.txt","w"); //Verilog does not support using absolute paths with $fopen.!!!
end

always #5 clk = ~clk;

wire			vs		;		
wire			de		;
wire	[7:0]	data	;

img_gen 
#(
	.ACTIVE_IW (640),
	.ACTIVE_IH (480),
	.TOTAL_IW  (800),
	.TOTAL_IH  (525),
	.H_START   (143), 
	.V_START   (34 )  
)
u1_img_gen
( 
	.clk		(clk	),
	.rst_n		(rst_n	), 
	.vs			(vs		), 
	.de			(de		),
	.data		(data	)
);
/*
//二值化
binarization u1_binarization(
    .clk     (clk    ),   // 时钟信号
    .rst_n   (rst_n  ),   // 复位信号（低有效）

	.per_frame_vsync   (vs),
	.per_frame_href    (),	
	.per_frame_clken   (de   ),
	.per_img_Y         (data     ),		

	.post_frame_vsync  (binarization_vsync),	
	.post_frame_href   (binarization_hsync),	
	.post_frame_clken  (binarization_de   ),	
	.post_img_Bit      (binarization_bit  ),		

	.Binary_Threshold  (8'd150)//这个阈值的设置非常重要
);
*/
/*
Hough Hough_u1(
	.nReset(rst_n),                                                      // Common to all
	.Clk(clk),     
	.PixelIn(data),
	.FrameIn(de),
	.LineIn(),
	.PixelOut(hough_data),		// Output wires as registeres in submodules
	.FrameOut(hough_de),
	.LineOut()
);
*/
/*

 //图像处理模块
lane_detection u_lane_detection(
    //module clock
    .clk              (clk		),           // 时钟信号
    .rst_n            (rst_n    ),          // 复位信号（低有效）
    //图像处理前的数据接口
    .pre_frame_vsync  (vs   			),
    .pre_frame_hsync  (				    ),
    .pre_frame_de     (de				),
    .pre_rgb          (data				),
    .xpos             (0   ),
    .ypos             (0   ),

    //图像处理后的数据接口
    .post_frame_vsync (post_frame_vsync ),  // 场同步信号
    .post_frame_hsync (post_frame_hsync ),   // 行同步信号
    .post_frame_de    (post_frame_de ),     // 数据输入使能
    .post_rgb         (post_rgb)            // RGB565颜色数据

);       
*/

 //图像处理模块
image_process u_image_process(
    //module clock
    .clk              (clk),           // 时钟信号
    .rst_n            (rst_n    ),          // 复位信号（低有效）
    //图像处理前的数据接口
    .pre_frame_vsync  (vs                 ),
    .pre_frame_hsync  (                   ),
    .pre_frame_de     (de                 ),
    .pre_rgb          (data               ),
    .xpos             (0   ),
    .ypos             (0   ),
    //图像处理后的数据接口
    .post_frame_vsync (post_frame_vsync ),  // 场同步信号
    .post_frame_hsync (post_frame_href  ),   // 行同步信号
    .post_frame_de    (post_frame_de    ),     // 数据输入使能
    .post_rgb         (post_rgb         )            // RGB565颜色数据

);   

reg	vs_r;
/*
always@(posedge clk)
	if(!rst_n)
		vs_r <= 1'b0;
	else
		vs_r <= vs;
*/
/* always@(posedge clk)
	if(~vs&&vs_r)
		begin
			$stop;
		end  	
	else if(de==1)
		begin
			$fdisplay(outfile,"%h",data);
		end
 */
 
always@(posedge clk)
	if(!rst_n)
		vs_r <= 1'b0;
	else
		vs_r <= post_frame_vsync;
		
always@(posedge clk)
	if(~post_frame_vsync&&vs_r)
	//if(cnt_frame == 'd147227)
		begin
			$stop;
		end  	
	else if(de==1)
		begin
			//cnt_frame <= cnt_frame + 1'b1;
			//$fdisplay(outfile,"%h",hough_data);
			//$fdisplay(outfile,"%h",binarization_bit ? 8'd255:8'd0);
            $fdisplay(outfile,"%h",post_rgb[7] ? 8'd255:8'd0);
		end
    
endmodule
