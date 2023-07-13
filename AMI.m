clear all;
close all;
clc;

bits = [1 0 1 0 0 1 1 0 1 1];
bit_duration = 2;

fs = 100;
Total_time = length(bits) * bit_duration;   # time needed to send whole data
t = 0: 1/fs: Total_time-(1/fs);

# sender end
prv_one_bit_state = -3;
for i = 1 : length(bits)
  if bits(i) == 0
    ami(((i-1) * bit_duration * fs) + 1 : i * bit_duration * fs) = zeros(1, (fs * bit_duration));
  else
    prv_one_bit_state = -prv_one_bit_state;
    ami(((i-1) * bit_duration * fs) + 1 : i * bit_duration * fs) = ones(1,(fs * bit_duration)) .* prv_one_bit_state;
  endif
endfor

# ploting
plot(t, ami);
xticks([0: bit_duration: Total_time]);
yticks([-5: 2: 5]);
ylim([-5, 5]);
xlim([0, Total_time]);
grid on;
title("Bipolar AMI");
xlabel("Time");
ylabel("Amplitude");
line ([0, Total_time], [0 0], "linestyle", "--", "color", "r");

% Top axis
ax1=gca;
ax2 = axes('Position', get(ax1, 'Position'), 'Color', 'none');
set(ax2, 'XAxisLocation', 'top');
set(ax2, 'XLim', get(ax1, 'XLim'));
set(ax2, 'YLim', get(ax1, 'YLim'));
set(ax2, 'XTick', [bit_duration/2: bit_duration: Total_time]);
set(ax2, 'YTick', [-5: 2: 5]);
set(ax2, 'XTickLabel', bits);
set(ax2, 'XLabel', 'Data bits');


# receiver end
for i = 1 : length(ami)/(bit_duration * fs)
  if ami(((i-1) * bit_duration * fs) + 1 : i * bit_duration * fs) == zeros(1, (fs * bit_duration))
    rcv_data(i) = 0;
  else
    rcv_data(i) = 1;
  endif
endfor

disp(rcv_data);
