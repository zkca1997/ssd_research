function features = FeaturesA( data, info )

  % remove idle tails
  data = TrimTails(data, 0.15);

  trial_samples   = info.fs * info.trial_length;
  window_samples  = info.fs * info.window;
  overlap_samples = window_samples / 2;
  signal_length   = length(data);
  nfft = 2 * info.num_vars - 1;
  if signal_length < trial_samples
    features = [];
  else
    elements = floor(signal_length / trial_samples);
    features = zeros([elements, info.num_vars]);
    for i = 1:elements
      seg = data((trial_samples*(i-1) + 1):(trial_samples*i));
      features(i,:) = mag2db(pwelch(seg, window_samples, overlap_samples, nfft));
    end
  end

end
