function dat = ReadBinRow(fileID, options)
arguments
    fileID
    options.Analogue double = 17
    options.Discrete double = 3
end

int32_wrd = options.Analogue + 2;
int16_wrd = ceil(options.Discrete / 16);

format_anlg = 'int';
format_disc = 'uint16';

dat = zeros(1,int32_wrd + options.Discrete);
for i = 1:int32_wrd
        dat(i) = fread(fileID,1, format_anlg);
end
disc = fread(fileID, 1, format_disc);
dat(i+1:end) = parseDisc(disc, options.Discrete);


function disc = parseDisc(bin, num)
sz = 16;
bin_str = dec2bin(bin, sz);
disc = zeros(1,num);
for i = 1:num
    disc(i) = str2double(bin_str(sz - num + i));
end