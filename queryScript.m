%readDir='onsetClappingDataset';
%readList = dir(fullfile(readDir,'*.wav'));
fid = fopen ('dataset.txt','r');
tline = fgetl(fid);
i=1;
while ischar(tline) 
    tlineNew=regexp(tline,' - ', 'split');
    keys{i}=tlineNew{1};
    tempo(i)=str2num(tlineNew{2});
    value{i}=str2num(tlineNew{3}(2:length(tlineNew{3})-1));
    urlPreview{i}=tlineNew{4};
    i=i+1;
    tline = fgetl(fid);
end
fclose(fid);

%get live input
recObj = audiorecorder;
disp('Start speaking.')
recordblocking(recObj, 10);
disp('End of Recording.');

% Play back the recording.
%play(recObj);
tline
% Store data in double-precision array.c
myRecording = getaudiodata(recObj);
wavwrite(myRecording, 'test.wav');
% Plot the waveform.
%plot(myRecording);
hold on;

[rawOnsets,rawTempo]=minweiOnsets('test.wav');
%stem(rawOnsets*8000, ones(length(rawOnsets)), 'b-');
clapping = rawOnsets; %query data
index=find(abs(rawTempo-tempo)<5)
if length(index)>0
    dataset = {value{index}};     %value index and value as a hashtable
    resultIndex = qbc(clapping, dataset);
    result=index(resultIndex);


% output the result
stem(dataset{resultIndex}*8000,ones(length(dataset{resultIndex})), 'r');
keys{result}
dbraw = mkblips2(rawOnsets, 44100, 44100*8);
sound(dbraw,44100);
db = mkblips(dataset{resultIndex}, 44100, 44100*6);
sound(db,44100);
urlwrite(urlPreview{result},'temp.mp3');
[a,fs]=mp3read('temp.mp3');
sound(a,fs);

end

    
% test for the samples    
% for i = 1:length(readList)
%     wavName = readList(i, 1).name;
%     wavName
%     readPath = [readDir '/' wavName];
%     rawOnsets=minweiOnsets(readPath);
%     clapping=rawOnsets;
%     dataset = value;
%     result = qbc(clapping, dataset);
%     keys{result}
%       
% end