function [data_filtered, time] = KalmanFilter(data_pos, data_acc, stochastic_process)

% for Schleife ergänzen
pos_LLH = [data_pos{1}.latitude data_pos{1}.longitude data_pos{1}.height];
acc = data_acc{1};
%pos_XYZ = convert from LLH to ECEF 
time = data_pos{1}.date;

[pos_LLH,B] = rmoutliers(pos_LLH(:,1:3));    
time = time(B~=1);

% Startwerte (evtl. Mittelwert berechnen
[t0, t0_idx] = max(time(time < '12-Dec-2023 10:45:00'));
xnn0 = median(pos_LLH(1:t0_idx,:))';
% East-North-Up
pos_ENU = lla2enu(pos_LLH, xnn0', 'flat');
xnn_all = zeros(size(pos_LLH));
xnn_all(1:t0_idx,:) = ones(t0_idx,1).*xnn0';

%% Messrauschen
sigma_R_RW = 5;
sigma_R_IRW = 5;

%% Random Walk
if stochastic_process == "RW"

    F = zeros(3);
    sigma_prozess = 0.1;
    G = sigma_prozess.*[1 1 1]';
    W = 1;
    A = [-F G*W*G'; zeros(size(F)) F'];
    n = length(A)/2;
    B = expm(A);
    Phi = B(n+1:2*n,n+1:2*n)';  %Zustandsübergangsmatrix
    Q = Phi*B(1:n,n+1:2*n);     %Matrix des Prozessrauschens
    
    % Messrauschen
    R = sigma_R_RW^2*eye(3);
    
    % Startwerte
    xnn = xnn0;
    Pnn = sigma_R_RW^2*eye(3); % für die Pnn-Anfangsmatrix können passende Werte frei gewählt werden
    %wm = webmap('World Imagery');
    %wmmarker(xnn(1),xnn(2),'Color','black','FeatureName','H1','Color','magenta','FeatureName','H1')
    
    for t = t0_idx+1:length(pos_ENU)
        % Berechnung vorab
        xnn_p = Phi*xnn;
        Pnn_p = Phi*Pnn*Phi' + Q;
        
        % Beobachtungen
        z = pos_ENU(t,:)';
        H = eye(3);
    
        % Kalman gain
        K = Pnn_p * H'*inv(H*Pnn_p*H' + R);
    
        % Update
        xnn = xnn_p + K * (z-H*xnn_p);
        Pnn = (eye(3) - K*H).*Pnn_p;
    
        % Speichern und Darstellung in Karte
        xnn_LLH = enu2lla(xnn', xnn0', 'flat');
        %wmmarker(xnn_LLH(1),xnn_LLH(2),'Color','black','FeatureName','H1','Color','cyan','FeatureName','H1')
    
        xnn_all(t,:) = xnn_LLH';
    
    end
    
    data_filtered{1} = xnn_all;

end

%% Integrated Random Walk
if stochastic_process == "IRW"

    F = [zeros(3) eye(3); zeros(3,6)];
    sigma_prozess = 0.1;
    G = sigma_prozess.*[0 0 0 1 1 1]';
    W = 1;
    A = [-F G*W*G'; zeros(size(F)) F'];
    n = length(A)/2;
    B = expm(A);
    Phi = B(n+1:2*n,n+1:2*n)';  %Zustandsübergangsmatrix
    Q = Phi*B(1:n,n+1:2*n);     %Matrix des Prozessrauschens
    
    % Messrauschen
    R = sigma_R_IRW^2*eye(3);
    
    % Startwerte
    xnn = [xnn0; zeros(3,1)];
    Pnn = sigma_R_IRW^2*eye(n); % für die Pnn-Anfangsmatrix können passende Werte frei gewählt werden
    %wm = webmap('World Imagery');
    %wmmarker(xnn(1),xnn(2),'Color','black','FeatureName','H1','Color','magenta','FeatureName','H1')
    
    for t = t0_idx+1:length(pos_ENU)
        % Berechnung vorab
        xnn_p = Phi*xnn;
        Pnn_p = Phi*Pnn*Phi' + Q;
        
        % Beobachtungen
        z = pos_ENU(t,:)';
        H = [eye(3) zeros(3)];
    
        % Kalman gain
        K = Pnn_p * H'*inv(H*Pnn_p*H' + R);
    
        % Update
        xnn = xnn_p + K * (z-H*xnn_p);
        Pnn = (eye(n) - K*H).*Pnn_p;
    
        % Speichern und Darstellung in Karte
        xnn_LLH = enu2lla(xnn(1:3)', xnn0', 'flat');
        %wmmarker(xnn_LLH(1),xnn_LLH(2),'Color','black','FeatureName','H1','Color','cyan','FeatureName','H1')
    
        xnn_all(t,:) = xnn_LLH';
    
    end
    
    data_filtered{1} = timetable(time,xnn_all);

end
end