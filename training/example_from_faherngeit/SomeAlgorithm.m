function [Rest, buffer_new] = SomeAlgorithm(window, buffer, params)
data = [buffer; window];
buffer_new = data(length(window)+1:end);

params.sample = 80;
params.frequency = 50;
params.Ts = 1 / params.sample / params.frequency;

time = getTime(data, params);
A = [ones(length(time),1), time', time.^2', time.^3', time.^4', time.^5'];
X = pinv(A) * data;

sim = A*X;
Rest = sim(end - length(window) + 1 : end);


function time = getTime(data, params)
% time = 0:params.Ts:params.Ts*(length(data) - 1);
time = 0:length(data) - 1;
