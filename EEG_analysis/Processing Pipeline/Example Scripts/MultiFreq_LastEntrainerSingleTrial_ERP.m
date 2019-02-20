%% Plot ERPs of your epochs
% An ERP is a plot of the raw, usually filtered, data, at one or multiple electrodes. It doesn't use time-frequency data.
% We make ERPs if we have segmented datasets that we want to compare across conditions. 

if exist('exp')~=1;
    load('LastEntrainerSingleTrial_Settings')
    anal.segments = 'on'; %load the EEG segments?
    anal.tf = 'off'; %load the time-frequency data?
    anal.singletrials = 'off'; %load the single trial data?
    anal.entrainer_freqs = [20; 15; 12; 8.5; 4]; %Single trial data is loaded at the event time, and at the chosen frequency. 
    anal.tfelecs = []; %load all the electodes, or just a few? Leave blank [] for all.
    anal.singletrialselecs = [2 4];
    Analysis(exp,anal) % The Analysis primarily loads the processed data. It will attempt to make some figures, but most analysis will need to be done in seperate scripts.
end

% In this case, you are using all your electrodes, not a subset.
electrodes = {EEG.chanlocs(:).labels};
frequencies = [20,15,12,8.5,4];
refreshes = [6, 8, 10, 14, 30];
colors = linspecer(nsets);
% Type "electrodes" into the command line. This will show you which number to use for i_chan
i_chan = [2];

% This code will take a grand average of the subjects, making one figure per set.
% This is the normal way to present ERP results.
data_out = [];
for i_set = 1:nsets 
    i_set
    
    % The code below uses a nested loop to determine which segmented dataset corresponds to the right argument in data_out
    % e.g. if you have 5 sets, 20 participants, and 4 events, for i_set ==
    % 2 and i_part == 1 and i_event == 1, the code uses the data from set (2-1)*4*20 + (1-1)*20 + 1 == set 81 
    for eegset = 1:nevents
        for i_part = 1:nparts
            data_out(:,:,eegset,i_part,i_set) = mean(ALLEEG((i_set-1)*nevents*nparts + (i_part-1)*(nevents) + eegset).data,3);
        end
    end
end

for i_set = 1:nsets    
    % this is the averaged ERP data. We take the mean across the selected channels (dim1) and the participants (dim4).
    tlims = [-2000 800];
    time_lims = [find(EEG.times > tlims(1),1):find(EEG.times > tlims(2),1)];
    erpdata = squeeze(mean(mean(data_out(i_chan,time_lims,:,:,i_set),1),4));
    erpstd = squeeze(std(mean(data_out(i_chan,time_lims,:,:,i_set),1),[],4))';
    erpSEM = erpstd/sqrt(nparts);

    % Here you make the figure. You can go back and choose different limits, colors, titles, etc. later
    figure; boundedline(EEG.times(time_lims),erpdata,erpSEM,'r');
    xlim([-2000 800])
    ylim([-3 7])
    h1 = title([exp.setname{i_set} ' at electrode ' electrodes{i_chan}]); set(h1,'fontsize',20)
    
    % Oftentimes you want to draw lines on the ERP to mark different events. 
    line([0 0],[-10 10],'color','k');
    line([-2000 800],[0 0],'color','k');
    entr1 = line([0,0], [-40,40], 'color', 'k'); Entr1 = 'First Entrainer';
    entr2 = line([-1*refreshes(i_set)*8.33,-1*refreshes(i_set)*8.33], [-40,40], 'color', 'k');
    entr3 = line([-2*refreshes(i_set)*8.33,-2*refreshes(i_set)*8.33], [-40,40], 'color', 'k');
    entr4 = line([-3*refreshes(i_set)*8.33,-3*refreshes(i_set)*8.33], [-40,40], 'color', 'k');
    entr5 = line([-4*refreshes(i_set)*8.33,-4*refreshes(i_set)*8.33], [-40,40], 'color', 'k');
    entr6 = line([-5*refreshes(i_set)*8.33,-5*refreshes(i_set)*8.33], [-40,40], 'color', 'k');
    entr7 = line([-6*refreshes(i_set)*8.33,-6*refreshes(i_set)*8.33], [-40,40], 'color', 'k');
    entr8 = line([-7*refreshes(i_set)*8.33,-7*refreshes(i_set)*8.33], [-40,40], 'color', 'k'); Entr8 = 'Last Entrainer';
    targ8 = line([0.5*refreshes(i_set)*8.33,0.5*refreshes(i_set)*8.33], [-40,40], 'color', 'k');
    targ8 = line([1*refreshes(i_set)*8.33,1*refreshes(i_set)*8.33], [-40,40], 'color', 'k');
    targ8 = line([1.5*refreshes(i_set)*8.33,1.5*refreshes(i_set)*8.33], [-40,40], 'color', 'k');
    targ8 = line([2*refreshes(i_set)*8.33,2*refreshes(i_set)*8.33], [-40,40], 'color', 'k');
end

