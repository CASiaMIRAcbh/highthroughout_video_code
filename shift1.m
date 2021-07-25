% 生成平移视频

% clear
% clc
% clf

imgRootStr = '';
width = 4000;
height = 14000;
redLineWidth = 2;

upScaleBarPosX = 480;
upScaleBarPosY = 540;
upScaleBarLength = 48;
upScaleBarTextPosX = 472;
upScaleBarTextPosY = 540-45;
upColor = 'white';

downScaleBarPosX = 480;
downScaleBarPosY = 198;
downScaleBarLength = 46;
downScaleBarTextPosX = 472;
downScaleBarTextPosY = 198-45;
downColor = 'white';

miu = native2unicode([hex2dec('CE') hex2dec('BC')],'UTF-8'); 
um_str = [' ', miu, 'm'];

img = imread([imgRootStr, 'layer1_1_', num2str(1), '.jpg']);
imgAll = imresize(img, [NaN 64]);
for i=2:9
    img = imread([imgRootStr, 'layer1_1_', num2str(i), '.jpg']);
    imgTemp = imresize(img, [NaN 64]);
    imgAll(:, end+1:end+size(imgTemp, 2)) = imgTemp;
end
% imgAll 是576个像素


v = VideoWriter('drawshift_7.avi', 'Motion JPEG AVI'); % 设定名称、格式
v.FrameRate = 25;
open(v)

isfirst = true;
img1 = imread([imgRootStr, 'layer1_1_', num2str(1), '.jpg']);
img2 = imread([imgRootStr, 'layer1_1_', num2str(2), '.jpg']);
img3 = imread([imgRootStr, 'layer1_1_', num2str(3), '.jpg']);
img4 = imread([imgRootStr, 'layer1_1_', num2str(4), '.jpg']);
for i=5:9
    img5 = imread([imgRootStr, 'layer1_1_', num2str(i), '.jpg']);
    imgBig = img1;
    imgBig(:, end+1:end+width) = img2;
    imgBig(:, end+1:end+width) = img3;
    imgBig(:, end+1:end+width) = img4;
    imgBig(:, end+1:end+width) = img5;
    % 14000大小
    wid = 1:width/60:width;
    for j=1:60
        
        if isfirst && j<8
           continue;
        end
        
        flame = imgBig(:, wid(j):wid(j)+height-1);
        vflame = imresize(flame, [NaN 576]);
        vflame(end+1:end+8, :) = ones(8, 576, 'uint8')*255;
        linePos = round(redLineWidth/2);
        
        % 上方加框
%         vflame = insertShape(vflame, 'Rectangle', [linePos linePos 576-linePos 576-linePos], ...
%                 'Color', 'red', 'SmoothEdges', true, 'Opacity', 1, 'LineWidth', redLineWidth);          
        % 加虚线框 
            %加上面的和下面的两条
            for xxp = 1:5:576
                vflame = insertShape(vflame, 'Line', [xxp linePos+2 xxp+linePos+1 linePos+2], 'Color', [229 180 139], 'SmoothEdges', false, 'Opacity', 1, 'LineWidth', redLineWidth);
                vflame = insertShape(vflame, 'Line', [xxp 576 xxp+linePos+1 576], 'Color', [229 180 139], 'SmoothEdges', false, 'Opacity', 1, 'LineWidth', redLineWidth);
            end
            %加左右两条
            for xxp = 1:5:574
                vflame = insertShape(vflame, 'Line', [3 xxp 3 xxp+linePos+1], 'Color', [229 180 139], 'SmoothEdges', false, 'Opacity', 1, 'LineWidth', redLineWidth);
                vflame = insertShape(vflame, 'Line', [576 xxp 576 xxp+linePos+1], 'Color', [229 180 139], 'SmoothEdges', false, 'Opacity', 1, 'LineWidth', redLineWidth);
            end

        % 上方加标注  5000倍在8k图像上 10um是3571.4像素 上面是8750->576 再缩小了15.2倍
        % 235像素是10um 23.5像素是1um
            % 加scaleBar
        vflame = insertShape(vflame, 'Line',...
            [upScaleBarPosX upScaleBarPosY upScaleBarPosX+upScaleBarLength upScaleBarPosY],...
            'Color', upColor, 'SmoothEdges', false, 'Opacity', 1, 'LineWidth', 3);
            % 加scaleBar的单位
        vflame = insertText(vflame, [upScaleBarTextPosX upScaleBarTextPosY],... % 这个是位置
            ['2', um_str], 'FontSize',20,'BoxOpacity',0,'TextColor',upColor, 'Font', 'Arial'); 
        vflame = insertText(vflame, [upScaleBarTextPosX+1 upScaleBarTextPosY],... % 这个是位置
            ['2', um_str], 'FontSize',20,'BoxOpacity',0,'TextColor',upColor, 'Font', 'Arial'); 
        vflame = insertText(vflame, [upScaleBarTextPosX upScaleBarTextPosY+1],... % 这个是位置
            ['2', um_str], 'FontSize',20,'BoxOpacity',0,'TextColor',upColor, 'Font', 'Arial'); 
        vflame = insertText(vflame, [upScaleBarTextPosX+1 upScaleBarTextPosY+1],... % 这个是位置
            ['2', um_str], 'FontSize',20,'BoxOpacity',0,'TextColor',upColor, 'Font', 'Arial'); 
        
        % 下方加框
