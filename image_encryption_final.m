% The code is done to perform exactly as the paper describes..
% Firstly, two  encryption keys are generated to be used for permutation
% step and the diffusion step, each key for a step.
% 
% The image encryption is carried out as following...
% 1- shuffle pixel indices using the Hilbert maps
% 2- Perform double cyclic shift in the resultant image. The cyclic shift  
% is done twice (doubled) one to the left using summation of the pixel
% value to the binary representation and one to the right using summation
% of the numbers in the key.
% 3- Perform the diffusion step to the previously encoded image and results
% in the final encrypted image.
% Refreshing figures and memory
clear, clc, close all

% Include the folder containing all helper functions
addpath('lib')
%  1- read the original image, 
I = imresize(imread('cameraman.tif'), [256, 256]);  % the resize is mentioned in the paper

% Key generation using the Henon keys
[m, n, ~] = size(I);

% As noted earlier, the keys are used in permutation ans the diffusion
% steps.
disp('Generating keys')
[key1, key2] = keys_generation_henon_maps(m, n);

% 1st step is to shuffle the pixels using Hilbert scan method..
% Firstly construct the suffle indices..
disp('========Encoding=========')
disp('Hilbert maps encoding')
shuffle_inds  = my_hibert_index(m, n);
% Shuffle the input image.
I_hilb = double(reshape(I(shuffle_inds), [m, n]));

% Performing permtation using double cyclic shift 
disp('Permutation encoding')
I_perm = permutation_encode(I_hilb, key1);


% Final step of the encodng process to diffuse the output image using key2
disp('Deffusion encoding')
I_diff = diffuse_encode(I_perm, key2);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Decoding step:
% Starting with diffusion decoding

disp('========Decoding=========')
disp('Diffusion decoding')
I_diff_dec = diffuse_decode(I_diff, key2);


% Then perform the permutation decoding from the above restored image
disp('Permutation decoding')
I_perm_dec = permutation_decode(I_diff_dec, key1);


% Finally, resoring the image using shffled 
disp('Hilbert maps decoding')
rec_inds = my_hibert_inverse_index(m, n);
I_hilb_dec = reshape(I_perm_dec(rec_inds), [m, n]);
%

%%
% Figures and displays
imshow(I, []), title('Original image')
figure, imshow(I_hilb, []), title('Hilbert maps shuffled image')
figure, imshow(rescale(I_perm)), title('Permuting the shuffled image using double cicular shift')
figure, imshow(rescale(I_diff)), title('Final diffused image (Final ecoded image)') 


figure, imshow(I_diff_dec, []), title('Diffused restored image')
figure, imshow(I_perm_dec, []), title('Permtation restored image')
figure, imshow(I_hilb_dec, []), title('Hilbert restored image (Final decoded image)')