function[training_input,training_output,validation_input,validation_output, ...
    testing_input,testing_output] = load_all_datastes(file_name,no_bias)

no_bias=logical(no_bias);

%file_name = 'all_datasets.xlsx';

training = readtable(file_name, 'Sheet', 'Training');
validation = readtable(file_name, 'Sheet', 'Validation');
testing = readtable(file_name, 'Sheet', 'Testing');

training_input = table2array(training(:,1:9-no_bias))';
validation_input = table2array(validation(:,1:9-no_bias))';
testing_input = table2array(testing(:,1:9-no_bias))';

training_output = table2array(training(:,11:21))';
validation_output = table2array(validation(:,11:21))';
testing_output = table2array(testing(:,11:21))';

end