%         imgAllTemp = insertShape(imgAll, 'Rectangle', [(1+(i-5)*4000+round(wid(j)))*224/14000, linePos,  224, 224-linePos], ...
%                 'Color', 'red', 'SmoothEdges', false, 'Opacity', 1, 'LineWidth', redLineWidth);
        % 加虚线框 
            smallBoxStartX = (1+(i-5)*width+round(wid(j)))*224/height;
            %加上面的和下面的两条
            imgAllTemp = imgAll;
            for xxp = 1:5:224
                imgAllTemp = insertShape(imgAllTemp, 'Line', [smallBoxStartX+xxp linePos+2 smallBoxStartX+xxp+linePos+1 linePos+2], 'Color', [229 180 139], 'SmoothEdges', false, 'Opacity', 1, 'LineWidth', redLineWidth);
                imgAllTemp = insertShape(imgAllTemp, 'Line', [smallBoxStartX+xxp 224 smallBoxStartX+xxp+linePos+1 224], 'Color', [229 180 139], 'SmoothEdges', false, 'Opacity', 1, 'LineWidth', redLineWidth);
            end
            %加左右两条
            for xxp = 1:5:224
                imgAllTemp = insertShape(imgAllTemp, 'Line', [smallBoxStartX xxp smallBoxStartX xxp+linePos+1], 'Color', [229 180 139], 'SmoothEdges', false, 'Opacity', 1, 'LineWidth', redLineWidth);
                imgAllTemp = insertShape(imgAllTemp, 'Line', [smallBoxStartX+224+linePos+3 xxp smallBoxStartX+224+linePos+3 xxp+linePos+1], 'Color', [229 180 139], 'SmoothEdges', false, 'Opacity', 1, 'LineWidth', redLineWidth);
            end
            
        % 下方加标注  5000倍在8k图像上 10um是3571.4像素 上面是2k5->64 再缩小了39倍 91.6像素是10um
        % 46像素是5um
            % 加scaleBar
        imgAllTemp = insertShape(imgAllTemp, 'Line',...
            [downScaleBarPosX downScaleBarPosY downScaleBarPosX+downScaleBarLength downScaleBarPosY],...
            'Color', downColor, 'SmoothEdges', false, 'Opacity', 1, 'LineWidth', 3);
            % 加scaleBar的单位
        imgAllTemp = insertText(imgAllTemp, [downScaleBarTextPosX downScaleBarTextPosY],... % 这个是位置
            ['5', um_str], 'FontSize',20,'BoxOpacity',0,'TextColor',downColor, 'Font', 'Arial'); 
        imgAllTemp = insertText(imgAllTemp, [downScaleBarTextPosX+1 downScaleBarTextPosY],... % 这个是位置
            ['5', um_str], 'FontSize',20,'BoxOpacity',0,'TextColor',downColor, 'Font', 'Arial'); 
        imgAllTemp = insertText(imgAllTemp, [downScaleBarTextPosX downScaleBarTextPosY+1],... % 这个是位置
            ['5', um_str], 'FontSize',20,'BoxOpacity',0,'TextColor',downColor, 'Font', 'Arial'); 
        imgAllTemp = insertText(imgAllTemp, [downScaleBarTextPosX+1 downScaleBarTextPosY+1],... % 这个是位置
            ['5', um_str], 'FontSize',20,'BoxOpacity',0,'TextColor',downColor, 'Font', 'Arial'); 
        
        % 合并图像
        vflame(end+1:end+size(imgAll, 1), :, :) = imgAllTemp;
        
        % 加斜线
        vflame = insertShape(vflame, 'Line', ...
            [2 576 (1+(i-5)*width+round(wid(j)))*224/height 576+11], ...
                'Color', [229 180 139], 'SmoothEdges', true, 'Opacity', 1, 'LineWidth', redLineWidth);
        vflame = insertShape(vflame, 'Line', ...
            [575 576 (1+(i-5)*width+round(wid(j)))*224/height+226 576+11], ...
                'Color', [229 180 139], 'SmoothEdges', true, 'Opacity', 1, 'LineWidth', redLineWidth);
            
        imshow(vflame);
        drawnow;
        
        writeVideo(v, vflame);
        if isfirst
            for k=1:50
                writeVideo(v, vflame);
            end
            isfirst = false;
        end


    end
    
    img1 = img2;
    img2 = img3;
    img3 = img4;
    img4 = img5;
    
