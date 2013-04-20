function [ onsetSequence ] = averageOnset( barsGo,beatsGo,onsetsGo, debug)
index=4:2:length(barsGo)/2;%10:2:22;
barsGo=[(barsGo(1,index)-beatsGo(1,2)+beatsGo(1,1));barsGo(2,index)];
averageOnsets=zeros(50,length(barsGo));
confidence=zeros(50,length(barsGo));
for i=1:length(barsGo)
    k=1;
    for j=1:length(onsetsGo)
        if i==length(barsGo)
            if onsetsGo(1,j)>=barsGo(1,i) && onsetsGo(1,j)<(barsGo(1,i)+4)% && onsetsGo(2,j) > 0.4  %confidence > 0.4
                averageOnsets(k,i)=onsetsGo(1,j)-barsGo(1,i);
                confidence(k,i)=onsetsGo(2,j);
                k=k+1;
            end
        end
        if i~=length(barsGo)
            if (onsetsGo(1,j)>=barsGo(1,i)) && (onsetsGo(1,j)<barsGo(1,i+1))% && onsetsGo(2,j) > 0.4
                averageOnsets(k,i)=onsetsGo(1,j)-barsGo(1,i);
                confidence(k,i)=onsetsGo(2,j);
                k=k+1;
            end
        end
    end
end

uncertainty=ones(50,length(barsGo))-confidence; % use the confidence as a add on

seqIndex=1;
temp=10000000;
for i=1:length(barsGo)
    distance=0;
    for j=1:length(barsGo)
        if debug==1
            distance=distance+dtw(averageOnsets(:,i),averageOnsets(:,j),uncertainty(:,i),uncertainty(:,j));
        end
        if debug==0
            distance=distance+dtw(averageOnsets(:,i),averageOnsets(:,j));
        end
    end
    if distance<temp
        temp=distance;
        seqIndex=i;
    end
end

[x,y]=size(averageOnsets);
if y~=0
valueIndex=find(averageOnsets(:,seqIndex)>0);
onsetSequence(valueIndex)=averageOnsets(valueIndex,seqIndex);
end

if y==0
    onsetSequnce(1) = -1;
    display('fail to extract the onset!');
end

end
