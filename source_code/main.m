function[validation_overall_results, testing_overall_results] = main(nb)

%load all datasets
[training_input,training_output,validation_input,validation_output, ...
    testing_input,testing_output] = load_all_datastes('all_datasets.xlsx',nb);

number_of_features = size(training_input,1); %Input vector nodes
number_of_outputs_nodes = size(training_output,1);

hidden_layer_neurons = 10;
count_of_input_vectors = size(training_input,2);


%Form MLP neural network
net = fitnet(hidden_layer_neurons);

%Set netwok parameters
net.layers{1}.transferFcn = 'logsig';
net.layers{2}.transferFcn = 'purelin';
net.trainParam.max_fail = 100;
net.trainParam.epochs = 1000;

%Use all provided data for training
net.divideFcn = 'dividerand';
net.divideParam.trainRatio = 1.0;
net.divideParam.valRatio = 0;
net.divideParam.testRatio = 0;

%Train the network with training data
net = train(net,training_input,training_output);

%Validate the network
estimated_validation_output = net(validation_input);
perf = perform(net,estimated_validation_output,validation_output);

labels = ['LoSC '; 'LoPrt'; 'LoSF '; 'LoRM '; 'LoLgm'; 'LoNa '; 'LoP  '; 'HiUF '; 'HiC  '; 'HiD  '; 'HiFib'];

%Threshold values determined for each output node (diet type) from
%validation data to minimize output error
threshold_values = [0.23, 0.20, 0.50, 0.139, 0.35, 0.3, 0.30, 0.43, 0.43, 0.26, 0.26];

%Conform output to binary values 
for i = 1:11
    estimated_validation_output_binary(i,:) = apply_threshold(estimated_validation_output,i,threshold_values(i));
end

%Compare estimated validation data results with known outputs
validation_difference = validation_output - estimated_validation_output_binary;

%Generate overall results table for validation results
for j = 1:11
    validation_overall_results(j,1) = size(validation_input,2); %Total
    validation_overall_results(j,2) = sum(~logical(validation_difference(j,:))); %Correct
    validation_overall_results(j,3) = sum(logical(validation_difference(j,:))); %Incorrect
    validation_overall_results(j,4) = 100 * validation_overall_results(j,2)/validation_overall_results(j,1); %Success Percentage
    
    validation_overall_results(j,5) = sum(validation_output(j,:)==1); %Total
    validation_overall_results(j,7) = sum(validation_difference(j,:)==1); %Incorrect
    validation_overall_results(j,6) = validation_overall_results(j,5) - validation_overall_results(j,7); %Correct
    validation_overall_results(j,8) = 100 * validation_overall_results(j,6)/validation_overall_results(j,5); %Success Percentage
    
    validation_overall_results(j,9) = sum(validation_output(j,:)==0); %Total
    validation_overall_results(j,11) = sum(validation_difference(j,:)==-1); %Incorrect
    validation_overall_results(j,10) = validation_overall_results(j,9) - validation_overall_results(j,11); %Correct
    validation_overall_results(j,12) = 100 * validation_overall_results(j,10)/validation_overall_results(j,9); %Success Percentage
end

%validation_overall_results = [labels, num2str(validation_overall_results)];

%Test the network. Run testing data through the trained network
estimated_testing_output = net(testing_input);

%Conform output to binary values
for i = 1:11
    estimated_testing_output_binary(i,:) = apply_threshold(estimated_testing_output,i,threshold_values(i));
end
testing_difference = testing_output - estimated_testing_output_binary;

%Generate overall results table for testing results
for j = 1:11
    testing_overall_results(j,1) = size(testing_input,2); %Total
    testing_overall_results(j,2) = sum(~logical(testing_difference(j,:))); %Correct
    testing_overall_results(j,3) = sum(logical(testing_difference(j,:))); %Incorrect
    testing_overall_results(j,4) = 100 * testing_overall_results(j,2)/testing_overall_results(j,1); %Success Percentage
    
    testing_overall_results(j,5) = sum(testing_output(j,:)==1); %Total
    testing_overall_results(j,7) = sum(testing_difference(j,:)==1); %Incorrect
    testing_overall_results(j,6) = testing_overall_results(j,5) - testing_overall_results(j,7); %Correct
    testing_overall_results(j,8) = 100 * testing_overall_results(j,6)/testing_overall_results(j,5); %Success Percentage
    
    testing_overall_results(j,9) = sum(testing_output(j,:)==0); %Total
    testing_overall_results(j,11) = sum(testing_difference(j,:)==-1); %Incorrect
    testing_overall_results(j,10) = testing_overall_results(j,9) - testing_overall_results(j,11); %Correct
    testing_overall_results(j,12) = 100 * testing_overall_results(j,10)/testing_overall_results(j,9); %Success Percentage
end


end
