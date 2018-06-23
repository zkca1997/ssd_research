OVERVIEW OF DIRECTORY STRUCTURE:

"common" subdirectory contains functions that are shared by different classifiers.  This entire directory should be added to the path

each additional subdirectory is associated with a specific project.  Each project contains a "TopLevel.m" file.  This is the analog to the "main" function of a generic programming language, and represents the control structure of a classifier.  "TopLevel.m" should be written such that a reader can see an overview of the entire processing algorithm in a few lines.

CURRENT PROJECTS:
- binary classifier: given a set of N classes, compute the classification accuracy of a classifier for each pairwise combination of N classes
- multi classifier: given a set of N classes, generate and report the performance of a N-way classifier
- unknown classifier: given a set of N classes, for each class, create a signature for the remaining N-1 classes and generate a classifier than classifies between "is a member of the N-1 classes" or "is not a member of the N-1 classes"
