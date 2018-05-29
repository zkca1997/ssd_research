#ifndef PWELCH_H
#define PWELCH_H

#include <gsl/gsl_matrix.h>

void pwelch(gsl_vector* signal, int bins, double fs);

#endif  // PWELCH_H
