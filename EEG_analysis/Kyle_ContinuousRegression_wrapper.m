function [meanW] = Kyle_ContinuousRegression_wrapper(eeg_data,con_data,win_length,srate,lambda)
% Kyle_ContinuousRegerssion_wrapper.m  - Kyle Mathewson, PhD, 2014 - Beckman Institute, University of Illinois 
% After -  O'Sullivan JA, Power AJ, Mesgarani N, Rajaram S, Foxe JJ, Shin-Cunningham BG, Slaney M, Shamma SA, Lalor EC (2014). Attentional Selection in a Cocktail Party Environment Can Be Decoded from Single-Trial EEG. Cerebral Cortex.
% Computes the regression between a set of EEG channels and a time lagged continuous variable of the same length and sampling rate
% - Inputs
% eeg_data - is a time x channels matrix
% con_data - is a row vector of the continous variable (rasampled to make the same rate as EEG)
% win_length - windows of eeg data to use as 'trials' to average together for the subject
% srate - sampling rate of eeg_data AND con_data in Hz.
% lambda - discount parameter for overfitting in the regression 
% - Outputs
% meanW - is the mean TRF windows for each channel

clear w

%make sure row vector
if iscolumn(con_data)
    con_data = con_data';
end
conDATA = con_data;

figure; 
for i_chan = 1:size(eeg_data,2)
    %get eeg channel
    eegDATA = eeg_data(:,i_chan);
    tic
    for i_window = 0:round(length(eeg_data)/win_length)-2
        %take window of data
        win_lims = 1+(i_window*win_length):(i_window+1)*win_length;
        %run the regression for this window of this channel
        w(:,i_window+1) = Kyle_ContinuousRegression(eegDATA(win_lims),conDATA(win_lims),srate,lambda,0);
    end
    toc
    %compute the mean for this channel over windows
    meanW(:,i_chan) = mean(w,2);
    
    %plot the results of each channel
    times = (1/srate):(1/srate):(1/srate)*size(w,1);
    subplot(4,4,i_chan); plot(times,meanW(:,i_chan)); title(['Channel : ' num2str(i_chan)]);
end