for i_set = 1:nsets
    tlims = [-3*refreshes(i_set)*8.33 3*refreshes(i_set)*8.33];
    time_lims = [find(EEG.times > tlims(1),1):find(EEG.times > tlims(2),1)];
    % this is the averaged ERP data. We take the mean across the selected channels (dim1) and the participants (dim4).
    erpdata = squeeze(mean(mean(mean(data_out(i_chan,time_lims,:,:,i_set),1),3),4))';
    erpstd = squeeze(std(mean(mean(data_out(i_chan,time_lims,:,:,i_set),1),3),[],4))';
    erpSEM = erpstd/sqrt(nparts);
    % erpdata_cen(i_set,:) = erpdata - repmat(erpdata(2601),[length(erpdata) 1]);
    
    figure; boundedline(EEG.times(time_lims),erpdata,erpSEM,'r');
    xlim([-3*refreshes(i_set)*8.33 3*refreshes(i_set)*8.33])
    ylim([-3 3])
    h1 = title([exp.setname{i_set} ' at electrode ' electrodes{i_chan}]); set(h1,'fontsize',20)

    line([0 0],[-10 10],'color','k');
    line([-3*refreshes(i_set)*8.33 3*refreshes(i_set)*8.33],[0 0],'color','k');
    entr1 = line([0,0], [-40,40], 'color', 'k'); Entr1 = 'First Entrainer';
    entr2 = line([-1*refreshes(i_set)*8.33,-1*refreshes(i_set)*8.33], [-40,40], 'color', 'k');
    entr3 = line([-2*refreshes(i_set)*8.33,-2*refreshes(i_set)*8.33], [-40,40], 'color', 'k');
    targ1 = line([0.5*refreshes(i_set)*8.33,0.5*refreshes(i_set)*8.33], [-40,40], 'color', 'k');
    targ2 = line([1*refreshes(i_set)*8.33,1*refreshes(i_set)*8.33], [-40,40], 'color', 'k');
    targ3 = line([1.5*refreshes(i_set)*8.33,1.5*refreshes(i_set)*8.33], [-40,40], 'color', 'k');
    targ4 = line([2*refreshes(i_set)*8.33,2*refreshes(i_set)*8.33], [-40,40], 'color', 'k');
    hold on
end
% 
% electrodes = {EEG.chanlocs.labels};
% frequencies = [20,15,12,8.5,4];
% refreshes = [6, 8, 10, 14, 30];
% for i_set = 1:nsets
%     data_out = [];
%     for eegset = 1:nevents
%         for i_part = 1:nparts
%             data_out(:,:,eegset,i_part) = mean(ALLEEG((i_set-1)*nevents*nparts + (eegset-1)*(nparts) + i_part).data,3);
%         end
%     end
%     
%     erpdata = squeeze(mean(mean(data_out(i_chan,:,:,:),1),4));
%     % erpdata(:,1) = squeeze(mean(mean(mean(data_out(i_chan,:,[1 2],:),1),3),4));
%     % erpdata(:,2) = squeeze(mean(mean(mean(data_out(i_chan,:,[3 4],:),1),3),4));
%     erpdata_cen = erpdata - repmat(erpdata(1401,:),length(erpdata),1);
%     
%     figure; plot(EEG.times,squeeze(erpdata_cen));
%     legend('1','2','3','4');
%     line([0 0],[-10 10],'color','k');
%     line([-2*refreshes(i_set)*8.33 10*refreshes(i_set)*8.33],[0 0],'color','k');
%     xlim([-2*refreshes(i_set)*8.33 10*refreshes(i_set)*8.33])
%     ylim([-3 6])
%     entr1 = line([0,0], [-40,40], 'color', 'k'); Entr1 = 'First Entrainer';
%     entr2 = line([1*refreshes(i_set)*8.33,1*refreshes(i_set)*8.33], [-40,40], 'color', 'k');
%     entr3 = line([2*refreshes(i_set)*8.33,2*refreshes(i_set)*8.33], [-40,40], 'color', 'k');
%     entr4 = line([3*refreshes(i_set)*8.33,3*refreshes(i_set)*8.33], [-40,40], 'color', 'k');
%     entr5 = line([4*refreshes(i_set)*8.33,4*refreshes(i_set)*8.33], [-40,40], 'color', 'k');
%     entr6 = line([5*refreshes(i_set)*8.33,5*refreshes(i_set)*8.33], [-40,40], 'color', 'k');
%     entr7 = line([6*refreshes(i_set)*8.33,6*refreshes(i_set)*8.33], [-40,40], 'color', 'k');
%     entr8 = line([7*refreshes(i_set)*8.33,7*refreshes(i_set)*8.33], [-40,40], 'color', 'k'); Entr8 = 'Last Entrainer';
%     targ8 = line([7.5*refreshes(i_set)*8.33,7.5*refreshes(i_set)*8.33], [-40,40], 'color', 'k');
%     targ8 = line([8*refreshes(i_set)*8.33,8*refreshes(i_set)*8.33], [-40,40], 'color', 'k');
%     targ8 = line([8.5*refreshes(i_set)*8.33,8.5*refreshes(i_set)*8.33], [-40,40], 'color', 'k');
%     targ8 = line([9*refreshes(i_set)*8.33,9*refreshes(i_set)*8.33], [-40,40], 'color', 'k');
%     title([exp.setname{i_set} ' at electrode ' electrodes{i_chan}])
% end
