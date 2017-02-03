%BME463 Class 1/5/16

%autocorrelation
x = -3:0.01:3;
rng default
y = 2*x+randn(size(x));
figure(1)
plot(x,y)

figure(2)
plot(x,y)
coeffs = polyfit(x,y,1);
yfit = coeffs(2)+coeffs(1)*x;
hold on
plot(x,yfit,'linewidth',2)

residuals = y - yfit;
[xc,lags] = xcorr(residuals,50,'coeff');

conf99 = sqrt(2)*erfcinv(2*.01/2);
lconf = -conf99/sqrt(length(x));
upconf = conf99/sqrt(length(x));

figure(3)

stem(lags,xc,'filled')
ylim([lconf-0.03 1.05])
hold on
plot(lags,lconf*ones(size(lags)),'r','linewidth',2)
plot(lags,upconf*ones(size(lags)),'r','linewidth',2)
title('Sample Autocorrelation with 99% Confidence Intervals')