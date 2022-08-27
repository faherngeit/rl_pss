function [mArray] = pyList_to_mArray(pyList)
    pyListCell = cell(pyList);
    mArray = [pyListCell{:}];
end

