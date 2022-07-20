function plotHB(varargin)
ColorSat = [0.75, 0.75, 0.75];
LineSat = 0.7;
Name = 'Hysteresis';
f = figure('Name', Name);
if length(varargin) == 1
    try
        plot(varargin{1}{end}(:,1), varargin{1}{end}(:,2),'b', LineWidth=2);
        hold on;
        for i = 1:length(varargin{1}) - 1
            plot(varargin{1}{i}(:,1), varargin{1}{i}(:,2), Color=ColorSat, LineWidth=LineSat);
        end
    catch
    end
    
else
    plot(varargin{end}(:,1), varargin{end}(:,2),'b', LineWidth=2);
    hold on;
    for i = 1:length(varargin) - 1
        plot(varargin{i}(:,1), varargin{i}(:,2), Color=ColorSat, LineWidth=LineSat);
    end
    
end

legend({'Кривая намагничивания модели'}, "Location","southeast")
hold off;
grid on;
grid minor;
xlim([0,600]);
ax = gca;
ax.FontName = 'Times';
ax.FontSize = 18;
ax.XLabel.String = 'Напряженность магнитного поля, А/м';
ax.YLabel.String = 'Магнитная индукция, Тл';

chH = get(ax,'Children');
set(ax, 'Children',[chH(end);chH(1:end-1)]);
hold off;

Height = 600;
Scale = 16 / 9;
Width = round(Height * Scale);
f.Position(3:4) = [Width  Height];
pos = [0.07, 0.1, 0.9, 0.9];
set(ax, 'Position', pos)
print(f, [Name,'.svg'], '-r300','-dsvg');

end