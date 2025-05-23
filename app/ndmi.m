% NDWI a partir de bandas G y NIR
% (Llevado a rango [1, 255])
% (Version vectorizada)

function z = ndmi(x, y)

  b = x > 0 & y > 0;
  g = double(x) / 255;
  n = double(y) / 255;
  z = (g - n) ./ (g + n);
  z = (z + 1) * 254 / 2 + 1;
  z = z .* b;
  z = uint8(z);

end
