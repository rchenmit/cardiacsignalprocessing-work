function ensemble_avg = ensemble_average(signal_data, cycles_start_indexes, fs, num_seconds_backward_sample, num_seconds_forward_sample)
    %calculate ensemble average
    %INPUT PARAMETERS: 
    %    signal_data:
    %    start_indexes: list of start indexes (in the signal_data) 
    %    fs: sampling freq
    %    num_seconds_backward_sample: number of seconds to sample BEHIND
    %    the peak
    %    num_seconds_forward_sample: number of seconds to sample FORWARD
    %    from the peak
    %OUTPUT: 
    %    ensemble_average : ensemble average of all individual beats
    num_samples_backward = floor(fs*num_seconds_backward_sample);
    num_samples_forward = floor(fs*num_seconds_forward_sample);
    
    beatarray = [];
    for i = 1:length(cycles_start_indexes)
        this_signal = signal_data(cycles_start_indexes(i)-num_samples_backward:cycles_start_indexes(i)+ num_samples_forward);
        beatarray = [beatarray, this_signal];
    end
    
    ensemble_avg = mean(beatarray, 2);

end

