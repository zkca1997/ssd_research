#include <stdio.h>
#include <fftw3.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
#include "pwelch.h"

double* pwelch(double* signal, int len, int bins, double fs) {

  int step = bins - 1;
  int n    = 2 * step;

  double* in  = (double*) fftw_malloc(n * sizeof(double));
  fftw_complex* out = (fftw_complex*) fftw_malloc(bins * sizeof(fftw_complex));
  fftw_plan plan = fftw_plan_dft_r2c_1d(n, in, out, FFTW_ESTIMATE);

  // initialize accum array
  double* accum = (double*) calloc(bins, sizeof(double));

  int count = 0;
  for(int i = 0; (i + n) <= len; i += step) {

    // 1) copy slice to tmp_in array
    void* offset = signal + i;
    memcpy(in, offset, n);void

    // 2) apply hann window to tmp_in
    hann_window(in, n);

    // 3) execute fft
    fftw_execute(plan);

    // 4) convert to magnitudes and add to mag accum array
    add_to_mag(out, accum, bins);

    // 5) iterate counter
    count++;
  }

  for(int i = 0; i < bins; i++) { accum[i] /= (double) count; }

  return accum;
}

void hann_window(double* signal, int n) {
  for(int i = 0; i < n; i++) {
    double weight =  0.5 * (1 - cos(2 * M_PI * i / (n - 1)));
    signal[i] *= weight;
  }
}

void add_to_mag(fftw_complex* complex, double* mag, int n) {
  for(int i = 0; i < n; i++) {
    mag[i] += sqrt( complex[i][0] * complex[i][0] +
                    complex[i][1] * complex[i][1] );
  }
}
