clear;
close all;

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

function [result] = Inverse_DCT_and_quantization(chanel, quantization_matrix)

chanel = chanel - 128.0;

% to co wcześniej ale na odwrót
chanel = blkproc(chanel, [8 8], 'x.*P1', quantization_matrix);

% odwrotna DCT
chanel = blkproc(chanel, [8 8], 'idct2(x)');  

% otrzymana macierz po dekwantyzacji oraz po odwrotnym DCT
result = chanel/255;      

end
%wczytanie obrazu przed kompresja
inimg = imread('4k.jpg');

%zmiana RGB->YCbCr
imgycbcr = rgb2ycbcr(inimg);

% wczytanie zmiennych do tablicy
[row, column, colour] = size(imgycbcr);
 
% rozszerzanie do wielokrotności 8
rows = ceil(row/8) * 8; %ceil() zaokragla liczbe do najeblizszego inta w gore
columns = ceil(column/8) * 8; 

% pobieranie składowych kolorów o wartości połowy zakresu 
Y  = imgycbcr(:, :, 1);                   
Cb = zeros(rows/2, columns/2);       
Cr = zeros(rows/2, columns/2);       

%dzielenie na kwałki o wymiarach 8x8 np f(i,j) gdzie i,j=0,1...7
for i = 1 : rows/2
    for j = 1 : 2 : (columns/2) - 1 % kolumna nieparzysta
       Cb(i, j) = double(imgycbcr(i*2 - 1, j*2 - 1, 2));     
       Cr(i, j) = double(imgycbcr(i*2 - 1, j*2 + 1, 3));     
    end
   
    for j = 2 : 2 : (columns/2) % kolumna parzysta      
       Cb(i, j) = double(imgycbcr(i*2 - 1, j*2 - 2, 2));     
       Cr(i, j) = double(imgycbcr(i*2 - 1, j*2,     3));     
    end
end

% tablica luminancji - jasność 
luminance_table = [ 16  11  10  16   24   40    51  61
                    12  12  14  19   26   58   60   55
                    14  13  16  24   40   57   69   56
                    14  17  22  29   51   87   80   62
                    18  22  37  56   68  109  103   77
                    24  35  55  64   81  104  113   92
                    49  64  78  87  103  121  120  101
                    72  92  95  98  112  100  103   99 ];
  
% tabela kwantyzacji chrominancji - różnica w kolorach
chroma_table =  [ 17,  18,  24,  47,  99,  99,  99,  99;
                  18,  21,  26,  66,  99,  99,  99,  99;
                  24,  26,  56,  99,  99,  99,  99,  99;
                  47,  66,  99,  99,  99,  99,  99,  99;
                  99,  99,  99,  99,  99,  99,  99,  99;
                  99,  99,  99,  99,  99,  99,  99,  99;
                  99,  99,  99,  99,  99,  99,  99,  99;
                  99,  99,  99,  99,  99,  99,  99,  99 ];

% DCT i kwantyzacja 
Y_dct_quant  = dct_quant(Y,  luminance_table);
Cb_dct_quant = dct_quant(Cb, chroma_table);
Cr_dct_quant = dct_quant(Cr, chroma_table);

% generowanie słownika Huffmana i kodu dla każdej składowej
I1 = floor(Y_dct_quant(:));%zaokrąglenie w dół
dictY = dictionary(Y_dct_quant);
encoY = huffmanenco(I1, dictY); 

I2 = floor(Cb_dct_quant(:));
dictCb = dictionary(Cb_dct_quant);
encoCb = huffmanenco(I2, dictCb); 

I3 = floor(Cr_dct_quant(:));
dictCr = dictionary(Cr_dct_quant);
encoCr = huffmanenco(I3, dictCr); 

% zapis kodu huffmana i słownika do pliku
save('obraz_po_kompresji.JMC', 'dictY', 'encoY', 'dictCb', 'encoCb', 'dictCr', 'encoCr', '-mat');

% odczyt kodu huffmana i słowników
readed = load('obraz_po_kompresji.JMC', '-mat');

% dekodowanie kodu Huffmana odczytanego z pliku
decoY  = col2im(huffmandeco(readed.encoY,  readed.dictY),  [row, column],     [row, column],     'distinct');
decoCb = col2im(huffmandeco(readed.encoCb, readed.dictCb), [row/2, column/2], [row/2, column/2], 'distinct');
decoCr = col2im(huffmandeco(readed.encoCr, readed.dictCr), [row/2, column/2], [row/2, column/2], 'distinct');

% dekwantyzacja i odwrotna DCT dla każdego z kanałów
invers_Y  = invert_dct_quant(decoY,  luminance_table);
invers_Cb = invert_dct_quant(decoCb, chroma_table);
invers_Cr = invert_dct_quant(decoCr, chroma_table);

% % odzyskiwanie obrazu YCbCr
YCbCr_out_img(:, :, 1) = invers_Y;

for i=1:rows/2
   for j=1:columns/2
       
       YCbCr_out_img(2*i - 1, 2*j - 1, 2) = invers_Cb(i, j);
       YCbCr_out_img(2*i - 1, 2*j,     2) = invers_Cb(i, j);
       YCbCr_out_img(2*i, 2*j - 1, 2) = invers_Cb(i, j);
       YCbCr_out_img(2*i, 2*j,     2) = invers_Cb(i, j); 
       
       YCbCr_out_img(2*i - 1, 2*j - 1, 3) = invers_Cr(i, j);
       YCbCr_out_img(2*i - 1, 2*j,     3) = invers_Cr(i, j);
       YCbCr_out_img(2*i, 2*j - 1, 3) = invers_Cr(i, j);
       YCbCr_out_img(2*i, 2*j,     3) = invers_Cr(i, j);
       
   end
end

out_img = ycbcr2rgb(YCbCr_out_img);

figure(1)

imshow(inimg);
title('Oryginalny obraz'); 

figure(1)
imshow(out_img);
title('Obraz po operacjach kodujacych ');

imwrite(out_img, 'out.png')

A = imread('out.png');

X = immse(A, inimg);
disp(strcat(['Wartość błędu średniokwadratowego wynosi: ' num2str(X)]));
