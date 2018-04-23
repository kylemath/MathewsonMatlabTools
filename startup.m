
%set the paths
%eeglab
%addpath(genpath('M:\Experiments\matlab\eeglab13_4_4b'));
%parallel port
addpath('M:\Experiments\matlab\ParallelPorts');
%EEG analysis
addpath('M:\Experiments\matlab\EEG_analysis');
addpath('M:\Experiments\matlab\FilterM_20Jul2011');
%Circle Stats
addpath('M:\Experiments\matlab\Mathewson_Circ');
addpath('M:\Experiments\matlab\CircStat2012a');
addpath(genpath('M:\Experiments\matlab\MemToolbox-master'));

%start GPU
%http://www.mathworks.com/matlabcentral/newsreader/view_thread/314059
gpuDeviceCount


%reload previous location
if ispref('user','lwd')
    cd(getpref('user','lwd'));
end
%dock all figures
set(0,'DefaultFigureWindowStyle','docked') %docked/normal

% Call Psychtoolbox-3 specific startup function:
if exist('PsychStartup'), PsychStartup; end;

