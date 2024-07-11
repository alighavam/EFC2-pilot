trained = [29212;92122;91211;22911];
untrained = [21291;12129;12291;19111];
chords = [trained;untrained];

colors_red = [[255, 219, 219] ; [255, 146, 146] ; [255, 73, 73] ; [255, 0, 0] ; [182, 0, 0]]/255;
colors_gray = ['#d3d3d3' ; '#b9b9b9' ; '#868686' ; '#6d6d6d' ; '#535353'];
colors_blue = ['#dbecff' ; '#a8d1ff' ; '#429bff' ; '#0f80ff' ; '#0067db'];
colors_green = ['#9bdbb1' ; '#3aa35f' ; '#3aa35f' ; '#2d7d49' ; '#1f5833'];
colors_cyan = ['#adecee' ; '#83e2e5' ; '#2ecfd4' ; '#23a8ac' ; '#1b7e81'];
colors_random = ['#773344' ; '#E3B5A4' ; '#83A0A0' ; '#0B0014' ; '#D44D5C'];

colors_blue = hex2rgb(colors_blue);
colors_green = hex2rgb(colors_green);
colors_cyan = hex2rgb(colors_cyan);
colors_gray = hex2rgb(colors_gray);
colors_random = hex2rgb(colors_random);

D = dload('analysis/efc2_all.tsv');
D = getrow(D,D.trialCorr==1);

% colors for trained and untrained:
colors = [colors_green(3,:) ; colors_red(3,:)];

% loop on participants:
sn_unique = unique(D.sn);
for i = 1:length(sn_unique)
    % trained:
    row = ismember(D.chordID,trained) & D.sn==sn_unique(i);
    [~, day, MD, chord, SN] = get_sem(D.MD(row), D.sn(row), D.day(row), D.chordID(row));
    figure('Units','centimeters', 'Position',[15 15 8 8]);
    lineplot(day,MD,'markersize',2,'markerfill',colors(1,:),'markercolor',colors(1,:),'linecolor',colors(1,:),'linewidth',2,'errorcolor',colors(1,:),'errorcap',0);
    hold on;

    % untrained
    row = ismember(D.chordID,untrained) & D.sn==sn_unique(i) & D.is_test==1;
    [~, day, MD, chord, SN] = get_sem(D.MD(row), D.sn(row), D.day(row), D.chordID(row));
    lineplot(day,MD,'markersize',2,'markerfill',colors(2,:),'markercolor',colors(2,:),'linecolor',colors(2,:),'linewidth',2,'errorcolor',colors(2,:),'errorcap',0);

    h = gca;
    ylim([0 3])
    h.YTick = [0 1.5 3];
    h.LineWidth = 1;
    xlim([0.5 5.5])
    xlabel('day')
    ylabel('MD')
    title(sprintf('subject %d',sn_unique(i)))
end

for i = 1:length(sn_unique)
    % trained:
    row = ismember(D.chordID,trained) & D.sn==sn_unique(i);
    [~, day, MD, chord, SN] = get_sem(D.MT(row), D.sn(row), D.day(row), D.chordID(row));
    figure('Units','centimeters', 'Position',[15 15 8 8]);
    lineplot(day,MD,'markersize',2,'markerfill',colors(1,:),'markercolor',colors(1,:),'linecolor',colors(1,:),'linewidth',2,'errorcolor',colors(1,:),'errorcap',0);
    hold on;

    % untrained
    row = ismember(D.chordID,untrained) & D.sn==sn_unique(i) & D.is_test==1;
    [~, day, MD, chord, SN] = get_sem(D.MT(row), D.sn(row), D.day(row), D.chordID(row));
    lineplot(day,MD,'markersize',2,'markerfill',colors(2,:),'markercolor',colors(2,:),'linecolor',colors(2,:),'linewidth',2,'errorcolor',colors(2,:),'errorcap',0);

    h = gca;
    ylim([0 4200])
    h.YTick = [0 2100 4200];
    h.LineWidth = 1;
    xlim([0.5 5.5])
    xlabel('day')
    ylabel('MT')
    title(sprintf('subject %d',sn_unique(i)))
end