end



% 最后收个尾 还剩下2k像素的图 wid是单张的整个宽 只用取不到一半的wid即可
for j=1:24
    flame = imgBig(:, wid(j)+width:wid(j)+width+height-1);
    vflame = imresize(flame, [NaN 576]);
    vflame(end+1:end+8, :) = ones(8, 576, 'uint8')*255;

    % 上方加框
%     vflame = insertShape(vflame, 'Rectangle', [linePos linePos 576-linePos 576-linePos], ...
%             'Color', 'red', 'SmoothEdges', true, 'Opacity', 1, 'LineWidth', redLineWidth);   
    % 加虚线框 
        %加上面的和下面的两条
         for xxp = 1:5:576
            vflame = insertShape(vflame, 'Line', [xxp linePos+2 xxp+linePos+1 linePos+2], 'Color', [229 180 139], 'SmoothEdges', false, 'Opacity', 1, 'LineWidth', redLineWidth);
            vflame = insertShape(vflame, 'Line', [xxp 576 xxp+linePos+1 576], 'Color', [229 180 139], 'SmoothEdges', false, 'Opacity', 1, 'LineWidth', redLineWidth);
        end
        %加左右两条
        for xxp = 1:5:574
            vflame = insertShape(vflame, 'Line', [3 xxp 3 xxp+linePos+1], 'Color', [229 180 139], 'SmoothEdges', false, 'Opacity', 1, 'LineWidth', redLineWidth);
            vflame = insertShape(vflame, 'Line', [576 xxp 576 xxp+linePos+1], 'Color', [229 180 139], 'SmoothEdges', false, 'Opacity', 1, 'LineWidth', redLineWidth);
        end       

    % 上方加标注  5000倍在8k图像上 10um是3571.4像素 上面是14k->576 再缩小了24.3倍
    % 146.97像素是10um 29.4像素是2um
        % 加scaleBar
    vflame = insertShape(vflame, 'Line',...
        [upScaleBarPosX upScaleBarPosY upScaleBarPosX+upScaleBarLength upScaleBarPosY],...
        'Color', upColor, 'SmoothEdges', false, 'Opacity', 1, 'LineWidth', 3);
        % 加scaleBar的单位
    vflame = insertText(vflame, [upScaleBarTextPosX upScaleBarTextPosY],... % 这个是位置
        ['2', um_str], 'FontSize',20,'BoxOpacity',0,'TextColor',upColor, 'Font', 'Arial'); 
    vflame = insertText(vflame, [upScaleBarTextPosX+1 upScaleBarTextPosY],... % 这个是位置
        ['2', um_str], 'FontSize',20,'BoxOpacity',0,'TextColor',upColor, 'Font', 'Arial'); 
    vflame = insertText(vflame, [upScaleBarTextPosX upScaleBarTextPosY+1],... % 这个是位置
        ['2', um_str], 'FontSize',20,'BoxOpacity',0,'TextColor',upColor, 'Font', 'Arial'); 
    vflame = insertText(vflame, [upScaleBarTextPosX+1 upScaleBarTextPosY+1],... % 这个是位置
        ['2', um_str], 'FontSize',20,'BoxOpacity',0,'TextColor',upColor, 'Font', 'Arial'); 

    % 下方加框
