function [H, M, B] = GetSatCurve(varargin)
mu0 = 4*pi*1e-7;
delta = 1;
if length(varargin) > 1
    alpha = varargin{1};
    Ms = varargin{2};
    k = varargin{3};
    c = varargin{4};
    beta = varargin{5};
    a1 = varargin{6};
    a2 = varargin{7};
    a3 = varargin{8};
    b = varargin{9};
else
    try
        alpha = varargin{1}.alpha;
        Ms = varargin{1}.Ms;
        k = varargin{1}.k;
        c = varargin{1}.c;
        beta = varargin{1}.beta;
        a1 = varargin{1}.a1;
        a2 = varargin{1}.a2;
        a3 = varargin{1}.a3;
        b = varargin{1}.b;
    catch
        alpha = varargin{1}(1);
        Ms = varargin{1}(2);
        k = varargin{1}(3);
        c = varargin{1}(4);
        beta = varargin{1}(5);
        a1 = varargin{1}(6);
        a2 = varargin{1}(7);
        a3 = varargin{1}(8);
        b = varargin{1}(9);
    end
end
H = linspace(0,2000,10000);
M = zeros(size(H));
B = zeros(size(H));
for i =2:length(H)
    He = H(i)+alpha*M(i);
    M_an = Ms*(a1*He+He^b)/(a3+a2*He+He^b);
    dM_an = Ms*(a1*a3+b*a3*He^(b-1)+(b-1)*(a2-a1)*He^b)/(a3+a2*He+He^b)^2;
    MMan = M_an-M(i-1);
    km = k*(1-beta*(M(i)/Ms));
    dM = (c*dM_an+(MMan/(delta*km/mu0-(alpha*MMan)/(1-c))))/(1-alpha*c*dM_an);
    M(i) = M(i-1)+dM*(H(i)-H(i-1));
    B(i) = mu0*(H(i)+M(i));
end
end