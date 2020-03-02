clear all; close all;

%% Import Method 1
% %% Import Data
% %Particular to the provided datasets for class
% %Code taken from the MATLAB auto-generated script
% 
% % Setup the Import Options
% opts = spreadsheetImportOptions("NumVariables", 2);
% 
% % Specify sheet and range
% opts.Sheet = "Normal";
% opts.DataRange = "A2:B65536";
% 
% % Specify column names and types
% opts.VariableNames = ["VarName1", "VarName2"];
% opts.VariableTypes = ["double", "double"];
% 
% % Import the data
% Normal = readtable("Normal.xls", opts, "UseExcel", false);
% opts.Sheet = "Data1";
% F1 = readtable("F1.xls", opts, "UseExcel", false);
% opts.Sheet = "Data2";
% F2 = readtable("F2.xls", opts, "UseExcel", false);
% % Clear temporary variables
% clear opts

%% Import Method 2
% Normal  = importfile('Normal.xls','Normal',1,65536);
% F1      = importfile('F1.xls','Data1',1,65536);
% F2      = importfile('F2.xls','Data2',1,65536);

%% Convert data from table to array
% t = table2array(Normal(:,1)).';
% 
% DataN = table2array(Normal(:,2)).';
% DataF1 = table2array(F1(:,2))';
% DataF2 = table2array(F2(:,2))';

%% Import Method 3
load('GivenData.mat')

%% WPT
level   = 8;
fs      = 1/(t(2)-t(1));
DLength = length(t);

wptN  = wpdec(DataN,level,'haar');
wptF1 = wpdec(DataF1,level,'haar');
wptF2 = wpdec(DataF2,level,'haar');

%% Plotting the Spectrums
[SpecN,TimeN,FreqN] = wpspectrum(wptN,fs,'plot');
title('Normal')

figure;
[SpecF1,TimeF1,FreqF1] = wpspectrum(wptF1,fs,'plot');
title('F1')

figure;
[SpecF2,TimeF2,FreqF2] = wpspectrum(wptF2,fs,'plot');
title('F2')

%% Extracting Coefficients

NCof  = zeros (2^level, DLength/(2^level));
F1Cof = zeros (2^level, DLength/(2^level));
F2Cof = zeros (2^level, DLength/(2^level));

for i = 0:((2^level) - 1)

    NCof(i+1,:)  = wpcoef(wptN, [level i]);
    F1Cof(i+1,:) = wpcoef(wptF1, [level i]);
    F2Cof(i+1,:) = wpcoef(wptF2, [level i]);
    
end


%% Feature Extraction

NFeatures = 17;
NDataSets = 3;

rmsN  = rms(NCof,2);
meanN = mean(NCof,2);
stdN  = std(NCof,0,2);
kurN  = kurtosis(NCof,1,2);
skwN  = skewness(NCof,1,2);
enrN  = StatEner2D(NCof);
entN  = StatEnt2D(NCof);
varN  = var(NCof,0,2);
harN  = harmmean(NCof,2);
% geoN  = geomean(NCof,2); Geomean function does not accept negative values
geoN  = geomean(abs(NCof),2);
mm2N  = moment(NCof,2,2);
mm3N  = moment(NCof,3,2);
mm4N  = moment(NCof,4,2);
mm5N  = moment(NCof,5,2);
p2pN  = peak2peak(NCof,2);
prmN  = peak2rms(NCof,2);
maxN  = max(NCof,[],2);


rmsF1  = rms(F1Cof,2);
meanF1 = mean(F1Cof,2);
stdF1  = std(F1Cof,0,2);
kurF1  = kurtosis(F1Cof,1,2);
skwF1  = skewness(F1Cof,1,2);
enrF1  = StatEner2D(F1Cof);
entF1  = StatEnt2D(F1Cof);
varF1  = var(F1Cof,0,2);
harF1  = harmmean(F1Cof,2);
geoF1  = geomean(abs(F1Cof),2);
mm2F1  = moment(F1Cof,2,2);
mm3F1  = moment(F1Cof,3,2);
mm4F1  = moment(F1Cof,4,2);
mm5F1  = moment(F1Cof,5,2);
p2pF1  = peak2peak(F1Cof,2);
prmF1  = peak2rms(F1Cof,2);
maxF1  = max(F1Cof,[],2);

