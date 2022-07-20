function plot_sat_shift(Meas, Desc, options)
arguments
    Meas
    Desc
    options.folder string = 'images/'
    options.save_fig double = 0
    options.history double = 40
end

FSize = 20;
FSizeAnno = 16;
FType = 'Times New Roman';
LineWidth = 2;
LineSat = 0.7;
LineEph = 1;
ColorSat = [0.75, 0.75, 0.75];
ColorMin = [0.4660 0.8 0.1880];
ColorMax = [0.6350 0.0780 0.1840];
ColorMed = [0.9290 0.6940 0.1250];

NamePostfix = ' Window drift';

Name = [Meas.Name , NamePostfix];

Height = 600;
Scale = 16 / 9;
Width = round(Height * Scale);

if options.save_fig
    f = figure('Name',Name, 'Visible', 'off');
else
    f = figure('Name', Name);
end


f.Position(3:4) = [Width  Height];
plot(Meas.Nominal,'--','LineWidth',LineWidth);
ax = gca;

ax.FontSize = FSize;
ax.FontName = FType;
% pos = get(ax, 'Position');
pos = [0.07, 0.15, 0.9, 0.8];
set(ax, 'Position', pos)

hold on;
plot(Meas.Saturated,'LineWidth',LineWidth);
grid on;
grid minor;

lim = (max(Desc.st - options.history, 1):Desc.en);
title(ax, '');
xlim(ax, [min(Meas.Nominal.Time(lim)), max(Meas.Nominal.Time(lim))]);
xlabel('Время, с', 'FontSize', FSize, 'FontName', FType)
ylabel('Ток, А', 'FontSize', FSize, 'FontName', FType)

medianId = GetMedianID([Meas.win_shft.RestErr]);

plot(Meas.win_shft(Meas.MinErrId).Data, Color=ColorMin, LineWidth=LineEph);
plot(Meas.win_shft(Meas.MaxErrId).Data, Color=ColorMax, LineWidth=LineEph);
plot(Meas.win_shft(medianId).Data, Color=ColorMed, LineWidth=LineEph);

legend(ax, {'Нормальный ток', 'Насыщенный ток', 'Лучший сценарий', 'Худший сценарий', 'Медиана'},'Location','north', ...
'FontSize', FSize, 'FontName', FType, 'NumColumns',5, 'AutoUpdate', 'off');

anno = sprintf(' Кратность тока КЗ = %i,\t Фаза начала КЗ = %i,\t Смещение фазы тока = %i, \t 1 \t MSE Насыщения = %0.1f,\n Среднее MSE Восстановления = %0.1f (Медиана = %0.1f, Min = %0.1f, Max = %0.1f),\n Нагрузка = %i %%, \t Z = %0.2f + j%0.2f ', ...
    Desc.Fault_rate, Desc.Fault_angle, Desc.Fault_angle_shift, Meas.AccSat, Meas.MeanErr, Meas.MedianErr, Meas.MinErrVal, Meas.MaxErrVal, round(Desc.P * 100), Desc.R, Desc.X);
annotation(f, 'textbox',[.08 0.205 0.99 0.065], 'String',anno, 'FontSize', FSizeAnno, 'FontName', FType, 'EdgeColor','none','FitBoxToText','on');

annoCT = sprintf('Параметры ТТ: \\alpha = %0.2e,\t M_s = %0.2e,\t k = %0.2e, \t c = %0.2e, \t \\beta = %0.2f, \t a_1 = %i,\t a_2 = %i,\t a_3 = %i,\t b = %i', ... 
    Desc.CT.alpha, Desc.CT.Ms, Desc.CT.k, Desc.CT.c, Desc.CT.beta, Desc.CT.a1, Desc.CT.a2, Desc.CT.a3, Desc.CT.b);
annotation(f, 'textbox',[.08 0.001 0.9 0.065], 'String', annoCT , 'FontSize', FSizeAnno, 'FontName', FType, 'EdgeColor','none','FitBoxToText','on');

for shft = 1:length(Meas.win_shft)
   plot(Meas.win_shft(shft).Data, Color=ColorSat, LineWidth=LineSat);
end

chH = get(ax,'Children');
set(ax, 'Children',[chH(end-1:end);chH(end-4);chH(end-2:-1:end-3);chH(1:end-5)]);

% plot(Meas.win_shft(Meas.MinErrId).Data, Color=ColorMin, LineWidth=LineEph);
% plot(Meas.win_shft(Meas.MaxErrId).Data, Color=ColorMax, LineWidth=LineEph);
% plot(Meas.win_shft(medianId).Data, Color=ColorMed, LineWidth=LineEph);

if options.save_fig
    print(f, options.folder + Name + '.svg', '-r300','-dsvg');
    close(f);
end