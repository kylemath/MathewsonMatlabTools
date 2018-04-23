%Resampling_kyle.m
%This is a basic script to show you the ins and outs of bootstrapping and jackknifing.

%Here is the actual Data
left_amygdala = [1848;1571;2199;1849;1802;1982;2473;1366;1253;1125;1815;1292;1470;2158;1795;1538;1941;2235;2361;1841;1549;2091;2093;1531;2004;2145;2021;2149;];
right_amygdala = [1886;1476;2105;1886;1867;1765;2223;1356;1279;1259;1780;1232;1491;1909;1742;1764;1827;2053;2149;1727;1651;1857;1984;1409;1907;2099;1882;1904;];

%Some information
n_samples = 1000;  %This is the number of random samples for bootstrapping, make it smaller if it takes too long, bigger for nicer pics
n_subjects = 28;
difference = left_amygdala-right_amygdala;
[significance P] = ttest(difference, zeros(n_subjects,1));  %Just a regular paired t-test
t_value = tinv(P,n_subjects-1);  

%Plot the actual data
figure;
    subplot(1,3,1);
        hist(left_amygdala,n_subjects);
            title('Left Amygdala Size ');
            xlabel(['(Mean = ' num2str(mean(left_amygdala)) ', Std = ' num2str(std(left_amygdala)) ', StdErr = ' num2str(std(left_amygdala)/sqrt(n_subjects-1)) ')']);
    subplot(1,3,2);
        hist(right_amygdala,n_subjects);
            title('Right Amygdala Size ');
            xlabel(['(Mean = ' num2str(mean(right_amygdala)) ', Std = ' num2str(std(right_amygdala)) ', StdErr = ' num2str(std(right_amygdala)/sqrt(n_subjects-1)) ')']);
    subplot(1,3,3);
        hist(difference,n_subjects);
            title(['Size Difference (t(' num2str(n_subjects-1) ') = ' num2str(t_value) ', p = ' num2str(P) ')']);
            xlabel(['(Mean = ' num2str(mean(difference)) ', Std = ' num2str(std(difference)) ', StdErr = ' num2str(std(difference)/sqrt(n_subjects-1)) ')']);


%--------------------------------------------------------------
%Bootstrap Analysis
%--------------------------------------------------------------
            
%Combine data and run the bootstrap                   
both = [left_amygdala right_amygdala];
[stat ids] = bootstrp(n_samples,'mean',both);
boot_mean = mean(stat)
boot_std_err = std(stat)  %Why is this the standard Error when it is computing the standard deviation?
figure; hist(stat,100);    

%Differences for each bootstrap
diff_boot = stat(:,1) - stat(:,2);
diff_mean = mean(diff_boot)
diff_std_err = std(diff_boot)
p_boot = length(find(diff_boot < 0))/n_samples;  %Why does this compute the p-value?
figure; hist(diff_boot,100);

%Plot them all like above
figure;
    subplot(1,3,1);
        hist(stat(:,1),100);
            title('Left Amygdala Bootstrapped Means');
            xlabel(['(Mean = ' num2str(mean(stat(:,1))) ', Std = ' num2str(std(stat(:,1))) ')']);
    subplot(1,3,2);
        hist(stat(:,2),100);
            title('Right Amygdala Bootstrapped Means');
            xlabel(['(Mean = ' num2str(mean(stat(:,2))) ', Std = ' num2str(std(stat(:,2))) ')']);    
    subplot(1,3,3);
        hist(diff_boot,100);
            title(['Bootstrapped Size Difference (p = ' num2str(p_boot) ')']);
            xlabel(['(Mean = ' num2str(mean(diff_boot)) ', Std = ' num2str(std(diff_boot)) ')']);    


            
%------------------------------------------------------------         
%Jackknife
%------------------------------------------------------------

[jstat] = jackknife('mean',both);
diff_jknife = jstat(:,1) - jstat(:,2);

