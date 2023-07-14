s=dir('*.mp4');
files={s.name};
for k=1:numel(files)
v= VideoReader(files{k});
j=0;
testFeatures=zeros(150,36);
while hasFrame(v)&&(j<150)
   
     frame=readFrame(v);
     j=j+1;
     labMap = signatureSal( frame );
     clf;
     subplot(1,2,1);
     show_imgnmap2( frame , labMap );
     title( sprintf('Sample Image %d: Image Signature - LAB', frame ) );
  
     c=detectHarrisFeatures(labMap);
     [fea,validcorner] = extractHOGFeatures(labMap,c);
     featVal = mean(fea);
     testFeatures(j, :) = featVal;
     testFeatures(~any(~isnan(testFeatures), 2),:)=[];
     
     imshow(labMap)
     hold on
     plot(validcorner);
     
    
end
xd=mean(testFeatures);
if k==1
     Final=xd;
else
     Final=[Final;xd];
end

end
csvwrite('Final.csv',Final)

