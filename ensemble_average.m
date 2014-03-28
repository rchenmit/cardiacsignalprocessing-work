function ensemble_avg = ensemble_average(signal_data, cycles_start_indexes, fs, num_seconds_to_sample)
    %calculate ensemble average
    %INPUT PARAMETERS: 
    %    signal_data:
    %    start_indexes: list of start indexes (in the signal_data) 
    %OUTPUT: 
    %    ensemble_average : ensemble average of all individual beats
    num_samples = floor(fs*num_seconds_to_sample);
    beatarray = [];
    for i = 1:length(cycles_start_indexes)
        this_signal = signal_data(cycles_start_indexes(i):cycles_start_indexes(i)+ num_samples);
        beatarray = [beatarray, this_signal];
    end
    
    ensemble_avg = mean(beatarray, 2);

end

