clc;
clear all;

bits = [1 0 1 0 1 1 1 0 1 1 0 1];
bitDuration = 2;

fs = 100;
totalTime = length(bits) * bitDuration;
time = 0 : 1/fs : totalTime;

amplitude = 2;
f1 = 1.5;
f0 = 0.5;
carrierSignalForOne = amplitude * sin(2 * pi * f1 * time);
carrierSignalForZero = amplitude * sin(2 * pi * f0 * time);

idx = 1;
for i = 1 : length(time)
  if bits(idx) == 1
    modulatedSignal(i) = carrierSignalForOne(i);
  else
    modulatedSignal(i) = carrierSignalForZero(i);
  endif
  if time(i) / bitDuration >= idx
    idx = idx + 1;
  endif
endfor

plot(time, modulatedSignal);
grid on;
xticks([0 : 2 : totalTime]);
xlim([0 totalTime]);
ylim([-amplitude-2 amplitude+2]);

idx = 1;
for i = 1 : length(time)
  if time(i)/bitDuration >= idx
    if modulatedSignal(i) == carrierSignalForOne(i)
      demodulatedSignal(idx) = 1;
    else 
      demodulatedSignal(idx) = 0;
    endif
    idx = idx + 1;
  endif
endfor

disp(demodulatedSignal);
all(demodulatedSignal == bits)

