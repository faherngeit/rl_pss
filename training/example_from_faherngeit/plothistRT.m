function plothistRT(stats, options)
arguments
    stats
    options.path = ''
    options.save = 0
end

MagRes = rmmissing([stats(:,2).meanArrRest]);
PhaseRes = rmmissing([stats(:,3).meanArrRest]);

MagSat = rmmissing([stats(:,2).meanArrSat]);
PhaseSat = rmmissing([stats(:,3).meanArrSat]);

figure('Name','Mag distribution');
h_Mag = histogram(MagRes, 100, 'Normalization','pdf');
hold on;
histogram(MagSat, 100, 'Normalization','pdf');
legend(h_Mag.Parent, 'Погрешность восстановленния','Погрешность при насыщении'); 
set_hist_param(h_Mag);

figure('Name','Full distribution');
h_Phase = histogram(PhaseRes, 1000, 'Normalization','pdf');
hold on;
histogram(PhaseSat, 1000, 'Normalization','pdf');
legend(h_Phase.Parent, 'Погрешность восстановленния','Погрешность при насыщении');
set_hist_param(h_Phase);
xlim(h_Phase.Parent, [-5000,5000]);

if options.save
    print(h_Mag.Parent.Parent, [options.path,'rtDistributionMag','.svg'], '-r300','-dsvg');
    print(h_Phase.Parent.Parent, [options.path,'rtDistributionPhase', '.svg'], '-r300','-dsvg');
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
xlabel('Погрешность, %', 'FontSize', FSize, 'FontName', FType)