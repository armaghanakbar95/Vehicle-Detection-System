function [C_Precision, C_Recall, C_F1 ]= other_detector(vidObj, gtData)
    % Load pre-trained model
   detector = vehicleDetectorACF('front-rear-view');

   
   if isprop(detector, 'ClassificationThreshold')
        detector.ClassificationThreshold = 0.2;  % Lower = more detections
    elseif isprop(detector, 'Threshold')
        detector.Threshold = 0.2;
    end
   
   

    nFrames = vidObj.NumFrames;
    Array_precision = zeros(nFrames, 1);
    Array_recall = zeros(nFrames, 1);
    Array_f1 = zeros(nFrames, 1);

    hFig = figure;
    set(hFig, 'Name', 'Cascade', 'NumberTitle', 'off');

    for n = 1:vidObj.NumFrames
        frame = read(vidObj, n);  % Read the nth frame
        if isempty(frame)
    error('The frame is empty. Check the video object.');
end
    
        % Get ground truth for the current frame
        gt = gtData{n};
    
        % Perform detection on the input frame
        %bboxes = step(detector, frame);
        [bboxes,scores] = detect(detector,frame);
        labels='Car';
        detectedImg = insertObjectAnnotation(frame,"Rectangle",bboxes,labels);
        imshow(detectedImg)

        threshold = 0.5;
        % Calculating Precision and recall By using built in function
        if isempty(bboxes)
        Cprecision = 0;
        Crecall = 0;
        else
        [Cprecision,Crecall] = bboxPrecisionRecall(bboxes,gt, threshold);
        end
        %Calculating Values of F1 For Each Frame
         if Cprecision==0 && Crecall == 0
        Cf1 = 0;
        else 
        Cf1 = 2 * (Cprecision * Crecall) / (Cprecision + Crecall);
         end

        % Saving values By each Frame
        Array_precision(n) = Cprecision;
        Array_recall(n) = Crecall;
        Array_f1(n) = Cf1;
    end
    %return Arrays
    C_Precision = Array_precision;
    C_Recall = Array_recall;
    C_F1 = Array_f1;
end