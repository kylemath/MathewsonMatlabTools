clear all
close all

srate = 1000;
points = 1000;
period = (1/srate)*1000;
t = period:period:points;
trials = 200;

%% do it once
figure('Color',[1 1 1]);
%create random noise (gausian for now) and plot two trial
noise = randn(trials,points)*50; %50 uV
subplot(3,1,1); 
    plot(t,noise(1:2,:));
    title('Noise Trials <50uV');
    xlabel('Time (ms)');
    ylabel('Voltage uV');

%create a fake ERP signal from 300-400 ms, and plot
signal = zeros(1,points);
signal(301:400) = signal(301:400)+hanning(100)';
signal = signal*20; %20 uV
subplot(3,1,2); 
    plot(t,signal);
    title('ERP Signal 20 uV');
    xlabel('Time (ms)');
    ylabel('Voltage uV');
    
%add signal to noise, and plot two trials
erp = noise + repmat(signal,[trials 1]);
subplot(3,1,3); 
    plot(t,erp(1:2,:));
    title('Signal + Noise ERP simulation trials');
    xlabel('Time (ms)');
    ylabel('Voltage uV');
    
%average more and more trials together
trial_counts = [5 10 15 20 30 50 75 100 150 200];
erp_win = [326:375]; %to test erp in
figure('Color',[1 1 1]);
for i_trials = 1:10
    subplot(10,1,i_trials); 
        plot(t,mean(erp(1:trial_counts(i_trials),:),1));
        title([num2str(trial_counts(i_trials)) ' Trials']);
        %compute window max and mean
        max_erp_o(i_trials) = max(mean(erp(1:trial_counts(i_trials),erp_win)));
        mean_erp_o(i_trials) = mean(mean(erp(1:trial_counts(i_trials),erp_win)));
end

figure('Color',[1 1 1]);
 subplot(1,2,1); 
            plot(trial_counts,max_erp_o);  
            xlabel('Number of trials');
            ylabel('Window Max ERP voltage');
            title('ERP window PEAK amplitude ');
        subplot(1,2,2); 
            plot(trial_counts,mean_erp_o); 
            xlabel('Number of trials');
            ylabel('Window Mean ERP voltage');
            title('ERP window MEAN amplitude ');

%% do it many times

for i_iter = 1:1000
    %create random noise (gausian for now) and plot two trial
    noise = randn(trials,points)*50; %50 uV

    %create a fake ERP signal from 300-400 ms, and plot
    signal = zeros(1,points);
    signal(301:400) = signal(301:400)+hanning(100)';
    signal = signal*20; %20 uV

    %add signal to noise, and plot two trials
    erp = noise + repmat(signal,[trials 1]);

    %average more and more trials together
    trial_counts = [5 10 15 20 30 50 75 100 150 200];
    erp_win = [326:375]; %to test erp in
    for i_trials = 1:10
            %compute window max and mean
            max_erp(i_trials,i_iter) = max(mean(erp(1:trial_counts(i_trials),erp_win)));
            mean_erp(i_trials,i_iter) = mean(mean(erp(1:trial_counts(i_trials),erp_win)));
    end

end

figure('Color',[1 1 1]);
        subplot(1,2,1); 
            errorbar(trial_counts,mean(max_erp,2),std(max_erp,[],2)); 
            title('ERP window PEAK amplitude');
            xlabel('Number of trials');
            ylabel('Window Max ERP voltage');
        subplot(1,2,2); 
            errorbar(trial_counts,mean(mean_erp,2),std(mean_erp,[],2));
            title('ERP window MEAN amplitude');
            xlabel('Number of trials');
            ylabel('Window MEAN ERP voltage');
            
            
%% do it many times with latency jitter

for i_iter = 1:1000
    %create random noise (gausian for now) and plot two trial
    noise = randn(trials,points)*50; %50 uV

    %create a fake ERP signal from 300-400 ms, and plot

    for i_trial = 1:trials
        signalt = zeros(1,points);
        jitter = randi(100);
        signalt(301+jitter:400+jitter) = signalt(301+jitter:400+jitter)+hanning(100)';
        signalt = signalt*20; %20 uV
        signal(i_trial,:) = signalt;
    end
    
    %add signal to noise, and plot two trials
    erp = noise + signal;

    %average more and more trials together
    trial_counts = [5 10 15 20 30 50 75 100 150 200];
    erp_win = [326:475]; %to test erp in
    for i_trials = 1:10
            %compute window max and mean
            max_erp(i_trials,i_iter) = max(mean(erp(1:trial_counts(i_trials),erp_win)));
            mean_erp(i_trials,i_iter) = mean(mean(erp(1:trial_counts(i_trials),erp_win)));
    end

