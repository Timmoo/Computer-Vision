function B = meanfilt(A,wid)
%wid is odd

[nrows, ncols] = size(A);
halfwid = (wid-1)/2;

%zero-padding
P = zeros(nrows+wid,ncols+wid);
P(halfwid+2:end-halfwid,halfwid+2:end-halfwid) = A;

%compute integral image
S = cumsum(P,1);
S = cumsum(S,2);

%box filtering
B =   S(wid+1:end,wid+1:end)...
    - S(1:end-wid,wid+1:end)...
    - S(wid+1:end,1:end-wid)...
    + S(1:end-wid,1:end-wid);

