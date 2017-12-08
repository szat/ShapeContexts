# ShapeContexts
Shape contexts for shape matching and for point correspondence.  A faithful implementation of Belongie's, Malik's and Puzicha's "Shape Contexts". Based on the chi-squared distance between rose histograms. 

## Getting Started

This little project is a faithful implementation of Belongie's, Malik's and Puzicha's "Shape Contexts". They can be used for shape matching as well as point correspondance from a shape to another shape. The method computes the earth mover's distance from the rose histograms of one shape to the rose histograms of the other shape, with one histogram per point. The function "munkres.m" is written by Yi Cao, originally from here:
https://www.mathworks.com/matlabcentral/fileexchange/20328-munkres-assignment-algorithm

### Prerequisites

For this to run you need Matlab installed, along these toolboxes:
	-image_toolbox
	-statistics_toolbox

If you want to run test_ransac.m you have to install Kovesi's matlab packages, they can be found here: 
http://www.peterkovesi.com/matlabfns/index.html

## Versioning

This is version 1, it is fairly slow, in the future I plan on writing a CUDA version or it as well as an update mechanism for the histograms. 

## Author

Adrian Szatmari 

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details

## Acknowledgments

* Warm thanks to Peter Kovesi and to Yi Cao for making their code publicly available. 
* Warm thanks to Serge Belongie, Jitendra Malik and Jan Puzicha for their excellent paper. 
