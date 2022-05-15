clear
close all;

% wczytanie oryginalnego obrazu
in_img = imread('Leopard-with-noise.jpg');
in_img = double(in_img)/255;

out_img = in_img;

% pobranie wymiarów obrazu
[xs, ys] = size(in_img);

for i = 2 : xs - 1       
    for j = 2 : ys - 1
        m = 1;
        n = 1;
        for x = i - 1 : i + 1
            for y = j - 1 : j + 1
                xd(m, n) = in_img(x, y);
                n = n + 1;
            end
            m = m + 1;
            n = 1;
        end
        
        medianfilter = reshape(xd', 9, 1); 
        queue = sort(medianfilter); % w szablonie 3 * 3 piąta wartość to mediana 
        median = queue(5); % przypisz medianę każdego punktu do wyjściowego obrazu           
        out_img(i,j) = median;       
    end
end

% wyświetlanie oryginalnego obrazu

subplot(1,2,1)
imshow(in_img)
title('Obraz przed filtracją');

% wyświetlanie obrazu po filtracji
subplot(1,2,2)
imshow(out_img)
title('Obraz po filtracji'); 

