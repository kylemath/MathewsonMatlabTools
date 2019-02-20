function [w,t] = mTRF(stim,resp,Fs,lambda,start,fin)
%MTRF Multivariate temporal response function.
%   [W,T] = MTRF(STIM,RESP,FS) performs a ridge regression on the stimulus 
%   input STIM and the neural response data RESP, both with a sampling
%   frequency FS, to solve for the multivariate temporal response function 
%   (mTRF) W and its time axis T. The mTRF is described by the equation:
% 
%                       w = inv(x*x'+lamda*M)*(x*y')                         
%
%   where X is a matrix of stimulus lags, Y is the neural response, M is 
%   the regularisation term used to prevent overfitting and LAMBDA is the 
%   ridge parameter.
% 
%   [W,T] = MTRF(STIM,RESP,FS,LAMBDA,START,FIN) calculates the mTRF for a 
%   specified ridge parameter LAMBDA. The time window over which the mTRF 
%   is calculated with respect to the stimulus is set between time lags 
%   START and FIN in milliseconds.
% 
%   Inputs:
%   stim   - stimulus input signal (frequency x time)
%   resp   - neural response data (channels x time)
%   Fs     - sampling frequency of stimulus and neural data in Hertz
%   lambda - ridge parameter for regularisation (default = max(x*x'))
%   start  - start time lag of TRF in milliseconds (default = -120ms)
%   fin    - stop time lag of TRF in milliseconds (default = 420ms)
%     
%   Outputs:
%   w      - mTRF (channels x time x frequency)
%   t      - time axis of mTRF in milliseconds (1 x time)
% 
%   Example: 
%   128-channel EEG was recorded at 512Hz. Stimulus was natural speech, 
%   presented at 48kHz for 60 seconds. The envelope of the speech waveform 
%   was got using a Hilbert transform and was then downsampled to 512Hz.
%      >> [w,t] = mTRF(envelope,EEG,512,4.4e2,-220,520);
%      >> plot(t,w(85,:)); 
%
%   See also GLOBALFIELDPOWER, STIMULIRECONSTRUCTION.

%   References:
%      [1] Lalor EC, Pearlmutter BA, Reilly RB, McDarby G, Foxe JJ (2006). 
%          The VESPA: a method for the rapid estimation of a visual evoked 
%          potential. NeuroImage, 32:1549-1561.
%      [2] Lalor EC, Power AP, Reilly RB, Foxe JJ (2009). Resolving precise 
%          temporal processing properties of the auditory system using 
%          continuous stimuli. Journal of Neurophysiology, 102(1):349-359.

%   Author: Edmund Lalor & Lab, Trinity College Dublin
%   Email: edmundlalor@gmail.com
%   Website: http://sourceforge.net/projects/aespa/
%   Version: 1.0
%   Last revision: 4 April 2014

if ~exist('start','var') || isempty(start)
    start = round(-0.12*Fs);
else
    start = round(start/1e3*Fs);
end
if ~exist('fin','var') || isempty(fin)
    fin = round(0.42*Fs);
else
    fin = round(fin/1e3*Fs);
end
window = length(start:fin);

% Set up buffer for lag generation
buffer = window;
if start > 0 
    stim = stim(:,1:end-start);
elseif fin <= 0
    buffer = buffer-fin;
end

% Calculate xxt matrix
x = zeros(window*size(stim,1),size(stim,2)-buffer+1);

for i = buffer:size(stim,2);
  tmpStim = stim(:,i:-1:i-window+1);
  x(:,i-buffer+1) = tmpStim(:); 
end
xxt = x*x';

% Calculate xy matrix
y = resp(:,buffer+start:size(stim,2)+start); 
xy = x*y';

% Set up regularisation
if ~exist('lambda','var') || isempty(lambda)
    lambda = max(max(abs(xxt)));
end
d = 2*eye(size(xxt)); d(1,1) = 1; d(size(xxt,1),size(xxt,2)) = 1;
u = [zeros(size(xxt,1)-1,1),eye(size(xxt)-1);zeros(1,size(xxt,2))];    
l = [zeros(1,size(xxt,2));eye(size(xxt)-1),zeros(size(xxt,1)-1,1)];
M = d-u-l;
lambdaM = lambda*M;

% Calculate mTRF and its time axis
w = (pinv(xxt+lambdaM)*xy)';
t = (start:fin)/Fs*1e3;

end 