% Function to generate Bland Altman plots. Barry Greene, September 2008
% Bland, J.M., Altman, D.G. 'Statistical methods for assessing agreement ...
% between two methods of clinical measurement'(1986) Lancet, 1 (8476), pp. 307-310.
% Inputs: data1: Data from first instrument
%         data2: Data from second instument  
% Produces Bland Altman plot with mean difference and mean difference +/-
% 2*SD difference lines.
% function [data_mean,data_diff,md,sd] = bland_altman(data1,data2)


function [data_mean,data_diff,md,sd] = bland_altman(data1,data2)

[m,n] = size(data1);
if(n>m)
    data1 = data1';
end

if(size(data1)~=size(data2))
    error('Data matrices must be the same size')
end

data_mean = nanmean([data1,data2],2);  % Mean of values from each instrument 
data_diff = data1 - data2;              % Difference between data from each instrument
md = nanmean(data_diff);               % Mean of difference between instruments 
sd = nanstd(data_diff);                % Std dev of difference between instruments 

plot(data_mean,data_diff,'.','MarkerSize',5,'LineWidth',2)   % Bland Altman plot
hold on,plot(data_mean,md*ones(1,length(data_mean)),'-k')             % Mean difference line  
plot(data_mean,2*sd*ones(1,length(data_mean)),'-k')                   % Mean plus 2*SD line  
plot(data_mean,-2*sd*ones(1,length(data_mean)),'-k')                  % Mean minus 2*SD line   
grid on
title('Bland Altman plot','FontSize',9)
xlabel('Mean of two measures','FontSize',8)
ylabel('Difference between two measures','FontSize',8)