%% Load the data, settings,

% If you run this script on an empty workspace, it will load the data needed for these plots.
if exist('exp')~=1; %check for a settings file
    load('FirstEntrainer_Settings')
    anal.segments = 'off'; %load the EEG segments?
    anal.tf = 'on'; %load the time-frequency data?
    anal.singletrials = 'off'; %load the single trial data?
    anal.entrainer_freqs = []; %Single trial data is loaded at the event time, and at the chosen frequency. 
    anal.tfelecs = []; %load all the electodes, or just a few? Leave blank [] for all.
    anal.singletrialselecs = [2 4];
    Analysis(exp,anal) % The Analysis primarily loads the processed data. It will attempt to make some figures, but most analysis will need to be done in seperate scripts.
end

%The variable electrodes will contain every loaded electrode. Make sure you
%know which electrode corresponds to the value you give in i_chan
if isempty(anal.tfelecs)==1;
    electrodes = {EEG.chanlocs(:).labels}
else
    electrodes = {EEG.chanlocs(anal.tfelecs).labels}
end
frequencies = [20,15,12,8.5,4];
refreshes = [6, 8, 10, 14, 30];

% Type "electrodes" into the command line. This will show you which number to use for i_chan
i_chan = [4];

%% Spectograms, topoplots, bargraphs

%ITC SPECTROGRAM
for i_set = 1:nsets
    figure;
    
    %The variable itc will be a 6D variable: (participants x sets x events x electrodes x frequencies x timepoints).
    %You need a 2D variable, frequency x time.
    %By default it will take the mean across participants, events, and channels (given in i_chan) and show the data for each set.
    set_itc = squeeze(mean(mean(abs(itc(:,i_set,:,i_chan,:,:)),3),4));
    
    %This variable sets the scale of the color axis, which corresponds to the itc or power values.
     CLim = ([0,0.35]); colormap(parula)
    
    %This code creates the spectogram. Arguents are x-axis values (time), y-axis valus (frequency) and color axis values (itc or ersp).
    imagesc(times,freqs,squeeze(mean(set_itc,1)),CLim); axis([-800 2000 1 40]); set(gca,'ydir','normal'); %Remove the CLim argument to find the right scale
    
    %Make a Title
    h1 = title([exp.setname{i_set} ' at electrode ' electrodes{i_chan}]); set(gca,'fontsize',20); set(h1,'fontsize',20)
    %You can also put lines on the figure to show the trial start, important events, etc.
    line([-800 2000], [frequencies(i_set) frequencies(i_set)], 'color', 'k');
    entr1 = line([0,0], [0,40], 'color', 'k'); Entr1 = 'First Entrainer';
    entr8 = line([7*refreshes(i_set)*8.33,7*refreshes(i_set)*8.33], [0,40], 'color', 'k'); Entr8 = 'Last Entrainer';
    tlims = [0 7*refreshes(i_set)*8.33]; time_lims = find(times>=tlims(1),1):find(times>=tlims(2),1)-1;
    flims = [frequencies(i_set)-1 frequencies(i_set)+1]; freq_lims = find(freqs>=flims(1),1):find(freqs>=flims(2),1)-1;
    line([tlims(1) tlims(2)],[flims(1) flims(1)], 'color', 'k');
    line([tlims(1) tlims(2)], [flims(2) flims(2)],'color', 'k');
    
    %This is also a good time to save a variable with the power in the defined range for each subject, which can make a bargraph
    sub_itc(i_set,:) = mean(mean(set_itc(:,freq_lims,time_lims),2),3);
    blims = [exp.erspbaseline - exp.winsize/2]; base_time_lims = find(times>=blims(1),1):find(times>=blims(2),1)-1;
    sub_baseline_itc(i_set,:) = mean(mean(set_itc(:,freq_lims,base_time_lims),2),3);
    
    figure; 
    Y = double([mean(sub_baseline_itc(i_set,:),2) mean(sub_itc(i_set,:),2)]);
    E = double([std(sub_baseline_itc(i_set,:),[],2)/sqrt(nparts) std(sub_itc(i_set,:),[],2)/sqrt(nparts)]);
    handles = barweb(Y,E,[],[],[],{[num2str(frequencies(i_set)), ' Hz'],'Baseline'},[],'parula',[]);    
    ylim([0 0.5]); set(gca,'fontsize',8,'color','none');
