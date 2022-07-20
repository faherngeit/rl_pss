clear all
global L2 Ln R2 Rn w1 w2 s l a b c d ii A om phi T
L2 = 0;%0.99/314;%индуктивность вторичной обмотки, Гн
Ln = 0;%(1/314)*0.2;%индуктивность нагрузки ТТ, Гн
R2 = 0.48;%сопротивление вторичной обмотки, Ом
Rn = 0.96;%сопротивление нагрузки ТТ, Ом
w1 = 2; %число витков первичной
w2 = 239;%число витков вторичной обмотки
s = 19.1e-4;%17.5e-4;%%площадь сечения магнитопровода, м^2
l = 0.9;%0.67;%средняя длина магнитного пути, м
%коэффициенты кривой намагничивания
a = 10^-12; b=19.04; c=18.1; d=0.00001; ii=10.7;

% %задание массива времени
%%время окончания расчета, с    
tk = 0.06;
ts = 1/(80*50);%шаг расчета, с
ti = (0:ts:tk)';
n = 0:length(ti)-1;
%задание массива первичного тока
A = 11950;%15*848.53; %%амплитуда первичного тока, А
om = 2*pi*50;   %циклическая частота, рад/с
phi = -pi*45/180;%начальная фаза первичного тока, рад
T = 0.05;

% i1 = zeros(1,length(ti));

i1 = (1 * A * sin(om * ti + phi)) + 0.3 * A * exp(-ti / T);% + (0.5*A*sin(3*om*ti(i)+phi));%*(1+0.00*(2*rand(1,1)-1));


    Noise = (2 * rand(length(i1),1)-1) * 0.0 * 100;
%     Noise = randn(length(i1),1) * 0.00 * 100 / 3;

% plot(Norise); grid minor;

%начальные условия
Ba_0 = 1.5;%индукция
ia_0 = i1(1,1)*w1/w2; %вторичный ток
[t,Y]=ode45(@CT, ti, [Ba_0 ia_0]);
B2 = Y(:,1);
i2 = Y(:,2);

i2 = i2 + Noise;
%апроксимирующие функции 
H1=a*sinh(b.*B2)+c.*B2; %1)апроксимирующие функиции
H2=18.*B2+45e-8.*B2.^35; %2)апроксимирующие функиции
H3=d*sinh(ii*B2); 
i_m=(H3*l)/(w2);
h = figure(2);
subplot(2,1,1);
plot(n, i1/119.5,'k-', n, i2, 'b.-','linewidth',1.2);grid on; grid minor; %, vv((length(vv)-length(i2)+1):end), i2/100,'b-o',
ylabel('\it i, A'); xlabel('\it t, с'); legend('Токи'); %xlim([0 21]);
subplot(2,1,2);
plot(n, B2,'b-o', 'linewidth',1.2);grid on; grid minor;
ylabel('\it B, Тл'); xlabel('\it t, с'); legend('Маг индукция');
current = struct('Time',ti, 'Ideal', i1/119.5, 'Meas', i2);

function F=CT(tk,x)
global L2 Ln R2 Rn w1 w2 s l a b c d ii
F=zeros(2,1);
F(1)=(w2*x(2)*(R2+Rn)+(L2+Ln)*w1*di1(tk))/(w2*s*w2+...
(L2+Ln)*l*(d*ii*cosh(ii*x(1))));%(a*b*cosh(b*x(1))+c));%(18*x(1)+45e-8*x(1)^35));%                                   
F(2)=(-l*(d*ii*cosh(ii*x(1)))*x(2)*(R2+Rn)+w2...%(a*b*cosh(b*x(1))+c)*x(2)*(R2+Rn)+w2...%(18*x(1)+45e-8*x(1)^35)*x(2)*(R2+Rn)+w2...%  
*s*w1*di1(tk))/(w2*s*w2+(L2+Ln)*l*(d*ii*cosh(ii*x(1))));%(a*b*cosh(b*x(1))+c));%(18*x(1)+45e-8*x(1)^35));% 
end

function di1 = di1(t)
    global A om phi T
    di1 = om * 1 * A * cos(om * t + phi)- A * 0.3 / T * exp(-t / T);
end
