clear all;
close all;
clc;

bits = [1 0 1 0 0 1 1 0 1 1 0];
bit_duration = 2;

fs = 100;
Total_time = length(bits) * bit_duration;   # time needed to send whole data
t = 0: 1/fs: Total_time-(1/fs);

# sender end
prv_state = -3
for i = 1 : length(bits)
    if bits(i) == 0
      nrzi(((i-1) * bit_duration * fs) + 1 : i * bit_duration * fs) = prv_state;
    else
      prv_state = -prv_state;
      nrzi(((i-1) * bit_duration * fs) + 1 : i * bit_duration * fs) = prv_state;
    endif
endfor

# ploting
plot(t, nrzi);
xticks([0: bit_duration: Total_time]);
yticks([-5: 2: 5]);
ylim([-5, 5]);
xlim([0, Total_time]);
grid on;
title("NRZ-I");
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
prv_found = ones(1, (bit_duration * fs)) .* 3;
for i = 1 : length(nrzi)/(bit_duration * fs)
    if nrzi(((i-1) * bit_duration * fs) + 1 : i * bit_duration * fs) == prv_found
        rcv_data(i) = 0;
    else
        rcv_data(i) = 1;
        prv_found = prv_found .* (-1);
    endif
endfor

disp(rcv_data);
