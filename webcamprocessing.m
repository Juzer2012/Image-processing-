
%Initialise video capturing object
vid = videoinput('winvideo',3);

%SERIAL COMUNICATION%
%Declaring the serial comunication object , to initialise serial
%comunication
s=serial('COM8','BAUD',9600);
%open serial port
fopen(s);
%VIDEO PROPERTIES SETTNG UP%
% Set the properties of the video object
set(vid, 'FramesPerTrigger', Inf);
set(vid, 'ReturnedColorspace', 'rgb')
vid.FrameGrabInterval = 10;

%start the video aquisition here
start(vid)
% Set a loop that stop after 100 frames of aquisition
for i=1:100
%while(vid.FramesAcquired<=200)
     % Get the snapshot of the current frame
    IMRED = getsnapshot(vid);
     % Now to track red objects in real time%
    % we have to subtractED the red component 
    % from the grayscale image to extract the red components in the image.
    diff_im = imsubtract(IMRED(:,:,1), rgb2gray(IMRED));
     gr=graythresh(diff_im);
    %Median filter IS USED to filter out noise
    diff_im = medfilt2(diff_im, [3 3]);
    % Convert the resulting grayscale image into a binary image.
    diff_im = im2bw(diff_im,.18);
    
    % Remove all those pixels less than 300px
    diff_im = bwareaopen(diff_im,300);
    
      
    % Label all the connected components in the image
    %and also count the nuber of red objects in frame
    [bw bw1] = bwlabel(diff_im, 8);
    % condition if one or more than one red object is present in frame,then
    %send value '100' else send 101
    if bw1>=1
        fprintf(s,100);
    elseif bw1==0
       fprintf(s,101);
    % Here we do the image blob analysis.
    % We get a set of properties for each labeled region.
    stats = regionprops(bw, 'BoundingBox', 'Centroid');
    
    % Display the image
    imshow( IMRED )
    
    hold on
    
    %This is a loop to bound the red objects in a rectangular box.
    for object = 1:length(stats)
        bb = stats(object).BoundingBox;
        bc = stats(object).Centroid;
        rectangle('Position',bb,'EdgeColor','r','LineWidth',2)
        plot(bc(1),bc(2), '-m+')
        a=text(bc(1)+15,bc(2), strcat('X: ', num2str(round(bc(1))), '    Y: ', num2str(round(bc(2)))));
        set(a, 'FontName', 'Arial', 'FontWeight', 'bold', 'FontSize', 12, 'Color', 'yellow');
    end
    
    hold off
    end
end
% Both the loops end her.
% Stop the video aquisition.
stop(vid);

% Flush all the image data stored in the memory buffer.
flushdata(vid);
%Close the serial port ,so that further communication could be establihed
%again.
fclose(s);
% Clear all variables
clear all
sprintf('%s','Happy controlling arduino using color recognition')
