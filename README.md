# cleaning_project
Class project for Getting and Cleaning data

This script works by reading in the samsung data.  The samsung data .zip file must be extracted in the working directory.  
The script will look for the files in the extracted path.

The script will create a data frame for both the "test" and "train" data sets.  
It will name the columns appropriately from the features.txt file.
It will also name the activities by setting it up as a factor.
The columns that contain "std" or "mean" will then be selected within each data frame and the data frames will be merged.
Finally, the data frame will be grouped by subject & activity and the mean for each of the columns/variables will be calculated.
The final summary will be written to the file merged.summary.txt.
