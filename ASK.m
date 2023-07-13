 clc; #... Clear command line
clear all; #... Clear variables
close all; #... Clear figures

bits = [1 0 1 0 0 1 1 0 1 1 0 0 1];

bitDuration = 2;

fs = 100;
totalTime = length(bits) * bitDuration;
time = 0 : 1/fs : totalTime;

amplitude = 2;
f = 0.5;
carrierSignal = amplitude * sin(2 * pi * f * time);

idx = 1;
for i = 1 : length(carrierSignal)
  modulatedSignal(i) = carrierSignal(i) * bits(idx);
  if time(i)/bitDuration >= idx  
    idx = idx + 1;
  endif
  
endfor
plot(time,modulatedSignal);
xlim([0, totalTime]);
ylim([-amplitude-2, amplitude+2]);
grid on;
xticks(0: 2 : totalTime);

idx = 1;
for i = 1 : length(time)
  if time(i)/bitDuration >= idx
    demodulatedSignal(idx) = modulatedSignal(i) / carrierSignal(i);
    idx = idx + 1;
  endif
endfor
disp(demodulatedSignal);
all(demodulatedSignal == bits)