end
figure;
CLim = ([0,0.40]); colormap(parula);
imagesc(times,freqs,squeeze(mean(set_itc,1)),CLim); axis([-800 2000 1 40]); set(gca,'ydir','normal'); set(gca,'fontsize',20); %Remove the CLim argument to find the right scale
colorbar;

%ITC TOPOPLOT
for i_set = 1:nsets
    figure;
    
    %A Topoplot needs to collapse across frequency and time so it can show the data across electrodes
    flims = [frequencies(i_set)-2 frequencies(i_set)+2]; % set the range of frequency to consider
    tlims = [0 7*refreshes(i_set)*8.33]; % set the range of time to consider
    
    freq_lims = find(freqs>= flims(1),1):find(freqs>=flims(2),1)-1; %this code finds the frequencies you want from the freqs variable
    time_lims = find(times>=tlims(1),1):find(times>=tlims(2),1)-1;  %this code finds the times you want from the timess variable
    
    %Here you need a 1D variable, electrodes.
    %By default it will take the mean across participants, events, times and frequencies, and show the data for each set
    set_elec_itc = squeeze(mean(mean(mean(mean(abs(itc(:,i_set,:,exp.brainelecs,freq_lims,time_lims)),1),3),5),6))';
    
    %This variable sets the scale of the color axis, which corresponds to the itc or power values.
    CLim = ([0.1,0.25]);
    
    %This code creates the topoplots. You need to replace all the non-brain electrodes with NaN.
    topoplot([NaN set_elec_itc NaN NaN],exp.electrode_locs,'maplimits',CLim,'plotrad',0.6,'whitebk','on','colormap',parula); colorbar;
    
    %Make a Title
    h1 = title([exp.setname{i_set}]); set(gca,'fontsize',20); set(h1,'fontsize',20)
end

% ERSP SPECTROGRAM
for i_set = 1:nsets
    figure;
    
    %The variable ersp will be a 6D variable: (participants x sets x events x electrodes x frequencies x timepoints).
    %You need a 2D variable, frequency x time.
    %By default it will take the mean across participants, events, and channels (given in i_chan) and show the data for each set.
    set_ersp = squeeze(mean(mean(ersp(:,i_set,:,i_chan,:,:),3),4));
    
    %This variable sets the scale of the color axis, which corresponds to the itc or power values.
    CLim = ([-2 1]); colormap(parula)
    
    %This code creates the spectogram. Arguents are x-axis values (time), y-axis valus (frequency) and color axis values (itc or ersp).
    imagesc(times,freqs,squeeze(mean(set_ersp,1)),CLim); axis([-800 2000 0.75 40]); set(gca,'ydir','normal'); colorbar; %Remove the CLim argument to find the right scale
    
    %Make a Title
    title([exp.setname{i_set} ' at electrode ' electrodes{i_chan}])
    
    %You can also put lines on the figure to show the trial start, important events, etc.
    line([-800 2200], [12 12], 'color', 'k');
    entr1 = line([0,0], [0,40], 'color', 'k'); Entr1 = 'First Entrainer';
    entr8 = line([7*refreshes(i_set)*8.33,7*refreshes(i_set)*8.33], [0,40], 'color', 'k'); Entr8 = 'Last Entrainer';
    tlims = [0 7*refreshes(i_set)*8.33]; time_lims = find(times>=tlims(1),1):find(times>=tlims(2),1)-1;
    flims = [frequencies(i_set)-1 frequencies(i_set)+1]; freq_lims = find(freqs>=flims(1),1):find(freqs>=flims(2),1)-1;
    line([tlims(1) tlims(2)],[flims(1) flims(1)], 'color', 'k');
    line([tlims(1) tlims(2)], [flims(2) flims(2)],'color', 'k');
    
