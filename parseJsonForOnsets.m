function [ bars, beats, segments, artistNew,titleNew, urlPreview, tempo ] = parseJsonForOnsets( artist, title, api_key )
% just want to get the beats and segments easily
% api_key='JOJVU69YBBKBHWZAO';
% artist='coldplay';
% title='life';

%urlGeneral=sprintf('http://developer.echonest.com/api/v4/song/search?api_key=%s&format=json&results=1&artist=%s&title=%s&bucket=audio_summary',api_key,artist,title);

urlGeneral=sprintf('http://developer.echonest.com/api/v4/song/search?api_key=%s&format=json&results=1&artist=%s&title=%s&bucket=audio_summary&bucket=tracks&bucket=id:7digital-US',api_key,artist,title);
parsedData=loadjson(urlread(urlGeneral));
%print out the artist and title
artistNew=parsedData.response.songs.artist_name
titleNew=parsedData.response.songs.title
urlPreview=parsedData.response.songs.tracks(1).preview_url;
tempo=parsedData.response.songs.audio_summary.tempo;
urlSummary=parsedData.response.songs.audio_summary.analysis_url;
parsedSummary=loadjson(urlread(urlSummary));

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
bars=parsedSummary.bars;
beats=parsedSummary.beats;
segments=parsedSummary.segments;
end

