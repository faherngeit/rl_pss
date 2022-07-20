function restore_current = check_restoration(Satur_current, simDesc, param, options)
arguments
    Satur_current
    simDesc
    param
    options.folder string = 'logs/'
    options.log_file = 'log.txt'
    options.save_fig double = -1
end
tic

if options.save_fig  == -1
    save_fig = param.savefig;
else
    save_fig = options.save_fig;
end

log_path = options.folder + options.log_file;
logging = fopen(log_path,'w');
msg = [param.desc, '\n'];
fprintf(logging, msg);
fprintf('Current compensations starts!\n');

restore_current = cell(length(Satur_current), 1);

D = parallel.pool.DataQueue;
afterEach(D, @msgLog);

max_stp = length(Satur_current);
stp = 0;

parfor i = 1:length(Satur_current)
% for i = 1:1
    Time = Satur_current(i).i_red.Time;
    Ideal = Satur_current(i).i_red.Data;
    Meas = Satur_current(i).i_sat.Data;
    
    WinSamples = simDesc(i).en - simDesc(i).st + 1;
    name = sprintf('Exp # %i', i);
    lim = (simDesc(i).st:simDesc(i).en);
    Tsw = Time(lim(1));
    acc_sat = (Ideal(lim) - Meas(lim))' * (Ideal(lim) - Meas(lim)) / WinSamples;
    rest_cur = struct('Nominal',timeseries(Ideal, Time - Tsw, 'Name', 'Nominal'), ...
        'Saturated', timeseries(Meas, Time - Tsw, 'Name', 'Saturated'), ...
        'Name', name, 'AccSat', acc_sat);
    
    Rest = arrayfun(@(x)struct('Data',x, 'RestErr', x), zeros(1,param.Nsmp_wnd));
    for shft = 1:param.Nsmp_wnd
%         try
            rest = RestoreCurrent(Meas(shft:end), [], buffer_size=3);
%         catch
%             if login == 0
%                 fprintf('Произошла ошибка! См. лог %s \n', log_path);
%                 login = 1;
%             end
%             fprintf(logging, "Ошибка в %i опыте на %i смещении\n",i, shft);
%             rest = zeros(1, length(Meas(shft:end)));
%             rest = Meas(shft:end)';
%         end
        acc_rest = (Ideal(lim) - rest(lim - shft)')' * (Ideal(lim) - rest(lim - shft)')/ WinSamples;
        Rest(shft).Data = timeseries(rest, Time(shft:min(shft + length(rest) - 1, length(Time))) - Tsw, 'Name', 'Restored');
        Rest(shft).RestErr = acc_rest;
    end
        [min_val, min_id] = min([Rest.RestErr]);
        [max_val, max_id] = max([Rest.RestErr]);
    rest_cur.win_shft = Rest;
    rest_cur.MeanErr = mean([Rest.RestErr]);
    rest_cur.MedianErr = median([Rest.RestErr]);
    rest_cur.MinErrVal = min_val;
    rest_cur.MinErrId = min_id;
    rest_cur.MaxErrVal = max_val;
    rest_cur.MaxErrId = max_id;
    
    restore_current{i} = rest_cur;
    send(D, i);
end

toc;

function msgLog(~)
    stp = stp + 1;
    fprintf('[%s] Proceed %i of %i steps\n',datetime(now,'ConvertFrom','datenum'), stp, max_stp);
end
end

