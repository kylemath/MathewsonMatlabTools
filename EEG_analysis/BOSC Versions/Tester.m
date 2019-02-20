%% test
   F = 1:1:100;
srate = 1000;
wavenum = 12;
test = randn(1E10,1);

tic; B = BOSC_tf(test,F,srate,wavenum); toc;
tic; B = BOSC_tf_2(test,F,srate,wavenum,1); toc;
tic; B = BOSC_tf_2(test,F,srate,wavenum); toc;
tic; [B,T] = BOSC_tf_2(test,F,srate,wavenum); toc;
tic; [B,T,P] = BOSC_tf_2(test,F,srate,wavenum); toc;


%% test over size
srate = 1000;


%fft is faster for any frequency less than the wavenumber
%fft is faster for any wavenumber larger than the frequency 

clear out


% points = [2:10:1E3 1E3+100:100:1E4 1E4+1000:1000:1E5 1E5:50000:1E6];
points = [ 20000E3 ];
F = (2^(1/4)).^(-26:1:28); %Log 
% F = [2 10];
max_wav = 40;

count = 1;
for i_test = points;
    
    fprintf([num2str(i_test) ' points. \n']);
    test = randn(i_test,1);
    for i_freq = 1:length(freqs)
        for i_wavenum = 1:max_wav
            
            %conv
            tic; tempB = BOSC_tf_1_conv(test,F(i_freq),srate,i_wavenum); 
                out(1,count,i_freq,i_wavenum) = toc;
                
            %fft    
            tic; B = BOSC_tf_1_fft(test,F(i_freq),srate,i_wavenum); 
                out(2,count,i_freq,i_wavenum) = toc;
            
        end
    end
    count = count+1;
end


%%

out_nconv_pfft = squeeze((out(1,:,:,:) - out(2,:,:,:))./out(1,:,:,:));
%positive - convolution took longer (fft faster)
%negative (blue) - fft took longer (conv faster)
figure;
%     suptitle('Red-FFT Faster/Blue-Conv Faster');

for i_test = 1:length(points)
    subplot(nextpow2(length(points)),nextpow2(length(points)),i_test);
    imagesc(1:max_wav,F,squeeze(100*out_nconv_pfft(i_test,:,:)) ,...
         [-100 100]);
     set(gca,'Ydir','normal');
%         [-max(max(max(abs(out_nconv_pfft(i_test,:,:)*100)))) max(max(max(abs(out_nconv_pfft(i_test,:,:)*100))))]);
    
% colorbar 
    
    newjet
    title([ num2str((points(i_test)/srate)) ' seconds.']);
    xlabel('Wavenumber');
    ylabel('Frequency');
end
    subplot(nextpow2(length(points)),nextpow2(length(points)),pow2(nextpow2(length(points))));
    imagesc(1:max_wav,F,squeeze(100*out_nconv_pfft(i_test,:,:)) ,...
         [-100 100]);
     colorbar 
         xlabel('Wavenumber');
    ylabel('Frequency');

%%
plot(points/srate,out(:,:,1,6)')
legend('CONV','FFT');
    xlabel(['seconds at ' num2str(srate) ' Hz']); 
    ylabel('Time (s)');
    
  %%  
plot(points/srate,out'); 
    legend('CONV','FFT');
    xlabel(['seconds at ' num2str(srate) ' Hz']); 
    ylabel('Time (s)');
    %%
    
    CLim = [0 10000];
    figure; subplot(3,1,1); imagesc(B,CLim); colorbar; 
        subplot(3,1,2); imagesc(tempB,CLim); colorbar; 
        subplot(3,1,3); imagesc(tempB-B); colorbar; 
        