rmsF2  = rms(F2Cof,2);
meanF2 = mean(F2Cof,2);
stdF2  = std(F2Cof,0,2);
kurF2  = kurtosis(F2Cof,1,2);
skwF2  = skewness(F2Cof,1,2);
enrF2  = StatEner2D(F2Cof);
entF2  = StatEnt2D(F2Cof);
varF2  = var(F2Cof,0,2);
harF2  = harmmean(F2Cof,2);
geoF2  = geomean(abs(F2Cof),2);
mm2F2  = moment(F2Cof,2,2);
mm3F2  = moment(F2Cof,3,2);
mm4F2  = moment(F2Cof,4,2);
mm5F2  = moment(F2Cof,5,2);
p2pF2  = peak2peak(F2Cof,2);
prmF2  = peak2rms(F2Cof,2);
maxF2  = max(F2Cof,[],2);

NClmn((1:2^level),1)  = 0;
F1Clmn((1:2^level),1) = 1;
F2Clmn((1:2^level),1) = 2;

%% Throwing away first datapoint

% rmsN  = rmsN(2:2^level);
% meanN = meanN(2:2^level);
% stdN  = stdN(2:2^level);
% kurN  = kurN(2:2^level);
% skwN  = skwN(2:2^level);
% enrN  = enrN(2:2^level);
% entN  = entN(2:2^level);
% varN  = varN(2:2^level);
% 
% rmsF1  = rmsF1(2:2^level);
% meanF1 = meanF1(2:2^level);
% stdF1  = stdF1(2:2^level);
% kurF1  = kurF1(2:2^level);
% skwF1  = skwF1(2:2^level);
% enrF1  = enrF1(2:2^level);
% entF1  = entF1(2:2^level);
% varF1  = varF1(2:2^level);
% 
% rmsF2  = rmsF2(2:2^level);
% meanF2 = meanF2(2:2^level);
% stdF2  = stdF2(2:2^level);
% kurF2  = kurF2(2:2^level);
% skwF2  = skwF2(2:2^level);
% enrF2  = enrF2(2:2^level);
% entF2  = entF2(2:2^level);
% varF2  = varF2(2:2^level);

%% Consolidating Data
%AllFeatures = zeros(2^level, NFeatures*NDataSets);

rmsAll  = [rmsN;rmsF1;rmsF2];
meanAll = [meanN;meanF1;meanF2];
stdAll  = [stdN;stdF1;stdF2];
kurAll  = [kurN;kurF1;kurF2];
skwAll  = [skwN;skwF1;skwF2];
enrAll  = [enrN;enrF1;enrF2];
entAll  = [entN;entF1;entF2];
varAll  = [varN;varF1;varF2];
harAll  = [harN;harF1;harF2];
geoAll  = [geoN;geoF1;geoF2];
mm2All  = [mm2N;mm2F1;mm2F2];
mm3All  = [mm3N;mm3F1;mm3F2];
mm4All  = [mm4N;mm4F1;mm4F2];
mm5All  = [mm5N;mm5F1;mm5F2];
p2pAll  = [p2pN;p2pF1;p2pF2];
prmAll  = [prmN;prmF1;prmF2];
maxAll  = [maxN;maxF1;maxF2];

VarClmn = [NClmn;F1Clmn;F2Clmn];
AllFeatures = [rmsAll meanAll stdAll kurAll skwAll enrAll entAll varAll...
    harAll geoAll mm2All mm3All mm4All mm5All p2pAll prmAll maxAll];

AllAll = [AllFeatures VarClmn];

%% Plots

figure;
grid on;
hold on;
plot(rmsN);
plot(rmsF1);
plot(rmsF2);
legend('Normal','Fault1','Fault2');
title('RMS');
xlabel('Node Number');
ylabel('Coefficient Value');
hold off;

figure;
grid on;
hold on;
plot(meanN);
plot(meanF1);
plot(meanF2);
legend('Normal','Fault1','Fault2');
title('Mean');
xlabel('Node Number');
ylabel('Coefficient Value');
hold off;

