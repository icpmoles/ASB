function [datad] = SweepAnalysisMI(t_steady,u_focus, y_focus,data_bundle, to_merge)
%SWEEPANALYSIS given a slice of the time, input and output it analyzes the data and figures out gain and phase
% time, u and y are 1xN vectors
% omega = scalar in rad/s
    Tfocus = t_steady(end)-t_steady(1);
    Ts = 1/500;
    % T = 2*pi/omega;
    % Fv = 1/T;
    % max_samples_per_period = ceil(T/ts);
    % 
    % angular_resolution = 360/max_samples_per_period;
    % maxlag_n = ceil(max_samples_per_period/4);


    %% debias
    Integ = trapz(t_steady,y_focus);
    b = Integ/Tfocus;
    y_deb = y_focus - b;

    datad = iddata(y_deb',u_focus',Ts);
    % T=getTrend(data);
    % T.InputOffset = 0;
    % T.OutputOffset = 0;
    % datad = detrend(data, T);

    if to_merge==true
        datad = merge(data_bundle,datad);
    end
    % %% cross corr 4 phase
    % [c,lags] = xcorr(u_focus,y_deb,maxlag_n,'biased' );
    % c = c/2;
    % 
    % 
    % [c_max, cmaxid] = max(c);
    % focus_window = max_samples_per_period*2;
    % 
    % maxlag_time = (2*maxlag_n + 1) * ts;
    % lags_time = lags * ts;
    % lags_rad = lags_time * 2 * pi / T;
    % 
    % Phase = lags_rad(cmaxid);
    % 
    % 
    % %% peak to peak method:
    % theta_pp = [];
    % y_mxv = []; % values of max peaks
    % y_mxi = []; % timings of max peaks
    % y_mnv = []; % values of min peaks
    % y_mni = []; % timings of min peaks
    % delays = []; % delays in time
    % for idx = 1:max_samples_per_period:size(t_steady,2)
    %     if idx+max_samples_per_period>size(t_steady,2)
    %         continue
    %     else
    %         final_idx = idx+max_samples_per_period;
    %         % find max of volt
    %         [u_max, u_max_id] = max(u_focus(idx:final_idx));
    %         [u_min, u_min_id] = min(u_focus(idx:final_idx)); 
    % 
    %         % find max of angle
    %         [y_max, y_max_id] = max(y_deb(idx:final_idx));
    %         [y_min, y_min_id] = min(y_deb(idx:final_idx));
    % 
    %         % anglepeak to peak: find and save for display
    %         theta_pp(end+1) = (y_max-y_min)/2;
    %         y_mxv(end+1) = y_max;
    %         y_mnv(end+1) = y_min;
    %         y_mxi(end+1) = t_steady(idx+y_max_id-1);
    %         y_mni(end+1) = t_steady(idx+y_min_id-1);
    %         u_mxi = t_steady(idx+u_max_id-1);
    %         u_mni = t_steady(idx+u_min_id-1);
    % 
    %         % y is always leading u:
    %         delay_max = mod(-y_mxi(end) + u_mxi,T);
    %         delay_min = mod(-y_mni(end) + u_mni,T);
    %         delays(end+1) = (delay_max + delay_min)/2;
    % 
    %     end
    % end
    % 
    % gain = mean(theta_pp);
    % 
end





