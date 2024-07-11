% Calculate RT, MT, Mean Deviation for each trial of each subejct
% and create a struct without the mov signals and save it as a
% single struct called efc1_all.mat
day = [1,2,3,4,5];
percent_after_RT = 15;
for k = 1:length(day)
    % getting subject files:
    files = dir(fullfile(usr_path, 'Desktop', 'Projects', 'EFC2', 'analysis', ['efc2_*' '_day_' num2str(k) '_raw.tsv']));
    movFiles = dir(fullfile(usr_path, 'Desktop', 'Projects', 'EFC2', 'analysis', ['efc2_*' '_day_' num2str(k) '_mov.mat']));
    
    % container to hold all subjects' data:
    ANA = [];
    
    % looping through subjects' data:
    for i = 1:length({files(:).name})
        % load subject data:
        tmp_data = dload(fullfile(files(i).folder, files(i).name));
        tmp_mov = load(fullfile(movFiles(i).folder, movFiles(i).name));
        tmp_mov = tmp_mov.MOV_struct;
    
        mean_dev_tmp = zeros(length(tmp_data.BN),1);
        rt_tmp = zeros(length(tmp_data.BN),1);
        mt_tmp = zeros(size(rt_tmp));
        v_dev_tmp = zeros(length(tmp_data.BN),5);
        first_finger_tmp = zeros(size(rt_tmp));
        
        diff_force_f1 = zeros(length(tmp_data.BN),1);
        diff_force_f2 = zeros(length(tmp_data.BN),1);
        diff_force_f3 = zeros(length(tmp_data.BN),1);
        diff_force_f4 = zeros(length(tmp_data.BN),1);
        diff_force_f5 = zeros(length(tmp_data.BN),1);
    
        force_f1 = zeros(length(tmp_data.BN),1);
        force_f2 = zeros(length(tmp_data.BN),1);
        force_f3 = zeros(length(tmp_data.BN),1);
        force_f4 = zeros(length(tmp_data.BN),1);
        force_f5 = zeros(length(tmp_data.BN),1);
        force_e1 = zeros(length(tmp_data.BN),1);
        force_e2 = zeros(length(tmp_data.BN),1);
        force_e3 = zeros(length(tmp_data.BN),1);
        force_e4 = zeros(length(tmp_data.BN),1);
        force_e5 = zeros(length(tmp_data.BN),1);
        % loop through trials:
        for j = 1:length(tmp_data.BN)
            % if trial was correct:
            if (tmp_data.trialCorr(j) == 1)
                % calculate and store mean dev:
                mean_dev_tmp(j) = calculate_mean_dev(tmp_mov{j}, tmp_data.chordID(j), ...
                                                     tmp_data.baselineTopThresh(j), tmp_data.RT(j), ...
                                                     tmp_data.fGain1(j), tmp_data.fGain2(j), tmp_data.fGain3(j), ...
                                                     tmp_data.fGain4(j), tmp_data.fGain5(j));
                % calculate and stor rt and mt:
                [rt_tmp(j),mt_tmp(j),first_finger_tmp(j)] = calculate_rt_mt(tmp_mov{j}, tmp_data.chordID(j), ...
                                                            tmp_data.baselineTopThresh(j), tmp_data.RT(j), ...
                                                            tmp_data.fGain1(j), tmp_data.fGain2(j), tmp_data.fGain3(j), ...
                                                            tmp_data.fGain4(j), tmp_data.fGain5(j));
                % calculate initial deviation vector from ideal trajectory:
                v_dev_tmp(j,:) = calculate_dev_vector(tmp_mov{j}, tmp_data.chordID(j), ...
                                                      tmp_data.baselineTopThresh(j), tmp_data.RT(j), percent_after_RT, ...
                                                      tmp_data.fGain1(j), tmp_data.fGain2(j), tmp_data.fGain3(j), ...
                                                      tmp_data.fGain4(j), tmp_data.fGain5(j));
                
                % average force:
                idx_completion = find(tmp_mov{j}(:,1)==3);
                idx_completion = idx_completion(end);
                diff_force_f1(j) = mean(tmp_mov{j}(idx_completion-299:idx_completion,14));
                diff_force_f2(j) = mean(tmp_mov{j}(idx_completion-299:idx_completion,15));
                diff_force_f3(j) = mean(tmp_mov{j}(idx_completion-299:idx_completion,16));
                diff_force_f4(j) = mean(tmp_mov{j}(idx_completion-299:idx_completion,17));
                diff_force_f5(j) = mean(tmp_mov{j}(idx_completion-299:idx_completion,18));
    
                force_f1(j) = mean(tmp_mov{j}(idx_completion-299:idx_completion,9));
                force_f2(j) = mean(tmp_mov{j}(idx_completion-299:idx_completion,10));
                force_f3(j) = mean(tmp_mov{j}(idx_completion-299:idx_completion,11));
                force_f4(j) = mean(tmp_mov{j}(idx_completion-299:idx_completion,12));
                force_f5(j) = mean(tmp_mov{j}(idx_completion-299:idx_completion,13));
                force_e1(j) = mean(tmp_mov{j}(idx_completion-299:idx_completion,4));
                force_e2(j) = mean(tmp_mov{j}(idx_completion-299:idx_completion,5));
                force_e3(j) = mean(tmp_mov{j}(idx_completion-299:idx_completion,6));
                force_e4(j) = mean(tmp_mov{j}(idx_completion-299:idx_completion,7));
                force_e5(j) = mean(tmp_mov{j}(idx_completion-299:idx_completion,8));
            
            % if trial was incorrect:
            else
                diff_force_f1(j) = -1;
                diff_force_f2(j) = -1;
                diff_force_f3(j) = -1;
                diff_force_f4(j) = -1;
                diff_force_f5(j) = -1;
    
                force_f1(j) = -1;
                force_f2(j) = -1;
                force_f3(j) = -1;
                force_f4(j) = -1;
                force_f5(j) = -1;
                force_e1(j) = -1;
                force_e2(j) = -1;
                force_e3(j) = -1;
                force_e4(j) = -1;
                force_e5(j) = -1;
    
                % mean dev:
                mean_dev_tmp(j) = -1;
                rt_tmp(j) = -1;
                mt_tmp(j) = -1;
                v_dev_tmp(j,:) = -1*ones(1,size(v_dev_tmp,2));
                first_finger_tmp(j) = -1;
            end
        end
        
        % removing unnecessary fields:
        tmp_data = rmfield(tmp_data,'RT');
        tmp_data = rmfield(tmp_data,'trialPoint');
    
        % adding the calculated parameters to the subject struct:
        tmp_data.RT = rt_tmp;
        tmp_data.MT = mt_tmp;
        tmp_data.first_finger = first_finger_tmp;
        tmp_data.MD = mean_dev_tmp;
        tmp_data.v_dev1 = v_dev_tmp(:,1);
        tmp_data.v_dev2 = v_dev_tmp(:,2);
        tmp_data.v_dev3 = v_dev_tmp(:,3);
        tmp_data.v_dev4 = v_dev_tmp(:,4);
        tmp_data.v_dev5 = v_dev_tmp(:,5);
    
        tmp_data.diff_force_f1 = diff_force_f1;
        tmp_data.diff_force_f2 = diff_force_f2;
        tmp_data.diff_force_f3 = diff_force_f3;
        tmp_data.diff_force_f4 = diff_force_f4;
        tmp_data.diff_force_f5 = diff_force_f5;
    
        tmp_data.force_f1 = force_f1;
        tmp_data.force_f2 = force_f2;
        tmp_data.force_f3 = force_f3;
        tmp_data.force_f4 = force_f4;
        tmp_data.force_f5 = force_f5;
        tmp_data.force_e1 = force_e1;
        tmp_data.force_e2 = force_e2;
        tmp_data.force_e3 = force_e3;
        tmp_data.force_e4 = force_e4;
        tmp_data.force_e5 = force_e5;

        tmp_data.day = day(k) * ones(size(tmp_data.force_e1));
        
        % is testing day:
        tmp_data.is_test = ismember(day(k),[1,5]) * ones(size(tmp_data.force_e1));
        
        % adding subject data to ANA:
        ANA=addstruct(ANA,tmp_data,'row','force');
    end

    dsave(fullfile(usr_path,'Desktop','Projects','EFC2','analysis',['efc2_all_' 'day_' num2str(k) '.tsv']),ANA);
end