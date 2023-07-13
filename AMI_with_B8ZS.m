clear all;
close all;
clc;

bits = [1 0 0 0 0 0 0 0 0 1];
bit_duration = 2;

fs = 100;
totalTime = length(bits) * bit_duration;
t = 0:1/fs:totalTime-(1/fs);

#counting number of zeros

for i = 1:length(bits)
  if bits(i) == 0
    cnt++;
  else
    cnt = 0;
  endif
  if cnt==8
    j = i-8+1;
    bits(j+3) = 'V'; 
    bits(j+4) = 'B';
    bits(j+5) = 0;
    bits(j+6) = 'V';
    bits(j+7) = 'B';
  endif
endfor
bits

#sender end 
prev_non_zero_bit_state = -3;
for i = 1:length(bits)
  if bits(i) == 0
    ami(((i-1)*bit_duration*fs)+1 : i*bit_duration*fs) = zeros(1,(fs*bit_duration));
  else
    if bits(i) == 66 || bits(i)==1
      prev_non_zero_bit_state = -prev_non_zero_bit_state;
    endif
    
    ami(((i-1)*bit_duration*fs)+1 : i*bit_duration*fs) = ones(1,(fs*bit_duration)).*prev_non_zero_bit_state;
  endif
endfor

#ploting

plot(t,ami);
grid on;
#title("Bipolar AMI");
xlabel("Time");
ylabel("Amplitude");
ylim([-5,5]);

#Top axis
ax1=gca;
ax2 = axes('Position', get(ax1, 'Position'), 'Color', 'none');
set(ax2, 'XAxisLocation', 'top');
set(ax2,'XLim',get(ax1,'XLim'));
set(ax2, 'XTick', [bit_duration/2: bit_duration: totalTime]);
set(ax2,'XTickLabel',bits);

# receiver end
# This demodulation gives the bits after replacing continuous 8 zeros
j = 1;
for i = 1: length(ami)/(bit_duration*fs)
  if i<j 
    continue;
  endif
  if (ami(((i-1)*bit_duration*fs)+1 : i*bit_duration*fs) == ones(1,(fs*bit_duration)).*3 && prev_non_zero_bit_state==3) || (ami(((i-1)*bit_duration*fs)+1 : i*bit_duration*fs) == ones(1,(fs*bit_duration)).*-3 && prev_non_zero_bit_state==-3)
      deami(j) = 86;
      j++;
      deami(j) = 66;
      j++;
      deami(j) = 0;
      j++;
      deami(j) = 86;
      j++;
      deami(j) = 66;
      j++;
  elseif ami(((i-1)*bit_duration*fs)+1:i*bit_duration*fs)==zeros(1,(fs*bit_duration))
      deami(j) = 0;
      j++;
  else
      deami(j) = 1;
      j++;
      prev_non_zero_bit_state = -prev_non_zero_bit_state;
  endif
endfor
deami

# This demodulation gives the bits whitout replacing continuous 8 zeros
j = 1;
for i = 1: length(ami)/(bit_duration*fs)
  if i<j 
    continue;
  endif
  if (ami(((i-1)*bit_duration*fs)+1 : i*bit_duration*fs) == ones(1,(fs*bit_duration)).*3 && prev_non_zero_bit_state==3) || (ami(((i-1)*bit_duration*fs)+1 : i*bit_duration*fs) == ones(1,(fs*bit_duration)).*-3 && prev_non_zero_bit_state==-3)
      deami(j) = 0;
      j++;
      deami(j) = 0;
      j++;
      deami(j) = 0;
      j++;
      deami(j) = 0;
      j++;
      deami(j) = 0;
      j++;
  elseif ami(((i-1)*bit_duration*fs)+1:i*bit_duration*fs)==zeros(1,(fs*bit_duration))
      deami(j) = 0;
      j++;
  else
      deami(j) = 1;
      j++;
      prev_non_zero_bit_state = -prev_non_zero_bit_state;
  endif
endfor
deami














