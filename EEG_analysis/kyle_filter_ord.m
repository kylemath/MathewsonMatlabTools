function [Y_filt] = kyle_filter(Y,Fs,hipass,lopass,order)

% kyle_filter.m - Created Feb 23, 2012 by Kyle Mathewson, University of Illinois 
%[Y_filt] = kyle_filter(Y,Fs,hipass,lopass)
% Takes the time x channel data matrix Y, filters out a single frequency
% band,
% Input is: 
%           Y  - data matrix, time points by channels
%           Fs - Sampling Frequency in Hz
%           hipass - lower bound of filter
%           lopass - upper bound of filter
% Output is:
%            Y_filt - same as Y but not filtered

%--------------------------------------------------------------------------
%Initialize some variables
Y_filt = Y;  %Allocate memory for output

fprintf(['Filtering data between ' num2str(hipass) ' Hz and ' num2str(lopass) ' Hz. ' '\n']);

%--------------------------------------------------------------------------
%Filter with a bandpass butterworth

bandpass = [(hipass*2)/Fs, (lopass*2)/Fs];          % Bandwidth of bandpass filter
[Bbp,Abp] = butter(order,bandpass);                 % Generation of Xth order Butterworth highpass filter
for c = 1:size(Y,2)
    Y_filt(:,c) = filtfilt(Bbp,Abp,(Y(:,c)));       % Butterworth bandpass filtering of YY
end