end

% ERSP TOPOPLOT
for i_set = 1:nsets
    figure;
    
    %A Topoplot needs to collapse across frequency and time so it can show the data across electrodes
    flims = [frequencies(i_set)-2 frequencies(i_set)+2]; % set the range of frequency to consider
    tlims = [0 7*refreshes(i_set)*8.33]; % set the range of time to consider
    
    freq_lims = find(freqs>= flims(1),1):find(freqs>=flims(2),1)-1; %this code finds the frequencies you want from the freqs variable
    time_lims = find(times>=tlims(1),1):find(times>=tlims(2),1)-1;  %this code finds the times you want from the timess variable
    
    %Here you need a 1D variable, electrodes.
    %By default it will take the mean across participants, events, times and frequencies, and show the data for each set
    set_elec_ersp = squeeze(mean(mean(mean(mean(ersp(:,i_set,:,exp.brainelecs,freq_lims,time_lims),1),3),5),6))'
    
    %This variable sets the scale of the color axis, which corresponds to the itc or power values.
    CLim = ([-2 0]);
    
    %This code creates the topoplots. You need to replace all the non-brain electrodes with NaN.
    topoplot([NaN set_elec_ersp NaN NaN],exp.electrode_locs,'maplimits',CLim,'plotrad',0.6,'whitebk','on','colormap',parula); colorbar;
    
    %Make a Title
    title([exp.setname{i_set} ' at electrode ' electrodes{i_chan}])
end

%% Advanced analyses
% The basic spectograms and topoplots will often need to be tweaked to serve the specific purpose of your experiment.
% Here, I show examples where the data being plotted is normalized to the average of the other sets.

%ITC NORMALIZED SPECTROGRAM
for i_set = 1:nsets
    figure;
    
    %The variable itc will be a 6D variable: (participants x sets x events x electrodes x frequencies x timepoints).
    %You need a 2D variable, frequency x time.
    %By default it will take the mean across participants, events, and channels (given in i_chan) and show the data for each set.
    set_itc = squeeze(mean(mean(abs(itc(:,i_set,:,i_chan,:,:)),3),4));
    
    %Here we are also going to take the difference from the average of the other sets.
    diff = [1:nsets]; diff(i_set) = [];
    diff_itc = squeeze(mean(mean(mean(abs(itc(:,diff,:,i_chan,:,:)),2),3),4));
    
    %This variable sets the scale of the color axis, which corresponds to the itc or power values.
    CLim = ([-0.2 0.2]); colormap(b2r(CLim(1),CLim(2)))
    
    %This code creates the spectogram. Arguents are x-axis values (time), y-axis valus (frequency) and color axis values (itc or ersp).
    imagesc(times,freqs,squeeze(mean(set_itc - diff_itc,1)),CLim); axis([-800 2000 0.75 40]); set(gca,'ydir','normal');  %Remove the CLim argument to find the right scale
    
    %Make a Title
    h1 = title([exp.setname{i_set} ' at electrode ' electrodes{i_chan}]); set(gca,'fontsize',20); set(h1,'fontsize',20)

    %You can also put lines on the figure to show the trial start, important events, etc.
    line([-800 2000], [frequencies(i_set) frequencies(i_set)], 'color', 'k');
    entr1 = line([0,0], [0,40], 'color', 'k'); Entr1 = 'First Entrainer';
    entr8 = line([7*refreshes(i_set)*8.33,7*refreshes(i_set)*8.33], [0,40], 'color', 'k'); Entr8 = 'Last Entrainer';
    tlims = [0 7*refreshes(i_set)*8.33]; time_lims = find(times>=tlims(1),1):find(times>=tlims(2),1)-1;
    flims = [frequencies(i_set)-1 frequencies(i_set)+1]; freq_lims = find(freqs>=flims(1),1):find(freqs>=flims(2),1)-1;
    line([tlims(1) tlims(2)],[flims(1) flims(1)], 'color', 'k');
    line([tlims(1) tlims(2)], [flims(2) flims(2)],'color', 'k');
    
    %This is also a good time to save a variable with the power in the defined range for each subject, which can make a bargraph
    sub_itc(i_set,:) = mean(mean(set_itc(:,freq_lims,time_lims),2),3);
    sub_diff_itc(i_set,:) = mean(mean(diff_itc(:,freq_lims,time_lims),2),3);
    
    figure; barweb([mean(sub_itc(i_set,:),2) mean(sub_diff_itc(i_set,:),2)],[std(sub_itc(i_set,:),[],2)/sqrt(nparts) std(sub_diff_itc(i_set,:),[],2)/sqrt(nparts)])
    h1 = legend(exp.setname{i_set},'Baseline'); legend BOXOFF; ylim([0 0.5]); set(gca,'fontsize',20); set(h1,'fontsize',20)
