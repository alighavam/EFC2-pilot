function v_dev = calculate_dev_vector(mov, chordID, force_threshold, completion_time, percentage, fGain1, fGain2, fGain3, fGain4, fGain5)
% Description: 
%       Calculate deviation vector for the trial.
%
% INPUTS:
%       mov: the matrix that contains the mov data of the trial
%
%       chordID: ID of the chord. e.g. 12999 -> extension thumb, flexion
%       inedx, others relaxed.
%       
%       force_threshold: the force threshold of the baseline zone. 
%       
%       completion_time: Time from t=0 until the end of the execution phase
%
%       duration: Calculate the initial trajectory vector until
%                 duration(ms) after the first finger goes out of baseline
%
% OUTPUTS:
%       v_dev: the initial deviation vector from ideal trajectory

% container for thresholded force data:
forceTmp = [];

% time vector of the force signals:
tVec = mov(:,3);

% time of Go Cue, first time when state variable becomes 3:
tGoCue = mov(find(mov(:,1)==3,1),3);

% Turning chordID into a char array:
chordID = num2str(chordID);

% Gain applied to the fingers:
fGainVec = [fGain1 fGain2 fGain3 fGain4 fGain5];

% thresholding force of the fingers after "Go Cue" to find the first time
% a finger goes out of the baseline zone:
% Looping through fingers:
for j = 1:5
    % if instructed movement was extension:
    if (chordID(j) == '1')
        % Here it is assumed that if finger is instructed to extend, the
        % reaction time only makes sense when finger moves towards the
        % instructed state:
        forceTmp = [forceTmp (mov(tVec>=tGoCue,13+j)*fGainVec(j) > force_threshold)];
        
        % just as a sanity check that the finger has gone out of the 
        % baseline if instructed:
        if (isempty(find(forceTmp(:,end),1)))
            error('Mean Dev calculation error: Finger %d instructed to extend but does not look like it did. ChordID: %s',...
                j,chordID)
        end

    % if instructed movement was flexion:
    elseif (chordID(j) == '2')
        % Here it is assumed that if finger is instructed to extend, the
        % reaction time only counts when finger moves towards the
        % instructed state:
        forceTmp = [forceTmp (mov(tVec>=tGoCue,13+j)*fGainVec(j) < -force_threshold)];
        
        % just as a sanity check that the finger has gone out of the 
        % baseline if instructed:
        if (isempty(find(forceTmp(:,end),1)))
            error('Mean Dev calculation error: Finger %d instructed to flex but does not look like it did. ChordID: %s',...
                j,chordID)
        end

    % if finger should be relaxed:
    elseif (chordID(j) == '9')
        % If the finger should have been relaxed, we assume that if the
        % finger goes out of the baseline zone -both from extension and
        % flexion- it counts as RT:
        forceTmp = [forceTmp (mov(tVec>=tGoCue,13+j)*fGainVec(j) < -force_threshold | mov(tVec>=tGoCue,13+j)*fGainVec(j) > force_threshold)]; 
        
        % If finger never left the baseline zone as it should have, remove
        % the thresholded signal because it is all 0:
        if (isempty(find(forceTmp(:,end),1)))
            forceTmp(:,end) = [];
        end
    end
end

% find the first index where each finger moved out of the baseline:
tmpIdx = [];
for k = 1:size(forceTmp,2)
    tmpIdx(k) = find(forceTmp(:,k),1);
end

% Finding the earliest time that a finger went out of the baseline, 
% sortIdx(1) is the first index after "Go Cue" that the first finger 
% crossed the baseline threshold:
[sortIdx,~] = sort(tmpIdx);

% index after t=0 that the first finger moved out of baseline:
idxStart = find(tVec==tGoCue)+sortIdx(1)-1; 

% select the force from movement initiation until durAfterActive:
forceSelceted = [];

% Time from t=0 until durAfterActive:
durAfterActive = completion_time-600;    

% Optionally you may want to select the force from movement initiation 
% until a certain time later. In that case:
% durAfterActive = 200;   

% getting the force from idxStart to idxStart+durAfterActive
for j = 1:5     
    % durAfterActive is in ms. 500Hz is the fs.
    forceSelceted = [forceSelceted fGainVec(j)*mov(idxStart:find(tVec==tGoCue)+round(durAfterActive/1000*500),13+j)];
end

% The ideal trajectory. A straight line from the initial finger positions
% to the position right at the time when they reach the holding state:
c = forceSelceted(end,:)-forceSelceted(1,:);

% Initial trajectory vector:
v_init = mean(forceSelceted(1:round(percentage/100*size(forceSelceted,1)),:),1) - forceSelceted(1,:);

% calculate the initial deviation vector from ideal trajectory:
v_dev = c/norm(c) - v_init/norm(v_init);

if (v_init == 0)
    v_dev = -1*ones(1,5);
end


