function DataOut = StatEnt2D(Data)

DRows = size(Data, 1);

DataOut = zeros(DRows,1);

for i= 1:DRows
    DataOut(i) = sum(abs((Data(i,:).*log2(1./Data(i,:)))).^2);
end

