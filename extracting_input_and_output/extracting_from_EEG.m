number_of_samples_per_interval = 23976;
number_of_intervals = 10;
fs = 399.6098;

number_of_channels = 16;

files = dir('data/*.mat');
number_of_files = length(files);

A = zeros(number_of_channels,number_of_samples_per_interval,number_of_intervals);
number_of_features = 6 * number_of_channels;
X = zeros(number_of_intervals, number_of_features);
Y = zeros(number_of_intervals, 1);

index = 1;

for i=1:number_of_files
    file = files(i);
    if contains(file.name, "test")
        break;
    end
    loadedFile = load("data/" + file.name);
    fields = fieldnames(loadedFile);
    field = fields{1};
    segment = getfield(loadedFile, field);
    for j = 1:number_of_intervals
        A(:,:, j) = segment.data(1:number_of_channels,(j-1)*number_of_samples_per_interval + 1: j*number_of_samples_per_interval);
        disp(index);
        feature_index = 1;
        for channel = 1:number_of_channels
            X(index, feature_index) = bandpower(A(channel,:,j),fs,[0.5,4]);
            feature_index = feature_index + 1;
            X(index, feature_index) = bandpower(A(channel,:,j),fs,[4,8]);
            feature_index = feature_index + 1;
            X(index, feature_index) = bandpower(A(channel,:,j),fs,[8,13]);
            feature_index = feature_index + 1;
            X(index, feature_index) = bandpower(A(channel,:,j),fs,[13,30]);
            feature_index = feature_index + 1;
            X(index, feature_index) = bandpower(A(channel,:,j),fs,[30,70]);
            feature_index = feature_index + 1;
            X(index, feature_index) = bandpower(A(channel,:,j),fs,[70,128]);
            feature_index = feature_index + 1;
        end
        if contains(file.name, "interictal")
            Y(index) = 0;
        elseif contains(file.name, "preictal")
            Y(index) = 1;
        end

        index = index + 1;
        
    end
end
save('X.mat', 'X');
save('Y.mat', 'Y');

    

