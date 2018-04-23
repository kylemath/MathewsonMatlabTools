function [r] = nancorr(X,Y);
%nancorr - Bivariate correlation excluding NaN in either variable
%output - R - pearson corr
%Kyle Mathewson Ualberta

r = corr(X(~isnan(X) & ~isnan(Y)),Y(~isnan(X) & ~isnan(Y)));
end