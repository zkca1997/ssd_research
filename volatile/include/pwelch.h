#ifndef PWELCH_H
#define PWELCH_H

#include <gsl/gsl_matrix.h>

double* pwelch(double* signal, int len, int bins, double fs);

#endif  // PWELCH_H
