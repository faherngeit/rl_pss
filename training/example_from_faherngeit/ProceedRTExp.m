function ExpArray = ProceedRTExp(Desc, options)
arguments
    Desc
    options.path = '/'
    options.folder char = 'Data'
    options.name char = 'Exp'
    options.save_fig double = 0
    options.image_path char = 'images/'
end

path = [options.path, options.folder];
tic
fprintf('[%s] Searching for COMTRADES\n',datetime(now,'ConvertFrom','datenum'));
list = dir(path);
files = {};
for st = 1:length(list)
    name = split(list(st).name,'.');
    if contains(name{1}, options.name) && length(name) > 1 && strcmpi(name{2},'cfg')
        files{length(files) + 1} = name{1};
    end
end
fprintf('[%s] %i COMTRADES has been found in %s!\n',datetime(now,'ConvertFrom','datenum'), length(files), path);
fprintf('[%s] Reading and splitting COMTRADEs...\n',datetime(now,'ConvertFrom','datenum'));

SplitedData = [];
for file = 1:length(files)
    Data = Comtrade2Data([path,'/', files{file}]);
    SplitedData = [SplitedData, SplitData2Exps(Data)];
    fprintf('[%s] Proceed %i of %i steps\n',datetime(now,'ConvertFrom','datenum'), file, length(files));
end
toc

if options.save_fig && not(isfolder([options.path, '/', options.image_path]))
    mkdir([options.path, options.image_path])
end

image_path = [options.path, '/', options.image_path, '/'];
fprintf('[%s] Processig loaded data\n',datetime(now,'ConvertFrom','datenum'));
ExpArray = ProcessExps(SplitedData);

fprintf('[%s] Visualise results\n',datetime(now,'ConvertFrom','datenum'));

save_fig = options.save_fig;

D = parallel.pool.DataQueue;
afterEach(D, @msgLog);

stp = 0;
lim = min(length(ExpArray), length(Desc));
parfor exp = 1:lim
% for exp = 1:1
    name = sprintf('Exp %i', exp);
    plotRT(ExpArray(exp).Data(1,:), Desc(exp), instance=1, folder=image_path, ...
        Name=[name, ' Instance'], save_fig = save_fig);
    plotRT(ExpArray(exp).Data(2,:), Desc(exp), folder=image_path, ...
        Name=[name, ' Magnitude'], save_fig = save_fig);
    plotRT(ExpArray(exp).Data(3,:), Desc(exp), folder=image_path, ...
        Name=[name, ' Phase'], save_fig = save_fig, Y_Title='Угол, градусы');
    plotRT(ExpArray(exp).Data(4,:), Desc(exp), folder=image_path, ...
        Name=[name, ' Frequency'], save_fig = save_fig, Y_Title='Частота, Гц');
    send(D, exp);
end
ExpArray = ExpArray(1:lim);

if save_fig
    save([options.path, 'ExpArray.mat'], 'ExpArray');
end
fprintf('[%s] Completed!\n',datetime(now,'ConvertFrom','datenum'));
toc

function msgLog(~)
    stp = stp + 1;
    fprintf('[%s] Proceed %i of %i steps\n',datetime(now,'ConvertFrom','datenum'), stp, lim);
end
end