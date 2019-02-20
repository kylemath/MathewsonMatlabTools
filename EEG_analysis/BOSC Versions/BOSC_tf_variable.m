eegsignal = data; %
Fsample = 1000; %Hz
freqs = [.1:.1:50];
wavenumber = [3 .01]; %just like eeglab
for i_freq = 1:length(freqs)
    F = freqs(i_freq);
    curr_wave = wavenumber(1) + ((i_freq-1)*wavenumber(2));
    [B(:,i_freq),T,P(:,i_freq)] = BOSC_tf(eegsignal,F,Fsample,curr_wave);
end