end
figure;
CLim = ([-0.2 0.2]); colormap(b2r(CLim(1),CLim(2)))
colorbar;

%ITC NORMALIZED TOPOPLOT
for i_set = 1:nsets
    figure;
    
    %A Topoplot needs to collapse across frequency and time so it can show the data across electrodes
    flims = [frequencies(i_set)-2 frequencies(i_set)+2]; % set the range of frequency to consider
    tlims = [0 7*refreshes(i_set)*8.33]; % set the range of time to consider
    
    freq_lims = find(freqs>= flims(1),1):find(freqs>=flims(2),1)-1; %this code finds the frequencies you want from the freqs variable
    time_lims = find(times>=tlims(1),1):find(times>=tlims(2),1)-1;  %this code finds the times you want from the timess variable
    
    %Here you need a 1D variable, electrodes.
    %By default it will take the mean across participants, events, times and frequencies, and show the data for each set
    set_elec_itc = squeeze( mean(mean( mean(abs(itc(:,i_set,:,:,freq_lims,time_lims)),1),5),6) )';
    
    %Here we are also going to take the difference from the average of the other sets.
    diff = [1:nsets]; diff(i_set) = [];
    diff_set_elec_itc = squeeze( mean(mean(mean(mean(mean(abs(itc(:,diff,:,:,freq_lims,time_lims)),1),2),3),5),6) )';
    
    %This variable sets the scale of the color axis, which corresponds to the itc or power values.
    CLim = ([-0.1 0.1]); colorbar; set(gca,'fontsize',20)
    
    %This code creates the topoplots. You need to replace all the non-brain electrodes with NaN.
    topoplot([NaN squeeze(set_elec_itc(2:32)-diff_set_elec_itc(2:32)) NaN NaN],exp.electrode_locs,'maplimits',CLim,'plotrad',0.6,'whitebk','on','colormap',b2r(CLim(1),CLim(2))); 
    
    %Make a Title
    h1 = title([exp.setname{i_set} ' - Baseline']); set(h1,'fontsize',30)
end

