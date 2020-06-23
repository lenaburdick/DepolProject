fileID=fopen('TwoSidedSep20.txt','r')

formatSpec='%f'

A=fscanf(fileID, formatSpec)

FindLengthsofFilament2=A(1)
FindNumberofRuns2=A(2)
FindTimeMatrix2=A(3)
FindDiffCons2=A(4)
FindAverageTimeMatrix2=A(5)

LengthsofFilament2=A(FindLengthsofFilament2:FindNumberofRuns2-1)
NumberofRuns2=A(FindNumberofRuns2:FindTimeMatrix2-1)
TimeMatrix2=A(FindTimeMatrix2:FindDiffCons2-1)
DiffCons2=A(FindDiffCons2:FindAverageTimeMatrix2-1)
AverageTimeMatrix2=A(FindAverageTimeMatrix2:end)


TimeMatrix2=reshape(TimeMatrix2,LengthsofFilament2(end),size(LengthsofFilament2,1))'

figure(1)

x2=(1:LengthsofFilament2)
y2=TimeMatrix2
plot(x2,y2)

%--------------------------------------------------------------------------
fileID=fopen('OneSidedSep20.txt','r')

formatSpec='%f'

A=fscanf(fileID, formatSpec)

FindLengthsofFilament=A(1)
FindNumberofRuns=A(2)
FindTimeMatrix=A(3)
FindDiffCons=A(4)
FindAverageTimeMatrix=A(5)

LengthsofFilament=A(FindLengthsofFilament:FindNumberofRuns-1)
NumberofRuns=A(FindNumberofRuns:FindTimeMatrix-1)
TimeMatrix=A(FindTimeMatrix:FindDiffCons-1)
DiffCons=A(FindDiffCons:FindAverageTimeMatrix-1)
AverageTimeMatrix=A(FindAverageTimeMatrix:end)


TimeMatrix=reshape(TimeMatrix,LengthsofFilament(end),size(LengthsofFilament,1))'

figure(2)

x=(1:LengthsofFilament)
y=TimeMatrix
plot(x,y)
