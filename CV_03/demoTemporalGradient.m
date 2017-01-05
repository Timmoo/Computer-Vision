clear all; close all; clc;

% mov = mmreader('WALKPASS_3.AVI');
mov = VideoReader('WALKPASS.AVI');
vidFrames = read(mov);

h1 = figure(1); set(h1,'DoubleBuffer','on');
h2 = figure(2); set(h2,'DoubleBuffer','on');
h3 = figure(3); set(h3,'DoubleBuffer','on');

figure(1); imshow(vidFrames(:,:,:,1),[]);
[cx, cy] = ginput(1); 
cx = round(cx); cy = round(cy);

ft = zeros(size(vidFrames,4),1);

for ii = 1:size(vidFrames,4)
    ft(ii) = vidFrames(cy,cx,1,ii);
    figure(1); clf; imshow(vidFrames(:,:,:,ii),[]);
    hold on; plot([cx-10 cx+10], [cy cy],'y');
    plot([cx cx], [cy-10 cy+10],'y');
    hold off;
    
    figure(2); clf; plot(1:ii,ft(1:ii)); axis([1 size(vidFrames,4) 0 255]); title('original signal');
    
    if ii>1
        figure(3); clf; plot(1:ii-1,ft(2:ii)-ft(1:ii-1)); axis([1 size(vidFrames,4) -255 255]); title('gradient signal');
    end
    
    drawnow;
end

pause

for ii = 2:size(vidFrames,4)
    figure(4); imshow(double(vidFrames(:,:,1,ii))-double(vidFrames(:,:,1,ii-1)),[-255,255]);
    drawnow;
end

    