#include <stdlib.h>
#include <gsl/gsl_blas.h>
#include "logistic.h"

bool logistic_predict(gsl_vector* x, gsl_vector* B) {
  double result;
  gsl_blas_ddot(x, B, result)

  if(result > 0) { return 1; }
  else { return 0; }
}

gsl_vector* logistic_train(gsl_matrix* X, bool* Y, double tol) {
  
}
