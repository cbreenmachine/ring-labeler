function gatherRawImages(img_seq_fol, varargin)
%GATHERRAWIMAGES goes into the img_seq_fol folder and pulls out a random
%assortment of images that we will label using MATLAB's image labeler app.
%prob gives the probability that a given image
%varargin is either nothing or a a trget folder (i.e. where to save the
%image set)

% Set target_folder
if (nargin > 0)
   target_fol = varargin{1}; 
else
   target_fol = pwd;
end


% list of the folders with sequences (e.g. 54320 contains image01,...)
master_fol = dir(img_seq_fol);
master_fol = pruneDirectory(master_fol);

for ff = 1:length(master_fol)
    % loop thru the sub folders (e.g. 54320)
    sub_fol_name = master_fol(ff).name;
    
    % loop thru images in one folder at a time
    img_list = dir(strcat(img_seq_fol, sub_fol_name));
    img_list = pruneDirectory(img_list);
    
    % how many images in sequence
    num_imgs = length(img_list);
    
    % allocate memory, size of first image by the number of images
    first_img = rgb2gray(imread(strcat(img_seq_fol, sub_fol_name, "/", img_list(1).name)));
    
    sz = size(first_img);
    stack = zeros(sz(1), sz(2), num_imgs);
    
    % loop thru the 2nd image onwards
    for ii = 1:num_imgs
        stack(:,:,ii) = rgb2gray(imread(strcat(img_seq_fol, sub_fol_name, "/", img_list(ii).name)));
    end
    
    % get rid of black padding
    stack2 = removePadding(stack);
    
    % omit the duplicate frames
    stack3 = cullDuplicates(stack2);
    stack4 = uint8(stack3);
    
    % save to target folder
    save_fol = strcat(target_fol, sub_fol_name);
    saveStack(stack4, save_fol);
      
end
end

function pruned = pruneDirectory(directory)
%PRUNED goes through directory and keeps only the numeric folders (e.g.
%54321) and removes the weird ones (., ..)
index = false(length(directory), 1);

for ii = 1:length(directory)
    my_name = directory(ii).name;
    if (isnan(str2double(my_name)) && ~contains(my_name, ".png"))
        index(ii) = true;
    end 
end       
pruned = directory;
pruned(index, :) = [];
end

function cropped_stack = removePadding(stack)
%REMOVEPADDING removes the large black edges that are an artifact of
%ClearVolume.

% one imae out of the many
layer = stack(:,:,1);

% find the bounding
[row, col] = find(layer > 0);

% crop it
cropped_stack = stack(min(row):max(row), min(col):max(col), :); % crop the stored hyper cube

end


function culled_stack = cullDuplicates(stack)
%CULLDUPLICATES takes a 3D stack of images and itereates thru z to
%eliminate the duplicate images

% copy stack to the sacrificial lamb
culled_stack = stack;

% loop thru image and then loop thru succeeding images
num_images = size(stack, 3);
index = false(num_images, 1);

for ii = 1:num_images
    img_ii = stack(:, :, ii);
    
    for jj = (ii + 1):num_images
        img_jj = stack(:, :, jj);
        
        % if they're the same, kill it
        if(img_ii == img_jj)
           index(jj) = true;
        end
    end
end

% empty duplicates
culled_stack(:,:,index) = [];

end


function saveStack(stack, save_fol)
%SAVESTACK saves an image stack as a sequence of pngs
%save_fol should be in the form save/me/54320, and the stack layers will be
%saved as 54320-000, 54320-001, etc. 

num_layers = size(stack, 3);
for zz = 1:num_layers
   full_path = strcat(save_fol, "-", sprintf('%03d', zz), '.png');
   imwrite(stack(:,:,zz), full_path)
end

msg = strcat("Wrote ", string(num_layers), " images to ", save_fol);
disp(msg)
end