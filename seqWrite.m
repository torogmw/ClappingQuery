function [ number ] = seqWrite( title, tempo, onsetSequence, urlPreview )
% write the onsetSequence to the dataset

fid = fopen('dataset.txt', 'a+');
number=fprintf(fid,'%s - %s - %s - %s\n', title, mat2str(tempo,4), mat2str(onsetSequence,4), urlPreview);
fclose(fid);




end

