function Rest = check_window_rest(Satur_current, simDesc, param, options)
arguments
    Satur_current
    simDesc
    param
    options.save_fig double = 0
    options.folder string = 'images/'
end

Time = Satur_current.i_red.Time;
Ideal = Satur_current.i_red.Data;
Meas = Satur_current.i_sat.Data;

WinSamples = simDesc.en - simDesc.st + 1;
lim = (simDesc.st:simDesc.en);
lim_plt = (simDesc.st - 40:simDesc.en);
Tsw = Time(lim(1));

