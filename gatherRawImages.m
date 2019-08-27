function gatherRawImages(img_seq_fol, target_folder)
%GATHERRAWIMAGES goes into the img_seq_fol folder and pulls out a random
%assortment of images that we will label using MATLAB's image labeler app.
%prob gives the probability that a given image

% list of the folders with sequences (e.g. 54320 contains image01,...)
master_fol = dir(img_seq_fol);

for ff = 1:length(master_fol)
    % loop thru the sub folders (e.g. 54320)
    sub_fol = master_fol(ff).name;
    if (isnan(str2double(sub_fol)))
        % skip the werid ones in directory (e.g. '..')
        continue
    end
    
    % loop thru images in one folder at a time
    sub_fol = dir(strcat(img_seq_fol, sub_fol));
    for ii = 1:length(sub_fol)
        
    end
      
end
end




function culled_stack = cullDuplicates(stack)
%CULLDUPLICATES takes a 3D stack of images and itereates thru z to
%eliminate the duplicate images

% copy stack to the sacrificial lamb
culled_stack = stack;

% loop thru image and then loop thru succeeding images
num_images = size(stack, 3);
for ii = 1:num_images
    img_ii = stack(:, :, ii);
    
    for jj = (ii + 1):num_images
        img_jj = stack(:, :, jj);
        
        % if they're the same, kill it
        if(img_ii == img_jj)
           culled_stack(:, :, jj) = [];
        end
    end
end
end

function saveStack(stack, save_fol)
%SAVESTACK saves an image stack as a sequence of pngs
%save_fol should be in the form save/me/54320, and the stack layers will be
%saved as 54320-000, 54320-001, etc. 

a = sprintf('%03d', 0); % pro tip
end