%Plot them all like above
figure;
    subplot(1,3,1);
        hist(jstat(:,1),10);
            title('Left Amygdala Jackknifed Mean');
            xlabel(['(Mean = ' num2str(mean(jstat(:,1))) ', Std = ' num2str(std(jstat(:,1))) ', StdErr = ' num2str(std(jstat(:,1))*sqrt(n_subjects-1)) ')' ]);
    subplot(1,3,2);
        hist(jstat(:,2),10);
            title('Right Amygdala Jackknifed Mean');
            xlabel(['(Mean = ' num2str(mean(jstat(:,2))) ', Std = ' num2str(std(jstat(:,2))) ', StdErr = ' num2str(std(jstat(:,2))*sqrt(n_subjects-1)) ')' ]);
    subplot(1,3,3);
        hist(diff_jknife,10);
            title('Jackknifed Size Difference');
            xlabel(['(Mean = ' num2str(mean(diff_jknife)) ', Std = ' num2str(std(diff_jknife)) ', StdErr = ' num2str(std(diff_jknife)*sqrt(n_subjects-1)) ')' ]);


%-------------------------------------
%Plot them all together on one figure to compare
%-----------------------------------------
            
figure;
    subplot(3,3,1);
        hist(left_amygdala,n_subjects);
            title('Left Amygdala Size ');
            xlabel(['(Mean = ' num2str(mean(left_amygdala)) ', Std = ' num2str(std(left_amygdala)) ', StdErr = ' num2str(std(left_amygdala)/sqrt(n_subjects-1)) ')']);
    subplot(3,3,2);
        hist(right_amygdala,n_subjects);
            title('Right Amygdala Size ');
            xlabel(['(Mean = ' num2str(mean(right_amygdala)) ', Std = ' num2str(std(right_amygdala)) ', StdErr = ' num2str(std(right_amygdala)/sqrt(n_subjects-1)) ')']);
    subplot(3,3,3);
        hist(difference,n_subjects);
            title(['Size Difference (t(' num2str(n_subjects-1) ') = ' num2str(t_value) ', p = ' num2str(P) ')']);
            xlabel(['(Mean = ' num2str(mean(difference)) ', Std = ' num2str(std(difference)) ', StdErr = ' num2str(std(difference)/sqrt(n_subjects-1)) ')']);      
%Plot them all like above
% figure;
    subplot(3,3,4);
        hist(stat(:,1),100);
            title('Left Amygdala Bootstrapped Means');
            xlabel(['(Mean = ' num2str(mean(stat(:,1))) ', Std = ' num2str(std(stat(:,1))) ')']);
    subplot(3,3,5);
        hist(stat(:,2),100);
            title('Right Amygdala Bootstrapped Means');
            xlabel(['(Mean = ' num2str(mean(stat(:,2))) ', Std = ' num2str(std(stat(:,2))) ')']);    
    subplot(3,3,6);
        hist(diff_boot,100);
            title(['Bootstrapped Size Difference (p = ' num2str(p_boot) ')']);
            xlabel(['(Mean = ' num2str(mean(diff_boot)) ', Std = ' num2str(std(diff_boot)) ')']);          
%Plot them all like above
% figure;
   subplot(3,3,7);
        hist(jstat(:,1),10);
            title('Left Amygdala Jackknifed Mean');
            xlabel(['(Mean = ' num2str(mean(jstat(:,1))) ', Std = ' num2str(std(jstat(:,1))) ', StdErr = ' num2str(std(jstat(:,1))*sqrt(n_subjects-1)) ')' ]);
    subplot(3,3,8);
        hist(jstat(:,2),10);
            title('Right Amygdala Jackknifed Mean');
            xlabel(['(Mean = ' num2str(mean(jstat(:,2))) ', Std = ' num2str(std(jstat(:,2))) ', StdErr = ' num2str(std(jstat(:,2))*sqrt(n_subjects-1)) ')' ]);
    subplot(3,3,9);
        hist(diff_jknife,10);
            title('Jackknifed Size Difference');
            xlabel(['(Mean = ' num2str(mean(diff_jknife)) ', Std = ' num2str(std(diff_jknife)) ', StdErr = ' num2str(std(diff_jknife)*sqrt(n_subjects-1)) ')' ]);

            
            
            
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
    n_lines = 10;
    subplot(2,3,3); hold;
        for i_sample=1:n_lines
            scatter(left_amygdala(cids(:,i_sample),1),right_amygdala(cids(:,i_sample),1));
            lsline;
        end


            
%------------------------------------------------------------         
%Jackknife
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
        
        
       

