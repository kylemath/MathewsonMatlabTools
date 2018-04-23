%Resampling_Kyle.m
%This is a basic script to show you the ins and outs of bootstrapping and jackknifing.
% It will show a between subjects bootstrap and
% jacknife of the same data for a correlation model

%Here is the actual Data
left_amygdala = [1848;1571;2199;1849;1802;1982;2473;1366;1253;1125;1815;1292;1470;2158;1795;1538;1941;2235;2361;1841;1549;2091;2093;1531;2004;2145;2021;2149;];
right_amygdala = [1886;1476;2105;1886;1867;1765;2223;1356;1279;1259;1780;1232;1491;1909;1742;1764;1827;2053;2149;1727;1651;1857;1984;1409;1907;2099;1882;1904;];

%Some information
n_samples = 1000;  %This is the number of random samples for bootstrapping, make it smaller if it takes too long, bigger for nicer pics
n_subjects = 28;        
            
%------------------------------------------------------------         
%Bootstrap Correlation
%------------------------------------------------------------


 %Plot the correlation between left and right amygdala size           
 figure; 
    subplot(2,3,1); 
    scatter(left_amygdala,right_amygdala);
        lsline;
        [r p_corr] = corr(left_amygdala,right_amygdala);
        title('Correlation between L & R Amygdala Size');
        xlabel(['(r = ' num2str(r)  ', p = ' num2str(p_corr) ')']  );
 
            
 %Bootstrap the correlations
    [cstat cids] = bootstrp(n_samples,'corr',left_amygdala,right_amygdala);  %What is different here than before?
        boot_mean = mean(cstat)
        boot_std_err = std(cstat)
        p_corr_boot = length(find(cstat<0))/n_samples;
    subplot(2,3,2); 
        hist(cstat,100);
            title(['Bootstrapped Correlations (Mean_r = ' num2str(boot_mean) ', p = ' num2str(p_corr_boot) ')']);


    %Plot each correlation line (Make this more than 10 but less than 100 or it
    %will take forever)
    n_lines = 50;
    subplot(2,3,3); hold;
        for i_sample=1:n_lines
            scatter(left_amygdala(cids(:,i_sample),1),right_amygdala(cids(:,i_sample),1));
            lsline;
        end


            
%------------------------------------------------------------         
%Jackknife Correlation
%------------------------------------------------------------

[jstat_corr] = jackknife('corr',left_amygdala,right_amygdala);
    subplot(2,3,5);
        hist(jstat_corr,n_subjects);
            title(['Jackknifed Correlations (Mean_r = ' num2str(mean(jstat_corr)) ')']);
            xlabel(['Mean_r = ' num2str(mean(jstat_corr)) ')']);
            
    subplot(2,3,6); hold
        for i_sub = 1:n_subjects
            without_left = left_amygdala;
            without_left(i_sub) = [];
            
            without_right = right_amygdala;
            without_right(i_sub) = [];
            
            scatter(without_left,without_right);
                lsline;
        end
        