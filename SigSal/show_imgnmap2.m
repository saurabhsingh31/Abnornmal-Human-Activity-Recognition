function show_imgnmap2( frame , smap )

smap = mat2gray( imresize(smap,[size(frame,1) size(frame,2)]) );
imshow(smap);