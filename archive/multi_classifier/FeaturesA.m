function features = FeaturesA( data )

  fs = 200000;
  trial_length = 0.05;
  window   = 0.01;
  num_vars = 300;

  trial_samples   = fs * trial_length;
  window_samples  = fs * window;
  overlap_samples = window_samples / 2;
  signal_length   = length(data);
  nfft = 2 * num_vars - 1;
  if signal_length < trial_samples
    features = [];
  else
    elements = floor(signal_length / trial_samples);
    features = zeros([elements, num_vars]);
    for i = 1:elements
      seg = data((trial_samples*(i-1) + 1):(trial_samples*i));
      features(i,:) = mag2db(pwelch(seg, window_samples, overlap_samples, nfft));
    end
  end

end
