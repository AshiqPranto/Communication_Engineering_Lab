clc;
clear all;

bits = [1 0 1 1 0 1 0 1 0 1];
bitDuration = 2;
totalTime = length(bits) * bitDuration;
fs = 100;
time = 0 : 1/fs : totalTime;
amplitude = 5;
f = 1.5;

carrierSignal = amplitude * sin(2 * pi * f * time);

idx = 1;
for i = 1 : length(time)
  if bits(idx) == 1
    modulatedSignal(i) = carrierSignal(i);
  else
    modulatedSignal(i) = carrierSignal(i) * (-1);
  endif
  if time(i) / bitDuration >= idx
    idx = idx + 1;
  endif
endfor

plot(time, modulatedSignal);
grid on;
ylim([-amplitude-2 amplitude+2]);
xticks([0 : bitDuration : totalTime]);

idx = 1;
for i = 1 : length(time)
  if time(i) / bitDuration >= idx
    if modulatedSignal(i) == carrierSignal(i)
      demodulatedSignal(idx) = 1;
    else
      demodulatedSignal(idx) = 0;
    endif
    idx = idx + 1;
  endif
endfor

disp(demodulatedSignal);
all(demodulatedSignal == bits)