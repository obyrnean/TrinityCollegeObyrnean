% Turbine parameters
r = 12;
v = 8;
rho = 1.225;

%
% PART 1: Calculate the power out with v = 8m/s
%
wind_power = (rho*pi*(r^2)*(v^3))/2;     % You change this line 

%
% PART 2: Calculate the power vector
%
r_vals = [1, 12, 24, 40, 60, 80, 100, 120, 200]; 
power_output = (rho*pi*(r_vals.^2)*(v^3))/2;   % You change this line

% Plot figure(1)
figure(1);          % You add plot after this line
plot(r_vals, power_output,'-*', 'color','red','LineWidth',3)
ylabel('Power (W)', 'FontSize', 20)
xlabel('Radius (m)','FontSize', 20)

%
% PART 3: Calculate ratio between calculations using "for loops" or "vector operations"
%
% Calculate speed difference by repeating this 2xxxx times, record operation time using tic-toc function.
% If you do something once in a computer, its going to be too fast to measure differences 
% So we are going to do the calculation with "for loops" and then "vector operations" 2000 times each
%   which will result in measurable times.
%
% First Calculate power output for all r_vals using a single vector operation to give power_output_a
M = 2000;  %This is the variable name for the number of times you want to do the operation

tstart_1 = tic; % This starts the clock in Matlab and puts the stoipwatch starttime in tstart
for n = 1 : M  % This is the loop for calculating the power_output_a "M"
   power_output_a = (rho*pi*(r_vals.^2)*(v^3))/2;
end
T_v = toc(tstart_1); %"vector computation" execution time % Here you have to figure out how to get the current stopwatch time and calculate the average time for execution of one calculation T_v. See[6]

% Calculate power output using "for" loops, to yield the vector power_output_f
power_output_f = zeros(); % This is the variable we are using to store the output 
tstart_2 = tic; % As above we have to start the stopwatch
for n = 1 : M  %Again we are doing this 2000 times
    for this_r = r_vals
        power_output_f = (rho*pi*(this_r^2)*(v^3))/2;
    end   % Now in here goes the calculation of the power output for each value in r_val, and you are going to use a "for" loop to do that
end
T_f = toc(tstart_2); %"for" loop execution time %And now read the stopwatch and measure the time for execution of one calculation  T_f

% Compute time ratio. This should be a nunmber bigger than 1 because "for" loops are slower than vector math 
ratio = T_f/T_v;       % replace 1/2 with the ratio we want between T_v and T_f
fprintf('Execution time ratio: for loop / array operation = %f \n', ratio);
