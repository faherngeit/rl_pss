function ExtractCOMTRADE(path, options)
arguments
    path char
    options.zip_path char = '/T-100'
    options.data_path char = '/Data'
    options.sandbox char = '/sandbox'
end

zip_path = [path, options.zip_path];
data_path = [path, options.data_path];
sand_path = [path, options.sandbox];

if not(isfolder(data_path))
    mkdir(data_path)
end
if not(isfolder(sand_path))
    mkdir(sand_path)
end

archives = dir(zip_path);
counter = 0;
for file = 1:length(archives)
    if length(archives(file).name) > 3 && strcmpi(archives(file).name(end-2:end), 'zip')
       list = unzip([zip_path,'/', archives(file).name], sand_path);
       for doc = 1:length(list)
           type = list{doc}(end-2:end);
           if strcmpi(type, 'cfg') 
               counter = counter + 1;
               name = sprintf('Exp_%i.%s', counter, type);
               copyfile(list{doc}, [data_path,'/',name]);
           end
           if strcmpi(type, 'dat')
               name = sprintf('Exp_%i.%s', counter, type);
               copyfile(list{doc}, [data_path,'/',name]);
           end
       end
    end
end
delete([sand_path,'/*']);
rmdir(sand_path);

