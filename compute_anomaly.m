function [data_anom,mon_mean,trend] = compute_anomaly(data,timesteps,opts)
%compute_anomaly to form the  anomaly data based on the data and timestep
%inputed
%  first detrended and then monthly means are removed
arguments
    data double
    timesteps datetime
    opts.detrend = "on"
end

% to remove the linear trend over years 
% by subtracting the best-fit line from the data.
trend = [];
if opts.detrend == "on"
    temp = data;
    tsin = timeseries(data);
    tsout = detrend(tsin,'linear');
    data = tsout.Data;
    trend = temp - data;
end

[m,n] = size(data);
[~, month] = ymd(timesteps);
mon_mean = nan(12,n);

for i = 1:12
    index = (month == i);
    for j = 1:n
        temp = data(:,j);
        mon_mean(i,j) = mean(temp(index),"omitnan");
    end
end

% to subtract the monthly means
data_anom = nan(size(data));

for i =1:m
    for j = 1:n
        data_anom(i,j) = data(i,j) - mon_mean(month(i),j);
    end
end

end

