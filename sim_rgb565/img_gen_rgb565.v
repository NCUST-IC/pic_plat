`timescale 1ns / 1ps
//***********************************************************************
//parameter define
//ACTIVE_IW: 图像的活动水平像素宽度（即横向分辨率）。在这个宽度内，图像包含可见的像素数据。
//ACTIVE_IH: 图像的活动垂直像素高度（即纵向分辨率）。在这个高度内，图像包含可见的像素数据。
//TOTAL_IW: 图像的总水平像素宽度。这个宽度通常包括同步信号和前肩/后肩（front porch/back porch）等图像之外的部分。
//TOTAL_IH: 图像的总垂直像素高度。这个高度通常包括同步信号和前肩/后肩等图像之外的部分。
//H_START: 水平同步信号的起始位置。这个参数通常指示了视频图像每行像素数据的开始位置。
//V_START: 垂直同步信号的起始位置。这个参数通常指示了视频帧的开始位置或每帧的第一行像素数据的开始位置。
//*************************************************************************
module img_gen_rgb565 
#(
	parameter ACTIVE_IW  =640,  
	parameter ACTIVE_IH  =480,
	parameter TOTAL_IW   =800,
	parameter TOTAL_IH   =525,
	parameter H_START    =143, 
	parameter V_START    =34   
)
( 
	input 				clk		,
	input 				rst_n	, 
	output reg 			vs		, 
	output reg 			de		,
	output reg [15:0]	data	
);

reg  [15:0] raw_array [ACTIVE_IW*ACTIVE_IH-1:0];

integer i;
 
initial begin
	//$readmemh("F:/FPGA/pic_plat/data/pre_data.txt",raw_array);
    $readmemh("../data/pre_rgb565.txt",raw_array);
end

reg [15:0] 	hcnt		;
reg [15:0] 	vcnt		;

reg			h_de		;
reg			v_de		;

reg			index_de	;	
reg	[31:0]	index       ;

always@(posedge clk or negedge rst_n)
	if(!rst_n)
		hcnt <= 'd0;
	else if(hcnt==TOTAL_IW-1)
		hcnt <= 'd0;
	else 
		hcnt <= hcnt + 1'b1;
		
always@(posedge clk or negedge rst_n)
	if(!rst_n)
		vcnt <= 'd0;
	else if(hcnt==TOTAL_IW-1&&vcnt==TOTAL_IH-1)
		vcnt <= 'd0;
	else if(hcnt==TOTAL_IW-1)
		vcnt <= vcnt + 1'b1;
	else
		vcnt <= vcnt;
					
always@(posedge clk or negedge rst_n)
	if(!rst_n)
		vs <= 1'b0;
	else if(vcnt>=2)
		vs <= 1'b1;
	else
		vs <= 1'b0;

always@(posedge clk or negedge rst_n)
	if(!rst_n)
		h_de <= 1'b0;
	else if(hcnt>=H_START&&hcnt<H_START+ACTIVE_IW)
		h_de <= 1'b1;
	else
		h_de <= 1'b0;
	
always@(posedge clk or negedge rst_n)
	if(!rst_n)
		v_de <= 1'b0;
	else if(vcnt>=V_START&&vcnt<V_START+ACTIVE_IH)
		v_de <= 1'b1;
	else
		v_de <= 1'b0;

always@(posedge clk or negedge rst_n)
	if(!rst_n)
		index_de <= 1'b0;
	else if(h_de==1'b1&&v_de==1'b1)
		index_de <= 1'b1;
	else
		index_de <= 1'b0;
		
always@(posedge clk or negedge rst_n)
	if(!rst_n)
		index <= 'd0;
	else if(index==ACTIVE_IW*ACTIVE_IH-1)
		index <= 'd0;
	else if(index_de==1'b1)
		index <= index + 1'b1;
	else
		index <= index;
		
always@(posedge clk or negedge rst_n)
	if(!rst_n)
		de <= 1'b0;
	else
		de <= index_de;
		
always@(posedge clk or negedge rst_n)
	if(index_de==1'b1)
		data <= raw_array[index];
	else
		data <= 0;


 
endmodule 