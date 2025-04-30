
close all;
clear;

% Initialise your variables
%coefficients which express the diffusion rate between the layers of ocean:
k12 = 0.58;
k21 = 1.87;

M = 280.00; 
m1 = 87.5;
m2 = M - m1;

% Task 1: Functions that return derivatives
lowerOcean(k12, k21, m1, m2);
upperOcean(k12, k21, m1, m2);

% Task 2: Solve over a time interval
h_3 = 0.25; %3 months
t_3 = 0 : h_3 : 5;
N = length(t_3);

 m1_e3 = zeros(size(t_3));
 m2_e3 = zeros(size(t_3));

m1_e3(1) = m1;
m2_e3(1) = m2;

for k = 2:N
    dm1dt = lowerOcean(k12, k21, m1_e3(k-1), m2_e3(k-1));
    dm2dt = upperOcean(k12, k21, m1_e3(k-1), m2_e3(k-1));
    h = t_3(k) - t_3(k-1);
    m1_e3(k) = m1_e3(k-1) + dm1dt*h; 
    m2_e3(k) = m2_e3(k-1) + dm2dt*h;
end

%concentration of phosphorus at t= 3
index = find(t_3 == 3);
m1pe = m1_e3(index); %lowerOcean(k12, k21, m1_e3(index), m2_e3(index));
m2pe = m2_e3(index); %upperOcean(k12, k21, m1_e3(index), m2_e3(index));

% Task 3: Solve over a time interval
h_1 = 1/12; %1 month
t_1 = 0 : h_1 : 5;
N_2 = length(t_1);

 m1_e1 = zeros(size(t_1));
 m2_e1 = zeros(size(t_1));

m1_e1(1) = m1;
m2_e1(1) = m2;

for k = 2:N_2
    dm1dt = lowerOcean(k12, k21, m1_e1(k-1), m2_e1(k-1));
    dm2dt = upperOcean(k12, k21, m1_e1(k-1), m2_e1(k-1));
    h = t_1(k) - t_1(k-1);
    m1_e1(k) = m1_e1(k-1) + dm1dt*h; 
    m2_e1(k) = m2_e1(k-1) + dm2dt*h; 
end

% Task 4: Plot previous 2 task values

figure (1);
plot (t_3, m1_e3,'b+-',t_3, m2_e3, 'b+-');
shg;
hold on;
plot (t_1, m1_e1,'g.-',t_1, m2_e1, 'g.-');
shg;

% figure(1)
% hold on;
% plot(t_3, m1_e3,'b-+', t_3, m2_e3, 'b-+');
% plot(t_1, m1_e1, 'g-.', t_1, m2_e1, 'g-.', 'MarkerSize', 8);

% Task 5: Plot after change in temperature
new_k12 = k12 + k12*0.05;

 m1_e1_hot = zeros(size(t_1));
 m2_e1_hot = zeros(size(t_1));

m1_e1_hot(1) = m1;
m2_e1_hot(1) = m2;

for k = 2:N_2
    dm1dt = lowerOcean(new_k12, k21, m1_e1_hot(k-1), m2_e1_hot(k-1));
    dm2dt = upperOcean(new_k12, k21, m1_e1_hot(k-1), m2_e1_hot(k-1));
    h = t_1(k) - t_1(k-1);
    m1_e1_hot(k) = m1_e1_hot(k-1) + dm1dt*h; 
    m2_e1_hot(k) = m2_e1_hot(k-1) + dm2dt*h; 
end

figure (2);
plot (t_1, m1_e1,'kx-',t_1, m2_e1, 'kx-');
shg
hold on;
plot (t_1, m1_e1_hot,'r.-',t_1, m2_e1_hot, 'r.-', 'MarkerSize', 8.0);
shg;

% figure(2)
% hold on;
% plot(t_1, m1_e1,'k-x', t_1, m2_e1, 'k-x');
% plot(t_1, m1_e1_hot, 'r-.', t_1, m2_e1_hot, 'r-.', 'MarkerSize', 8);

% Task 6
%before change: 
index = find(t_1 == 3);
m_1 = m1_e1(index);
m_2 = m2_e1(index);

%after change: 
m_bot1 = m1_e1_hot(index);
m_bot2 = m2_e1_hot(index);

%perc_change = 100 * (m_bot - m)/m; 
m1_change_hot = 100 * abs(m_bot1 - m_1)/m_1;
m2_change_hot = 100 * abs(m_bot2 - m_2)/m_2;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This tests your functions. Do not change this
testdata = rand(4, 1);
uppertest = upperOcean(testdata(1), testdata(2), testdata(3), testdata(4));
lowertest = lowerOcean(testdata(1), testdata(2), testdata(3), testdata(4));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Function definitions go below here
% You can edit these as you like. Note that you should use better 
% names for the arguments so that they make sense 
% And remember that the arguments have to be in the same order and with the 
% same meaning as in the lab description

function output = lowerOcean(a, b, c, d)
  output = -a * c + b * d ;
end

function output = upperOcean(a, b, c, d)
  output = a * c - b * d;
end
