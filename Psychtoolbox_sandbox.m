%% Drawshapes
clear all
close all
warning off MATLAB:DeprecatedLogicalAPI
Screen('Preference', 'SkipSyncTests', 1); %for test on an LCD
Priority(2);
screenNumber = max(Screen('Screens')); % Get the maximum screen number i.e. get an external screen if avaliable

 %background colour
white=WhiteIndex(screenNumber);
black=BlackIndex(screenNumber);
grey=round((white+black)/2);
inc=white-grey;
red = [255 0 0];

% [window,rect]=Screen(screenNumber ,'OpenWindow',grey(1));
[w rect] =Screen('OpenWindow',screenNumber, grey, [100 100 800 800]);%use this line for testing

v_res = rect(4);
h_res = rect(3);
v_center = v_res/2;
h_center = h_res/2;
target_size = 18;
entrainer_size = 48;

%load the window up

%draw the horizontal lines
step = 4;
temp = v_center-entrainer_size:step:v_center+entrainer_size;
n_lines = length(temp);
for i_line = 1:n_lines
    ys(i_line*2-1:i_line*2) = temp(i_line); 
end
xs = [h_center-entrainer_size, h_center+entrainer_size];
xs = repmat(xs,[1,n_lines]);
xylines_hor = [xs;ys];
xylines_ver = [ys;xs];


Screen('FillOval',w,red, [h_center-entrainer_size v_center-entrainer_size h_center+entrainer_size v_center+entrainer_size]  ); %Entrainer
% Screen('DrawLines',w,black,h_center-entrainer_size,v_center,h_center+entrainer_size,v_center)
Screen('DrawLines',w,xylines_ver,2, black)
Screen('FrameOval',w,grey,[h_center-entrainer_size-20 v_center-entrainer_size-20 h_center+entrainer_size+20 v_center+entrainer_size+20],20) 
Screen('FillOval',w,grey, [h_center-target_size v_center-target_size h_center+target_size v_center+target_size] ); %Entrainer Center
Screen('FrameOval',w,black,[h_center-entrainer_size v_center-entrainer_size h_center+entrainer_size v_center+entrainer_size]) 
Screen('FrameOval',w,black,[h_center-target_size v_center-target_size h_center+target_size v_center+target_size]) 

Screen('Flip', w);





KbWait;


Screen('Close', w);

% phase=pi;
% % grating
% [x,y]=meshgrid(-300:300,-300:300);
% angle=90*pi/180; % 30 deg orientation.
% f=0.03*2*pi; % cycles/pixel
% a=cos(angle)*f;
% b=sin(angle)*f;
% m=exp(sin(a*x+b*y+phase));
% m=exp(-((x/90).^2)-((y/90).^2)).*sin(a*x+b*y+phase);
% tex=Screen('MakeTexture', w, 50*m);
% Screen('DrawTexture', w, tex);


