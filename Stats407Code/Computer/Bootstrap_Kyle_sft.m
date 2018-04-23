
difference = left_amygdala-right_amygdala;

%Plot the actual data
figure;
    subplot(1,3,1);
        hist(left_amygdala,28);
            title('Left Amygdala Size');
    subplot(1,3,2);
        hist(right_amygdala,28);
            title('Right Amygdala Size');
    subplot(1,3,3);
        hist(difference,28);
            title('Size Difference');

%Combine data and run the bootstrap                   
both = [left_amygdala right_amygdala];
[stat ids] = bootstrp(10000,'mean',both);
boot_mean = mean(stat);
boot_std_err = std(stat);

%Bootstrapped Differences
diff_boot = stat(:,1) - stat(:,2);

%Plot them all like above
figure;
    subplot(1,3,1);
        hist(stat(:,1),100);
            title('Left Amygdala Bootstrapped Mean');
    subplot(1,3,2);
        hist(stat(:,2),100);
            title('Right Amygdala Bootstrapped Mean');
    subplot(1,3,3);
        hist(diff_boot,100);
            title('Bootstrapped Size Difference');
         
%Bootstrap the correlations
[cstat cids] = bootstrp(10000,'corr',left_amygdala,right_amygdala);
boot_mean = mean(cstat)
boot_std_err = std(cstat)
figure; hist(cstat,100);

%Plot each correlation line
figure; hold;
for i=1:100
    scatter(left_amygdala(cids(:,i),1),right_amygdala(cids(:,i),1));
    lsline;
end




%Jackknife
[jstat] = jackknife('mean',both);

diff_jknife = jstat(:,1) - jstat(:,2);

%Plot them all like above
figure;
    subplot(1,3,1);
        hist(jstat(:,1),10);
            title('Left Amygdala Jackknifed Mean');
    subplot(1,3,2);
        hist(jstat(:,2),10);
            title('Right Amygdala Jackknifed Mean');
    subplot(1,3,3);
        hist(diff_jknife,10);
            title('Jackknifed Size Difference');



            
figure;
    subplot(3,3,1);
        hist(left_amygdala,28);
            title('Left Amygdala Size');
    subplot(3,3,2);
        hist(right_amygdala,28);
            title('Right Amygdala Size');
    subplot(3,3,3);
        hist(difference,28);
            title('Size Difference');           
%Plot them all like above
% figure;
    subplot(3,3,4);
        hist(stat(:,1),100);
            title('Left Amygdala Bootstrapped Mean');
    subplot(3,3,5);
        hist(stat(:,2),100);
            title('Right Amygdala Bootstrapped Mean');
    subplot(3,3,6);
        hist(diff_boot,100);
            title('Bootstrapped Size Difference');            
%Plot them all like above
% figure;
    subplot(3,3,7);
        hist(jstat(:,1),10);
            title('Left Amygdala Jackknifed Mean');
    subplot(3,3,8);
        hist(jstat(:,2),10);
            title('Right Amygdala Jackknifed Mean');
    subplot(3,3,9);
        hist(diff_jknife,10);
            title('Jackknifed Size Difference');
