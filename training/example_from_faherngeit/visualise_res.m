function visualise_res(restore_current, simDesc, options)
arguments
    restore_current
    simDesc
    options.save_fig double = 0
    options.folder string = 'images/'
end
for i = 1:length(restore_current)
    plot_sat_shift(restore_current{i}, simDesc(i), save_fig=options.save_fig, folder=options.folder);
end