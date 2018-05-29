#include <stdio.h>
#include <fftw3.h>
#include <stdlib.h>
#include <math.h>
#include <gsl/gsl_matrix.h>

/*void hann_window(double* signal, int window_size)
{
  for(int i = 0; i < window_size; i++) {
    int weight =  0.5 * (1 - cos(2*M_PI*i / (window_size - 1)));
    signal[i] *= weight;
  }
}*/

void pwelch(gsl_vector* signal, int bins, double fs)
{
  int window_len = 2 * bins;

  for(int i = 0; (i + window_len) <= signal->size; i += bins)
  {
    // take slice of signal of window length and set as "in"
    gsl_vector_view slice = gsl_vector_subvector(signal, i, window_len);

    // execute FFT with output "out"
    double* out = (double*) malloc(sizeof(double) * bins);
    fftw_plan plan = fftw_plan_r2r_1d(window_len, slice.vector.data, out,
                                          FFTW_R2HC, FFTW_ESTIMATE);

    fprintf(stderr, "BREAKPOINT\n");
    fftw_execute(plan);

    // clean up
    fftw_destroy_plan(plan);
    free(out);
  }
}
