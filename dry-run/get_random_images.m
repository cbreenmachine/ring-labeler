
% grab a few random images
n = 15;
pics_location = "../raw-images/";
copy_location = "images/";

delete_me = strcat(copy_location, "*.png");
delete(delete_me)

all_images = dir(pics_location);
all_images(1:2) = []; % no ., ..

sample = datasample(all_images, n, 'Replace', false);

%% loop and put images in our folder here

for ii = 1:length(sample)
   old = strcat(pics_location, sample(ii).name);
   new = strcat(copy_location, sample(ii).name);
   
   copyfile(old, new)
end
