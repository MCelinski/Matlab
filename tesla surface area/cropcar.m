org=imread("tesla.jpg");
figure (1);
imshow(org);
org=rgb2gray(org)
%org_wnoise = imnoise(org,'salt & pepper',0.05);
imshow(org_wnoise);
imshow(org);
%L = superpixels(org_wnoise,520);
L = superpixels(org,520);
% h1 = drawpolygon('Position',[72,105; 1,231; 0,366; 104,359;...
%         394,307; 518,343; 510,39; 149,72]);

h1 = drawpolygon('Position',[34,141; 7.5,231; 6.5,366; 28.5,517.5;...
        776.5,517.5; 761.5,155; 651.5,19; 194,9]);
roiPoints = h1.Position;
roi = poly2mask(roiPoints(:,1),roiPoints(:,2),size(L,1),size(L,2));
BW = grabcut(org_wnoise,L,roi);
figure (2)
imshow(BW);
figure(3);
imshow(org)