end

figure('Color',[1 1 1]);
        subplot(1,2,1); 
            errorbar(trial_counts,mean(max_erp,2),std(max_erp,[],2)); 
            title('ERP window PEAK amplitude');
            xlabel('Number of trials');
            ylabel('Window Max ERP voltage');
        subplot(1,2,2); 
            errorbar(trial_counts,mean(mean_erp,2),std(mean_erp,[],2));
            title('ERP window MEAN amplitude');
            xlabel('Number of trials');
            ylabel('Window MEAN ERP voltage');
        
        
        
%% simulate 20 subjects 
iters = 1000;
subs = 20;
max_erp = zeros(subs,2,iters);
mean_erp = zeros(subs,2,iters);
grand_max = zeros(iters,2);
grand_mean =zeros(iters,2);

t_test_max = zeros(iters,2);
p_max = zeros(iters,2);
t_test_mean = zeros(iters,2);
p_mean = zeros(iters,2);

trials = 100;
a_trials = 20;
b_trials = trials-a_trials;
for i_iter = 1:iters
    
    for i_sub = 1:subs
        
        %create random noise (gausian for now) and plot two trial
        noise = randn(trials,points)*50; %50 uV

        %create a fake ERP signal from 300-400 ms, and plot
        signal = zeros(1,points);
        signal(301:400) = signal(301:400)+hanning(100)';
        signal = signal*20; %20 uV

        %add signal to noise, and plot two trials
        erp = noise + repmat(signal,[trials 1]);

        %average more and more trials together
%         trial_counts = [5 10 15 20 30 50 75 100 150 200];
        erp_win = [326:375]; %to test erp in
%         for i_trials = 1:10
                %compute window max and mean
        max_erp(i_sub,1,i_iter) = max(mean(erp(1:a_trials,erp_win)));
        max_erp(i_sub,2,i_iter) = max(mean(erp(a_trials+1:trials,erp_win)));
        mean_erp(i_sub,1,i_iter) = mean(mean(erp(1:a_trials,erp_win)));
        mean_erp(i_sub,2,i_iter) = mean(mean(erp(a_trials+1:trials,erp_win)));
%         end

    end
    
    grand_max(i_iter,:) = mean(max_erp(:,:,i_iter),1);
    grand_mean(i_iter,:) = mean(mean_erp(:,:,i_iter),1);
    [t_test_max(i_iter,1) p_max(i_iter,1)] = ttest(max_erp(:,1,i_iter)-max_erp(:,2,i_iter),0,.025,'left');
    [t_test_max(i_iter,2) p_max(i_iter,2)] = ttest(max_erp(:,1,i_iter)-max_erp(:,2,i_iter),0,.025,'right');

    [t_test_mean(i_iter,1) p_mean(i_iter,1)] = ttest(mean_erp(:,1,i_iter)-mean_erp(:,2,i_iter),0,.025,'left');
    [t_test_mean(i_iter,2) p_mean(i_iter,2)] = ttest(mean_erp(:,1,i_iter)-mean_erp(:,2,i_iter),0,.025,'right');

end

figure('Color',[1 1 1]);
        subplot(2,2,1); 
            hist(grand_max(:,1),50); hold on
            hist(grand_max(:,2),50); 
             g=findobj(gca,'Type','patch');
            set(g(1),'FaceColor',[.9 0 0],'EdgeColor','k');
            set(g(2),'FaceColor',[0 .9 0],'EdgeColor','k');
            title('ERP window PEAK amplitude');
            ylabel('Trial Counts');
            legend('Condition A','Condition B');
        subplot(2,2,2); 
            hist(grand_mean(:,1),50); hold on
            hist(grand_mean(:,2),50); 
             g=findobj(gca,'Type','patch');
            set(g(1),'FaceColor',[.9 0 0],'EdgeColor','k');
            set(g(2),'FaceColor',[0 .9 0],'EdgeColor','k');
            title('ERP window MEAN amplitude');
            ylabel('Trial Counts');
            legend('Condition A','Condition B');
        subplot(2,2,3); 
             barweb(sum(t_test_max)/iters,[0 0])
            title('False Alarms - PEAK amplitude');
            ylabel('False Alarm Proportion');
            legend('B>A','A>B');
        subplot(2,2,4); 
            barweb(sum(t_test_mean)/iters,[0 0])
            title('False Alarms - MEAN amplitude');
            ylabel('False Alarm Proportion');
            legend('B>A','A>B');
