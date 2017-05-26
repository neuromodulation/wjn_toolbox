function TFaxes
y=ylabel('Frequency [Hz]');myfont(y);
if sum(abs(get(gca,'xlim')))>500
    x=xlabel('Time [ms]');myfont(x);
else
    x=xlabel('Time [s]');myfont(x);
end
myfont(gca);