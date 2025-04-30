close all
% clear This line is normally compulsory in Matlab scripts but in the matlab Grader it invalidates
%       testing. So it is commented out here. In your submitted assignments, all scripts _must_
%       start with both "close all" and "clear".

% Set parameters for the problem
g = 9.81;
m = 80;
% Create time vector
h = 0.01; 
t = 0 : h : 12; % This is wrong, fix it.
v = zeros(size(t));

point = find(t == 10);
v(point) = 65; 
% Put the 3 values of alpha into a vector just for neatness
alpha = [5 10 20] / 80;

% Plot the various curves
% Remember that you must create a handle for figure 1 called "handle_1"
handle_1 = figure(1);
% Your plot curves go in here (The first one is already right)
plot(t, parachuteVelocity( alpha(1), g, t), 'r', 'linewidth', 2 );
hold on;
plot(t, parachuteVelocity(alpha(2), g, t), 'g', 'linewidth', 2);
plot(t, parachuteVelocity(alpha(3), g, t), 'b', 'linewidth', 2);
% Now plot the black asterix in the right place and the right size
plot( t(point), v(point), 'k*', 'MarkerSize', 10);
% Now label the x and y axis
xlabel('Time [s]', 'fontsize', 20);
ylabel("Velocity [m/s]", 'fontsize', 20);
% Finally the legend
legend({'alpha = 5/80', 'alpha = 10/80', 'alpha = 20/80'}, 'location', 'southeast','fontsize', 14);

grid on;

function v = parachuteVelocity(alpha, g, t)
    v = (g / alpha) * ( 1 - exp((alpha * t)*-1));% This is wrong fix it.
end
