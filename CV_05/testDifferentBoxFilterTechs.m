clc;

im = double(imread('cameraman.tif'));

iptsetpref('UseIPPL', false);

wid = 21;

nTimes = 100;

% tt=cputime; 
% for ii = 1:nTimes
%     boxfilt2d = imfilter(im,ones(wid,wid),'same',0);
% end
% disp(['2D boxfiltering:' num2str(cputime-tt) ' seconds']);

tic 
for ii = 1:nTimes
    boxfilt2d = imfilter(im,ones(wid,wid),'same',0);
end
disp(['2D boxfiltering:' num2str(toc) ' seconds']);

tic;
for ii = 1:nTimes
    two1Dfilt = imfilter(imfilter(im,ones(wid,1),'same',0),ones(1,wid),'same',0);
end
fprintf('\nTwo 1D boxfiltering: %f seconds \n\n', toc);

tic;
for ii = 1:nTimes
    integralfilt = meanfilt(im,wid);
end
disp(['Boxfiltering by integral image: ' num2str(toc) ' seconds']);
fprintf('\n');

disp(['max(abs(boxfilt2d(:)-two1Dfilt(:)))' num2str(max(abs(boxfilt2d(:)-two1Dfilt(:))))]);
% isequal(boxfilt2d,two1Dfilt)

disp(['max(abs(boxfilt2d(:)-integralfilt(:)))' num2str(max(abs(boxfilt2d(:)-integralfilt(:))))]);
% isequal(boxfilt2d,integralfilt)