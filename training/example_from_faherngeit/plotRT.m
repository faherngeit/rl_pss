function plotRT(Meas, Desc, options)
arguments
    Meas
    Desc
    options.folder string = 'images/'
    options.save_fig double = 0
    options.history double = 40
    options.future double = 30
    options.xlim double = [-0.02, 0.08]
    options.err_lim double = [1601:1921]
    options.instance double = 0
    options.Name char = 'Exp'
    options.Y_Title char = 'Ток, А'
end

FSize = 20;
FSizeAnno = 16;
FType = 'Times New Roman';
LineWidth = 2;
% LineSat = 0.7;
LineEph = 1;
% ColorSat = [0.75, 0.75, 0.75];
% ColorMin = [0.4660 0.8 0.1880];
% ColorMax = [0.6350 0.0780 0.1840];

Name = options.Name;

Height = 600;
Scale = 16 / 9;
Width = round(Height * Scale);

if options.save_fig
    f = figure('Name',Name, 'Visible', 'off');
else
    f = figure('Name', Name);
end


f.Position(3:4) = [Width  Height];
plot(Meas(1),'--','LineWidth',LineWidth);
ax = gca;

ax.FontSize = FSize;
ax.FontName = FType;
% pos = get(ax, 'Position');
pos = [0.07, 0.15, 0.9, 0.8];
set(ax, 'Position', pos)

hold on;
plot(Meas(2),'LineWidth',LineWidth);
plot(Meas(3),'LineWidth',LineWidth);
grid on;
grid minor;

% lim = (max(Desc.st - options.history, 1):Desc.en);
title(ax, '');
xlim(ax, options.xlim);
xlabel('Время, с', 'FontSize', FSize, 'FontName', FType)
ylabel(options.Y_Title, 'FontSize', FSize, 'FontName', FType)

legend(ax, {'Нормальный ток', 'Насыщенный ток', 'Восстановленный ток'},'Location','northoutside', ...
'FontSize', FSize, 'FontName', FType, 'NumColumns',5, 'AutoUpdate', 'off');

if options.instance == 1
    dSat = Meas(1).Data(options.err_lim) - Meas(2).Data(options.err_lim);
    ErrSat = dSat' * dSat;
    dRest =  Meas(1).Data(options.err_lim) - Meas(3).Data(options.err_lim) ;
    ErrRest = dRest' * dRest;
    anno = sprintf(' Кратность тока КЗ = %i,\t Фаза начала КЗ = %i,\t Смещение фазы тока = %i,\t1 \n MSE Насыщения = %0.1f,\t MSE Восстановления = %0.1f,\n Нагрузка = %i %%, \t Z = %0.2f + j%0.2f ', ...
        Desc.Fault_rate, Desc.Fault_angle, Desc.Fault_angle_shift, ErrSat, ErrRest, round(Desc.P * 100), Desc.R, Desc.X);
    annotation(f, 'textbox',[.08 0.205 0.99 0.065], 'String',anno, 'FontSize', FSizeAnno, 'FontName', FType, 'EdgeColor','none','FitBoxToText','on');
    
    annoCT = sprintf('Параметры ТТ: \\alpha = %0.2e,\t M_s = %0.2e,\t k = %0.2e, \t c = %0.2e, \t \\beta = %0.2f, \t a_1 = %i,\t a_2 = %i,\t a_3 = %i,\t b = %i', ...
        Desc.CT.alpha, Desc.CT.Ms, Desc.CT.k, Desc.CT.c, Desc.CT.beta, Desc.CT.a1, Desc.CT.a2, Desc.CT.a3, Desc.CT.b);
    annotation(f, 'textbox',[.08 0.001 0.9 0.065], 'String', annoCT , 'FontSize', FSizeAnno, 'FontName', FType, 'EdgeColor','none','FitBoxToText','on');
else
    meanNorm = GetLastMean(Meas(1), lim=options.err_lim);
    meanSat = GetLastMean(Meas(2), lim=options.err_lim);
    meanRest = GetLastMean(Meas(3), lim=options.err_lim);
    meanArrSat = (meanNorm - meanSat) / meanNorm * 100;
    meanArrRest = (meanNorm - meanRest) / meanRest * 100;
    
    anno = sprintf(' Кратность тока КЗ = %i,\t Фаза начала КЗ = %i,\t Смещение фазы тока = %i,\t1 \n Погрешность насыщения = %0.1f%%,\t Погрешность восстановления = %0.1f %%,\n Нагрузка = %i %%, \t Z = %0.2f + j%0.2f ', ...
        Desc.Fault_rate, Desc.Fault_angle, Desc.Fault_angle_shift, meanArrSat, meanArrRest, round(Desc.P * 100), Desc.R, Desc.X);
    annotation(f, 'textbox',[.08 0.205 0.99 0.065], 'String',anno, 'FontSize', FSizeAnno, 'FontName', FType, 'EdgeColor','none','FitBoxToText','on');
    
    annoCT = sprintf('Параметры ТТ: \\alpha = %0.2e,\t M_s = %0.2e,\t k = %0.2e, \t c = %0.2e, \t \\beta = %0.2f, \t a_1 = %i,\t a_2 = %i,\t a_3 = %i,\t b = %i', ...
        Desc.CT.alpha, Desc.CT.Ms, Desc.CT.k, Desc.CT.c, Desc.CT.beta, Desc.CT.a1, Desc.CT.a2, Desc.CT.a3, Desc.CT.b);
    annotation(f, 'textbox',[.08 0.001 0.9 0.065], 'String', annoCT , 'FontSize', FSizeAnno, 'FontName', FType, 'EdgeColor','none','FitBoxToText','on');    
end
hold off;

if options.save_fig
    print(f, options.folder + Name + '.svg', '-r300','-dsvg');
    close(f);
end


function mn = GetLastMean(data, options)
arguments
    data
    options.lim double = [2500, 3500]
end
mn = mean(data.Data(options.lim));