basePath = '..\img\';
outputDir = fullfile(basePath, '..', 'results_lab3');
if ~exist(outputDir, 'dir')
    mkdir(outputDir);
end

% Lista de carpetas dentro del directorio base
folders = dir(basePath);
folders = folders([folders.isdir] & ~startsWith({folders.name}, '.'));

for i = 1:length(folders)
    folderName = folders(i).name;
    fullFolderPath = fullfile(basePath, folderName);
    
    % Leer bandas necesarias
    B02_file = dir(fullfile(fullFolderPath, '*B02__Raw_*.png')); % Azul
    B03_file = dir(fullfile(fullFolderPath, '*B03__Raw_*.png')); % Verde
    B04_file = dir(fullfile(fullFolderPath, '*B04__Raw_*.png')); % Rojo
    B08_file = dir(fullfile(fullFolderPath, '*B08__Raw_*.png')); % NIR
    
    if isempty(B02_file) || isempty(B03_file) || isempty(B04_file) || isempty(B11_file)
        warning('Faltan bandas en la carpeta: %s', folderName);
        continue;
    end
    
    azul = imread(fullfile(fullFolderPath, B02_file(1).name));
    verde = imread(fullfile(fullFolderPath, B03_file(1).name));
    rojo = imread(fullfile(fullFolderPath, B04_file(1).name));
    nir = imread(fullfile(fullFolderPath, B08_file(1).name)); % Usando NIR

    % Expansión de la banda SWIR1 para ajustar el rango de valores
    nir = expan(nir, 0, 255);  

    % Aplicar corte de colas a las imágenes para eliminar valores extremos
    azul = corte(azul, 0.01);
    verde = corte(verde, 0.01);
    rojo = corte(rojo, 0.01);
    nir = corte(nir, 0.01);
    
    % Crear la subcarpeta para esta fecha
    outputSubDir = fullfile(outputDir, folderName);
    if ~exist(outputSubDir, 'dir')
        mkdir(outputSubDir);
    end
    
    % Guardar Banda NIR
    imwrite(nir, fullfile(outputSubDir, 'Banda_NIR.png'));
    
    % Guardar Histograma Banda NIR
    h = figure('Visible', 'off');
    histogram(nir(:), 256);
    title('Histograma Banda NIR');
    xlabel('Intensidad');
    ylabel('Número de píxeles');
    saveas(h, fullfile(outputSubDir, 'Histograma_NIR.png'));
    close(h);
    
    % Composición True Color 
    trueColor = combina(rojo, verde, azul);  
    imwrite(trueColor, fullfile(outputSubDir, 'Composicion_True_Color.png'));
    
    % Composición False Color (SWIR1, Rojo, Verde)
    falseColor = cat(3, nir, rojo, verde);  
    imwrite(falseColor, fullfile(outputSubDir, 'Composicion_False_Color_NIR.png'));
    
    % Aplicar corte en HSV (Saturación)
    falseColorHSV = cortehsv(falseColor, 0.1);  
    imwrite(falseColorHSV, fullfile(outputSubDir, 'Composicion_False_Color_Corte_S.png'));
end
