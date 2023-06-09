clear;
a = zeros(1, 2);
mu = 0;
sigma = 0.001;

iterations = 1000;

for i = 1 : iterations
    if (i < 100)
        mu = 2;
        sigma = 1;
    elseif ((100 <= i) && (i < 200))
        mu = 2;
        sigma = 1;
    elseif ((200 <= i) && (i < 300))
        mu = 2.5;
        sigma = 1;
    elseif ((300 <= i) && (i < 400))
        mu = 2;
        sigma = 0.7;
    elseif ((400 <= i) && (i < 500))
        mu = 1.3;
        sigma = 0.3;
    elseif ((500 <= i) && (i < 600))
        mu = 1;
        sigma = 0.5;
    elseif ((600 <= i) && (i < 700))
        mu = 0.8;
        sigma = 0.3;
    elseif ((700 <= i) && (i < 900))
        mu = 0.4;
        sigma = 0.2;
    elseif ((900 <= i) && (i < 1000))
        mu = 0.15;
        sigma = 0.05;
    else
        mu = 0.2;
        sigma = 0.1;
    end

    a(i) = normrnd(mu, sigma);
    if ((a(i) < 0) && (i < 400))
        a(i) = -a(i);
    end
end

p = plot(1:iterations, a, 'Color', "none", 'Marker','o', 'MarkerFaceColor', "#0072BD");
grid on;
grid minor;
axis([0 1100 -2 2])


% for i = 1 : iterations
%     if (i < 100)
%         mu = 7;
%         sigma = 3;
%     elseif ((100 <= i) && (i < 200))
%         mu = 5;
%         sigma = 1;
%     elseif ((200 <= i) && (i < 300))
%         mu = 3;
%         sigma = 1;
%     elseif ((300 <= i) && (i < 400))
%         mu = 2.5;
%         sigma = 0.7;
%     elseif ((400 <= i) && (i < 500))
%         mu = 2;
%         sigma = 0.5;
%     elseif ((500 <= i) && (i < 800))
%         mu = 1;
%         sigma = 0.5;
%     elseif ((100 <= i) && (i < 1000))
%         mu = 0.7;
%         sigma = 0.2;
%     else
%         mu = 0.5;
%         sigma = 0.1;
%     end
%     a(i) = normrnd(mu, sigma);
% end