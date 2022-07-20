function [Satur_current, simDesc, restore_current] = TestRestoration(params)

[simParam, simDesc] = EstimSimParam(params);
Satur_current = parsim(simParam);
restore_current = check_restoration(Satur_current, simDesc, params, folder=params.folder);
visualise_res(restore_current, simDesc, save_fig=params.savefig, folder=params.folder);
