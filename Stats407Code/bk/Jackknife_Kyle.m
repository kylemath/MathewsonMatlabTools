difference = left_amygdala-right_amygdala;



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

both = [left_amygdala right_amygdala];
[stat ids] = bootstrp(10000,'mean',both);
boot_mean = mean(stat);
boot_std_err = std(stat);
figure; hist(stat,100);    

diff_boot = stat(:,1) - stat(:,2);
figure; hist(diff_boot,100);

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
         

[stat ids] = bootstrp(10000,'corr',left_amygdala,right_amygdala);
boot_mean = mean(stat)
boot_std_err = std(stat)
figure; hist(stat,100);

figure; hold;
for i=1:10
    scatter(left_amygdala(ids(:,i),1),right_amygdala(ids(:,i),1));
    lsline;
end

