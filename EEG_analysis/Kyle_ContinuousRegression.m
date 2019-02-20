function [w] = Kyle_ContinuousRegression(eeg_data,con_data,srate,lambda,DOplot)
% Kyle_ContinuousRegression.m - Kyle Mathewson, PhD, 2014 - Beckman Institute, University of Illinois 
% After -  O'Sullivan JA, Power AJ, Mesgarani N, Rajaram S, Foxe JJ, Shin-Cunningham BG, Slaney M, Shamma SA, Lalor EC (2014). Attentional Selection in a Cocktail Party Environment Can Be Decoded from Single-Trial EEG. Cerebral Cortex.
% Computes the regression between a single EEG channel window and a time lagged continuous variable window of the same length and sampling rate
% - Inputs
% eeg_data - is a row vector of EEG data
% con_data - is a row vector of the continous variable (rasampled to make the same rate as EEG)
% srate - sampling rate of eeg_data AND con_data in Hz.
% lambda - discount parameter for overfitting in the regression 
% DOplot - 1 if you want to plot each window's analysis
% - Outputs
% w - the TRF vector for this window

window  = length(eeg_data);
times = (1/srate):(1/srate):(1/srate)*window;

%convert to row vectors
if iscolumn(eeg_data)
    eeg_data = eeg_data';
end
R = eeg_data;

if iscolumn(con_data)
    con_data = con_data';
end
S1 = con_data;


%construct S
S(:,1) = S1;

for i_col = 2:length(S1)
    S(1,i_col) = 0;
    S(i_col:end,i_col) = S1(1:end-(i_col-1));
end

%compute forward model
w = (S*S.' + lambda*eye(length(S)))\(S*R.');

if DOplot == 1
    figure; plot(times,w);
end