figure;
grid on;
hold on;
plot(stdN);
plot(stdF1);
plot(stdF2);
legend('Normal','Fault1','Fault2');
title('STD');
xlabel('Node Number');
ylabel('Coefficient Value');
hold off;

figure;
grid on;
hold on;
plot(kurN);
plot(kurF1);
plot(kurF2);
legend('Normal','Fault1','Fault2');
title('Kurtosis');
xlabel('Node Number');
ylabel('Coefficient Value');
hold off;

figure;
grid on;
hold on;
plot(skwN);
plot(skwF1);
plot(skwF2);
legend('Normal','Fault1','Fault2');
title('Skew');
xlabel('Node Number');
ylabel('Coefficient Value');
hold off;

figure;
grid on;
hold on;
plot(enrN);
plot(enrF1);
plot(enrF2);
legend('Normal','Fault1','Fault2');
title('Energy');
xlabel('Node Number');
ylabel('Coefficient Value');
hold off;

figure;
grid on;
hold on;
plot(entN);
plot(entF1);
plot(entF2);
legend('Normal','Fault1','Fault2');
title('Entropy');
xlabel('Node Number');
ylabel('Coefficient Value');
hold off;

figure;
grid on;
hold on;
plot(varN);
plot(varF1);
plot(varF2);
legend('Normal','Fault1','Fault2');
title('Variance');
xlabel('Node Number');
ylabel('Coefficient Value');
hold off;

figure;
grid on;
hold on;
plot(harN);
plot(harF1);
plot(harF2);
legend('Normal','Fault1','Fault2');
title('Harmonic Mean');
xlabel('Node Number');
ylabel('Coefficient Value');
hold off;

figure;
grid on;
hold on;
plot(geoN);
plot(geoF1);
plot(geoF2);
legend('Normal','Fault1','Fault2');
title('Geometric Mean of Absolute Values');
xlabel('Node Number');
ylabel('Coefficient Value');
hold off;

figure;
grid on;
hold on;
plot(mm2N);
plot(mm2F1);
plot(mm2F2);
legend('Normal','Fault1','Fault2');
title('Second Moment');
xlabel('Node Number');
ylabel('Coefficient Value');
hold off;

figure;
grid on;
hold on;
plot(mm3N);
plot(mm3F1);
plot(mm3F2);
legend('Normal','Fault1','Fault2');
title('Third Momentum');
xlabel('Node Number');
ylabel('Coefficient Value');
hold off;

figure;
grid on;
hold on;
plot(mm4N);
plot(mm4F1);
plot(mm4F2);
legend('Normal','Fault1','Fault2');
title('Fourth Momentum');
xlabel('Node Number');
ylabel('Coefficient Value');
hold off;

figure;
grid on;
hold on;
plot(mm5N);
plot(mm5F1);
plot(mm5F2);
legend('Normal','Fault1','Fault2');
title('Fifth Momentum');
xlabel('Node Number');
ylabel('Coefficient Value');
hold off;

figure;
grid on;
hold on;
plot(p2pN);
plot(p2pF1);
plot(p2pF2);
legend('Normal','Fault1','Fault2');
title('Peakt to Peak');
xlabel('Node Number');
ylabel('Coefficient Value');
hold off;

figure;
grid on;
hold on;
plot(prmN);
plot(prmF1);
plot(prmF2);
legend('Normal','Fault1','Fault2');
title('Peak/RMS (Crest Factor)');
xlabel('Node Number');
ylabel('Coefficient Value');
hold off;

figure;
grid on;
hold on;
plot(maxN);
plot(maxF1);
plot(maxF2);
legend('Normal','Fault1','Fault2');
title('Maximum Values');
xlabel('Node Number');
ylabel('Coefficient Value');
hold off;

%% Comparison Logic
F1FaultNodes = zeros(size(rmsN));
F2FaultNodes = zeros(size(rmsN));

for i= 1:size(rmsN)
    
  if (abs(rmsN(i) - rmsF1(i)) / stdN(i) > 2)
      F1FaultNodes(i) = 1;
  end

  if (abs(rmsN(i) - rmsF2(i)) / stdN(i) > 2)
      F2FaultNodes(i) = 1;
  end
  
end