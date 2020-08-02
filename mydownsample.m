%%% Downsample function 
%%% Alex Libby
%%% 9/9/2015

function [new_amp, new_amp_t] = mydownsample(currentSR,desiredSR,amp,amp_t)

% %%% user inputs: 
% currentSR = 20000; %%% current SR of data
% desiredSR = 1000; %%% desired SR

downsamplefactor = round(currentSR/desiredSR); 
fprintf('\tDownsampling the data by a factor of %d.\n', downsamplefactor);

%%% esnure that sizing is correct on input data (we want rows >>> columns);
if size(amp,1) < size(amp,2)
    amp = amp';
end

new_amp = amp(1:downsamplefactor:end,:);

if exist('amp_t','var')
    
    if size(amp_t,1) < size(amp_t,2)
        amp_t = amp_t';
    end
    
    new_amp_t = amp_t(1:downsamplefactor:end,:);
    
else
    
    new_amp_t = [];
    
end

    
