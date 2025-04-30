% Load problem parameters
g  = 9.81; % gravitational force
% ======================= TASK 3 Calculate and plot f(c) in Figure 1 =======================
% Defining vector parameters
h = 0.025; 
alpha = 0 : h : 0.35; % Put a range of alpha here for plotting the error (f(alpha)) in figure 1
alpha_est = zeros(1, 20); % Initialise alpha_est so you can use it later if you want

% Initializing other parameters
m = 80;
zeroVect = zeros(size(alpha));
error = zeros(size(alpha));
dError = zeros(size(alpha));
index = find(alpha == 0.2); 
x =  parError(0.2, g)
% Use the function parError to determine the error for various values of alpha

% Plotting the curve of f(c) versus c
% Remember that we are plotting these things in figure(1)
h1 = figure(1);
hold on; 
% Plot things here
plot(alpha, parError(alpha, g), 'r', 'linewidth', 3);
plot(alpha, zeroVect, 'k', 'linewidth', 3);
plot(0.2, x, 'b.', 'MarkerSize', 20)

xlabel("Drag coefficient alpha", 'fontsize', 20);
ylabel("Error", 'fontsize', 20);
title("Error as a function of alpha", 'FontSize', 20);

grid on; 

axis([0 0.35 -0.2 1.2]);  % This will limit your axes to the values we want, we recommend that you leave this alone
% =====================================================================


% ========================== SOLVING THE ROOT (TASK 4) GOES HERE ==========================
% Newton-Raphson loop
% Set your termination conditions and your starting point c_est(1) = 8.0
maxIters = 20; % Change this! We suggest to use this to set the max iterations allowed
maxStepDiff = 0.001; %Change this! We suggest to use this to set the maximum step allowed
iteration = 1; % This is our suggested iteration counter
alpha_est(iteration) = 0.2; 
stepDiff = Inf; 
e_vec = zeros(size(alpha_est));
gradient = zeros(size(alpha_est));
n = 1:maxIters;

while ( (abs(stepDiff) > maxStepDiff) && (iteration < maxIters) ) % and this is our suggested loop
    %Calculate the function value at this estimate of alpha,  alpha_est(iteration)
    e_vec(iteration) =  parError(alpha_est(iteration), g);

    % Calculate the gradient
    gradient(iteration) = pardError(alpha_est(iteration), g);

    % Calculate the Update stepDiff
    stepDiff =  alpha_est(iteration +1) - alpha_est(iteration);
    
    % Apply the Newton-Rhapson update to alpha_est(iteration)
    alpha_est(iteration+1) = alpha_est(iteration) - (e_vec(iteration))/gradient(iteration);
  
    % Print out the current status of yourr iterations here
    fprintf('Current error, alpha, iteration = ', e_vec(iteration), alpha_est(iteration), iteration);
    
    
    % Increment the counter
    iteration = iteration + 1; 
    
 end % This ends the while loop. If you change the loop you might have to change this too.

% ========================== Plot your convergence curve here (Task 5) ==========================
% Plotting for figure 2
h2 = figure(2); % remember we want this curve to appear in Figure 2
hold on; 

e_vecSize4 = e_vec(1,4);

% plot code goes here
plot(n, abs(e_vecSize4), 'r-x', 'linewidth', 2);
xlabel("Iteration", 'fontsize', 20);
ylabel("Absolute Error", 'fontsize', 20);
title("Absolute error per iteration", 'FontSize', 20);

grid on; 

axis([1 4 0 0.5]);
% ============================================================================


% Test parError and pardError functions
% We are using this to test your functions hence they can't be changed
testParError  = parError(  0:0.05:0.5, 10 );
testPardError = pardError( 0:0.05:0.5, 10 );

% ============================== Local Student Functions ==============================

function error = parError(alpha, g) % calculates f(a)
% ================== TASK 1 CODE GOES HERE ===================
% Calculate the error given an estimate of alpha
    
    error = ((65*alpha)/g) - ( 1 - exp((alpha * 10)*-1));
    
end

function dError = pardError(alpha, g) % calculates the derivative of the error
% ================== TASK 2 CODE GOES HERE ===================
% Calculate the derivative of the error given an estimate of alpha
    
    dError = (65/g) - (10*exp((alpha * 10)*-1));
    
end
