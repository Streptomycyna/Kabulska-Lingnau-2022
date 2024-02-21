function Analysis2_featureRedundancyRemoval(resDir)
% I'm recalculating the binary features that could be reflected on a
% scale (Section S.2.2.2)

load(fullfile(resDir,'resultList_part1'));
T = resultList;

% Change of location
CC = T(30:32,:);
newCC=[CC(3,:);CC(2,:);CC(1,:)]; % new order: (1)no change, (2)in proximity, (3)far away
CC=newCC;
my_CC=[];
for i = 1:length(T)
    thisLoc = find(CC(:,i)==2); % '2' means 'Yes' (that's how the raw data was coded)
    thisLoc_temp = sum(thisLoc)/length(thisLoc);
    my_CC(i) = thisLoc_temp;
end

% Duration
DD = T(35:40,:);
my_DD=[];
for i = 1:length(T)
    thisLoc = find(DD(:,i)==2);
    thisLoc_temp = sum(thisLoc)/length(thisLoc);
    my_DD(i) = thisLoc_temp;
end

%Contact with others
TT = T(41:44,:); 
newTT=[TT(4,:);TT(3,:);TT(1,:);TT(2,:)];
TT=newTT;
for i = 1:length(T)
    thisLoc = find(TT(:,i)==2);
    if isempty(thisLoc)
        thisLoc_temp = 2.5; % take the average
    else
        thisLoc_temp = sum(thisLoc)/length(thisLoc);
    end
    my_TT(i) = thisLoc_temp;
end

%% Build the new list
% Be aware, here I'm already changing the order!!
newList = [];
newList(1:29,:) = resultList([1:29],:);  % Themes: Body parts, Object, Trajectory, Limb type
newList(30:34,:) = resultList([46:50],:); % Theme: Posture
newList(35,:) = resultList(45,:); % Keeping balance
newList(36,:) = my_CC; % Change of location
newList(37,:) = my_DD;  % Duration
newList(38,:) = my_TT; % Contact with others
newList([39:40],:) = resultList([33:34],:);
newList(41,:) = resultList(51,:);

save(fullfile(resDir,'resultList_part1_afterReduction'), 'newList');

end
