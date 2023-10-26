function slice = imsplitr(I,n)

%_______________________________________
% This function divides an image to n
% rectangular ring areas
%_______________________________________
%  Output args：
%     slice  [grayscale(2D) or rgb(3D) image arrays] : slices of I
% if I is a grayscale picture, the slice will be H*W*n array where H and W
%  are the height and width of image, the number of split areas
% if I is a rgb image, slice will be a H*W*3*n array.
%
% **************************************
%  Input args：
%   I  [grayscale or rgb image] : image to be segmented
%   n  [uint8 or double] : the number of split areas
%________________________________________
%
% Example:
%     I=imread('test.jpg');  % read a rgb picture
%     sl= imsplitr(I,4);
%     image(sl(:,:,:,1));  % display the outer rectangular ring
%   
%     gI=rgb2gray(I);     % grayscale input 
%     gsl=imsplitr（gI,4);
%     imshow(gsl(:,:,3)); % display the third ring from edge.
% 
% Log
% 25/Oct/2023:Function first Created   
%
%_______________________________________
% Author:
%    Yicheng Zhang
% Affiliations:
%   CIL-School of Computer Science- University of Lincoln; 
%  ISTL-Au school- Guangdong University of Petrolchemical Technology
%  Emaile: zhangyicheng@gdupt.edu.cn
%_______________________________________

[H,W,~]=size(I);
d=numel(size(I));

deltah=H/2/n;
deltaw=W/2/n;

% Test region mask
% r1x=[deltaw,W-deltaw,W-deltaw,deltaw];
% r1y=[deltah,deltah,H-deltah,H-deltah];
% r2x=[2*deltaw,W-2*deltaw,W-2*deltaw,2*deltaw]
% msk1=poly2mask(r1x,r1y,H,W);

% generate rectangle ring masks
    for i=1:n
       rx(:,i)=[i.*deltaw,W-i.*deltaw,W-i.*deltaw,i.*deltaw];
       ry(:,i)=[i.*deltah,i.*deltah,H-i.*deltah,H-i.*deltah];
       msk(:,:,i)=poly2mask(rx(:,i),ry(:,i),H,W);
       if i==1
           Masks(:,:,i)=~msk(:,:,i);
       else
           Masks(:,:,i)=xor(msk(:,:,i-1),msk(:,:,i));
       end
%        figure
%        imshow(Masks(:,:,i));
           if d==3
               % slice rgb image
                 rgbMask(:,:,1,i)=Masks(:,:,i);
                 rgbMask(:,:,2,i)=Masks(:,:,i);
                 rgbMask(:,:,3,i)=Masks(:,:,i);
                 slice(:,:,:,i)=immultiply(I,rgbMask(:,:,:,i));
           elseif d==2
               % slice grayscale image
                 slice(:,:,i)=immultiply(I,Masks(:,:,i));
           else
              %throw an error 
              
           end  % end of dimension judgement

%         slice(:,:,i)=immultiply(I,Masks(:,:,i));
    end  % end of for

% Masks(:,:,1)=~msk(:,:,1);
% Masks(:,:,2)=xor(msk(:,:,1),msk(:,:,2));
% Masks(:,:,3)=xor(msk(:,:,2),msk(:,:,3));



end