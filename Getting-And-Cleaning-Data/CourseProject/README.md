README

Run ```loadData()``` function from "run_analysis.R" - function will load and extract data into "UCI HAR Dataset". Function ```loadData``` has 1 parameter: "then.run" if it is set to "TRUE" - than analysis will automatically start after loading & extracting the data, otherwise you have to call function ```runAnalysis()``` manually to run the analysis. 

If you have already gotten the data put the *"run_analysis.R"* in the same folder where "UCI HAR Dataset" folder is located.

Script will read the data from: 
- *activity_labels.txt*
- *features.txt*
- *test\X_test.txt*
- *test\subject_test.txt*
- *test\y_test.txt*
- *train\X_train.txt*
- *train\subject_train.txt*
- *train\y_train.txt*

merge test and train datasets and extract only data of mean and standart deviation.

After merging script will write tidy data into two files:

- *tidy.txt* - all data(mean and standart deviation)
- *tidy_avereged.txt* - same as *"tidy.txt"* but with the average of each variable for each activity and each subject. 

More information about tidy datasets you can find in *"CodeBook.md"*.
