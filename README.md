# PushMe #
A workflow for the collection, processing, analysis and visualisation of personal 
transport choices.

### continuousMethod.R ###
This is an [R](http://http://cran.r-project.org) script for performing feature extraction 
on continuous accelerometer and GPS data. It produces and prepares a range of features for 
a decision-tree based classification process that occurs in the Processing application.

### pushMe.pde ###
This is a Processing sketch that reads in the R output, classifies the trip data by its 
transport mode, produces summary statistics and presents it all in a map/stat visualisation.

### pushMe.pde ###
This sketch performs the same initial operations as the main sketch, but the visualisation
 is geared towards a quick, glanceable display of information.
 
### Report.pdf ###
This is the dissertation that the system was built for, feel free to read it but fair warning, it's very long.
 
### Data ###
This folder contains some sample data for use in the Processing applications.

---------------------------------------

## License ##
- The Avenir typeface is Copyright © 2012 Linotype GmbH.
- The report is Copyright © 2012 Jack Harrison.
- Everything else is released under an [MIT License](http://opensource.org/licenses/MIT).