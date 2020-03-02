function DataOut = StatEner2D(Data)

DRows = size(Data, 1);

DataOut = zeros(DRows,1);

for i= 1:DRows
    DataOut(i) = sum((Data(i,:).^2));
end

