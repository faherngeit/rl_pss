function dat = ReadBinDat(fileID, options)
arguments
    fileID
    options.Analogue double = 17
    options.Discrete double = 3
    options.Length double = 83999
end

dat = zeros(options.Length, 2 + options.Analogue + options.Discrete);
% dat = zeros(options.Length, 20);
for i = 1:options.Length
    row = ReadBinRow(fileID, Analogue=options.Analogue, Discrete=options.Discrete);
    dat(i,:) = row; 
end

