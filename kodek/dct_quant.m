function [result] = dct_quant(chanel, quantization_matrix)

% dzielenie bloków na 8x8 pikseli
% przeprowadzanie na nich DCT
chanel = blkproc(chanel, [8 8], 'dct2(x)');

% określanie ile będzie takich bloków i zaokrąglenie tej liczby w górę
chanel = blkproc(chanel, [8 8], 'round(x./P1)', quantization_matrix);

chanel = chanel + 128.0; 

% zwracana jest skwantowana macierz
result = chanel;

end