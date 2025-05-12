function [slices] = sliceTimeSeries(time,om)
%SLICETIMESERIES given time and frequency series returns start and stop of steady state as a collection of structs.
%   Detailed explanation goes here




sampleRes = 100;

slices = {};


lastFreq = -1;
inTranstion = false;
lastEnd = -1;
previousTcheck = -1;


singleFreq = struct;

singleFreq.f = om(1);
singleFreq.t_start = time(1);
singleFreq.t_end = time(2);
slices = [slices,singleFreq];


for i = 1:sampleRes:size(time,2)
    if lastFreq == om(i)
        % steady state
        inTranstion = false;
    else
        if ~inTranstion
            % if we are in transition and the previus check
            % wasn't a transition: we found a transiotion start
            % == steady state end
            lastEnd = previousTcheck;
        end
        inTranstion = true;
    end

    if ~inTranstion && slices{end}.f ~= lastFreq 
        % if ( in a steady freq zone) and the freq from 
        % previous iteration different from the last logged
        % frequency = we found a new plateau
        singleFreq.f = lastFreq;
        singleFreq.t_start = time(i);

        slices{end}.t_end = lastEnd;
        slices = [slices,singleFreq];

        lastEnd = time(i);
        
    end

    
    lastFreq = om(i);
    previousTcheck = time(i);
    
end

slices{end}.t_end = previousTcheck;

end

