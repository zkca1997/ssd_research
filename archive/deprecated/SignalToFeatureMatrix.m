function features = SignalToFeatureMatrix( tsignal, num_vars, trial_length, window, fs )
%USAGE: features = SignalToFeatureMatrix( tsignal, num_vars, trial_length, window, fs )
% Takes in a time domain signal and converts it into a feature matrix of N time
% slices and M frequency domain samples (variables)

  trial_samples   = fs * trial_length;
  window_samples  = fs * window;
  overlap_samples = window_samples / 2;
  signal_length   = length(tsignal);
  nfft = 2*num_vars - 1;
  if signal_length < trial_samples
    features = [];
  else
    elements = floor(signal_length / trial_samples);
    features = zeros([elements, num_vars]);
    for i = 1:elements
      seg = tsignal((trial_samples*(i-1) + 1):(trial_samples*i));
      features(i,:) = mag2db(pwelch(seg, window_samples, overlap_samples, nfft));
    end
  end
end
