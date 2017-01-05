clc;

%read an image
[filename, pathname] = uigetfile({'*.tif';'*.jpg';'*.*'},'Pictures');
im = imread(fullfile(pathname,filename));
maxval = max(im(:));

button = 1;
while button == 1        
    figure(1); clf; imshow(im(:,:,1)); axis equal    
    [x,y, button] = ginput(1); 
    if button == 3 %Right-click in figure 1 to exit the demo
        close all;
        break;
    end  
    
    x = round(x); y=round(y);  %make it integer
    
    %display point and box around it
    hold on; plot(x,y,'r+');    
    halfwid = 8;  
    plot([x-halfwid x-halfwid x+halfwid x+halfwid x-halfwid],...
         [y-halfwid y+halfwid y+halfwid y-halfwid y-halfwid],'r');
    hold off
    drawnow;

    %extract rectangular patch.  Note use of vectors as indices.
    deltavec = -halfwid:halfwid;
    patch = double(im(y+deltavec, x+deltavec,1));
    
    %display patch as 3D surface
    figure(2);  colormap(gray); surf(flipud(patch)); axis([1 2*halfwid+1 1 2*halfwid+1 0 maxval]);
    title(['Mean = ' num2str(mean(patch(:))) ';  Std = ' num2str(std(patch(:)))]);
    drawnow;
    pause
end

