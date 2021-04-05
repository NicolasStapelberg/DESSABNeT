
%% DESSABNeT Population Setup. Copyright (C) Nicolas J. C. Stapelberg 2020, 2021, All Rights Reserved 

        % A Discrete-Event, Simulated Social Agent-Based Network Transmission (DESSABNeT) Model for Communicable Diseases
        % Programmed by Nicolas J. C. Stapelberg, commenced 2 April 2020
        % Modular Version completed 20 August 2020
        
       
    % This program is free software: you can redistribute it and/or modify
    % it under the terms of the GNU General Public License as published by
    % the Free Software Foundation, either version 3 of the License, or
    % (at your option) any later version.

    % This program is distributed in the hope that it will be useful,
    % but WITHOUT ANY WARRANTY; without even the implied warranty of
    % MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    % GNU General Public License for more details: Please access <https://www.gnu.org/licenses/>.
    
    % If you use this software, please cite the following peer-reviewed paper: 
    
    % N.J.C. Stapelberg, N.R. Smoll, M. Randall, D. Palipana, B. Bui, K. Macartney, G. Khandaker, A. Wattiaux (In Review). 
    % A Discrete-Event, Simulated Social Agent-Based Network Transmission (DESSABNeT) Model for Communicable Diseases: 
    % Method and Validation Using SARS-CoV-2 Data in Three Large Australian Cities. PlosOne  
        
     %% Build Weekly Timetable for the Simulated Population: Population Movement Per Day        

                fprintf('%s\t','3) Calculating Weekly Schedules of Population Movement Per Day for this Context');
                fprintf('\n');
                
                % Activities will be setup for Weekdays:
                    % Each waking day is divided into 3 timeperiods.
                    
                    % The timeperiods approximately correspond to morning (work time) afternoon (discretionary time), and evening (social time)
                    % Work, school, essential activities (shopping etc) are spread across morning and afternoon, social and
                    % family activity occur in the evening (social time).

                    % Workday: People having contact with workgroups (full-time workers) (one timeslot either morning or afternoon to simulate shift work, equally distributed)
                    % Commuting for those using public transport (one timeslot either morning or afternoon, equally distributed)
                    % Parttime workers, will work some days per week (one timeslot either morning or afternoon, equally distributed)
                    % Pensioners and unemployed also modelled 
                    % All people attend medium and large group leisure
                    % activities, more often during the weekends if they work or go to school during the week. Thus random contacts in public spaces are also modelled.
                    % Evening: Contact with family and contact with friends & kin



                %% Weekly Scheduling

                % This will set up a simple timetable for all people. 
                % Full time workers will go to work, children will go to school
                % Part time workers will work some days but will engage in other activities also
                % All people will visit shops and services
                % Vists with friends will be scheduled in a semi-structured way
                % Family units will be in contact every evening

                % 0 = Null
                % 1 = Work or School
                % 2 = Essential Activity (Food shopping, pharmacy, doctor, etc) 5 per week, small or medium group exposure
                % 3 = Leisure Activity (Gym, cafe, eating out, shopping) small, medium, or large group exposure
                % 4 = Public transport (small group exposure)
                % 5 = Social activity (friends, dinners, BBQ) small group exposure
                % 6 = No Activity (Staying Home)

                Person_Profile = Person_Profile(1:Population,:); % Truncate Person_Profile to correct number of rows
                
                %% Index work from home group

                Work_From_Home_Group = sort(randperm(Adult_Group_Rows,round(Adult_Group_Rows*Work_From_Home/100,0)));

                %% Fill in working week either Mo-Fri or Wed-Sun
                
                for CounterY = 1:Full_Time_Group_Rows 
                    Addon1 = 0;
                    Addon2 = 0;
                        if any(First_Half_FT(:) == Full_Time_Group(CounterY,1))    
                            Addon1 = 2;
                        end
                        if any(First_Half_Adult(:) == Full_Time_Group(CounterY,1))
                            Addon2 = 7;
                        end
                        if Full_Time_Group(CounterY,7) == 6, Addon1 = 0; Addon2 = 7; end % Make sure teachers share timeslot with pupils
                        for CounterZ1 = (11+Addon1+Addon2):(15+Addon1+Addon2)
                            if Person_Profile(Full_Time_Group(CounterY,1),CounterZ1)==0

                                    Person_Profile(Full_Time_Group(CounterY,1),CounterZ1)=1; % Fill in Timetable slots
                                    if any(Work_From_Home_Group(:) == Full_Time_Group(CounterY,1)), Person_Profile(Full_Time_Group(CounterY,1),CounterZ1)=6; end %If person working from home, change their status to being at home 
                                    if Person_Profile(Full_Time_Group(CounterY,1),8)==2
                                   
                                        if Addon2 == 7
                                            Person_Profile(Full_Time_Group(CounterY,1),CounterZ1-7)=4; % Fill in public transport slots
                                        else
                                            Person_Profile(Full_Time_Group(CounterY,1),CounterZ1+7)=4; % Fill in public transport slots
                                        end    
                                    end

                            end
                        end
                end


                %% Part Time Activities: What days do these people work?

                SwitchX = 0;
                SwitchY = 0;
                for CounterY = 1:Part_Time_Group_Rows 
                    Addon2 = 0;
                    if any(First_Half_Adult(:) == Part_Time_Group(CounterY,1))
                            Addon2 = 7;
                    end
                    if Part_Time_Group(CounterY,7) == 6, Addon1 = 0; Addon2 = 7; end % Make sure teachers share timeslot with pupils
                    ActiveDays = sort(randperm(7,randi(4))); % May do 1, 2 up to 4 workdays
                    for CounterZ1 = (11+Addon2):(15+Addon2) % Part time work over 7 days a week
                        SwitchX = 0;    
                        for CounterAA = 1:length(ActiveDays)
                            if CounterZ1==ActiveDays(CounterAA)+10+Addon2 % if day of week matches randomly chosen day 
                                if Person_Profile(Part_Time_Group(CounterY,1),CounterZ1)==0
                                    Person_Profile(Part_Time_Group(CounterY,1),CounterZ1)=1;
                                    SwitchX = 1;
                                    if Person_Profile(Part_Time_Group(CounterY,1),8)==2
                                    
                                        if CounterZ1 > 17
                                            Person_Profile(Part_Time_Group(CounterY,1),CounterZ1-7)=4; % Fill in public transport slots
                                        end
                                        if CounterZ1 < 18
                                            Person_Profile(Part_Time_Group(CounterY,1),CounterZ1+7)=4; % Fill in public transport slots
                                        end
                                    end
                                end
                            end
                        end
                    end
                end   


                %% Fill in T1 and T2 with essential activities for all adults
                
                LSH_Counter = 0;
                for CounterY = 1:Adult_Group_Rows  
                    Addon1 = 0;
                    Addon2 = 0;
                    
                        ActiveDays = sort(randperm(14,Essential_Visits_per_Week)); % Essential activities T1 or T2 up to 7 days a week
                        for CounterZ1 = 11:24 
                            SwitchX = 0;
                            for CounterAA = 1:length(ActiveDays)
                                if CounterZ1==ActiveDays(CounterAA)+10 % if day of week matches randomly chosen day     
                                    if Person_Profile(Adult_Group(CounterY,1),CounterZ1)==0
                                            Person_Profile(Adult_Group(CounterY,1),CounterZ1)=2; % Fill in Timetable slots
                                            SwitchX = 1;
                                    end
                                end
                            end
                            if SwitchX == 0
                                if Person_Profile(Adult_Group(CounterY,1),CounterZ1)==0
                                    LSH_Activity = sum(rand >= cumsum([0,Perc_Leisure_Activity/100, Perc_Social_Activity/100, Perc_Home_Activity/100 ])); 
                                    if LSH_Activity == 1, Person_Profile(Adult_Group(CounterY,1),CounterZ1)=3; end
                                    if LSH_Activity == 2, Person_Profile(Adult_Group(CounterY,1),CounterZ1)=5; end
                                    if LSH_Activity == 3, Person_Profile(Adult_Group(CounterY,1),CounterZ1)=6; end
                                    LSH_Counter = LSH_Counter + 1;
                                end
                            end
                        end
                end

                %% Fill in evening activities for all adults
               
                
                for CounterY = 1:Adult_Group_Rows 
                    if Friend_Contacts_per_Week ~= 0
                        ActiveDays = sort(randperm(7,Friend_Contacts_per_Week)); % Friend or social contacts X times a week
                    end
                    for CounterZ1 = 25:31 % Evening activity up to 7 days a week
                        SwitchX = 0;
                        if Friend_Contacts_per_Week ~= 0
                            for CounterAA = 1:length(ActiveDays)

                                if CounterZ1==ActiveDays(CounterAA)+24 % if day of week matches randomly chosen day     
                                    Person_Profile(Adult_Group(CounterY,1),CounterZ1)=5; % Fill in Timetable slots
                                    SwitchX = 1;
                                end
                            end
                        end
                        if SwitchX == 0
                                % Do nothing here
                        end
                    end
                end   


                %% School working week Mo-Fri
                
                for CounterY = 1:School_Group_Rows 
                    for CounterZ1 = 11:17
                        Person_Profile(School_Group(CounterY,1),CounterZ1)=6; % Fill in Timetable slots
                    end

                    Fam_Group = Person_Profile(Person_Profile(:,4)==School_Group(CounterY,4),:); %Who is in the family group?
                    [Fam_Group_Rows,Fam_Group_Cols] = size(Fam_Group); %How many rows and columns?
                    for CounterZ1 = 16:31
                        Person_Profile(School_Group(CounterY,1),CounterZ1)=Fam_Group(end,CounterZ1); % Children do what one of their parents does on weekends and evenings
                    end

                    for CounterZ1 = 18:22
                        Person_Profile(School_Group(CounterY,1),CounterZ1)=1; %Default schools open: 1 = Schools are Open, 6 = Schools are shut.
                    end    
                    
                end
                
                %% Check all spaces filled, if not, fill with 6 (home activity)
                Placeholder = Person_Profile(:,11:24);
                Placeholder(Placeholder==0) = 6;
                Person_Profile(:,11:24) = Placeholder;
                
        %% Set up All Group and Subgroup Indexing Here, as This is Processor-Intensive: 
        fprintf('%s\t','4) Indexing all Subgroups in the Social Network');
        fprintf('\n');
        fprintf('%s\t','4A) Indexing Work Subgroups...');
        fprintf('\n');

        % Work Groups 
                No_Subgroups_Work = zeros(14,1);    
                Subgroup_N_Work_Rows= zeros(100,14); 
                Subgroup_N_Work = zeros(100,max(Person_Profile(:,5)),14); %The 100: Biggest group is schhol groups, so 100 is a safe number.

                for Weekday_Maker = 1:7        
                    for Morning_Afternoon = 1:2 % Look at both morning and day Time periods (T1 and T2)
                        if Morning_Afternoon == 2, Gear = Weekday_Maker + 7; else, Gear = Weekday_Maker; end
                        Group_X_Work = Person_Profile(Person_Profile(:,10+Gear)==1,:); %Who is working today?

                        No_Subgroups_Work(Gear) = max(Person_Profile(:,5)); %Change No_Subgroups_Work in Dynamic software. 5 = Workgroup ID
                        for CounterNN = 1:No_Subgroups_Work(Gear)
                            
                            Workgroup_Day = Group_X_Work(Group_X_Work(:,5)==CounterNN,1); % Here get only ID column
                            [Subgroup_N_Work_Rows(CounterNN,Gear),~] = size(Workgroup_Day); %How many rows and columns?  
                            for CounterMM = 1:Subgroup_N_Work_Rows(CounterNN,Gear)
                                Subgroup_N_Work(CounterMM,CounterNN,Gear)=Workgroup_Day(CounterMM);
                                
                            end 

                        end
                    end
                end

             
                    
                    
           fprintf('%s\t','4B) Indexing Leisure Gatherings, Medium Groups...');
           fprintf('\n');
           
           % Social Groups 
                No_Subgroups_Social = zeros(14,1);    
                Subgroup_N_Social_Rows= zeros(Medium_Group_Exposure,14);  
                Subgroup_N_Social = zeros(Medium_Group_Exposure,max(Person_Profile(:,34)),14); %The 100: Biggest group is 100 people, so 100 is a safe number.

                for Weekday_Maker = 1:7        
                    for Morning_Afternoon = 1:2 % Look at both morning and day Time periods (T1 and T2)
                        if Morning_Afternoon == 2, Gear = Weekday_Maker + 7; else, Gear = Weekday_Maker; end
                        Group_X_Social = Person_Profile(Person_Profile(:,10+Gear)==5,:); %Who is doing a medium group leisure activity today?

                        No_Subgroups_Social(Gear) = max(Person_Profile(:,34)); %34 = Medium_group ID
                        for CounterNN = 1:No_Subgroups_Social(Gear)
                           
                            Socialgroup_Day = Group_X_Social(Group_X_Social(:,34)==CounterNN,1); % Here get only ID column
                            [Subgroup_N_Social_Rows(CounterNN,Gear),~] = size(Socialgroup_Day); %How many rows and columns?  
                            for CounterMM = 1:Subgroup_N_Social_Rows(CounterNN,Gear)
                                Subgroup_N_Social(CounterMM,CounterNN,Gear)=Socialgroup_Day(CounterMM);
                                
                            end 

                        end
                    end
                end


                fprintf('%s\t','4C) Indexing Public Transport Subgroups...');
                fprintf('\n');
                
                % PublicT Groups 
                No_Subgroups_PublicT = zeros(14,1);    
                Subgroup_N_PublicT_Rows= zeros(Small_Group_Exposure,14);  
                Subgroup_N_PublicT = zeros(Small_Group_Exposure,max(Person_Profile(:,33)),14); %The 100: Biggest group is schhol groups, so 100 is a safe number.

                for Weekday_Maker = 1:7        
                    for Morning_Afternoon = 1:2 % Look at both morning and day Time periods (T1 and T2)
                        if Morning_Afternoon == 2, Gear = Weekday_Maker + 7; else, Gear = Weekday_Maker; end
                        Group_X_PublicT = Person_Profile(Person_Profile(:,10+Gear)==4,:); %Who is taking public transport today?

                        No_Subgroups_PublicT(Gear) = max(Person_Profile(:,33)); %Change No_Subgroups_PublicT in Dynamic software
                        for CounterNN = 1:No_Subgroups_PublicT(Gear)
                           
                            PublicTgroup_Day = Group_X_PublicT(Group_X_PublicT(:,33)==CounterNN,1); % Here get only ID column
                            [Subgroup_N_PublicT_Rows(CounterNN,Gear),~] = size(PublicTgroup_Day); %How many rows and columns?  
                            for CounterMM = 1:Subgroup_N_PublicT_Rows(CounterNN,Gear)
                                Subgroup_N_PublicT(CounterMM,CounterNN,Gear)=PublicTgroup_Day(CounterMM); 
                                
                            end 

                        end
                    end
                end


                fprintf('%s\t','4D) Indexing Essential Services Subgroups...');
                fprintf('\n');
                
                % Essential Groups 
                No_Subgroups_Essential = zeros(14,1);    
                Subgroup_N_Essential_Rows= zeros(Medium_Group_Exposure,14);  
                Subgroup_N_Essential = zeros(Medium_Group_Exposure,max(Person_Profile(:,34)),14); %The 100: Biggest group is schhol groups, so 100 is a safe number.

                for Weekday_Maker = 1:7        
                    for Morning_Afternoon = 1:2 % Look at both morning and day Time periods (T1 and T2)
                        if Morning_Afternoon == 2, Gear = Weekday_Maker + 7; else, Gear = Weekday_Maker; end
                        Group_X_Essential = Person_Profile(Person_Profile(:,10+Gear)==2,:); %Who is doing an essential activity today?

                        No_Subgroups_Essential(Gear) = max(Person_Profile(:,34)); %Change No_Subgroups_Essential in Dynamic software
                        for CounterNN = 1:No_Subgroups_Essential(Gear)
                            
                            Essentialgroup_Day = Group_X_Essential(Group_X_Essential(:,34)==CounterNN,1); % Here get only ID column
                            [Subgroup_N_Essential_Rows(CounterNN,Gear),~] = size(Essentialgroup_Day); %How many rows and columns?  
                            for CounterMM = 1:Subgroup_N_Essential_Rows(CounterNN,Gear)
                                Subgroup_N_Essential(CounterMM,CounterNN,Gear)=Essentialgroup_Day(CounterMM);
                               
                            end 

                        end
                    end
                end

                fprintf('%s\t','4E) Indexing Leisure Activity Subgroups...');
                fprintf('\n');
                
                % Leisure Groups 
                No_Subgroups_Leisure = zeros(14,1);    
                Subgroup_N_Leisure_Rows= zeros(Large_Group_Exposure,14); 
                Subgroup_N_Leisure = zeros(Large_Group_Exposure,max(Person_Profile(:,35)),14); %Large Group Exposure = 500

                for Weekday_Maker = 1:7        
                    for Morning_Afternoon = 1:2 % Look at both morning and day Time periods (T1 and T2)
                        if Morning_Afternoon == 2, Gear = Weekday_Maker + 7; else, Gear = Weekday_Maker; end
                        Group_X_Leisure = Person_Profile(Person_Profile(:,10+Gear)==3,:); %Who is doing a large group activity today?

                        No_Subgroups_Leisure(Gear) = max(Person_Profile(:,35)); %Change No_Subgroups_Leisure in Dynamic software
                        for CounterNN = 1:No_Subgroups_Leisure(Gear)
                            
                            Leisuregroup_Day = Group_X_Leisure(Group_X_Leisure(:,35)==CounterNN,1); % Here get only ID column
                            [Subgroup_N_Leisure_Rows(CounterNN,Gear),~] = size(Leisuregroup_Day); %How many rows and columns?  
                            for CounterMM = 1:Subgroup_N_Leisure_Rows(CounterNN,Gear)
                                Subgroup_N_Leisure(CounterMM,CounterNN,Gear)=Leisuregroup_Day(CounterMM);
                                
                            end 

                        end
                    end
                end

                fprintf('%s\t','4F) Indexing Friend Subgroups...');
                fprintf('\n');
                
                % Friends Groups 
                No_Subgroups_Friends = zeros(7,1);    
                Subgroup_N_Friends_Rows= zeros(100,7); 
                Subgroup_N_Friends = zeros(100,max(Person_Profile(:,6)),7); %The 100: Biggest group is social groups, so 100 is a safe number.
                  
                    for Weekday_Maker = 1:7        
                        Gear = Weekday_Maker;
                        Group_X_Friends = Person_Profile(Person_Profile(:,24+Gear)==5,:);
                        
                            No_Subgroups_Friends(Gear) = max(Person_Profile(:,6)); %Change No_Subgroups_Friends in Dynamic software
                            for CounterNN = 1:No_Subgroups_Friends(Gear)
                                
                                Friendsgroup_Day = Group_X_Friends(Group_X_Friends(:,6)==CounterNN,1); % Here get only ID column
                                [Subgroup_N_Friends_Rows(CounterNN,Gear),~] = size(Friendsgroup_Day); %How many rows and columns?  
                                for CounterMM = 1:Subgroup_N_Friends_Rows(CounterNN,Gear)
                                    Subgroup_N_Friends(CounterMM,CounterNN,Gear)=Friendsgroup_Day(CounterMM);
                                   
                                end 

                            end
                    end

                    fprintf('%s\t','4G) Indexing Family Subgroups...');
                    fprintf('\n');
                    fprintf('\n');
                    
           
                    % Family Groups      
                    Subgroup_N_Family_Rows=zeros(10,1);  %zeros(4,1); %This should be the size of No_Subgroups_Family
                    No_Subgroups_Family = max(Person_Profile(:,4)); % How many Subgroups are there?
                    Subgroup_N_Family = zeros(10,No_Subgroups_Family);

                    for CounterNN = 1:No_Subgroups_Family
                        Who_in_my_Familygroup = Person_Profile(Person_Profile(:,4)==CounterNN,1);
                                
                                [Subgroup_N_Family_Rows(CounterNN),~] = size(Who_in_my_Familygroup); %How many rows and columns?  
                                for CounterMM = 1:Subgroup_N_Family_Rows(CounterNN)
                                    Subgroup_N_Family(CounterMM,CounterNN)=Who_in_my_Familygroup(CounterMM);
                                   
                                end 
                    end
 
     
     