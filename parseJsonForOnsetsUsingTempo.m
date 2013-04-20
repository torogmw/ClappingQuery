function [  count ] = parseJsonForOnsetsUsingTempo( queryText,returnNum,api_key )
% Echonest query for tempo and onset calculation
% output the onset and tempo information and preview url
% this is a larger database with further query general search
count = 0;

fid = fopen (queryText,'r');
tline = fgetl(fid);
while ischar(tline) 
    tlineNew=regexp(tline,' ', 'split');
    minTempo=str2double(tlineNew{1}); 
    maxTempo=str2double(tlineNew{2});
    urlGeneral=sprintf('http://developer.echonest.com/api/v4/song/search?api_key=%s&format=json&results=%d&artist_min_familiarity=0.85&min_tempo=%d&max_tempo=%d&min_energy=0.72&bucket=audio_summary&bucket=tracks&bucket=id:7digital-US',api_key,returnNum,minTempo,maxTempo);
    parsedData=loadjson(urlread(urlGeneral));
    for index = 1:returnNum
        if (isempty(parsedData.response.songs(index).tracks) ~= 1)  % if have track preview, we count it
            %print print out the artist and title
            artistNew=parsedData.response.songs(index).artist_name
            titleNew=parsedData.response.songs(index).title
            urlPreview=parsedData.response.songs(index).tracks(1).preview_url;
            tempo=parsedData.response.songs(index).audio_summary.tempo;
            urlSummary=parsedData.response.songs(index).audio_summary.analysis_url;
            parsedSummary=loadjson(urlread(urlSummary));    % start the second query from here
            if (length(parsedSummary.bars)>10)
                barsGo=[parsedSummary.bars.start;parsedSummary.bars.confidence];
                beatsGo=[parsedSummary.beats.start;parsedSummary.beats.confidence];
            for i=1:length(parsedSummary.segments)
                onsetsGo(1,i)=parsedSummary.segments{i}.start;
                onsetsGo(2,i)=parsedSummary.segments{i}.confidence; 
                onsetsGo(3,i)=parsedSummary.segments{i}.loudness_max;
            end
            onsetSequence=averageOnset(barsGo,beatsGo,onsetsGo,1)
    %onsetSequence_2=averageOnset(barsGo,beatsGo,onsetsGo,0);
            if onsetSequence(1) ~= -1
            number = seqWrite(titleNew,tempo,onsetSequence,urlPreview);
            count=count+1;
            end
            end
        end   
    end
    tline = fgetl(fid);
end
fclose(fid);

% array initialization
% bars=zeros(1,length(parsedSummart.bars))
% segments=zeros(1,length(parsedSummary.segments));
% segmentsIndex=zeros(1,length(parsedSummary.segments));
% %beatsDuration=zeros(1,length(parsedSummary.beats));
% beats=zeros(1,length(parsedSummary.beats));
% for i=1:length(parsedSummary.segments)
%     segments(i)=parsedSummary.segments{1,i}.duration;
%     segmentsIndex(i)=parsedSummary.segments{1,i}.duration;
%     if i>1
%         segmentsIndex(i)=segments(i)+segmentsIndex(i-1);
%     end
% end
% for i=1:length(parsedSummary.beats)
%     beats(i)=parsedSummary.beats(1,i).duration;    
% end
% 
% fname=sprintf('%s_%s.txt',artistNew,titleNew);
% dlmwrite(fname,segments);

end

