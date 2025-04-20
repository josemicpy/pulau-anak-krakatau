% Ruta base donde están las carpetas
basePath = '..\pulau-anak-krakatau\img\';

% Lista de carpetas dentro del directorio base (exceptuando . y ..)
folders = dir(basePath);
folders = folders([folders.isdir] & ~startsWith({folders.name}, '.'));

% Definir los umbrales de clasificación
UMBRAL = [0, 50, 100, 150, 200, 255];  % Umbrales proporcionados

for i = 1:length(folders)
    folderName = folders(i).name;
    fullFolderPath = fullfile(basePath, folderName);
    
    % Construimos los nombres de archivo
    B03_file = dir(fullfile(fullFolderPath, '*B03__Raw_*.png'));
    B08_file = dir(fullfile(fullFolderPath, '*B08__Raw_*.png'));
    
    if isempty(B03_file) || isempty(B08_file)
        warning('Faltan bandas en la carpeta: %s', folderName);
        continue;
    end
    
    % Leemos las imágenes
    g = imread(fullfile(fullFolderPath, B03_file(1).name));  % Banda verde
    n = imread(fullfile(fullFolderPath, B08_file(1).name));  % Banda NIR
    
    % Procesamiento NDWI
    water = ndwi_v(g, n);
    water = fmediana_v(water);  % Filtrar la imagen para eliminar ruido
    
    % Verificar valores de NDWI (min y max)
    disp(['Valores de NDWI en la carpeta ', folderName, ' - Min: ', num2str(min(water(:))), ', Max: ', num2str(max(water(:)))]);

    % Clasificación de píxeles según los umbrales proporcionados
    umb = umbraliza(water);  % Se asume que umbraliza aplica estos umbrales
    
    % Generamos el mapa de clasificación
    mapa = mapa_v(umb);  % Se asume que mapa_v clasifica los valores
    
    % Mostrar resultados
    figure('Name', folderName);
    subplot(1,3,1);
    imshow(water, []);
    title('NDWI');
    
    histo = histo_v(water);
    subplot(1,3,2);
    plot(histo);
    title('Histograma');
    
    subplot(1,3,3);
    imshow(mapa, []);
    title('Mapa Clasificado');
    
    % Clasificar manualmente según los umbrales
    % Asumimos que los valores de mapa_v deben ser ajustados según los umbrales
    
    % Crear una nueva clasificación
    agua = (water < UMBRAL(2));  % Píxeles de agua
    terreno_inundado = (water >= UMBRAL(2) & water < UMBRAL(3));  % Terreno inundado
    terreno_seco = (water >= UMBRAL(3));  % Terreno seco
    
    % Contar los píxeles de cada tipo
    area_agua = sum(agua(:)); 
    area_terreno_inundado = sum(terreno_inundado(:)); 
    area_terreno_seco = sum(terreno_seco(:)); 
    
    % Calcular el porcentaje de cada tipo
    total_pixeis = numel(water);
    perc_agua = (area_agua / total_pixeis) * 100;
    perc_terreno_inundado = (area_terreno_inundado / total_pixeis) * 100;
    perc_terreno_seco = (area_terreno_seco / total_pixeis) * 100;
    
    % Mostrar los resultados en la consola
    fprintf('En la carpeta %s:\n', folderName);
    fprintf('Área de Agua: %.2f%%\n', perc_agua);
    fprintf('Área de Terreno Inundado: %.2f%%\n', perc_terreno_inundado);
    fprintf('Área de Terreno Seco: %.2f%%\n\n', perc_terreno_seco);
end
