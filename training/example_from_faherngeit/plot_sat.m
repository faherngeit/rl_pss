function plot_sat(Meas, Desc, options)
arguments
    Meas
    Desc
    options.folder string = 'images/'
    options.save_fig double = 0
    options.steps double = []
end
FSize = 20;
FSizeAnno = 16;
FType = 'Times New Roman';
LineWidth = 2;

Height = 600;
Scale = 16 / 9;
Width = round(Height * Scale);

if options.save_fig
    f = figure('Name',Meas.Name, 'Visible', 'off');
else
    f = figure('Name',Meas.Name);
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
plot(Meas.Restored,'LineWidth',LineWidth);
grid on;
grid minor;

title(ax, '');
xlim(ax, [min(Meas.Nominal.Time), max(Meas.Nominal.Time)]);
legend(ax, {'Нормальный ток', 'Насыщенный ток', 'Восстановленный ток'},'Location','north', ...
'FontSize', FSize, 'FontName', FType, 'NumColumns',3, 'AutoUpdate', 'off');
xlabel('Время, с', 'FontSize', FSize, 'FontName', FType)
ylabel('Ток, А', 'FontSize', FSize, 'FontName', FType)

anno = sprintf(' Кратность тока КЗ = %i,\t Фаза начала КЗ = %i,\t Смещение фазы тока = %i, \t 1 \n MSE Насыщения = %0.2f,\t MSE Восстановления = %0.2f,\n Нагрузка = %i %%, \t Z = %0.2f + j%0.2f ', ...
    Desc.Fault_rate, Desc.Fault_angle, Desc.Fault_angle_shift, Meas.AccSat, Meas.AccRest,round(Desc.P * 100), Desc.R, Desc.X);
annotation(f, 'textbox',[.08 0.205 0.99 0.065], 'String',anno, 'FontSize', FSizeAnno, 'FontName', FType, 'EdgeColor','none','FitBoxToText','on');

annoCT = sprintf('Параметры ТТ: \\alpha = %0.2e,\t M_s = %0.2e,\t k = %0.2e, \t c = %0.2e, \t \\beta = %0.2f, \t a_1 = %i,\t a_2 = %i,\t a_3 = %i,\t b = %i', ... 
    Desc.CT.alpha, Desc.CT.Ms, Desc.CT.k, Desc.CT.c, Desc.CT.beta, Desc.CT.a1, Desc.CT.a2, Desc.CT.a3, Desc.CT.b);
annotation(f, 'textbox',[.08 0.001 0.9 0.065], 'String', annoCT , 'FontSize', FSizeAnno, 'FontName', FType, 'EdgeColor','none','FitBoxToText','on');

minmax(1) = min([min(Meas.Nominal.Data), min(Meas.Saturated.Data), min(Meas.Restored.Data)]);
minmax(2) = max([max(Meas.Nominal.Data), max(Meas.Saturated.Data), max(Meas.Restored.Data)]);

if ~isempty(options.steps)
    for id = 1:length(options.steps)
        plot_vline(f, options.steps(id), minmax);
    end
end

hold off;

if options.save_fig
    print(f, options.folder + Meas.Name + '.svg', '-r300','-dsvg');
    close(f);
end


function plot_vline(f, time, minmax)
    plot([time, time], minmax,'--', 'LineWidth',1, 'Color', [0.7, 0.7, 0.7])
