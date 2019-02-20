%% test over size
srate = 1000;
%fft is faster for any frequency less than the wavenumber
%fft is faster for any wavenumber larger than the frequency
clear out

points = [ 1E3:1000:10E3 20E3 60E3 180E3  ];
% F = (2^(1/4)).^(-26:1:28); %Log
F = [1:20];
max_wav = 20;

count = 1;
for i_test = points;
    
    fprintf([num2str(i_test) ' points. \n']);
    test = randn(i_test,1);
    for i_freq = 1:length(F)
        for i_wavenum = 1:max_wav
            
            %conv
            tic; tempB = BOSC_tf_conv(test,F(i_freq),srate,i_wavenum);
            out(1,count,i_freq,i_wavenum) = toc;
            
            %fft
            tic; B = BOSC_tf_fft(test,F(i_freq),srate,i_wavenum);
            out(2,count,i_freq,i_wavenum) = toc;
            
        end
    end
    count = count+1;
end


%% plot the output as images
out_nconv_pfft = squeeze((out(1,:,:,:) - out(2,:,:,:))./out(1,:,:,:));
%positive (red)  - convolution took longer (fft faster)
%negative (blue) - fft took longer (conv faster)
figure;

for i_test = 1:length(points)
    subplot(nextpow2(length(points))+1,nextpow2(length(points))+1,i_test);
    imagesc(1:max_wav,F,100*squeeze(out_nconv_pfft(i_test,:,:)) ,...
        [-150 150]);
    set(gca,'Ydir','normal');
    
    colorbar_lab('FFT SLOWER <-------> FFT FASTER');
    
    newjet
    title([ num2str((points(i_test)/srate)) ' seconds.']);
    xlabel('Wavenumber');
    ylabel('Frequency');
end


%% plot a single wavenumber

figure; plot(points/srate,out(:,:,1,6)')
legend('CONV','FFT');
    xlabel(['seconds at ' num2str(srate) ' Hz']); 
    ylabel('Time (s)');
    
%% plot the spectra for each method



CLim = [0 10000];
figure; subplot(3,1,1); imagesc(B,CLim); colorbar;
subplot(3,1,2); imagesc(tempB,CLim); colorbar;
subplot(3,1,3); imagesc(tempB-B); colorbar;


%% 