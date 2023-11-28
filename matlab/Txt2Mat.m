clear;
clc;
close all;

a = textread('../data/image_process_chuanA869UI.txt','%s');
IMdec = hex2dec(a);

col = 640;
row = 480;

IM = reshape(IMdec,col,row);
b = uint8(IM)';

imwrite(b,'../img/image_process_chuanA869UI.bmp');
imshow('../img/image_process_chuanA869UI.bmp');



