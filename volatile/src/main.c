#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <gsl/gsl_matrix.h>
#include "pca.h"
#include "pwelch.h"

int main()
{
  //const int rows = 4, cols = 3, L = 2;
  //gsl_matrix *test_data = gsl_matrix_alloc(rows, cols);
  //gsl_matrix *comp_data = gsl_matrix_alloc(rows, L);

  // initialize a matrix
  //double vals[12] = { 0.9040, 0.9757, 0.2695, 0.9409, 0.3172, 0.5896, 0.8025, 0.8128, 0.8330, 0.2420, 0.6974, 0.3638 };
  //memcpy( test_data->data, vals, sizeof(double) * 12);

  //comp_data = pca(test_data, L);
  //printf("\nThe Compressed Matrix:\n");
  //gsl_matrix_fprintf(stdout, comp_data, "%f");

  double* foo = (double*) calloc(16384, sizeof(double));
  double* psd = pwelch(foo, 16384, 257, 200000);

  free(psd);
  free(foo);

  return 0;
}
