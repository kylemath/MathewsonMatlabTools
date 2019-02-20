%% illini_filter_wrap.m - How to call illini_filter.m
o_data = csvread('1.csv'); %load data
s_rate = 960; %sampling rate
high_pass = .1; %lower cutoff
low_pass = 30; %upper cutoff
order = 2;
type = 'band'; %type of filter
[f_data] = illini_filter(o_data,s_rate,high_pass,low_pass,order,'band'); %run the filter (which plots a graph)

