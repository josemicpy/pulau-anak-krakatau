basePath = '..\pulau-anak-krakatau\img\';
savePath = '..\pulau-anak-krakatau\results\';

folders = dir(basePath);
folders = folders([folders.isdir] & ~startsWith({folders.name}, '.'));

porcentajes = zeros(1, length(folders));
nombresOrdenados = strings(1, length(folders));

for i = 1:length(folders)
    folderName = folders(i).name;
    fullFolderPath = fullfile(basePath, folderName);

    HV_file = dir(fullfile(fullFolderPath, '*-VH.png'));

    if isempty(HV_file)
        warning('Faltan bandas en la carpeta: %s', folderName);
        continue;
    end

    hv = imread(fullfile(fullFolderPath, HV_file(1).name));

    hv = hv > 0;

    figure('Name', folderName);
    subplot(1,3,1);
    imshow(hv);

    z = hv;

    % Quita manchas bancas
    u = 13;
    for k = 1:4
        z = quitamanchas(z, u, 0, 1);
        z = quitamanchas(z, u, 1, 1);
    end

    subplot(1,3,2);
    imshow(z);

    % Quita manchas negras
    u = 45;
    for k = 1:4
        z = quitamanchas(z, u, 0, 0);
        z = quitamanchas(z, u, 1, 0);
    end
 
    % Tamaño de imagen
    [alto, ancho] = size(z);
    
    % Centro y radio en píxeles
    cx = ancho / 2;
    cy = alto / 2;
    radio_px = 1245;  % Círculo de 19.46 km²
    
    % Crear máscara circular
    [xx, yy] = meshgrid(1:ancho, 1:alto);
    mask = ((xx - cx).^2 + (yy - cy).^2) <= radio_px^2;
    
    % Aplicar máscara a la imagen binaria
    z_masked = z & mask;
    
    % Calcular porcentaje solo dentro del círculo
    num_1 = nnz(z_masked);
    num_total = nnz(mask);  % Solo píxeles dentro del círculo
    
    porcentaje = (num_1 / num_total) * 100;

    subtxt = sprintf('Blancos (1): %d | Negros (0): %d | Porcentaje blancos: %.2f%%', ...
                 num_1, num_0, porcentaje);
    
    annotation("textbox", [0.5, 0.91, 0.5, 0.05], "String", subtxt, "HorizontalAlignment","right");

    subplot(1,3,3);
    imshow(z); hold on;
    % Crear coordenadas de un círculo
    theta = linspace(0, 2*pi, 1000);
    x_circ = cx + radio_px * cos(theta);
    y_circ = cy + radio_px * sin(theta);
    
    % Dibujar círculo
    plot(x_circ, y_circ, 'r', 'LineWidth', 0.8);
    
    title(sprintf('Área considerada: %.2f km²', 19.46));
    % Guardar el valor y nombre
    porcentajes(i) = porcentaje;
    nombresOrdenados(i) = folderName;

    % Guardar imagen procesada como PNG
    nombreSalida = fullfile(savePath, sprintf('%s.png', folderName));
    imwrite(z, nombreSalida);

end

%%%%%%%%%%%%%%

% Ordenar por nombre para gráfica coherente
[~, orden] = sort(nombresOrdenados);
porcentajes_ordenados = porcentajes(orden);

% Gráfica evolución
figure;
plot(porcentajes_ordenados, '-o', 'LineWidth', 2);
xlabel('Índice temporal (orden alfabético)');
ylabel('Porcentaje de blancos (%)');
title('Evolución del porcentaje de blancos');
grid on;

% Guardar la gráfica
saveas(gcf, fullfile(savePath, 'evolucion_porcentaje_blancos.png'));

%%%%%%%%%%%%%%%%%%%%

% Calcular área en m² a partir del porcentaje
area_total_m2 = 19.46 * 1e6;
area_blanca_m2 = (porcentajes_ordenados / 100) * area_total_m2;

% Gráfica del área en metros cuadrados
figure;
plot(area_blanca_m2, '-s', 'LineWidth', 2, 'MarkerSize', 6);
xlabel('Índice temporal (orden alfabético)');
ylabel('Área blanca (m²)');
title('Evolución del área blanca en el círculo (m²)');
grid on;

% Guardar la gráfica
saveas(gcf, fullfile(savePath, 'evolucion_area_blanca_m2.png'));
