function ANA = efc2_subj(subj_num,varargin)

% setting paths:
usr_path = userpath;
usr_path = usr_path(1:end-17);
project_path = fullfile(usr_path, 'Desktop', 'Projects', 'EFC2');

day = [1,2,3,4,5];
smoothing_win_length = 30;
fs=500;
vararginoptions(varargin,{'smoothing_win_length','fs'})
for j = 1:length(day)
    ANA = [];
    datFileName = fullfile(project_path,'data',['day' num2str(j)], ['efc2_' num2str(subj_num) '.dat']);
    subjFileName = [usr_path '/Desktop/Projects/EFC2/analysis/efc2_' num2str(subj_num) '_day_' num2str(j) '_raw.tsv'];          % output dat file name (saved in analysis folder)
    movFileName = [usr_path '/Desktop/Projects/EFC2/analysis/efc2_' num2str(subj_num) '_day_' num2str(j) '_mov.mat'];           % output mov file name (saved in analysis folder)

    D = dload(datFileName);

    % container for the dat and mov structs:
    MOV_struct = cell(length(D.BN),1);
    oldBlock = -1;
    % loop on trials:
    for i = 1:length(D.BN)
        % load the mov file for each block:
        if (oldBlock ~= D.BN(i))
            fprintf("Loading the .mov file.\n")
            mov = movload(fullfile(project_path,'data',['day' num2str(j)],['efc2_' num2str(subj_num) '_' num2str(D.BN(i),'%02d') '.mov']));
            oldBlock = D.BN(i);
        end
        fprintf('Block: %d , Trial: %d\n',D.BN(i),D.TN(i));
        % trial routine:
        C = efc2_trial(getrow(D,i));
    
        % adding the routine output to the container:
        ANA = addstruct(ANA,C,'row','force');
    
        % MOV file: 
        MOV_struct{i} = smoothing(mov{D.TN(i)}, smoothing_win_length, fs);
    end
    
    % adding subject name to the struct:
    sn = ones(length(D.BN),1) * subj_num;
    
    % remove subNum field:
    ANA = rmfield(ANA,'subNum');
    
    % adding subj number to ANA:
    ANA.sn = sn;
    
    % saving ANA as a tab delimited file:
    dsave(subjFileName,ANA);
    
    % saving mov data as a binary file:
    save(movFileName, 'MOV_struct', '-v7.3')
end
    

