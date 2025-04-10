function process_images()
    base_img_folder = fullfile('..', 'pulau-anak-krakatau', 'img');
    result_folder = fullfile('..', 'pulau-anak-krakatau', 'results');
    
    if ~exist(result_folder, 'dir')
        mkdir(result_folder);
    end
    
    % Obtener todas las carpetas de fechas
    date_folders = dir(base_img_folder);
    date_folders = date_folders([date_folders.isdir] & ~startsWith({date_folders.name}, '.'));
    
    for d = 1:length(date_folders)
        date_folder = fullfile(base_img_folder, date_folders(d).name);
        result_date_folder = fullfile(result_folder, date_folders(d).name);
        
        if ~exist(result_date_folder, 'dir')
            mkdir(result_date_folder);
        end
        
        % Obtener las imágenes B03 y B08
        files_B03 = dir(fullfile(date_folder, '*_B03__Raw_*.png'));
        files_B08 = dir(fullfile(date_folder, '*_B08__Raw_*.png'));
        
        for i = 1:length(files_B03)
            g1 = imread(fullfile(date_folder, files_B03(i).name));
            n1 = imread(fullfile(date_folder, files_B08(i).name));
            
            % Calcular NDWI
            water1 = ndwi_v(g1, n1);
            
            % Crear figura
            figure;
            subplot(1,3,1);
            imshow(water1);
            title('NDWI');
            
            % Calcular histograma
            histo1 = histo_v(water1);
            subplot(1,3,2);
            plot(histo1);
            title('Histograma');
            
            % Umbralizar y generar mapa
            umb1 = umbraliza(water1);
            mapa1 = mapa_v(umb1);
            subplot(1,3,3);
            imshow(mapa1);
            title('Mapa Umbralizado');
            
            % Guardar resultado
            saveas(gcf, fullfile(result_date_folder, strcat('result_', num2str(i), '.png')));
            close;
        end
    end
end
