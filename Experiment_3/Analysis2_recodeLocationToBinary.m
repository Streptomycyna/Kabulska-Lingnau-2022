function Analysis2_recodeLocationToBinary(resDir)
%% Changing Location from continuous to binary
% I'm taking data from Analysis1_infoAboutActions
% just for the part 2
% The reason is to decode 'Location' from 1-3 answers to 'Indoor','Outdoor' features 
load(fullfile(resDir,'resultList_part2.mat'));

LL = resultList(4,:);
load(fullfile(resDir,'ratingsPerAction_part2'));
numOfCorr = ratingsPerAction;
nActions=100;
c=1;
new_LL=[];
full_list=[];
for i = 1:nActions
    d = c+(numOfCorr(i)-1);
    current_list = LL(1,c:d);
    temp1 = double(current_list==1); 
    temp1=temp1+double(current_list==3);
    temp2 = double(current_list==2); 
    temp2=temp2+double(current_list==3);
    full_list(:,(c:d))=[temp1;temp2];
    c=d+1;
end

full_list = full_list+1;  % I'm doing it because the data were not normalized yet

newList([1:3],:) = resultList(1:3,:); %Harm, Water, Season-dep. 
newList([4:5],:) = full_list; % Indoor, Outdoor
newList([6:8],:) = resultList([5:7],:); %Concentration, Noise, Emotions

save(fullfile(resDir,'resultList_part2_afterRecodedLoc'), 'newList');

end
