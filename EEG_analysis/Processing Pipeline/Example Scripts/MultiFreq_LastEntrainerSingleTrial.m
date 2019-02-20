%% Load the data, settings,

% If you run this script on an empty workspace, it will load the data needed for these plots.
if exist('exp')~=1; %check for a settings file
    load('LastEntrainerSingleTrial_Settings')
    anal.segments = 'off'; %load the EEG segments?
    anal.tf = 'off'; %load the time-frequency data?
    anal.singletrials = 'on'; %load the single trial data?
    anal.entrainer_freqs = [20; 15; 12; 8.5; 4]; %Single trial data is loaded at the event time, and at the chosen frequency. 
    anal.tfelecs = []; %load all the electodes, or just a few? Leave blank [] for all.
    anal.singletrialselecs = [2 4];
    Analysis(exp,anal) % The Analysis primarily loads the processed data. It will attempt to make some figures, but most analysis will need to be done in seperate scripts.
end

%% Compute the Entrainment Index

if strcmp('on',anal.singletrials)==1

electrodes = {EEG.chanlocs(:).labels}
frequencies = [20,15,12,8.5,4];
refreshes = [6, 8, 10, 14, 30];
i_chan = [2 2 2 2 4];

out = []; out_split = [];
count = []; count_split = [];
trials = []; trials_split = [];

