function plotHyst(stats, options)
arguments
    stats
    options.path = ''
    options.save = 0
end
figure('Name','Mean distribution');
h_mean = histogram(stats.RelMean, 200, 'Normalization','pdf');
set_hist_param(h_mean);

figure('Name','Full distribution');
h_full = histogram(stats.Full, 200, 'Normalization','pdf');
set_hist_param(h_full);

figure('Name','Combine distribution');
h_sum = histogram(stats.RelMean, 50, 'Normalization','pdf');
set_hist_param(h_sum);
hold on;
histogram(stats.Full, 200, 'Normalization','pdf');
hold off;

if options.save
    print(h_mean.Parent.Parent, [options.path,'DistributionMean','.svg'], '-r300','-dsvg');
    print(h_full.Parent.Parent, [options.path,'DistributionFull', '.svg'], '-r300','-dsvg');
    print(h_sum.Parent.Parent, [options.path, 'DistributionBoth', '.svg'], '-r300','-dsvg');
    close all;
end


function set_hist_param(hist)
Height = 600;
Scale = 16 / 9;
Width = round(Height * Scale);
pos = [0.07, 0.15, 0.9, 0.8];

FSize = 20;
FSizeAnno = 16;
FType = 'Times New Roman';

hist.Parent.Parent.Position(3:4) = [Width  Height];

grid on;
grid minor;

ax = hist.Parent;
ax.FontSize = FSize;
ax.FontName = FType;
set(ax, 'Position', pos)
xlabel('Ненормированное значение MSE, о.е.', 'FontSize', FSize, 'FontName', FType)