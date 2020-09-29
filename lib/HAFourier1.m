function [fitresult, gof] = HAFourier1(xData, yData, fnum)
%CREATEFIT3(XXF,YYF)
%  Create a fit.
%
%  Data for 'untitled fit 1' fit:
%      X Input : xxf
%      Y Output: yyf
%  Output:
%      fitresult : a fit object representing the fit.
%      gof : structure with goodness-of fit info.
%
%  See also FIT, CFIT, SFIT.

%  Auto-generated by MATLAB on 28-Oct-2019 16:26:22


%% Fit: 'untitled fit 1'.

% Set up fittype and options.
ft = fittype( 'fourier1' );
opts = fitoptions( 'Method', 'NonlinearLeastSquares' );
opts.Display = 'Off';
opts.StartPoint = [0 0 0 0.0020];

% Fit model to data.
[fitresult, gof] = fit( xData, yData, ft, opts );

% Plot fit with data.
figure(fnum);
h = plot( fitresult, xData, yData );
legend( h, 'yyf vs. xxf', 'untitled fit 1', 'Location', 'NorthEast' );
% Label axes
xlabel xxf
ylabel yyf
grid on