for i_part = 1:nparts
    disp(['Subject: ' num2str(i_part)])
    clear subject_correct subject_answer subject_lags subject_position subject_present subject_rt subject_freqs

    load(['M:\Data\MultiFreq\BEH\MultiFreq_' exp.participants{i_part} '.mat'],'subject_answer','subject_lags','subject_position','subject_present','subject_rt','subject_freqs')

    subject_correct = subject_answer;
    subject_correct(find(subject_correct == 99)) = 0;
    subject_freqs = repmat(subject_freqs',1,length(subject_answer));

    tf_complex = nan(1200,length(freqs),length(times));
    EntrainIdx = nan(1,1200);

    for i_freq = 1:nsets

        for i_trial=1:length(tf_trialnum{i_freq,i_event,i_part,i_chan(i_freq)})
            tf_complex(tf_trialnum{i_freq,i_event,i_part,i_chan(i_freq)}(i_trial)-50,:,:) = tf_data{i_freq,i_event,i_part,i_chan(i_freq)}(:,:,i_trial);
        end

        clear angles pre_angles
        angles(1,:) = squeeze(angle(tf_complex(tf_trialnum{i_freq,i_event,i_part,i_chan(i_freq)}-50,find(freqs>frequencies(i_freq),1),find(times>0.5*refreshes(i_freq)*8.33,1))));
        angles(2,:) = squeeze(angle(tf_complex(tf_trialnum{i_freq,i_event,i_part,i_chan(i_freq)}-50,find(freqs>frequencies(i_freq),1),find(times>1.0*refreshes(i_freq)*8.33,1))));
        angles(3,:) = squeeze(angle(tf_complex(tf_trialnum{i_freq,i_event,i_part,i_chan(i_freq)}-50,find(freqs>frequencies(i_freq),1),find(times>1.5*refreshes(i_freq)*8.33,1))));
        angles(4,:) = squeeze(angle(tf_complex(tf_trialnum{i_freq,i_event,i_part,i_chan(i_freq)}-50,find(freqs>frequencies(i_freq),1),find(times>2.0*refreshes(i_freq)*8.33,1))));
        
%         pre_angles(1,:) = squeeze(angle(tf_complex(tf_trialnum{i_freq,i_event,i_part,i_chan(i_freq)}-50,find(freqs>frequencies(i_freq),1),find(times>0*refreshes(i_freq)*8.33,1))));
%         pre_angles(2,:) = squeeze(angle(tf_complex(tf_trialnum{i_freq,i_event,i_part,i_chan(i_freq)}-50,find(freqs>frequencies(i_freq),1),find(times>-0.5*refreshes(i_freq)*8.33,1))));
%         pre_angles(3,:) = squeeze(angle(tf_complex(tf_trialnum{i_freq,i_event,i_part,i_chan(i_freq)}-50,find(freqs>frequencies(i_freq),1),find(times>-1*refreshes(i_freq)*8.33,1))));
%         pre_angles(4,:) = squeeze(angle(tf_complex(tf_trialnum{i_freq,i_event,i_part,i_chan(i_freq)}-50,find(freqs>frequencies(i_freq),1),find(times>-1.5*refreshes(i_freq)*8.33,1))));
%         
        phase_diff1 = circ_dist(angles(1,:),angles(2,:));
        phase_diff2 = circ_dist(angles(3,:),angles(4,:));
        mean_diff = mean(abs([phase_diff1;phase_diff2]));

%         phase_diff1pre = circ_dist(pre_angles(1,:),pre_angles(2,:));
%         phase_diff2pre = circ_dist(pre_angles(3,:),pre_angles(4,:));
%         
%         mean_diffpre = mean(abs([phase_diff1pre;phase_diff2pre]));

        EntrainIdx(tf_trialnum{i_freq,i_event,i_part,i_chan(i_freq)}-50)=abs(mean_diff);
        subject_EntrainIdx=reshape(EntrainIdx,80,15)';

%         sortedvalues = sort(abs(mean_diff));
%         ngood = length(sortedvalues); 
%         disp(['#trials per condition: ' num2str(ngood)]);
%         Med_Idx = sortedvalues(ceil(ngood/2));
%         med_lims = [0 Med_Idx pi];

        sortedvalues = sort(abs(mean_diff));
        ngood = length(sortedvalues); 
        disp(['#trials per condition: ' num2str(ngood)]);
        firstthird = sortedvalues(ceil(ngood/3));
        secondthird = sortedvalues(ceil(ngood*2/3));    
        med_lims = [0 firstthird secondthird pi];
        
        for i_lag = 1:4
            count(i_lag,i_freq,i_part) = sum(subject_correct(subject_lags == i_lag & subject_present == 1 & subject_freqs == i_freq & subject_rt >= .2 & subject_rt < 2));
            out(i_lag,i_freq,i_part) = sum(subject_correct(subject_lags == i_lag & subject_present == 1 & subject_freqs == i_freq & subject_rt >= .2 & subject_rt < 2)) / ...
                                    length(subject_correct(subject_lags == i_lag & subject_present == 1 & subject_freqs == i_freq & subject_rt >= .2 & subject_rt < 2));
            trials(i_lag,i_freq,i_part) = length(subject_correct(subject_lags == i_lag & subject_present == 1 & subject_freqs == i_freq & subject_rt >= .2 & subject_rt < 2));
        end

        for i_split = 1:length(med_lims)-1
            for i_lag = 1:4
                count_split(i_split,i_lag,i_freq,i_part) = sum(subject_correct(subject_EntrainIdx > med_lims(i_split) & subject_EntrainIdx <= med_lims(i_split+1) & subject_lags == i_lag & subject_present == 1 & subject_freqs == i_freq & subject_rt >= .2 & subject_rt < 2));
                out_split(i_split,i_lag,i_freq,i_part) = sum(subject_correct(subject_EntrainIdx > med_lims(i_split) & subject_EntrainIdx <= med_lims(i_split+1) & subject_lags == i_lag & subject_present == 1 & subject_freqs == i_freq & subject_rt >= .2 & subject_rt < 2)) / ...
                                                      length(subject_correct(subject_EntrainIdx > med_lims(i_split) & subject_EntrainIdx <= med_lims(i_split+1) & subject_lags == i_lag & subject_present == 1 & subject_freqs == i_freq & subject_rt >= .2 & subject_rt < 2));
                trials_split(i_split,i_lag,i_freq,i_part) = length(subject_correct(subject_EntrainIdx > med_lims(i_split) & subject_EntrainIdx <= med_lims(i_split+1) & subject_lags == i_lag & subject_present == 1 & subject_freqs == i_freq & subject_rt >= .2 & subject_rt < 2));
            end
        end
        
        out_Entrain_Idx(i_freq,i_part) = nanmean(subject_EntrainIdx(subject_freqs == i_freq));

    end

end

%%  plot detection rate
sub_means = mean(mean(out,1),2);
out_cen = out - repmat(sub_means,[4 5]);

figure('Color', [1,1,1]);
subplot(2,3,1)
boundedline((1:4),mean(out(:,1,:),3),std(out_cen(:,1,:),[],3)/sqrt(nparts),'r',(1:4),mean(out(:,2,:),3),std(out_cen(:,2,:),[],3)/sqrt(nparts),'b',(1:4),mean(out(:,3,:),3),std(out_cen(:,3,:),[],3)/sqrt(nparts),'g',(1:4),mean(out(:,4,:),3),std(out_cen(:,4,:),[],3)/sqrt(nparts),'y',(1:4),mean(out(:,5,:),3),std(out_cen(:,5,:),[],3)/sqrt(nparts),'c'); ax = gca; set(ax,'XTick',[1 2 3 4]); set(ax, 'XTickLabel', {'Lag 1','Lag 2','Lag 3','Lag 4'});
xlabel('Relative SOA');
ylabel('Detection Proportion');
title(['Grand Average for ' num2str(nparts) ' subjects.']);
legend('20Hz','15Hz','12Hz','8.5Hz','4.0Hz');
axis tight; ylim([0.2 0.8]);

out_split(isnan(out_split)==1)=0;

% %plot perceptual entrainment index
% figure;
Y = mean(out([2 4],:,:),1) - mean(out([1 3],:,:),1);
E = mean(out_cen([2 4],:,:),1) - mean(out_cen([1 3],:,:),1);
% barweb(mean(Y,3), std(E,[],3)/sqrt(nparts) ); 
%     ylim([-.2 .3]); xlabel('In-phase vs. Out-of-phase'); ylabel('Perceptual Entrainment Index'); title('Temporo-Spatial Interaction'); legend({'20Hz','15Hz','12Hz','8.5Hz','4.0Hz'});
% 
% out_Perceptual_Idx = squeeze(mean(out([2 4],:,:),1) - mean(out([1 3],:,:),1));

%  plot detection rate
sub_means = mean(mean(mean(out_split,1),2),3);
out_split_cen = out_split - repmat(sub_means,[3 4 5]);

% figure('Color', [1,1,1]);
subplot(2,3,2)
boundedline((1:4),mean(out_split(1,:,1,:),4),std(out_split_cen(1,:,1,:),[],4)/sqrt(nparts),'r',(1:4),mean(out_split(1,:,2,:),4),std(out_split_cen(1,:,2,:),[],4)/sqrt(nparts),'b',(1:4),mean(out_split(1,:,3,:),4),std(out_split_cen(1,:,3,:),[],4)/sqrt(nparts),'g',(1:4),mean(out_split(1,:,4,:),4),std(out_split_cen(1,:,4,:),[],4)/sqrt(nparts),'y',(1:4),mean(out_split(1,:,5,:),4),std(out_split_cen(1,:,5,:),[],4)/sqrt(nparts),'c'); 
ax = gca; set(ax,'XTick',[1 2 3 4]); set(ax, 'XTickLabel', {'Lag 1','Lag 2','Lag 3','Lag 4'});
xlabel('Relative SOA'); ylabel('Detection Proportion');
title({['Grand Average for ' num2str(nparts) ' subjects.'],'Poorly Entrained Trials'});
legend('20Hz','15Hz','12Hz','8.5Hz','4.0Hz');
axis tight; ylim([0.2 0.8]);

% figure('Color', [1,1,1]);
subplot(2,3,3)
boundedline((1:4),mean(out_split(3,:,1,:),4),std(out_split_cen(3,:,1,:),[],4)/sqrt(nparts),'r',(1:4),mean(out_split(3,:,2,:),4),std(out_split_cen(3,:,2,:),[],4)/sqrt(nparts),'b',(1:4),mean(out_split(3,:,3,:),4),std(out_split_cen(3,:,3,:),[],4)/sqrt(nparts),'g',(1:4),mean(out_split(3,:,4,:),4),std(out_split_cen(3,:,4,:),[],4)/sqrt(nparts),'y',(1:4),mean(out_split(3,:,5,:),4),std(out_split_cen(3,:,5,:),[],4)/sqrt(nparts),'c'); 
ax = gca; set(ax,'XTick',[1 2 3 4]); set(ax, 'XTickLabel', {'Lag 1','Lag 2','Lag 3','Lag 4'});
xlabel('Relative SOA'); ylabel('Detection Proportion');
title({['Grand Average for ' num2str(nparts) ' subjects.'],'Well Entrained Trials'});
legend('20Hz','15Hz','12Hz','8.5Hz','4.0Hz');
axis tight; ylim([0.2 0.8]);

% figure;
subplot(2,3,4:6)
Y_S = squeeze(mean(out_split(:,[2 4],:,:),2) - mean(out_split(:,[1 3],:,:),2));
E_S = squeeze(mean(out_split_cen(:,[2 4],:,:),2) - mean(out_split_cen(:,[1 3],:,:),2));
barweb([mean(Y,3); mean(Y_S,3)]', [std(E,[],3)/sqrt(nparts); std(E_S,[],3)/sqrt(nparts)]',[],{'20Hz','15Hz','12Hz','8.5Hz','4.0Hz'} ); 
    ylim([-.2 .3]); xlabel('In-phase vs. Out-of-phase'); ylabel('Perceptual Entrainment Index'); title('Perceptual-Entrainment Frequency Interaction'); legend({'Grand Mean','Poorly Entrained','Middle Third','Well Entrained'});

end