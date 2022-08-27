function configurationStruct = jsonDataExtract(jsonFile)

fid = fopen(jsonFile);
raw = fread(fid, inf);
str = char(raw');
fclose(fid);

configurationStruct = jsondecode(str);
end

