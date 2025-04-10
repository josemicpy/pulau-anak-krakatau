% Aplicar la mascara de agua a todas las imagenes 
% Umbralizar por ¿0,2?
% Calcular el area de tierra en función de los píxeles buscando la conversión pixel-metro en copernicus

% 0,2 a 1 -> agua
% 0 a 0,2 -> terreno inundado
% -0,3 a 0 -> terreno moderadamente seco
% -1 a -0,3 -> terreno seco

% NDWI_escalado = (NDWI + 1)/2*255 para calcular los umbrales
% UMBRAL = [0, 89, 127, 153, 255];

g1 = imread("..\pulau-anak-krakatau\img\2017-09-15\2017-09-15-00_00_2017-09-15-23_59_Sentinel-2_L2A_B03__Raw_.png");
n1 = imread("..\pulau-anak-krakatau\img\2017-09-15\2017-09-15-00_00_2017-09-15-23_59_Sentinel-2_L2A_B08__Raw_.png");

water1 = ndwi_v(g1, n1);
figure;
subplot(1,3,1);
imshow(water1);

histo1 = histo_v(water1);
subplot(1,3,2);
plot(histo1);

umb1 = umbraliza(water1);
mapa1 = mapa_v(umb1);
% subplot(1,3,3);
figure;
imshow(mapa1);

g8 = imread("..\pulau-anak-krakatau\img\2024-11-09\2024-11-09-00_00_2024-11-09-23_59_Sentinel-2_L2A_B03__Raw_.png");
n8 = imread("..\pulau-anak-krakatau\img\2024-11-09\2024-11-09-00_00_2024-11-09-23_59_Sentinel-2_L2A_B08__Raw_.png");

%figure;
%subplot(1,2,1);
water8 = ndwi_v(g8, n8);
%imshow(water8);

%subplot(1,2,2);
histo8 = histo_v(water8);
%plot(histo8);

umb8 = umbraliza(water8);
mapa8 = mapa(umb8);
% subplot(1,3,3);
figure;
imshow(mapa8);