%     imgAllTemp = insertShape(imgAll, 'Rectangle', [(1+(i-4)*4000+round(wid(j)))*224/14000, linePos,  224, 224-linePos], ...
%             'Color', 'red', 'SmoothEdges', false, 'Opacity', 1, 'LineWidth', redLineWidth);     
    % 加虚线框 
        smallBoxStartX = (1+(i-4)*width+round(wid(j)))*224/height;
        %加上面的和下面的两条
        imgAllTemp = imgAll;
        for xxp = 1:5:224
            imgAllTemp = insertShape(imgAllTemp, 'Line', [smallBoxStartX+xxp linePos+2 smallBoxStartX+xxp+linePos+1 linePos+2], 'Color', [229 180 139], 'SmoothEdges', false, 'Opacity', 1, 'LineWidth', redLineWidth);
            imgAllTemp = insertShape(imgAllTemp, 'Line', [smallBoxStartX+xxp 224 smallBoxStartX+xxp+linePos+1 224], 'Color', [229 180 139], 'SmoothEdges', false, 'Opacity', 1, 'LineWidth', redLineWidth);
        end
        %加左右两条
        for xxp = 1:5:224
            imgAllTemp = insertShape(imgAllTemp, 'Line', [smallBoxStartX xxp smallBoxStartX xxp+linePos+1], 'Color', [229 180 139], 'SmoothEdges', false, 'Opacity', 1, 'LineWidth', redLineWidth);
            imgAllTemp = insertShape(imgAllTemp, 'Line', [smallBoxStartX+224+linePos+3 xxp smallBoxStartX+224+linePos+3 xxp+linePos+1], 'Color', [229 180 139], 'SmoothEdges', false, 'Opacity', 1, 'LineWidth', redLineWidth);
        end
        
        
    % 下方加标注  5000倍在8k图像上 10um是3571.4像素 上面是4k->64 再缩小了62.5倍 57.1像素是10um
        % 加scaleBar
    imgAllTemp = insertShape(imgAllTemp, 'Line',...
        [downScaleBarPosX downScaleBarPosY downScaleBarPosX+downScaleBarLength downScaleBarPosY],...
        'Color', downColor, 'SmoothEdges', false, 'Opacity', 1, 'LineWidth', 3);
        % 加scaleBar的单位
    imgAllTemp = insertText(imgAllTemp, [downScaleBarTextPosX downScaleBarTextPosY],... % 这个是位置
        ['5', um_str], 'FontSize',20,'BoxOpacity',0,'TextColor', downColor, 'Font', 'Arial'); 
    imgAllTemp = insertText(imgAllTemp, [downScaleBarTextPosX+1 downScaleBarTextPosY],... % 这个是位置
        ['5', um_str], 'FontSize',20,'BoxOpacity',0,'TextColor', downColor, 'Font', 'Arial'); 
    imgAllTemp = insertText(imgAllTemp, [downScaleBarTextPosX downScaleBarTextPosY+1],... % 这个是位置
        ['5', um_str], 'FontSize',20,'BoxOpacity',0,'TextColor', downColor, 'Font', 'Arial'); 
    imgAllTemp = insertText(imgAllTemp, [downScaleBarTextPosX+1 downScaleBarTextPosY+1],... % 这个是位置
        ['5', um_str], 'FontSize',20,'BoxOpacity',0,'TextColor', downColor, 'Font', 'Arial'); 

    % 合并图像
    vflame(end+1:end+size(imgAll, 1), :, :) = imgAllTemp;

    % 加斜线
    vflame = insertShape(vflame, 'Line', ...
        [2 576 (1+(i-4)*width+round(wid(j)))*224/height 576+11], ...
            'Color', [229 180 139], 'SmoothEdges', true, 'Opacity', 1, 'LineWidth', redLineWidth);
    vflame = insertShape(vflame, 'Line', ...
        [575 576 (1+(i-4)*width+round(wid(j)))*224/height+226 576+11], ...
            'Color', [229 180 139], 'SmoothEdges', true, 'Opacity', 1, 'LineWidth', redLineWidth);

    imshow(vflame);
    drawnow;

    
    writeVideo(v, vflame);
end

for i=1:50
    writeVideo(v, vflame);
end

close(v);