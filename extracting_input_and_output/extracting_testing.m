number_of_samples_per_interval = 23976;
number_of_intervals = 10;
fs = 399.6098;

number_of_channels = 16;

files = dir('data/Dog_2/*.mat');
number_of_files = length(files);

A = zeros(number_of_channels,number_of_samples_per_interval,number_of_intervals);
number_of_features = 6 * number_of_channels;
X = zeros(number_of_intervals, number_of_features);
Y = zeros(number_of_intervals, 1);

index = 1;

filename = 'data/SzPrediction_answer_key.csv';
delimiter = ',';
startRow = 2;

formatSpec = '%s%f%[^\n\r]';
fileID = fopen(filename,'r');
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'TextType', 'string', 'EmptyValue', NaN, 'HeaderLines' ,startRow-1, 'ReturnOnError', false, 'EndOfLine', '\r\n');

fclose(fileID);
SzPredictionanswerkey = table(dataArray{1:end-1}, 'VariableNames', {'clip','preictal'});

interictalLeft = 1500;
preictalLeft = 1500;
for i=1:number_of_files
    if (interictalLeft <= 0 && preictalLeft <= 0) 
        break;
    end
    file = files(i);
    loadedFile = load("data/Dog_2/" + file.name);
    fields = fieldnames(loadedFile);
    field = fields{1};
    segment = getfield(loadedFile, field);
    for j = 1:number_of_intervals
        A(:,:, j) = segment.data(1:number_of_channels,(j-1)*number_of_samples_per_interval + 1: j*number_of_samples_per_interval);
        disp(index);
        feature_index = 1;
        
        if (contains(file.name, 'interictal') || (contains(file.name, 'test') && SzPredictionanswerkey{contains(SzPredictionanswerkey.clip, file.name),{'preictal'}} == 0)) && interictalLeft > 0 
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
            Y(index) = 0;
            interictalLeft = interictalLeft - 1;
            index = index + 1;
        elseif (contains(file.name, 'preictal') || (contains(file.name, 'test') && SzPredictionanswerkey{contains(SzPredictionanswerkey.clip, file.name),{'preictal'}} == 1)) && preictalLeft > 0
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
            Y(index) = 1;
            preictalLeft = preictalLeft - 1;
            index = index + 1;
        end
    end
end
mkdir('out');
save('out/testX.mat', 'X');
save('out/testY.mat', 'Y');

    

