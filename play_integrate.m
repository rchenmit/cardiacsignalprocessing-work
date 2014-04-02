%% try a more robust integration of the SCG

%% one way: use gausssian smoothing:
% Generate sample data.
vector = 5*(1+cosd(1:3:180)) + 2 * rand(1, 60);
plot(vector, 'r-', 'linewidth', 3);
set(gcf, 'Position', get(0,'Screensize')); % Maximize figure.

% Construct blurring window.
windowWidth = int16(5);
halfWidth = windowWidth / 2
gaussFilter = gausswin(5)
gaussFilter = gaussFilter / sum(gaussFilter); % Normalize.

% Do the blur.
smoothedVector = conv(vector, gaussFilter)

% plot it.
hold on;
plot(smoothedVector(halfWidth:end-halfWidth), 'b-', 'linewidth', 3);



%% using  cumptrapz
cond_scgSt_EA = struct_this_subject_data_processed.cond_scgSt_EA{j};

figure
hold on
plot(cumtrapz(cond_scgSt_EA-mean(cond_scgSt_EA)), '-b')
plot(cumtrapz(cumtrapz(cond_scgSt_EA-mean(cond_scgSt_EA))-mean(cumtrapz(cond_scgSt_EA-mean(cond_scgSt_EA)))), '-r')

