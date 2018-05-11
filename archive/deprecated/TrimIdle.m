function trimmed = TrimIdle( data, threshhold )
%USAGE: trimmed = trimIdle( data )
%trimmed: a 1xn vector of only "active" data
%data: a 1xn vector of raw sample data (with "idle")

% trimIdle takes in raw vector data and strips off 1ms segments that
% average below a set threshold.  This is achieved by aggressively
% decimating the data and using points that lie below the threshold as
% markers for their corresponding 1ms segment.  This entire segment is then
% removed from the final return vector

  factor = 2000;    % decimation factor
  marker = decimate(data, factor);  % marker vector

  n = 1;
  M = length(marker);
  startN = [];
  endN   = [];

  % The logic that strips out segments marked by delete markers
  while n <= M

    if marker(n) < threshhold

      endN = horzcat(endN, n);

      while (n <= M) && (marker(n) < threshhold)
        n = n + 1;
      end

      startN = horzcat(startN, n-1);
      n = n + 1;

    else
      n = n + 1;
    end

  end

  startN = startN * factor;
  endN   = endN * factor;

  trimmed = [];
  for i = 2:length(startN)
      trimmed = horzcat( trimmed, data(startN(i-1):endN(i)) );
  end

end
