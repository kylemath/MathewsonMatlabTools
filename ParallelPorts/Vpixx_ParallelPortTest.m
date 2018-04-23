

clear all
close all
warning off MATLAB:DeprecatedLogicalAPI
Screen('Preference', 'SkipSyncTests', 1); %for test on an LCD

%% Open the main window and get dimensions
white=[255,255,255];  %WhiteIndex(window);
black=[0,0,0];   %BlackIndex(window);
grey= (white+black)/2; %background colour

%load the window up
screenNumber = max(Screen('Screens')); % Get the maximum screen number i.e. get an external screen if avaliable
[window,rect]=Screen(0 ,'OpenWindow',black);
% HideCursor;     
v_res = rect(4);
h_res = rect(3);
v_center = v_res/2;
h_center = h_res/2;
fixation = [h_center-10 v_center-10];
trigger_size = [0 0 100 100]; %use [0 0 1 1] for eeg, 50 50 for photodiode


%red = 1 2 4 8                      %triggers given out
%green = 16 32 64 128               %triggers out
%red = 1/ 2/ 4/ 8/ 16 32 64 128     %colours needed for triggers above
%green = 1/ 2/ 4/ 8/ 16 32 64 128
KbWait;
for i=255:-1:1
    
    trigger=Screen(window,'OpenoffScreenWindow',black);
    Vpixx2Vamp(i)
    Screen(trigger, 'FillRect',Vpixx2Vamp(i),trigger_size); %eeg trigger
    Screen('CopyWindow',trigger ,window,rect,rect);
    Screen('Flip', window,[],0);
% WaitSecs(1);
    trigger=Screen(window,'OpenoffScreenWindow',black);
    Screen(trigger, 'FillRect',black,trigger_size); %eeg trigger
    Screen('CopyWindow',trigger ,window,rect,rect);
    Screen('Flip', window,[],0);
    
    WaitSecs(.5);
%     KbWait;
end

% Screen('FillOval',window,white, [h_center-2 v_center-2 h_center+2 v_center+2 ] ); %Target
% KbWait; 
Screen('Close', window);
ShowCursor;