%% Set up parallel port
% This assumes that you have downloaded and installed according to the
% instructions the parallel port drivers in my kit: 
% http://www.kylemathewson.com/wp-content/uploads/2013/06/ParallelPortKit.zip
% By Dr. Kyle Mathewson - 2012



%% Initialize the inpoutx64 low-level I/O driver
config_io;

%optional step: verify that the inpoutx64 driver was successfully installed
global cogent;
if( cogent.io.status ~= 0 )
   error('inp/outp installation failed');
end

%% write a value to the default LPT1 printer output port (at 0x378)
address_eros = hex2dec('B010');
outp(address_eros,0);

%% Trigger BOXY 
outp(address_eros,128);  %TMS is only the 8th pin
WaitSecs(.1);
outp(address_eros,0);  %TMS is only the 8th pin


break

%% Tests all other trigger values in reverse
for i=[255:-1:1]
    outp(address_eros,i);  %TMS is only the 8th pin
    WaitSecs(.1);
    outp(address_eros,0);  %TMS is only the 8th pin
    WaitSecs(.250);
end

%% Test the trigger values forward
for i=1:255
    outp(address_eros,i);  %TMS is only the 8th pin
    WaitSecs(.01);
    outp(address_eros,0);  %TMS is only the 8th pin
    WaitSecs(.250);
end
