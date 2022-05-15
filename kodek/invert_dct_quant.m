function [result] = Inverse_DCT_and_quantization(chanel, quantization_matrix)

chanel = chanel - 128.0;

% to co wcześniej ale na odwrót
chanel = blkproc(chanel, [8 8], 'x.*P1', quantization_matrix);

% odwrotna DCT
chanel = blkproc(chanel, [8 8], 'idct2(x)');  

% otrzymana macierz po dekwantyzacji oraz po odwrotnym DCT
result = chanel/255;      

end