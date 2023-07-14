function outMap = signatureSal( frame , param )


if ( strcmp(class(frame),'char') == 1 ) frame = imread(frame); end


if ( strcmp(class(frame),'uint8') == 1 ) frame = double(frame)/255; end

if ( ~exist( 'param' , 'var' ) )
  param = default_signature_param;
end

frame = imresize(frame, param.mapWidth/size(frame, 2));

numChannels = size( frame , 3  );

if ( numChannels == 3 )
  
  if ( isequal( lower(param.colorChannels) , 'lab' ) )
    
    labT = makecform('srgb2lab');
    tImg = applycform(frame, labT);
    
  elseif ( isequal( lower(param.colorChannels) , 'rgb' ) )
    
    tImg = frame;
    
  elseif ( isequal( lower(param.colorChannels) , 'dkl' ) )
    
    tImg = rgb2dkl( frame );
    
  end

else
  
  tImg = frame;

end

cSalMap = zeros(size(frame));  

for i = 1:numChannels
  cSalMap(:,:,i) = idct2(sign(dct2(tImg(:,:,i)))).^2;
end

outMap = mean(cSalMap, 3);

if ( param.blurSigma > 0 )
  kSize = size(outMap,2) * param.blurSigma;
  outMap = imfilter(outMap, fspecial('gaussian', round([kSize, kSize]*4), kSize));
end

if ( param.resizeToInput )
  outMap = imresize( outMap , [ size(frame,1) size(frame,2) ] );
end
  
outMap = mynorm( outMap , param );
