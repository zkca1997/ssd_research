Initial work on a portable open source licensed client side firmware classifier
The eventual goal is to rewrite the MATLAB algorithm in generic c code that can be compiled and executed universally under a GPL license
For this to be feasible, the underlying function base must be developed:

* Current work is focused on developing c language libraries that provide functionality currently provided by proprietary MATLAB functions, to include:
* - pwelch		(Welch Method Power Spectral Density Estimation)
* - pca			(Principle Component Analysis)
* - fitclinear	(Logistic Regression Classifier)