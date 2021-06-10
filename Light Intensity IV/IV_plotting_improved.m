dataArray = importdata('curve_data.csv');
data1 = dataArray.data;

plot(data1(:,1),data1(:,2)*10^3)
title('IV Curves for Perovskite Sample (Composition X)')
xlabel('Voltage (V)')
ylabel('Current (mA)')
hold on
index = 4; 

for i = 4:(size(data1,2)/3-3-3*3)
    V = (data1(:,index)+data1(:,index+3))/2;
    I = (data1(:,index+1)+data1(:,index+4))/2;
    if index == 40 && index == 28
        break
    else
        plot(V,I*10^3)
        hold on
    end
    index = index + 3;
end
legend('100','T89','T75','T63','T56','T39','T18','T8','T5.1')
xlim([0 1.2]);
ylim([0 3.5]);