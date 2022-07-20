function CTgrid = GetCTgrid(params)
[Data{9}, Data{8}, Data{7}, Data{6}, Data{5}, Data{4}, Data{3}, Data{2}, Data{1}] = ...
    ndgrid(params.b, params.a3, params.a2, params.a1, ...
    params.beta, params.c, params.k, params.Ms, params.alpha);
for i = 1:9
    Data{i} = reshape(Data{i},1,[]);
end
CTgrid = Data{1}';
for i = 2:9
    CTgrid = [CTgrid, Data{i}'];
end
