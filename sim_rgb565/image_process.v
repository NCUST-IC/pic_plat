
module image_process(
    //module clock
    input           clk            ,   // 时钟信号
    input           rst_n          ,   // 复位信号（低有效）

    //图像处理前的数据接口
    input           pre_frame_vsync,
    input           pre_frame_hsync,
    input           pre_frame_de   ,
    //input    [7 :0] pre_rgb        ,    //gray picture
    input    [15:0] pre_rgb        ,  //rgb565 picture
    input    [10:0] xpos           ,
    input    [10:0] ypos           ,

    //图像处理后的数据接口
    output          post_frame_vsync,  // 场同步信号
    output          post_frame_hsync,  // 行同步信号
    output          post_frame_de   ,  // 数据输入使能
    //output   [15:0] post_rgb           // RGB565颜色数据
    output   [7 :0] post_rgb           //gray picture
);

//RGB转YCbCr
wire                  ycbcr_vsync;
wire                  ycbcr_hsync;
wire                  ycbcr_de   ;
wire   [ 7:0]         img_y      ;
wire   [ 7:0]         img_cb     ;
wire   [ 7:0]         img_cr     ;
//二值化
wire binarization_vsync ;
wire binarization_hsync ;
wire binarization_de    ;
wire binarization_bit   ;

//*****************************************************
//**                    main code
//*****************************************************

//assign output
assign  post_frame_vsync = binarization_vsync;
assign  post_frame_de    = binarization_de;
assign  post_rgb         = {8{binarization_bit}};
//assign  post_frame_vsync = ycbcr_vsync;
//assign  post_frame_de    = ycbcr_de;
//assign  post_rgb         = img_y;


//pic deal module
//RGB转YCbCr模块
rgb2ycbcr u1_rgb2ycbcr(
    //module clock
    .clk             (clk    ),            // 时钟信号
    .rst_n           (rst_n  ),            // 复位信号（低有效）
    //图像处理前的数据接口
    .pre_frame_vsync (pre_frame_vsync),    // vsync信号
    .pre_frame_hsync (pre_frame_hsync),    // href信号
    .pre_frame_de    (pre_frame_de   ),    // data enable信号
    .img_red         (pre_rgb[15:11] ),
    .img_green       (pre_rgb[10:5 ] ),
    .img_blue        (pre_rgb[ 4:0 ] ),
    //图像处理后的数据接口
    .post_frame_vsync(ycbcr_vsync),   // vsync信号
    .post_frame_hsync(ycbcr_hsync),   // href信号
    .post_frame_de   (ycbcr_de   ),   // data enable信号
    .img_y           (img_y ),
    .img_cb          (img_cb),
    .img_cr          (img_cr)
);


//二值化
binarization u1_binarization(
    .clk     (clk    ),   // 时钟信号
    .rst_n   (rst_n  ),   // 复位信号（低有效）

	.per_frame_vsync   (ycbcr_vsync       ),
	.per_frame_href    (ycbcr_hsync       ),	
	.per_frame_clken   (ycbcr_de          ),
	.per_img_Y         (img_y             ),		

	.post_frame_vsync  (binarization_vsync),	
	.post_frame_href   (binarization_hsync),	
	.post_frame_clken  (binarization_de   ),	
	.post_img_Bit      (binarization_bit  ),		

	.Binary_Threshold  (8'd150)//这个阈值的设置非常重要
);







endmodule



