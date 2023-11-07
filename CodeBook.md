# Code Book
The script run_analysis.R does as follow:

1. First, downloads and unzips the folder using the url
2. Then, loads the data on which the cleaning is done as well as the rest of the necessary files in the folder.
3. Filters the data according to the asked criterion (features containing mean and standard deviation).
4. Merges the both the train and test datasets into a single dataframe.
5. Renames the columns of the dataset, updates factor values and sorts by the subject number.
6. Melts the sorted dataframe using the subject and activity as id and recasts it to get the mean of ecah feature for each (subject,activity) pair.

The clean_data.txt file contains 88 columns corresponding to the subject, activity and all the features considered (respectively).
The clean_data_mean.txt contains 88 columns as well. The first two are the different subject-activity combinations while the rest refer to the mean of each feature for that specific subject and activity.
