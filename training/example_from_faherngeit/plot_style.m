function plot_style(data, Desc, varargin)
FSize = 20;
FType = 'Times New Roman';
LineWidth = 2;

Height = 600;
Scale = 16 / 9;
Width = round(Height * Scale);
pr_flag = 0;

if ~isempty(varargin) && varargin{1}
    try
        folder = varargin{2};
    catch
        folder = 'images/';
    end
    pr_flag = 1;
end

if pr_flag
    f = figure('Name','Sample plot', 'Visible', 'off');
else
    f = figure('Name','Sample plot');
end


f.Position(3:4) = [Width  Height];
plot(data,'LineWidth',LineWidth);
ax = gca;

ax.FontSize = FSize;
ax.FontName = FType;
pos = [0.07, 0.09, 0.9, 0.88];
set(ax, 'Position', pos)

grid on;
grid minor;

title(ax, '');
xlim(ax, [min(data.Time), max(data.Time)]);
% legend(ax, {'Нормальный ток'},'Location','north', 'FontSize', FSize, 'FontName', FType, 'NumColumns',3);
xlabel('Время, с', 'FontSize', FSize, 'FontName', FType)
ylabel('Ток, А', 'FontSize', FSize, 'FontName', FType)

anno = sprintf(' Кратность тока КЗ = %i\n Фаза начала КЗ = %i\n Смещение фазы тока = %i', ...
    Desc.Fault_rate, Desc.Fault_angle, Desc.Fault_angle_shift);
annotation('textbox',[.08 0.1 .3 .2], 'String',anno,'FitBoxToText','on', 'FontSize', FSize, 'FontName', FType, 'EdgeColor','none');

if pr_flag
    print(f, [folder, Meas.Name,'.svg'], '-r300','-dsvg');
    close(f);
end

end