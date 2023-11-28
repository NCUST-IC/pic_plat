clear;
clc;
close all;
a = imread('../img/粤B15TT2.jpg');
imshow(a);
[row, col, ~] = size(a);  % 获取图像的行数和列数

p_fid = fopen('../data/image_process_rgb565.txt','w+');  % 打开文件准备写入RGB565格式的数据
for i = 1:row
    for j = 1:col
        pixel = a(i,j,:);  % 获取当前像素的RGB值
        r = floor(double(pixel(1))/8);  % 将红色值右移3位并取整，以适配5位的存储空间
        g = floor(double(pixel(2))/4);  % 将绿色值右移2位并取整，以适配6位的存储空间
        b = floor(double(pixel(3))/8);  % 将蓝色值右移3位并取整，以适配5位的存储空间
        rgb565 = bitshift(r, 11) + bitshift(g, 5) + b;  % 将R、G、B值按照RGB565格式合并
        fprintf(p_fid, '%04X\n', rgb565);  % 将合并后的RGB565值以十六进制格式写入文件
    end
end
fclose(p_fid);  % 关闭文件
