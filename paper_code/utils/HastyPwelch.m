function HastyPwelch(data, factor, fig)
%USAGE: hastyPwelch(data, factor, fig)
    Fs = 200000;
    figure(fig);
    new_data = pwelch(data);
    out = abs(decimate(new_data, factor));
    F = linspace(0, Fs/2, length(out));
    semilogy(F, out);
    xlabel("Frequency (Hz)");
    ylabel("Decibels");
end
