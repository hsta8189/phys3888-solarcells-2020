%% Loading Data
dataArray = importdata('curve_data.csv')
data1 = dataArray.data;

index = 1;
filters = [1001 917 772 638 591 512 445 226 181 100 89 7 383]; %W/m^2
filter_labels = ['sun' 'T89' 'T75' 'T63' 'T56' 'T51' 'T39' 'T20' 'T18' 'T8' 'T5' 'Room' 'Torch'];

%% Plotting IV Curves
plot(data1(:,1),data1(:,2)*10^3)
title('IV Curves for Perovskite Sample (Composition X)')
xlabel('Voltage (V)')
ylabel('Current (mA)')
hold on
index = 4; 
transmittance = filters(1:(end-1))/filters(1)*100;

for i = 4:(size(data1,2)/3-3-3*3)
    V = (data1(:,index)+data1(:,index+3))/2;
    I = (data1(:,index+1)+data1(:,index+4))/2;
    index = index + 3;
    plot(V,I*10^3)
    hold on
end
legend('100%','92%','77%','64%','59%','51%','44%','23%','18%','10%','9%','1%')
xlim([0 1.2]);
ylim([-1 4]);

%% Extracting and plotting additional parameters vs intensity
data2 = importdata('parameters_data.csv');

filters = [1001 917 772 638 591 512 445 226 181 100 89 7]; %W/m^2
filter_labels = ['sun' 'T89' 'T75' 'T63' 'T56' 'T51' 'T39' 'T20' 'T18' 'T8' 'T5.1' 'Room'];

x = filters;
y = zeros(length(filters),6);
count = 2;

y(1,:) = data2(1,:);
for i = 2:11
    y(i,:) = (data2(count,:)+data2(count+1,:))/2;
    count = count + 2;
end
y(12,:) = data2(22,:);

J_sc = y(:,1); %mA
V_oc = y(:,2); %mV
FF = y(:,3); %percentage
eta = y(:,4); %percentage
Rshunt = y(:,5); %mOhm.cm2
Rparallel = y(:,6); %mOhm.cm2

subplot(2,2,1)
plot(x,J_sc,'o')
title('Short Circuit Current vs Intensity')
xlabel('$Intensity (W/m^2)$','interpreter','latex')
ylabel('$J_{sc} (mA)$','interpreter','latex')
subplot(2,2,2)
plot(x,V_oc,'o')
title('Open Circuit Voltage vs Intensity')
xlabel('$Intensity (W/m^2)$','interpreter','latex')
ylabel('$V_{oc} (mV)$','interpreter','latex')
subplot(2,2,3)
plot(x,FF,'o')
title('Fill Factor vs Intensity')
xlabel('$Intensity (W/m^2)$','interpreter','latex')
ylabel('Fill factor (%)')
subplot(2,2,4)
plot(x,eta,'o')
title('Conversion Efficiency vs Intensity')
xlabel('$Intensity (W/m^2)$','interpreter','latex')
ylabel('Conversion efficiency (%)')
% subplot(2,3,5)
% plot(x,R_shunt,'o')
% title('Shunt Resistance vs Intensity')
% xlabel('$Intensity (W/m^2)$','interpreter','latex')
% ylabel('$Shunt Resistance (mOhm.cm^2)$','interpreter','latex')
% subplot(2,3,6)
% plot(x,Rparallel,'o')
% title('Parallel Resistance vs Intensity')
% xlabel('$Intensity (W/m^2)$','interpreter','latex')
% ylabel('$Parallel Resistance (mOhm.cm^2)$','interpreter','latex')

%% Pseudo JV Curves
condition_list = ['sun' 'T89' 'T75' 'T63' 'T56' 'T51' 'T39' 'T20' 'T18' 'T8' 'T5' 'Room' 'zero'];
J_sc = [20.33108177 18.4752409 15.9533325 13.19578601 12.82105289 10.75038663 10.06602349 5.169450001 4.316684523 3.274100686 2.361920534 0.101659462 0];
V_oc = [1103.751225 1091.223875 1068.208259 1047.946216 1046.383061 1038.909712 1033.148027 985.4674677 977.8661151 969.2986836 958.8362358 831.5249723 0];
J_V_oc = [0 1.855840865 4.377749264 7.135295758 7.510028879 9.580695135 10.26505828 15.16163177 16.01439725 17.05698108 17.96916124 20.22942231 20.33108177];

mpp = max(V_oc.*J_V_oc);
for i = 1:length(V_oc)
    if V_oc(i)*J_V_oc(i) == mpp
        Vmmp_pseudo = V_oc(i);
        Immp_pseudo = J_V_oc(i);
    end
end
pFF = mpp/(V_oc(1)*J_sc(1));

plot(V_oc, J_V_oc,'-o');
title('Pseudo JV Curve');
xlabel('$V_{oc} (mV)$','interpreter','latex');
ylabel('$J(V_{oc}) (mA)$','interpreter','latex');

%% Series Resistance
intensity = [1001 917 772 638 591 512 445 226 181 100 89 7 0]; %W/m^2
Vmmp = [921.621568572605 912.9741427 895.8235417 878.592292 877.075026 877.075026 871.9660363 867.3629461 811.4110081 805.9781167 806.7816216 685.624916397295 0]; %mV
Immp = [2.99615130580588 2.729404222 2.355319318 1.951645248 1.898198697 1.898198697 1.590672093 1.49211968 0.756543163 0.630908202 0.481319976 0.0155214392811307 0]; %mA

series_resistance = abs(Vmmp-Vmmp_pseudo)./Immp; %Ohms
series_resistance = series_resistance(1:(end-2));
intensity = intensity(1:(end-2));

plot(intensity, series_resistance,'o')
title('Series Resistance vs Intensity')
xlabel('Intensity $(W/m^2)$','interpreter','latex');
ylabel('Series Resistance $(\Omega)$','interpreter','latex')

%% Just J_sc
filters = [1001 917 772 638 591 512 445 226 181 100 89 7]; %W/m^2
filter_labels = ['sun' 'T89' 'T75' 'T63' 'T56' 'T51' 'T39' 'T20' 'T18' 'T8' 'T5.1' 'Room'];
x = filters;

J_sc = [20.33108177 18.4752409 15.9533325 13.19578601 12.82105289 10.75038663 10.06602349 5.169450001 4.316684523 3.274100686 2.361920534 0.101659462];
plot(x,J_sc,'s')
xlabel('Intensity (W/m^2)','interpreter','latex')
xlim([0 1000]);
ylabel('Short Circuit Current $(mA/cm^2)$','interpreter','latex')