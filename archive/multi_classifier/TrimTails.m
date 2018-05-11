function out = TrimTails(data)

  factor = 2000;    % decimation factor
  threshold = 0.15;
  marker = decimate(data, factor);  % marker vector

  % find left start point
  M = length(marker);
  startN = 1;
  while (startN <= M) && (marker(startN) < threshold)
    startN = startN + 1;
  end

  % find right end point
  endN = length(marker);
  M = 1;
  while (endN >= M) && (marker(endN) < threshold)
    endN = endN - 1;
  end

  if startN >= endN; out = [];
  else
    startN = (startN - 1)*factor + 1;
    endN   = (endN * factor);
    if endN > length(data); endN = length(data); end
    out    = data(startN:endN);
  end

end
