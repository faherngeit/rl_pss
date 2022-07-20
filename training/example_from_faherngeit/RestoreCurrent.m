function rest = RestoreCurrent(current, params, options)
arguments
    current
    params
    options.window_size double = 20
    options.buffer_size double = 2
    options.shift double = 0
end

% buffer = zeros(options.buffer_size, 1);
N_windows = floor(length(current) / options.window_size);
rest = zeros(1, N_windows * options.window_size);
Ilim = 1000;

RequiredParams = struct('SAT1', 0, 'SAT2', 0, 'Initial', 0, 'SAT3', 0);
SS = 0;

buffer = current(1:options.buffer_size * options.window_size);
rest(1:options.buffer_size *options.window_size) = buffer;
for stp = options.buffer_size + 1:N_windows
    st_id = (stp - 1) * options.window_size + 1;
    en_id = stp * options.window_size;
    wnd = current(st_id:en_id);
%     [rest_wnd, buffer] = SomeAlgorithm(wnd, buffer, params);
    try
        [rest_wnd, buffer, RequiredParams, SS] = TheMethod_V4(wnd, buffer, RequiredParams, SS);
    catch
        rest_wnd = wnd;
        hlp = [buffer;  wnd];
        buffer = hlp(options.window_size + 1:end);
    end
    ub = ones(options.window_size,1) * Ilim;
    lb = ones(options.window_size,1) * -Ilim;
    rwnd = rest_wnd(end - options.window_size + 1: end);
    rest(st_id:en_id) = min(max(rwnd, lb), ub);
end