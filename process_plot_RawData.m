function [data_pos_all, data_acc_all] = process_plot_RawData(handys, posData, imuData, createPlot)

for i = 1:length(handys)

    handy = handys{i};

    lat = posData.(handy).latitude;
    lon = posData.(handy).longitude;
    u = posData.(handy).height;

    acc = imuData.(handy).acceleration(:,3:5);
    gyro = imuData.(handy).orientationDeg(:,3:5);

    date = posData.(handy).date;
    
    % Umrechnung in enu-System
    % Approximation 'flat' -> laut Matlab höhere Genauigkeiten über kurze
    % Distanzen
    lla0 = [lat(1) lon(1) u(1)]; % [lat0 lon0 alt0] Ursprung für lokales Koordinatensystem
    
    ENU = lla2enu([lat, lon, u], lla0, 'flat');
    east = ENU(:,1);
    north = ENU(:,2);
    up = ENU(:,3);
    
    
    % Mittelwert aus n Werten
    n = 30;
    datemean = date(1:(end-30));
    for j = 1:(length(east)-n)
    meaneast(j) = mean(east(j:(j+n),:));
    meannorth(j) = mean(north(j:(j+n),:));
    meanup(j) = mean(up(j:(j+n),:));
    end
    
    %% Plot
    if createPlot
        %Zeitpunkte
            points = [datetime('12-Dec-2023 10:45:00.000');
                      datetime('12-Dec-2023 10:55:00.000');
                      datetime('12-Dec-2023 11:10:00.000');
                      datetime('12-Dec-2023 11:20:00.000');
                      datetime('12-Dec-2023 11:35:00.000')];
        
        
        figure
        t = tiledlayout(2,2);
        title(t,[handy,' - Raw Data'])
        nexttile
        plot(date,east);hold on;
        plot(datemean,meaneast,'r');
        xline(points,'--',{'1','2','3','4','5'})
        ylabel('[m]');xlabel('Time');
        title('Position in East')
        nexttile
        plot(date,north);hold on;
        plot(datemean,meannorth,'r');
        xline(points,'--',{'1','2','3','4','5'})
        ylabel('[m]');xlabel('Time');
        title('Position in North')
        nexttile
        plot(date,up);hold on;
        plot(datemean,meanup,'r');
        xline(points,'--',{'1','2','3','4','5'})
        ylabel('[m]');xlabel('Time');
        title('Position in Up')
        nexttile
        scatter(east,north,'x');hold on;
        scatter(meaneast,meannorth,'x','r')
        ylabel('[m]');xlabel('[m]');
        title('Position in East, North')
        
        clear meaneast
        clear meannorth
        clear meanup

    end

    % save data
    data_pos_all{i} = [posData.(handy)(:,1:3)];
    data_acc_all{i} = acc;

end
end