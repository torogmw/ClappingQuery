function [ result ] = qbc(clapping, dataset )
distance = 1000000;
%clapping=clapping(1:round(length(clapping)*0.8));  % need to improve after annie
for i=1:length(dataset)
   clappingRevised=clapping-clapping(1)+dataset{i}(1); %alignment optimization
   index=find(clappingRevised-dataset{i}(length(dataset{i}))<1);
   clappingNew=clappingRevised(index);
   temp=dtw(clappingNew,dataset{i});
   temp
%    figure;
%    stem(clapping,ones(length(clapping)),'r');
%    hold on;
%    stem(dataset{10},ones(length(dataset{10})),'g');   
   if temp<distance
       distance=temp;
       result=i;
   end
end
clappingRevised2=clapping-clapping(1)+dataset{result}(1);
index=find(clappingRevised2-dataset{result}(length(dataset{result}))<1);
clappingFinal=clappingRevised2(index);
stem(clappingFinal*8000, ones(length(clappingFinal))*0.5, '--bo');
end
