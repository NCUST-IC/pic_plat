
module image_process(
    //module clock
    input           clk            ,   // 时钟信号
    input           rst_n          ,   // 复位信号（低有效）

    //图像处理前的数据接口
    input           pre_frame_vsync,
    input           pre_frame_hsync,
    input           pre_frame_de   ,
    input    [7 :0] pre_rgb        ,    //gray picture
    //input    [15:0] pre_rgb        ,  //rgb565 picture
    input    [10:0] xpos           ,
    input    [10:0] ypos           ,

    //图像处理后的数据接口
    output          post_frame_vsync,  // 场同步信号
    output          post_frame_hsync,  // 行同步信号
    output          post_frame_de   ,  // 数据输入使能
    //output   [15:0] post_rgb           // RGB565颜色数据
    output   [7 :0] post_rgb           //gray picture
);


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

//pic deal module

//二值化
binarization u1_binarization(
    .clk     (clk    ),   // 时钟信号
    .rst_n   (rst_n  ),   // 复位信号（低有效）

	.per_frame_vsync   (pre_frame_vsync ),
	.per_frame_href    (),	
	.per_frame_clken   (pre_frame_de    ),
	.per_img_Y         (pre_rgb         ),		

	.post_frame_vsync  (binarization_vsync),	
	.post_frame_href   (binarization_hsync),	
	.post_frame_clken  (binarization_de   ),	
	.post_img_Bit      (binarization_bit  ),		

	.Binary_Threshold  (8'd150)//这个阈值的设置非常重要
);







endmodule



