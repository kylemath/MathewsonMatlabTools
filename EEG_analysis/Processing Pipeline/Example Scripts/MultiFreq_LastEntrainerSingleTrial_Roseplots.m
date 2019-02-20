%% Roseplots of Last Entrainer Data

if exist('exp')~=1;
    load('LastEntrainerSingleTrial_Settings')
    anal.segments = 'off'; %load the EEG segments?
    anal.tf = 'off'; %load the time-frequency data?
    anal.singletrials = 'on'; %load the single trial data?
    anal.entrainer_freqs = [20; 15; 12; 8.5; 4]; %Single trial data is loaded at the event time, and at the chosen frequency. 
    anal.tfelecs = []; %load all the electodes, or just a few? Leave blank [] for all.
    anal.singletrialselecs = [2 4];
    exp.events = repmat({[48]},5,1);
    Analysis(exp,anal) % The Analysis primarily loads the processed data. It will attempt to make some figures, but most analysis will need to be done in seperate scripts.
end

electrodes = {EEG.chanlocs(:).labels}
frequencies = [20,15,12,8.5,4];
refreshes = [6, 8, 10, 14, 30];
i_chan = 4;

for i_set = 1:nsets
    figure;
    suptitle([exp.setname{i_set} ' at electrode ' electrodes{i_chan}]);
    % xlim([-.1 .1]);
    % ylim([-.1 .1]);
    entrained_phase = vertcat(all_event_phase{i_set,1,:,i_chan});
    circ_plot(entrained_phase,'hist',[],20,true,true,'linewidth',2,'color','r');
    title('Last Entrainer');
end

for i_chan = [2 4]
for i_set = 1:nsets
    for i_part = 1:nparts
        vector_length(i_chan,i_set,i_part) = circ_r(all_event_phase{i_set,1,i_part,i_chan})
    end
end
end

for i_chan = [2 4]
for i_set = 1:nsets
    for i_part = 1:nparts
        mean_phase(i_chan,i_set,i_part) = circ_mean(all_event_phase{i_set,1,i_part,i_chan})
    end
end
end