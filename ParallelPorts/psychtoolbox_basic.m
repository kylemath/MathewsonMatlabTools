 

clear all
close all 
warning off MATLAB:DeprecatedLogicalAPI
% Screen('Preference', 'SkipSyncTests', 1); %for test on an LCD
Priority(2);
  
     %% Set up parallel port
%initialize the inpoutx64 low-level I/O driver
config_io;
%optional step: verify that the inpoutx64 driver was successfully installed
global cogent;
if( cogent.io.status ~= 0 )
   error('inp/outp installation failed');
end
%write a value to the default LPT1 printer output port (at 0x378)
address_eeg = hex2dec('B010');
outp(address_eeg,0);  %set pins to zero  


%% Open the main window and get dimensions
white=[255,255,255];  %WhiteIndex(window);
black=[0,0,0];   %BlackIndex(window);
grey= (white+black)/2; %background colour

%load the window up
screenNumber = max(Screen('Screens')); % Get the maximum screen number i.e. get an external screen if avaliable
[window,rect]=Screen(screenNumber ,'OpenWindow',black (1));
HideCursor;     
v_res = rect(4);
h_res = rect(3);
v_center = v_res/2;
h_center = h_res/2;
fixation = [h_center-10 v_center-10]; 
trigger_size = [0 0 100 100]; %use [0 0 1 1] for eeg, 50 50 for photodiode
% Get presentation timing information
refresh = Screen('GetFlipInterval', window); % Get flip refresh rate
slack = refresh/2; % Divide by 2 to get slack
length = .5; %500 ms 
step = 5;



target = Screen(window,'OpenoffScreenWindow',black);
Screen('CopyWindow',target ,window,rect,rect);
 Screen(window, 'Flip', 0);

 for i_try = 1:10
    flip_onset = KbWait;  
    for i_step = 1:step:255
        target = Screen(window,'OpenoffScreenWindow',[i_step,i_step,i_step]);
        Screen('CopyWindow',target ,window,rect,rect);
        flip_onset = Screen(window, 'Flip', flip_onset + length - slack);
        target = Screen(window,'OpenoffScreenWindow',[i_step,i_step,i_step]);
        Screen(target, 'FillRect',[0 0 0],trigger_size);
        WaitSecs(.1);
        Screen('CopyWindow',target ,window,rect,rect);
        Screen(window, 'Flip', 0);

    %     outp(address_eeg,i_step);
    %     WaitSecs(.01);
    %     outp(address_eeg,0);
    end
    WaitSecs(.5-(GetSecs-flip_onset));
    target = Screen(window,'OpenoffScreenWindow',black);
    Screen('CopyWindow',target ,window,rect,rect);
    flip_onset = Screen(window, 'Flip', 0);
    KbWait;  
 end 

Screen('Close', window);
ShowCursor;