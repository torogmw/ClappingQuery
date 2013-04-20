api_key='JOJVU69YBBKBHWZAO';
returnNum=50;

% fid = fopen ('queryset.txt','r');
% tline = fgetl(fid);
% while ischar(tline) 
%     tlineNew=regexp(tline,' ', 'split');
%     artist=tlineNew{1}; title=tlineNew{2};
%     [ bars, beats, segments, artist, title, urlPreview, tempo]=parseJsonForOnsets( artist, title, api_key );
%     barsGo=[bars.start;bars.confidence];
%     beatsGo=[beats.start;beats.confidence];
%     for i=1:length(segments)
%         onsetsGo(1,i)=segments{i}.start;
%         onsetsGo(2,i)=segments{i}.confidence; 
%         onsetsGo(3,i)=segments{i}.loudness_max;
%     end
%     onsetSequence=averageOnset(barsGo,beatsGo,onsetsGo,1);
%     %onsetSequence_2=averageOnset(barsGo,beatsGo,onsetsGo,0);
%     number=seqWrite(title,tempo,onsetSequence,urlPreview);
%     tline = fgetl(fid);
% end
% fclose(fid);
% 
[ count ] = parseJsonForOnsetsUsingTempo( 'queryset.txt',returnNum,api_key )
% query start from here
fid = fopen ('dataset.txt','r');
tline = fgetl(fid);
i=1;
while ischar(tline) 
    tlineNew=regexp(tline,' - ', 'split');
    keys{i}=tlineNew{1};
    value{i}=str2num(tlineNew{2}(2:length(tlineNew{2})-1));
    i=i+1;
    tline = fgetl(fid);
end
fclose(fid);

%dtw matching
% clapping = onsets(1:length(onsets)/2);
% dataset = value;
% result = qbc(clapping, dataset);
% got=keys{result}
% ss stem(onsetsGo(1,:),onsetsGo(2,:),'--rs');
% hold on
% stem(beatsGo(1,:),beatsGo(2,:),'--ys');
% stem(barsGo(1,:),barsGo(2,:),'--bs');



% db = mkblips(onsetSequence, 44100, 44100*10);
% db1 = mkblips(barsGo(1,:va), 44100, 44100*300);
% db2 = mkblips2(beatsGo(1,:), 44100, 44100*300);
% db3 = mkblips(onsetsGo(1,:), 44100, 44100*300);
%sound(db,44100);
