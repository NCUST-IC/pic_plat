clear;
clc;
close all;
a = imread('../img/川A869UI.bmp');
a = rgb2gray(a);
imshow(a);
[row,col] = size(a);

p_fid = fopen('../data/pre_data_chuanA869UI.txt','w+');
for i = 1:row
     for j = 1:col 
           fprintf(p_fid,'%02x' ,a(i,j));
           fprintf(p_fid,'\n');
     end
 end
fclose(p_fid);

%imwrite(a,'../img/post.bmp');