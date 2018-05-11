function HastyView(data, factor, fig)
%USAGE: hastyView(data, factor)
%factor = decimation factor
    figure(fig);
    step = 0.000005 * factor;
    new_data = decimate(data, factor);
    tmp = length(new_data);
    T = linspace(0, step*tmp, tmp);
    plot(T, new_data);
end
