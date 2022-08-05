function outData = actionDelay(time, period, data, initPSS)
    if (time >= (period + 0.01))
        outData = data;
        return;
    end
    outData = initPSS;
end

