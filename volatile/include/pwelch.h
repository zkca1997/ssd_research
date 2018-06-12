#ifndef PWELCH_H
#define PWELCH_H

#include <fftw3.h>

void hann_window(double* signal, int n);
void add_to_mag(fftw_complex* complex, double* mag, int n);
double* pwelch(double* signal, int len, int bins, double fs);

#endif  // PWELCH_H
