function zval = ztest2(x,y)

% x - sample 1
% y - sample 2
dim = 2;
mux = 0; %nanmean(x,dim);
muy = 0; %nanmean(y,dim);

varax = var(x,[],dim);
vary = var(y,[],dim);


% mux - mean of x to be used in difference. If you are not testing a
% specific difference, use mux = 0
% muy - mean of y. If you are not testing a
% specific difference, use muy = 0
% varx - variance of x
% vary - variance of y
Nx = size(x,2);
Ny = size(y,2);
zval = ((mean(x,dim)-mean(y,dim))-(mux-muy))./sqrt(varax/Nx+vary/Ny);

end