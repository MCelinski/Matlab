clc;
clear;
img = imread('pobrane.png')
img = rgb2gray(img);
[m, n, z] = size(img);
img = double(img);
fz = 5;  
img_pad = zeros(m+fz-1, n+fz-1);  

half = floor(fz/2);
img_pad(half+1:m+half, half+1:n+half) = img;


filter1 = 1/fz^2 * ones(fz);
G1 = zeros(m, n);
for i = 1:m
    for j = 1:n
        L = img_pad(i:i+fz-1, j:j+fz-1).*filter1;
        G1(i, j) = sum(sum(L));
    end
end
figure,subplot(1,2,1),imshow(uint8(img)); 
title('przed filtrają');
subplot(1,2,2),imshow(uint8(G1)); 
title('po filtracji ');

G2 = zeros(m, n);
for i = 1:m
    for j = 1:n
        area = img_pad(i:i+fz-1, j:j+fz-1);
        area = area(:);
        med = median(area);
        G2(i, j) = med;
    end
end
figure,subplot(1,2,1),imshow(uint8(img)); 
title('lampart przed filtracją ');
subplot(1,2,2),imshow(uint8(G2)); 
title('lampart po filtracji ');