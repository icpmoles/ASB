function [Phase,gain, phase_delay] = SweepAnalysis(t_steady,inp_focus, out_focus, omega, plots)
%SWEEPANALYSIS given a slice of the time, input and output it analyzes the data and figures out gain and phase
% time, u and y are 1xN vectors
% omega = scalar in rad/s
warning('Use NewSweepAnalysis instead')
    Tfocus = t_steady(end)-t_steady(1);
    ts = 1/500;
    T = 2*pi/omega;
    Fv = 1/T;
    max_samples_per_period = ceil(T/ts);

    angular_resolution = 360/max_samples_per_period;
    maxlag_n = ceil(max_samples_per_period/4);


    %% debias
    Integ = trapz(t_steady,out_focus);
    b = Integ/Tfocus;
    out_deb = out_focus - b;
    
    %% cross corr 4 phase
    [c,lags] = xcorr(inp_focus,out_deb,maxlag_n,'biased' );
    c = c/2;

    
    [c_max, cmaxid] = max(c);
    focus_window = max_samples_per_period*2;
    
    maxlag_time = (2*maxlag_n + 1) * ts;
    lags_time = lags * ts;
    lags_rad = lags_time * 2 * pi / T;

    Phase = lags_rad(cmaxid);


    %% peak to peak method:
    % inp_pp = [];
    out_pp = [];
    out_mxv = []; % values of max peaks
    out_mxi = []; % timings of max peaks
    out_mnv = []; % values of min peaks
    out_mni = []; % timings of min peaks
    delays = []; % delays in time
    for idx = 1:max_samples_per_period:size(t_steady,2)
        if idx+max_samples_per_period>size(t_steady,2)
            continue
        else
            final_idx = idx+max_samples_per_period;
            % find max of input
            [inp_max, inp_max_id] = max(inp_focus(idx:final_idx));
            [inp_min, inp_min_id] = min(inp_focus(idx:final_idx)); 
            % inp_pp(end+1) = (inp_max-inp_min)/2;
    

            % find max of output
            [out_max, out_max_id] = max(out_deb(idx:final_idx));
            [out_min, out_min_id] = min(out_deb(idx:final_idx));

            % output peak to peak: find and save for display
            out_pp(end+1) = (out_max-out_min)/2;
            out_mxv(end+1) = out_max;
            out_mnv(end+1) = out_min;
            out_mxi(end+1) = t_steady(idx+out_max_id-1);
            out_mni(end+1) = t_steady(idx+out_min_id-1);
            u_mxi = t_steady(idx+inp_max_id-1);
            u_mni = t_steady(idx+inp_min_id-1);
            
            % y is always leading u:
            delay_max = mod(-out_mxi(end) + u_mxi,T);
            delay_min = mod(-out_mni(end) + u_mni,T);
            delays(end+1) = (delay_max + delay_min)/2;

        end
    end

    gain = mean(out_pp);
    phase_delay = mean(delays) * 2 * pi / T;
    %% plot
    if plots
        subplot(2,2,3)
        hold on
        plot(t_steady,out_focus)
        plot(t_steady,out_deb)
        stem(out_mxi,out_mxv,"filled")
        stem(out_mni,out_mnv,"filled")
        % legend("raw","debiased","peak max","peak min")
        title("OUTPUT SIGNAL")
        title("gain: " + gain)
        hold off
    
        subplot(2,2,4)
        title("Phase: " + rad2deg(Phase) + "°")
        hold on
        stem(lags*angular_resolution,c)
        stem(rad2deg(Phase),c_max,"filled")
        hold off
        sgtitle(omega)
    end
end