for i = 1:length(sn_unique)
    % trained:
    row = ismember(D.chordID,trained) & D.sn==sn_unique(i);
    [~, day, MD, chord, SN] = get_sem(D.RT(row), D.sn(row), D.day(row), D.chordID(row));
    figure('Units','centimeters', 'Position',[15 15 8 8]);
    lineplot(day,MD,'markersize',2,'markerfill',colors(1,:),'markercolor',colors(1,:),'linecolor',colors(1,:),'linewidth',2,'errorcolor',colors(1,:),'errorcap',0);
    hold on;

    % untrained
    row = ismember(D.chordID,untrained) & D.sn==sn_unique(i) & D.is_test==1;
    [~, day, MD, chord, SN] = get_sem(D.RT(row), D.sn(row), D.day(row), D.chordID(row));
    lineplot(day,MD,'markersize',2,'markerfill',colors(2,:),'markercolor',colors(2,:),'linecolor',colors(2,:),'linewidth',2,'errorcolor',colors(2,:),'errorcap',0);

    h = gca;
    ylim([100 700])
    h.YTick = [100 400 700];
    h.LineWidth = 1;
    xlim([0.5 5.5])
    xlabel('day')
    ylabel('RT')
    title(sprintf('subject %d',sn_unique(i)))
end

% trained:
row = ismember(D.chordID,trained);
[~, day, MD, chord, SN] = get_sem(D.MD(row), D.sn(row), D.day(row), ones(sum(row),1));
figure('Units','centimeters', 'Position',[15 15 8 8]);
lineplot(day,MD,'markersize',2,'markerfill',colors(1,:),'markercolor',colors(1,:),'linecolor',colors(1,:),'linewidth',2,'errorcolor',colors(1,:),'errorcap',0);
hold on;
% untrained:
row = ismember(D.chordID,untrained);
[~, day, MD, chord, SN] = get_sem(D.MD(row), D.sn(row), D.day(row), ones(sum(row),1));
lineplot(day,MD,'markersize',2,'markerfill',colors(2,:),'markercolor',colors(2,:),'linecolor',colors(2,:),'linewidth',2,'errorcolor',colors(2,:),'errorcap',0);
h = gca;
ylim([0 2.2])
h.YTick = [0 1.1 2.2];
h.LineWidth = 1;
xlim([0.5 5.5])
xlabel('day')
ylabel('MD')
title('average MD')

% trained:
row = ismember(D.chordID,trained);
[~, day, MD, chord, SN] = get_sem(D.MT(row), D.sn(row), D.day(row), ones(sum(row),1));
figure('Units','centimeters', 'Position',[15 15 8 8]);
lineplot(day,MD,'plotfcn','median','markersize',2,'markerfill',colors(1,:),'markercolor',colors(1,:),'linecolor',colors(1,:),'linewidth',2,'errorcolor',colors(1,:),'errorcap',0);
hold on;
% untrained:
row = ismember(D.chordID,untrained);
[~, day, MD, chord, SN] = get_sem(D.MT(row), D.sn(row), D.day(row), ones(sum(row),1));
lineplot(day,MD,'plotfcn','median','markersize',2,'markerfill',colors(2,:),'markercolor',colors(2,:),'linecolor',colors(2,:),'linewidth',2,'errorcolor',colors(2,:),'errorcap',0);
h = gca;
ylim([0 2800])
h.YTick = [0 1400 2800];
h.LineWidth = 1;
xlim([0.5 5.5])
xlabel('day')
ylabel('MT')
title('median MT')

% trained:
row = ismember(D.chordID,trained);
[~, day, MD, chord, SN] = get_sem(D.RT(row), D.sn(row), D.day(row), ones(sum(row),1));
figure('Units','centimeters', 'Position',[15 15 8 8]);
lineplot(day,MD,'plotfcn','mean','markersize',2,'markerfill',colors(1,:),'markercolor',colors(1,:),'linecolor',colors(1,:),'linewidth',2,'errorcolor',colors(1,:),'errorcap',0);
hold on;
% untrained:
row = ismember(D.chordID,untrained);
[~, day, MD, chord, SN] = get_sem(D.RT(row), D.sn(row), D.day(row), ones(sum(row),1));
lineplot(day,MD,'plotfcn','mean','markersize',2,'markerfill',colors(2,:),'markercolor',colors(2,:),'linecolor',colors(2,:),'linewidth',2,'errorcolor',colors(2,:),'errorcap',0);
h = gca;
ylim([250 650])
h.YTick = [250 450 650];
h.LineWidth = 1;
xlim([0.5 5.5])
xlabel('day')
ylabel('RT')
title('median RT')


