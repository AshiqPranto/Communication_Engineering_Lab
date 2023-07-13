clc;
clear all;

msgAmp = 1;
msgFreq = 2;
time = 0 : 0.001 : 3;
msgSignal = msgAmp * sin(2 * pi * msgFreq * time);
subplot(4, 1, 1);
plot(time, msgSignal);
title('Msg Signal');

carrierAmp = 1.5;
carrierFreq = 30;
carrierSignal = carrierAmp * sin(2 * pi * carrierFreq * time);
subplot(4, 1, 2);
plot(time, carrierSignal);
title('Carrier Signal');

modulatedSignal = (carrierAmp + msgSignal) .* carrierSignal;
subplot(4, 1, 3);
plot(time, modulatedSignal);
title('Modulated Signal');

demodulatedSignal = (modulatedSignal ./ carrierSignal) - carrierAmp;
subplot(4, 1, 4);
plot(time, demodulatedSignal);
title('Demodulated Signal');