%ERSP NORMALIZED SPECTROGRAM
for i_set = 1:nsets
     figure;
    
    %The variable ersp will be a 6D variable: (participants x sets x events x electrodes x frequencies x timepoints).
    %You need a 2D variable, frequency x time.
    %By default it will take the mean across participants, events, and channels (given in i_chan) and show the data for each set.
    set_ersp = squeeze(mean(mean(ersp(:,i_set,:,i_chan,:,:),3),4));
    
    %Here we are also going to take the difference from the average of the other sets.
    diffs = [1:nsets]; diffs(i_set) = [];
    diff_ersp =  squeeze(mean(mean(mean(ersp(:,diffs,:,i_chan,:,:),2),3),4));
    
    %This variable sets the scale of the color axis, which corresponds to the itc or power values.
    CLim = ([-1 1]); colormap(b2r(CLim(1),CLim(2)))
    
    %This code creates the spectogram. Arguents are x-axis values (time), y-axis valus (frequency) and color axis values (itc or ersp).
     imagesc(times,freqs,squeeze(mean(set_ersp-diff_ersp,1)),CLim); axis([-800 2000 0.75 40]); set(gca,'ydir','normal'); %Remove the CLim argument to find the right scale
    
    %Make a Title
    h1 = title([exp.setname{i_set} ' at electrode ' electrodes{i_chan}]); set(gca,'fontsize',20); set(h1,'fontsize',20)
    
    %You can also put lines on the figure to show the trial start, important events, etc.
    line([-800 2000], [frequencies(i_set) frequencies(i_set)], 'color', 'k');
    entr1 = line([0,0], [0,40], 'color', 'k'); Entr1 = 'First Entrainer';
    entr8 = line([7*refreshes(i_set)*8.33,7*refreshes(i_set)*8.33], [0,40], 'color', 'k'); Entr8 = 'Last Entrainer';
    tlims = [0 7*refreshes(i_set)*8.33]; time_lims = find(times>=tlims(1),1):find(times>=tlims(2),1)-1;
    flims = [frequencies(i_set)-1 frequencies(i_set)+1]; freq_lims = find(freqs>=flims(1),1):find(freqs>=flims(2),1)-1;
    line([tlims(1) tlims(2)],[flims(1) flims(1)], 'color', 'k');
    line([tlims(1) tlims(2)], [flims(2) flims(2)],'color', 'k');
    
    %This is also a good time to save a variable with the power in the defined range for each subject, which can make a bargraph
    sub_ersp(i_set,:) = mean(mean(set_ersp(:,freq_lims,time_lims),2),3)';
    sub_diff_ersp(i_set,:) = mean(mean(diff_ersp(:,freq_lims,time_lims),2),3)';
    
%     figure; barweb([mean(sub_ersp(i_set,:),2) mean(sub_diff_ersp(i_set,:),2)],[std(sub_ersp(i_set,:),[],2)/sqrt(nparts) std(sub_diff_ersp(i_set,:),[],2)/sqrt(nparts)])
%     ylim([-4 2])
%     h1 = legend(exp.setname{i_set},'Baseline'); legend BOXOFF; ylim([-2 1]); set(gca,'fontsize',20); set(h1,'fontsize',20)
end
figure;
CLim = ([-1 1]); colormap(b2r(CLim(1),CLim(2)))
colorbar;

%ERSP NORMALIZED TOPOPPLOT
for i_set = 1:nsets
    figure;
    
    %A Topoplot needs to collapse across frequency and time so it can show the data across electrodes
    flims = [frequencies(i_set)-1 frequencies(i_set)+1]; % set the range of frequency to consider
    tlims = [0 7*refreshes(i_set)*8.33]; % set the range of time to consider
    
    freq_lims = find(freqs>= flims(1),1):find(freqs>=flims(2),1)-1; %this code finds the frequencies you want from the freqs variable
    time_lims = find(times>=tlims(1),1):find(times>=tlims(2),1)-1;  %this code finds the times you want from the timess variable
    
    %Here you need a 1D variable, electrodes.
    %By default it will take the mean across participants, events, times and frequencies, and show the data for each set
    set_elec_ersp = squeeze(mean(mean(mean(mean(ersp(:,i_set,:,exp.brainelecs,freq_lims,time_lims),1),3),5),6))'
    
    %Here we are also going to take the difference from the average of the other sets.
    diffs = [1:nsets]; diffs(i_set) = [];
    diff_set_elec_ersp = squeeze(mean(mean(mean(mean(mean(ersp(:,diffs,:,exp.brainelecs,freq_lims,time_lims),1),2),3),5),6))';
    
    %This variable sets the scale of the color axis, which corresponds to the itc or power values.
    CLim = ([-.5 .5]); colorbar; set(gca,'fontsize',20)
    
    %This code creates the topoplots. You need to replace all the non-brain electrodes with NaN.
    topoplot([NaN squeeze(set_elec_ersp - diff_set_elec_ersp) NaN NaN],exp.electrode_locs,'maplimits',CLim,'plotrad',0.6,'whitebk','on','colormap',colormap(b2r(CLim(1),CLim(2)))); colorbar;
    
    %Make a Title
    h1 = title([exp.setname{i_set} ' - Baseline']); set(h1,'fontsize',30)
end

