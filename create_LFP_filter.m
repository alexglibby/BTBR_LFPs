%%% Create LFP filter
%%% Alex Libby
%%% 9/8/2015
%%% used in electro_analysis_pipeline

function Hdlfp = create_LFP_filter(StopBand,FiltOrder,sr)

% sr = 20000; %sample rate
% StopBand = 150;
% FiltOrder = 20;

h = fdesign.lowpass('n,f3db', FiltOrder, StopBand, sr);    
Hdlfp = design(h, 'butter');