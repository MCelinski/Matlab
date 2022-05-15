clear;
tic
N=10000;
in = 0;
out= 0;
maska=imread("wyciete0,00.jpg");
[row,col,colour]=size(maska);
points=[randi(col,N,1),randi(row,N,1)];
X=(points(:,1));
Y=(points(:,2));
imshow(gray)
hold on;
scatter(X(:),Y(:),'filled','d');

for i= 1:1:N-1
    if gray(Y(i,1),X(i,1)) == 255 
        in=in+1;
    else
        out=out+1;
    end
end
wynikMC = in/(in+out)
wynik = in/out
pole = (col*row) * wynikMC
aspect = col/row
toc

