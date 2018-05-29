#include "pca.h"
#include <assert.h>
#include <gsl/gsl_matrix.h>
#include <gsl/gsl_statistics.h>
#include <gsl/gsl_eigen.h>
#include <gsl/gsl_blas.h>

gsl_matrix* pca(gsl_matrix* data, unsigned int L)
{
  assert(data != NULL); // assert dataset is not empty
  assert(L > 0 && L <= data->size2); // assert that reduction is less than number of dimensions

  unsigned int N = data->size1; // N is number of samples
  unsigned int P = data->size2; // P is the number of variables
  gsl_vector* mean = gsl_vector_alloc(P); // 1xP vector to hold mean values

  // compute a vector of column means
  for(int j = 0; j < P; j++) {
    gsl_vector_view tmp = gsl_matrix_column(data, j);
    gsl_vector_set(mean, j, gsl_stats_mean(tmp.vector.data, tmp.vector.stride, tmp.vector.size));
  }

  // subtract column means from dataset matrix
  gsl_matrix* mean_subtracted_data = gsl_matrix_alloc(N, P);
  gsl_matrix_memcpy(mean_subtracted_data, data);
  for(int i = 0; i < N; i++) {
    gsl_vector_view mean_subtracted_point_view = gsl_matrix_row(mean_subtracted_data, i);
    gsl_vector_sub(&mean_subtracted_point_view.vector, mean);
  }

  // print covariance_matrix
  //printf("\nMean Subtracted Data:\n");
  //gsl_matrix_fprintf(stdout, mean_subtracted_data, "%f");

  gsl_vector_free(mean);  // free column means vector

  // Compute Covariance Matrix
  gsl_matrix* covariance_matrix = gsl_matrix_alloc(P, P);
  gsl_blas_dgemm(CblasTrans, CblasNoTrans, 1.0 / (double) P, mean_subtracted_data, mean_subtracted_data, 0.0, covariance_matrix);

  // print covariance_matrix
  //printf("\nCovariance Matrix:\n");
  //gsl_matrix_fprintf(stdout, covariance_matrix, "%f");

  // Get eigenvectors, sort by eigenvalue
  gsl_vector* eigenvalues = gsl_vector_alloc(P);
  gsl_matrix* eigenvectors = gsl_matrix_alloc(P, P);
  gsl_eigen_symmv_workspace* workspace = gsl_eigen_symmv_alloc(P);
  gsl_eigen_symmv(covariance_matrix, eigenvalues, eigenvectors, workspace);
  gsl_eigen_symmv_free(workspace);
  gsl_matrix_free(covariance_matrix);

  // Sort the eigenvectors
  gsl_eigen_symmv_sort(eigenvalues, eigenvectors, GSL_EIGEN_SORT_ABS_DESC);

  //printf("\nEigenvalues:\n");
  //gsl_vector_fprintf(stdout, eigenvalues, "%f");
  //printf("\nEigenvectors:\n");
  //gsl_matrix_fprintf(stdout, eigenvectors, "%f");

  gsl_vector_free(eigenvalues); // free eigenvalues vector

  // Project the original dataset
  gsl_matrix* result = gsl_matrix_alloc(N, L);
  gsl_matrix_view L_eigenvectors = gsl_matrix_submatrix(eigenvectors, 0, 0, P, L);

  //printf("\nL_Eigenvector:\n");
  //gsl_matrix_fprintf(stdout, &L_eigenvectors.matrix, "%f");

  gsl_blas_dgemm(CblasNoTrans, CblasNoTrans, 1.0, mean_subtracted_data, &L_eigenvectors.matrix, 0.0, result);

  gsl_matrix_free(eigenvectors);
  gsl_matrix_free(mean_subtracted_data);

  return result;
}
