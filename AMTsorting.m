% LATIN SQUARE COUNTERBALANCING with 12 ROTATIONS

%ensure you're working in the trials directory to do this
%ensure matlab run as admin 


clc;
fclose('all');
clear all;
close all;
rng('shuffle')

subject = 12 ; %change for each subject
imagelabels = [ "Positive", "Negative", "Neutral"] ;
key = [1, 2, 3] ;
jittering = [4 6 8]; % three jitters types 
runs = 2; %number of runs

%stimuli files, you'll make these from a main mixed file 
d1 = fopen(['d1.txt']);
d2 = fopen(['d2.txt']);
d3 = fopen(['d3.txt']);

col_list = 1 ;
col_pic = 2;
col_label = 3;
col_descript = 4;
col_semantic = 5; 
col_val = 6;
col_aro = 7;
col_face = 8;
col_face_gender = 9;
col_face_age = 10;
col_face_ethnicity = 11 ;
col_face_attract = 12 ;


%Set up export paths here - nicer way of doing things. 

exp_name = 'Colouringfiles';
exp_path = ['C:\Users\p70069713\Documents\antonio-sorting\','\'] ; 
data_dir = [exp_path];
data_file = [data_dir,exp_name,'order',num2str(subject),'.mat'];

% Read existing result file and prevent overwriting files from a previous subject (except for subjects > 99)
if subject < 99 && fopen(data_file,'rt')~=-1
    fclose('all');
    error('Stimulus set already exists! Choose a different subject number.');
end

%%
% Condition possibilities
exp_conditions = [];
for iitem = 1:3
    exp_conditions = [exp_conditions; iitem];
end

% Counter balance possibilities
obj_assigner = [1:3];
for i = 2:3
    obj_assigner = [obj_assigner; obj_assigner(i-1,2:end), obj_assigner(i-1,1)];
end

% Assign counter balance order
for i = 1:3
    if ismember(subject,i:3:1000)
        obj_assignment = obj_assigner(i,:);
        
            if obj_assignment == [1,2,3]
                cond_order = {'Positive', 'Negative', 'Neutral'}
                
            elseif obj_assignment == [2,3,1]
                
                 cond_order = {'Negative', 'Positive', 'Neutral'}
                 
            elseif obj_assignment == [3,2,1]
                
                 cond_order = {'Neutral', 'Positive', 'Negative'} 
                    
            elseif obj_assignment == [3,1,2]
                 
                cond_order = {'Positive', 'Neutral', 'Negative'}
            
            elseif obj_assignment == [1,3,2]
    
                cond_order = {'Negative', 'Neutral', 'Positive'}
            
            elseif obj_assignment == [2,1,3]
                
                cond_order = {'Neutral', 'Negative', 'Positive'};
                
            end
    end
end



%sanity check for labels
labelassignment = num2cell([obj_assignment; key; imagelabels].') ;

%%

%import the optimal sequence file after making sure that its been cleaned (remove null events and timings)  and add labels to  order 
fid = fopen(['optseq.txt']);
optseq_conds1 = textscan(fid,'%d');
optseq_conds= cat(1,optseq_conds1{:});

cond_trials = {}

 for j = 1:3 ;
         if ismember(j,optseq_conds)
            cond_mask = ismember(optseq_conds,j); 
            cond_trials(cond_mask) = cond_order(j); 
            cond_trials = cond_trials.'
            
     end 
 end

final = horzcat( num2cell(optseq_conds),cond_trials);




%% extract and randomise stimulus lists, 
%when cleaning the stimuli list, make sure .extensions(.JPG) are added to the
%image files and that the spaces are removed or find alternative like '%s','delimiter','\n') ;


d1_text = textscan(d1,'%d %s %s %s %s %f %f %s %s %f %s %f %f');
day1stimuli = [num2cell(double(d1_text{1,col_list})) d1_text{1,col_pic} d1_text{1,col_label} d1_text{1,col_descript} d1_text{1,col_semantic} ...
    num2cell(double(d1_text{1,col_val})) num2cell(double(d1_text{1,col_aro})) d1_text{1,col_face} d1_text{1,col_face_gender} num2cell(double(d1_text{1,col_face_age}))...
     d1_text{1,col_face_ethnicity} num2cell(double(d1_text{1,col_face_attract}))];
day1stimuli = sortrows(day1stimuli,col_val);
day1stimuli = sortrows(day1stimuli,col_label);
day1stimuli = day1stimuli(randperm(length(day1stimuli)),:);

% replace underscores with spaces
for i = 1:length(day1stimuli) ;
    if ismember('?',day1stimuli{i,col_pic}) ;
        index = find(day1stimuli{i,col_pic} == '?');
        day1stimuli{i,col_pic}(index) = ' ';
    end
end

for i = 1:length(day1stimuli)    ;     
    if ismember('?',day1stimuli{i,col_descript}) ;
        index = find(day1stimuli{i,col_descript} == '?');
        day1stimuli{i,col_descript}(index) = ' ';
    end
end

%repeat this for the other days 

d2_text = textscan(d2,'%d %s %s %s %s %f %f %s %s %f %s %f %f');
day2stimuli = [num2cell(double(d2_text{1,col_list})) d2_text{1,col_pic} d2_text{1,col_label} d2_text{1,col_descript} d2_text{1,col_semantic} ...
    num2cell(double(d2_text{1,col_val})) num2cell(double(d2_text{1,col_aro})) d2_text{1,col_face} d2_text{1,col_face_gender} num2cell(double(d2_text{1,col_face_age}))...
     d2_text{1,col_face_ethnicity} num2cell(double(d2_text{1,col_face_attract}))];
day2stimuli = sortrows(day2stimuli,col_val);
day2stimuli = sortrows(day2stimuli,col_label);
day2stimuli = day2stimuli(randperm(length(day2stimuli)),:);

% replace underscores with spaces
for i = 1:length(day2stimuli) ; 
    if ismember('?',day2stimuli{i,col_pic}) ;
        index = find(day2stimuli{i,col_pic} == '?');
        day2stimuli{i,col_pic}(index) = ' ';
    end
end

for i = 1:length(day2stimuli) ;       
    if ismember('?',day2stimuli{i,col_descript}) ;
        index = find(day2stimuli{i,col_descript} == '?');
        day2stimuli{i,col_descript}(index) = ' ';
    end
end

d3_text = textscan(d3,'%d %s %s %s %s %f %f %s %s %f %s %f %f');
day3stimuli = [num2cell(double(d3_text{1,col_list})) d3_text{1,col_pic} d3_text{1,col_label} d3_text{1,col_descript} d3_text{1,col_semantic} ...
    num2cell(double(d3_text{1,col_val})) num2cell(double(d3_text{1,col_aro})) d3_text{1,col_face} d3_text{1,col_face_gender} num2cell(double(d3_text{1,col_face_age}))...
     d3_text{1,col_face_ethnicity} num2cell(double(d3_text{1,col_face_attract}))];
day3stimuli = sortrows(day3stimuli,col_val);
day3stimuli = sortrows(day3stimuli,col_label);
day3stimuli = day3stimuli(randperm(length(day3stimuli)),:);

% replace underscores with spaces
for i = 1:length(day3stimuli);
    if ismember('?',day3stimuli{i,col_pic}) ;
        index = find(day3stimuli{i,col_pic} == '?');
        day3stimuli{i,col_pic}(index) = ' ';
    end ;
end ;

for i = 1:length(day3stimuli)        
    if ismember('?',day3stimuli{i,col_descript}) ;
        index = find(day3stimuli{i,col_descript} == '?');
        day3stimuli{i,col_descript}(index) = ' ';
    end
end


%% Prepare condition files  for each day and followup

Nelem = (size(cond_trials,1) / 3 / 6 )*runs; % tot N of elements, divided by 3 conditions and 6 orders * runs
jittering = repelem(jittering, Nelem); % repeat so to cover all conds

% First jittering
PreJitt{1} = Shuffle(jittering); % the first condition
PreJitt{2} = Shuffle(jittering); % the second condition
PreJitt{3} = Shuffle(jittering); % the third condition

% Second jittering
PostJitt{1} = Shuffle(jittering); % the first condition
PostJitt{2} = Shuffle(jittering); % the second condition
PostJitt{3} = Shuffle(jittering); % the third condition

colouringlist= cell(size(day1stimuli));
PreJittCol = size(colouringlist,2)+1;
PostJittCol = PreJittCol +1;

N{1} = 0; % count number of elements for jitter vector 1
N{2} = 0; % count number of elements for jitter vector 2
N{3} = 0; % count number of elements for jitter vector 3

% These Ns will increas e over the loop

day1colouringlist = cell([size(cond_trials,1), 14]); % pre-allocate

for i = 1:size(cond_trials,1)
    
    index =  find(strcmp(cellstr(day1stimuli{i,col_label}), cond_trials));
    [ind2, ind3]= find(strcmp(cellstr(day1stimuli{i,col_label}), day1stimuli));
    day1colouringlist(index,1:12) =  day1stimuli(ind2,:);
    
    % What is missing:
    % 1. identify what "i" corresponds to -> which condition
    % 2. get an index -> 1,2,3 (name it new cond or whatever)
    % 3. count elements within your jitt cell (1:15) -> N
    % 4. There are three N (1,2,3) -> use the one corresponding to your
    % condition
    
    % make sure you count the elements within each jitt vector
    
    if strcmp(day1colouringlist(i,3), 'Negative')
        N{1} = N{1}+1;
        n = N{1};
        indi = 1;
        
    elseif strcmp(day1colouringlist(i,3), 'Positive')
        
        N{2} = N{2}+1;
        n = N{2};
        indi = 2;
        
    else
        
        N{3} = N{3}+1;
        n = N{3};
        indi = 3;
        
    end
        
    day1colouringlist{i,PreJittCol} = PreJitt{indi}(n); % NB: you have N1,N2,N3
    day1colouringlist{i,PostJittCol} = PostJitt{indi}(n);
    
end

d1filename = [exp_name,'_order1_', 'Participant_', num2str(subject), '.csv'];
day1colouringlist = cell2table(day1colouringlist);
day1colouringlist.Properties.VariableNames = {'List','Image','Label','Description','Semantic','Valence','Arousal','Face','Gender','Age','Ethnicity','Attractiveness', 'PrimeJit', 'Facejit'}

%%

% First jittering
PreJitt{1} = Shuffle(jittering); % the first condition
PreJitt{2} = Shuffle(jittering); % the second condition
PreJitt{3} = Shuffle(jittering); % the third condition

% Second jittering
PostJitt{1} = Shuffle(jittering); % the first condition
PostJitt{2} = Shuffle(jittering); % the second condition
PostJitt{3} = Shuffle(jittering); % the third condition

colouringlist2= cell(size(day2stimuli));
PreJittCol = size(colouringlist2,2)+1;
PostJittCol = PreJittCol +1;

N{1} = 0; % count number of elements for jitter vector 1
N{2} = 0; % count number of elements for jitter vector 2
N{3} = 0; % count number of elements for jitter vector 3


day2colouringlist = cell([size(cond_trials,1), 14]); % pre-allocate
day2colouringlist= cell(size(day2stimuli));
for i = 1:size(cond_trials,1)
    index =  find(strcmp(cellstr(day2stimuli{i,col_label}), cond_trials));
    [ind2, ind3]= find(strcmp(cellstr(day2stimuli{i,col_label}), day2stimuli));
    day2colouringlist(index,1:12) =  day2stimuli(ind2,:);

     if strcmp(day2colouringlist(i,3), 'Negative')
        N{1} = N{1}+1;
        n = N{1};
        indi = 1;
        
    elseif strcmp(day2colouringlist(i,3), 'Positive')
        
        N{2} = N{2}+1;
        n = N{2};
        indi = 2;
        
    else
        
        N{3} = N{3}+1;
        n = N{3};
        indi = 3;
        
    end
        
    day2colouringlist{i,PreJittCol} = PreJitt{indi}(n); % NB: you have N1,N2,N3
    day2colouringlist{i,PostJittCol} = PostJitt{indi}(n);
    
end

d2filename = [exp_name,'_order2_', 'Participant_', num2str(subject), '.csv'];    
day2colouringlist = cell2table(day2colouringlist);
day2colouringlist.Properties.VariableNames = {'List','Image','Label','Description','Semantic','Valence','Arousal','Face','Gender','Age','Ethnicity','Attractiveness', 'PrimeJit', 'Facejit'}

%%

% First jittering
PreJitt{1} = Shuffle(jittering); % the first condition
PreJitt{2} = Shuffle(jittering); % the second condition
PreJitt{3} = Shuffle(jittering); % the third condition

% Second jittering
PostJitt{1} = Shuffle(jittering); % the first condition
PostJitt{2} = Shuffle(jittering); % the second condition
PostJitt{3} = Shuffle(jittering); % the third condition

colouringlist3= cell(size(day3stimuli));
PreJittCol = size(colouringlist3,2)+1;
PostJittCol = PreJittCol +1;

N{1} = 0; % count number of elements for jitter vector 1
N{2} = 0; % count number of elements for jitter vector 2
N{3} = 0; % count number of elements for jitter vector 3


day3colouringlist = cell([size(cond_trials,1), 14]); % pre-allocate
day3colouringlist= cell(size(day3stimuli));
for i = 1:size(cond_trials,1)
    index =  find(strcmp(cellstr(day3stimuli{i,col_label}), cond_trials));
    [ind2, ind3]= find(strcmp(cellstr(day3stimuli{i,col_label}), day3stimuli));
    day3colouringlist(index,1:12)  =  day3stimuli(ind2,:);
    if strcmp(day3colouringlist(i,3), 'Negative')
        N{1} = N{1}+1;
        n = N{1};
        indi = 1;
        
    elseif strcmp(day3colouringlist(i,3), 'Positive')
        
        N{2} = N{2}+1;
        n = N{2};
        indi = 2;
        
    else
        
        N{3} = N{3}+1;
        n = N{3};
        indi = 3;
        
    end
        
    day3colouringlist{i,PreJittCol} = PreJitt{indi}(n); % NB: you have N1,N2,N3
    day3colouringlist{i,PostJittCol} = PostJitt{indi}(n);
    
    
    
end

d3filename = [exp_name,'_order3_', 'Participant_', num2str(subject), '.csv'];
day3colouringlist = cell2table(day3colouringlist);
day3colouringlist.Properties.VariableNames = {'List','Image','Label','Description','Semantic','Valence','Arousal','Face','Gender','Age','Ethnicity','Attractiveness', 'PrimeJit', 'Facejit'}


writetable(day1colouringlist,d1filename)
writetable(day2colouringlist,d2filename)
writetable(day3colouringlist,d3filename)

save(data_file,'final', 'day1colouringlist', 'day2colouringlist', 'day3colouringlist');
