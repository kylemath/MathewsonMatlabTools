ccc
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

%Trigger BOXY DOIL2
outp(address_eeg,128);  %TMS is only the 8th pin
data_eeg=inp(address_eeg)
WaitSecs(.1);
outp(address_eeg,0);
data_eeg=inp(address_eeg)

break

%Tests all other trigger values in reverse
for i=[255:-1:1]
    outp(address_eeg,i);  %TMS is only the 8th pin
    WaitSecs(.1);
    outp(address_eeg,0);
    WaitSecs(.550);
end



%and forward
for i=1:255
    i
    outp(address_eeg,i);  %TMS is only the 8th pin
    WaitSecs(.01);
    outp(address_eeg,0); 
    WaitSecs(.250);
end
