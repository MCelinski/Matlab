function result = change_size_back(in_img, scale)

% Interpolacja dwusześcienna
% wczytanie oryginalnego orazu
img = double(in_img);

% pobieranie wymiarów oryginału
[row, column, colour] = size(img);

% wypełanianie wyskalowanego już obrazu zerami a następnie wyliczenie
% nowej tablicy z ustalonymi proporcjami
out_img = [floor(row * scale), floor(column * scale), colour];
out_img = zeros(floor(row * scale), floor(column * scale), colour);
ratio = [row/floor(row * scale), column/floor(column * scale)];

for z = 1 : colour
    
    for x = 1 : floor(row * scale)
        n = ((row/floor(row * scale)) * x) + (0.5 * (1 - 1/scale));
        
        for y = 1 : floor(column * scale)
            m = ((column/floor(column * scale)) * y) + (0.5 * (1 - 1/scale));

            m(m < 1) = 1;
            m(m > column - 0.001) = column - 0.001;
            m2 = floor(m);
            m1 = m2 - 1;
            m1(m1 < 1) = 1;
            m3 = m2 + 1;

            n(n < 1) = 1;
            n(n > row - 0.001) = row - 0.001;
            n2 = floor(n);
            n1 = n2 - 1;
            n1(n1 < 1) = 1;
            n3 = n2 + 1;

            a = (m - floor(m)) / 2;
            b = (n - floor(n)) / 2;

            Fa = [0, 0, 0];
            Fx = zeros(3);

            Fx(1, 1) = img(n1, m1, z);
            Fx(1, 2) = img(n2, m1, z);
            Fx(1, 3) = img(n3, m1, z);
            Fx(2, 1) = img(n1, m2, z);
            Fx(2, 2) = img(n2, m2, z);
            Fx(2, 3) = img(n3, m2, z);
            Fx(3, 1) = img(n1, m3, z);
            Fx(3, 2) = img(n2, m3, z);
            Fx(3, 3) = img(n3, m3, z);
            
                for k = 1 : 3
                     Fa(k) = Fx(2, k) +a * (Fx(3, k) - Fx(1, k)) +a * a * (Fx(1, k) - 2 * Fx(2, k) + Fx(3, k));
                end
            F = Fa(2) +b * (Fa(3) - Fa(1)) +b * b * (Fa(1) - 2 * Fa(2) + Fa(3));

            out_img(x, y, z) = F;
        end
    end
end

% zwrócenie wyskalowanego obrazu

if scale < 1.0
    result = uint8(out_img);
else
    result = out_img;
end

end
