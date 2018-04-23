% clear all
% close all

%% corr_matt.m - Dr. Kyle Mathewson - Assistant Professor, Department of Psychology, University of Alberta
% Creates a large colourful correlation matrix from x number of variables over n subjects. 
% To Create - Put your variables in columns in excell with a title for each column. Each row is a different subject usually
% Highlight all the data plus the titles and Copy it to the clipboard (Ctrl + C).
% Then run the matlab script by typing into the command window corr_matt, either first adding its folder to the path or cd'ing to the folder
% Enjoy! - I usually make the figure square and copy the result into powerpoint, and convert to a microsoft drawing object by selecting ungroup

all_data = importdata('-pastespecial');
data = all_data.data;
textdata = all_data.textdata;

for i=1:length(textdata)
if isempty(findstr('#RAD',textdata{i})) ==0
    ind=findstr('#RAD',textdata{i});
    textdata{i}(ind:ind+3) = [];
    circ(i)=1;
else
    circ(i)=0;
end
end

numvars = size(data,2);
R = corrcoef(data,'rows','pairwise');

circvars=1:numvars;
circvars=circvars(circ==1);

for i=circvars
    for j = 1:numvars
        R(i,j) = circ_corrcl(data(:,i),data(:,j));
    end
end

for i=1:numvars
    for j = circvars
        R(i,j) = circ_corrcl(data(:,j),data(:,i));
    end
end

for i=circvars
    for j = circvars
        R(i,j) = circ_corrcc(data(:,i),data(:,j));
    end
end

% for i=1:numvars
%     for j = 1:numvars
%         if i>=j
%             R(i,j) = 0;
%         end
%     end
% end

CLim = [-1 1];
figure; imagesc(R,CLim);

new_jet = [0,0,0.562500000000000;0,0,0.625000000000000;0,0,0.687500000000000;0,0,0.750000000000000;0,0,0.812500000000000;0,0,0.875000000000000;0,0,0.937500000000000;0,0,1;0.0399999991059303,0.0399999991059303,1;0.0799999982118607,0.0799999982118607,1;0.119999997317791,0.119999997317791,1;0.159999996423721,0.159999996423721,1;0.200000002980232,0.200000002980232,1;0.239999994635582,0.239999994635582,1;0.280000001192093,0.280000001192093,1;0.319999992847443,0.319999992847443,1;0.360000014305115,0.360000014305115,1;0.400000005960465,0.400000005960465,1;0.439999997615814,0.439999997615814,1;0.479999989271164,0.479999989271164,1;0.519999980926514,0.519999980926514,1;0.560000002384186,0.560000002384186,1;0.600000023841858,0.600000023841858,1;0.639999985694885,0.639999985694885,1;0.680000007152557,0.680000007152557,1;0.720000028610230,0.720000028610230,1;0.759999990463257,0.759999990463257,1;0.800000011920929,0.800000011920929,1;0.839999973773956,0.839999973773956,1;0.879999995231628,0.879999995231628,1;0.920000016689301,0.920000016689301,1;0.959999978542328,0.959999978542328,1;1,1,1;1,0.956521749496460,0.956521749496460;1,0.913043498992920,0.913043498992920;1,0.869565188884735,0.869565188884735;1,0.826086938381195,0.826086938381195;1,0.782608687877655,0.782608687877655;1,0.739130437374115,0.739130437374115;1,0.695652186870575,0.695652186870575;1,0.652173936367035,0.652173936367035;1,0.608695626258850,0.608695626258850;1,0.565217375755310,0.565217375755310;1,0.521739125251770,0.521739125251770;1,0.478260874748230,0.478260874748230;1,0.434782594442368,0.434782594442368;1,0.391304343938828,0.391304343938828;1,0.347826093435288,0.347826093435288;1,0.304347813129425,0.304347813129425;1,0.260869562625885,0.260869562625885;1,0.217391297221184,0.217391297221184;1,0.173913046717644,0.173913046717644;1,0.130434781312943,0.130434781312943;1,0.0869565233588219,0.0869565233588219;1,0.0434782616794109,0.0434782616794109;1,0,0;0.937500000000000,0,0;0.875000000000000,0,0;0.812500000000000,0,0;0.750000000000000,0,0;0.687500000000000,0,0;0.625000000000000,0,0;0.562500000000000,0,0;0.500000000000000,0,0;];
colormap(new_jet); 
cb = colorbar %a colormap menu is added to your figure
set(get(cb,'ylabel'),'string','Correlation')



set(gca,'YLim',[.5 numvars+.5]);% 
set(gca,'YTick',[1:numvars]) % This automatically sets 
set(gca,'YTickLabel',textdata)




set(gca,'XLim',[.5 numvars+.5]);% 
set(gca,'XTick',[1:numvars]) % This automatically sets 
set(gca,'XTickLabel',textdata)


%rotate it - after rotateticklabel.m
a=get(gca,'XTickLabel');
set(gca,'XTickLabel',[]);
b=get(gca,'XTick');
c=get(gca,'YTick');

th=text(b,repmat(c(1)-.1*(c(2)-c(1)),length(b),1),a,'HorizontalAlignment','right','rotation',90);


% opts = statset('MaxIter',100,'Display','iter');
%  Y = mdscale(1-R,2,'start','random','Replicates',100,'Options',opts);
% figure; scatter(Y(:,1),Y(:,2));
% text(Y(:,1), Y(:,2), textdata, 'horizontal','left', 'vertical','bottom')