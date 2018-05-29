#ifndef PCA_H
#define PCA_H

#include <gsl/gsl_matrix.h>

gsl_matrix* pca(gsl_matrix* data, unsigned int L);

#endif  // PCA_H
