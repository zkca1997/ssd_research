#ifndef LOGISTIC_H
#define LOGISTIC_H

#include <gsl/gsl_matrix.h>

bool logistic_predict(double* vector, gsl_vector* B);
gsl_vector* logistic_train(gsl_matrix* X, bool* Y, double tol);

#endif  // LOGISTIC_H
