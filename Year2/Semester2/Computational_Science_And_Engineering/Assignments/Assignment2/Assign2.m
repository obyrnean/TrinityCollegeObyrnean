se all
clear
raw_data = xlsread('muscle_data_2023.xlsx'); %read in from document 
strain = raw_data(:, 3);
stress = raw_data(:, 4);
m = 1 : 5; %model orders
p = zeros(1, 5); %polynomial fit coefficients
sse_per_m = zeros (1, 5); %sum squared error vector
stress_1 = filloutliers (stress, "linear"); % solve for outliers, 
% corrupted measurements
% Task 1: Stress vs Starin curve without outliers
figure(1);
hold on;
part1 = plot(strain, stress_1, 'b', 'linewidth', 3);
xlabel('Strain');
ylabel('Stress (kPa)');
% Task 2: Fit data to a polynomial and plot the calculated sum squared 
% error for each model order
for k = 1: length(m)
 
p_coeff = polyfit(strain, stress_1, m(k)); %stores coefficients of 
 
% polynomial
 
p_values = polyval(p_coeff, strain); %calculates the values of the 
 
% previous polynomial
 
sse_per_m(k) = sum ((stress_1 - p_values) .^ 2); %sum squared error
end 
figure(2)
plot(m, sse_per_m, 'r', 'LineWidth', 3);
xlabel('Model Order');
ylabel('Sum Squqred Error');
min_indx = find(sse_per_m == min(sse_per_m)); %finds index of minimum 
% sse_per_m value
my_m = m(min_indx); %model order of minimum value
% Task 3: Calculate and plot estimated stress
N = length(strain);
est_stress = zeros(300, 1);
% 
% matrix initialisations:
% 
R = [N sum(strain) sum(strain .^ 2); sum(strain) sum(strain .^ 2) 
% sum(strain .^ 3); sum(strain .^ 2) sum(strain .^ 3) sum(strain .^ 4)];
% 
r = [sum(stress_1); sum(strain .* stress_1); 
% sum((strain .^ 2) .* stress_1)]; % sum((strain .^ 3) .* stress_1); 
% sum((strain .^ 4) .* stress_1)];
% 
a = R \ r;
% 
% for k = 1: 3 %looking at figrue 2, we can see that from point 3 to 5 
% its a straight line
% 
est_stress = est_stress + (strain .^ (k - 1)) .* a(k);
% end 
%looking at figrue 2, we can see that from point 3 to 5 its a straight line
 a = polyfit (strain, stress_1, m(3));
 est_stress = polyval (a, strain);
figure(1)
plot(strain, est_stress, 'r', 'LineWidth', 3);
% Task 4: Calculate error between estimate and observed stress
error_est = (stress_1 - est_stress);
error_s = sum (error_est .^ 2);
error_raw = stress_1 - mean (stress_1);
error_t = sum (error_raw .^ 2);
std_error = sqrt (error_s / (N - 2)); %standard error
nbins = 20; 
figure(3)
hist(error_est, nbins); 
xlabel('Error in Polynomial fit')
ylabel('Frequency')
h.FaceColor = 'b';
axis ([ - 0.2 0.6 0 150]);
r = sqrt ((error_t - error_s) / error_t); %correlation coefficient
ccoef_p = r ^ 2; %coefficient of determination
% Task 5: Use absolute error for best fit. 
p = @(a, x) a(1) + a(2) * x + a(3) * x .^ 2 + a(4) * x .^ 3 + a(5) * x .^ 4; 
%polynomial since our m is 5

initial_coef = [0.2, 0.2, 0.2, 0.2, 0.2]; %inital coefficients
funct = @(a) sum (abs (stress_1 - p (a, strain))); %function that finds 
% absolute error
coef_a = fminsearch(funct, initial_coef);
est_absStress = zeros(300, 1);
for k = 1: my_m
 
est_absStress = est_absStress + (strain .^ (k - 1)) .* coef_a(k);
end 
%correlation coefficient:
figure(1)
plot(strain, est_absStress, 'k--', 'LineWidth', 3);
% Task 6: Calculate Mean Sqaured Error for robust and Ls line fit. 
start = 25;
final = 70;
mse_nl = mean ((est_absStress(start : final) - stress_1(start : final)) .^ 2);
mse_ls = mean ((p_values(start : final) - stress_1(start : final)) .^ 2);
fprintf('MSE of LS fit = %f \n', mse_ls);
fprintf('MSE of Robust fit = %f', mse_nl);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The lines below here just check that you have addressed the variables
% required in the assignment.
%% Check my variables
if ( ~ exist ('a'))
 fprintf('\nVariable "a" does not exist.')
end;
if ( ~ exist ('mse_nl'))
 fprintf('\nVariable "mse_nl" does not exist.')
end;
if ( ~ exist ('mse_ls'))
 fprintf('\nVariable "mse_ls" does not exist.')
end;
if ( ~ exist ('ccoef_p'))
 fprintf('\nVariable "ccoef_p" does not exist.')
end;
if ( ~ exist ('est_stress'))
 fprintf('\nVariable "est_stress" does not exist.')
end;
if ( ~ exist ('my_m'))
 fprintf('\nVariable "my_m" does not exist.')
end;
if ( ~ exist ('sse_per_m'))
 fprintf('\nVariable "sse_per_m" does not exist.')
end;
fprintf('\n');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
