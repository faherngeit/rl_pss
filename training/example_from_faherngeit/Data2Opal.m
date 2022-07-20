function opalVar = Data2Opal(Data, options)
arguments
    Data
    options.save double = 0
    options.file_name = 'opVar.mat'
    options.folder = ''
end
opalVar(1,:) = Data.Nominal.Time';
opalVar(2,:) = Data.Nominal.Data';
opalVar(3,:) = Data.Saturated.Data';
opalVar(4,:) = Data.Restored.Data(1,:)';
opalVar(5,:) = Data.Control.Data';


if options.save
    save([options.folder, options.file_name], 'opalVar');
end