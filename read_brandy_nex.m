%%%% Read in NEX RAW data --> filter and plot spectral density 
%%%% 7/31/2020 - AL

%%% USER inputs 

file_dir = 'Z:\Users\Alex\MatlabBackup\ElectroAnalysis\brandy_wave\data\';

fn = 'SE-CSC-RAW-Ch1_.nex';

num_sec_pad = 10; %%% number of seconds to remove from start and end of file

%%% parameters of the LFP filter
StopBand = 350; FiltOrder = 20;

%%% parameters of the Yule-Walker Spectral Density Method
orderpy = 1000; %%% 
range_f = [1:150]; %%% range of frequencies 

%%% if you want to downsample your data (after the LFP filter)
downsample_on = 1; 
desiredSR = 1000; %% 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% load in data file
disp('loading in data file')
fileName = [file_dir fn];

[nexFile] = readNexFile(fileName);

data = nexFile.contvars{1,1}.data;
sr = nexFile.freq; %30000; %%% getting the sample rate of the data
disp('finished loading data')
%% take first ten seconds
disp(['removing ' num2str(num_sec_pad) ' seconds of data on start and end'])
data_t = [0:1/sr:(size(data)-1)/sr]; %%% start time at zero (in seconds or whatever sr is in)
data_use = data(sr*num_sec_pad:end-(sr*num_sec_pad));
data_t_use = data_t(sr*num_sec_pad:end-(sr*num_sec_pad)); %%% grab timing of the data

%% apply LFP filter
disp('applying LFP filter to data')
Hdlfp = create_LFP_filter(StopBand,FiltOrder,sr);

LFP_data = filtfilt(Hdlfp.SOSMatrix, Hdlfp.ScaleValues, data_use);
disp('finished')

%% downsample data 
if downsample_on
    disp('downsampling data')
    [data_use, data_t_use] = mydownsample(sr,desiredSR,LFP_data,data_t_use);
    sr = desiredSR;
end
%% plot spectrogram 
disp('plotting spectrogram')
[Pxx,F] = pyulear(data_use,orderpy,range_f,sr);
figure
clf
plot(F,10*log10(Pxx),'LineWidth',2.5)
xlabel('Frequency (Hz)')
ylabel('Power/Frequency (dB/Hz)')
legend(['pyulear PSD Estimate order: ' num2str(orderpy)])
disp('finished')