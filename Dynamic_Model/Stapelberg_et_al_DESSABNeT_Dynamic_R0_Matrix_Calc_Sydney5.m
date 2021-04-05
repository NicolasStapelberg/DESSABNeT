%% DESSABNeT Dynamic Model. Copyright (C) Nicolas J. C. Stapelberg 2020, 2021, All Rights Reserved 

        % A Discrete-Event, Simulated Social Agent-Based Network Transmission (DESSABNeT) Model for Communicable Diseases
        % Programmed by Nicolas J. C. Stapelberg. 
        
        
       
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
    
    
%% This is a Stand-Alone Module to Determine the WAIFU Matrix and R0 for Each Phase of the Simulation
% Commenced January 2021.
    
% This program does utilise:
% Stapelberg_et_al_DESSABNeT_Dynamic_Disease_Dynamic_Vars,
% Stapelberg_et_al_DESSABNeT_Dynamic_Module_Beta2021 and
% Stapelberg_et_al_DESSABNeT_Dynamic_Restr_Code_R0_Sydney modules

% A matrix is established which describes the contact of members of each
% age group with each other, for each day where there is a unique schedule or agents (1 week), for each container
% Each container will thus have a R0_Matrix array with values generated in this module

% This module is only run for the first week, and only on the first run, to save on computing resources


    clearvars
         
         fprintf('%s\t','Loading Simulated Population...');
         fprintf('\n');
         
         
         %% Load Global Variables and Context Data
         

         % Use this code to load the smaller test population:
         load('2021_DESSABNeT_Population_Setup_Global_10000_v7_3.mat') 
         Index_Variables_A = load('2021_DESSABNeT_Population_Indexed_Variables_Phase1_10000_v7_3.mat');
         Index_Variables_B = load('2021_DESSABNeT_Population_Indexed_Variables_Phase3_10000_v7_3.mat');
         Index_Variables_C = load('2021_DESSABNeT_Population_Indexed_Variables_Phase4_10000_v7_3.mat');
         
         %{
         % Use this code to load the full Sydney population:
         load('2021_DESSABNeT_Population_Setup_Global_5312000_v7_3.mat') %5312000
         Index_Variables_A = load('2021_DESSABNeT_Population_Indexed_Variables_Phase1_5312000_v7_3.mat');
         Index_Variables_B = load('2021_DESSABNeT_Population_Indexed_Variables_Phase3_5312000_v7_3.mat');
         Index_Variables_C = load('2021_DESSABNeT_Population_Indexed_Variables_Phase4_5312000_v7_3.mat');
        %}  
         
         
           Mask_Scaling_Factor = 1;
           School_Open = 1; %Schools Open
           Stapelberg_et_al_DESSABNeT_Dynamic_Disease_Dynamic_Vars
           Stapelberg_et_al_DESSABNeT_Dynamic_Module_Beta2021
           


        % Set up Person_Matrix to capture contacts for each agent:
        Person_Profile = Person_Profile(1:Population,:);
        Person_Matrix(:,1:8)= Person_Profile(:,1:8);

        People_Age_No(1) = sum(Person_Profile(:,2)==1);
        People_Age_No(2) = sum(Person_Profile(:,2)==2);
        People_Age_No(3) = sum(Person_Profile(:,2)==3);
        People_Age_No(4) = sum(Person_Profile(:,2)==4);
        People_Mean1 = People_Age_No(1)/mean(nonzeros(Social_Network_Matrix(1:People_Age_No(1),2))); %Divide all preschoolers by average preschool class size                                         
        People_Mean2 = People_Age_No(2)/mean(nonzeros(Social_Network_Matrix(People_Age_No(1)+1:People_Age_No(1)+People_Age_No(2),2))); %Divide all school attendees by average school class size
        People_Mean3 = (People_Age_No(3)+People_Age_No(4))/mean(nonzeros(Social_Network_Matrix(People_Age_No(1)+People_Age_No(2)+1:Population,2))); %Divide all adults by average workplace size
                                      
        %Calculate Total contacts in each age group:
         
        Pop_Range_0_4_Start = 1;
        Pop_Range_0_4_End = People_Age_No(1);
        Pop_Range_5_19_Start = People_Age_No(1)+1;
        Pop_Range_5_19_End = People_Age_No(1)+People_Age_No(2);
        Pop_Range_20_64_Start = People_Age_No(1)+People_Age_No(2)+1;
        Pop_Range_20_64_End = People_Age_No(1)+People_Age_No(2)+People_Age_No(3);
        Pop_Range_65_Over_Start = People_Age_No(1)+People_Age_No(2)+People_Age_No(3)+1;
        Pop_Range_65_Over_End = People_Age_No(1)+People_Age_No(2)+People_Age_No(3)+People_Age_No(4);

        %
        for aa = 1:Population
            if Person_Profile(aa,2)==0,Person_Profile(aa,2)=4; end
            if Person_Profile(aa,2)>4,Person_Profile(aa,2)=4; end
        end
        %
        

 
    
 for Phase_Count = 1:3
        
        Stapelberg_et_al_DESSABNeT_Dynamic_Restr_Code_R0_Sydney
        %Reset Arrays:
        Person_Matrix(:,9:36)=0;
        Total_Contacts(:)=0;
        
    for Day_Count = 1:7
        Weekday = Day_Count;
        
        
        
                % 1 = Transmission via workplace and school classroom groups (Workplace container)
                % What Group is being indexed/extracted?: All people working today, in daycare or schools
                for Morning_Afternoon = 1:2 % Look at both morning and day Time periods (T1 and T2)
                    
                    if Morning_Afternoon == 2, Gear = Weekday + 7; else, Gear = Weekday; end
                    for CounterA = 1:No_Subgroups_Work(Gear)
                        for CounterB = 1:Subgroup_N_Work_Rows(CounterA,Gear)
                              %  Additively calculate contacts for R0 for the Social Container and place them in the R0_Matrix_Social array
                                for CounterXX = 1:Subgroup_N_Work_Rows(CounterA,Gear) %Go through the whole group and determine contacts
                                    if CounterB ~= CounterXX %Dont count people contacting themselves...
                                    % Calculate the transmission probability for this handshake:
                                    if Person_Profile(Subgroup_N_Work(CounterB,CounterA,Gear),43) == 1 %Is the Source Agent asymptomatic?    
                                        T_P = 1 * Person_Profile(Subgroup_N_Work(CounterB,CounterA,Gear),44); % Multiply by personal Superspreader Factor
                                    else
                                        T_P = Perc_Asymptomatic_Transmission/100 * Person_Profile(Subgroup_N_Work(CounterB,CounterA,Gear),44); % Multiply by personal Superspreader Factor
                                    end
                                    if School_Open == 1 % Check if schools are open...
                                        if Person_Profile(Subgroup_N_Work(CounterXX,CounterA,Gear),2)==1, Transmission_Probability = Beta_Kindy*T_P; end %This is dependent on the Recipient (Chang et al., 2020) not the Source Agent!
                                        if Person_Profile(Subgroup_N_Work(CounterXX,CounterA,Gear),2)==2, Transmission_Probability = Beta_School*T_P; end
                                    else
                                        if Person_Profile(Subgroup_N_Work(CounterXX,CounterA,Gear),2)==1, Transmission_Probability = 0; end %This is dependent on the Recipient (Chang et al., 2020) not the Source Agent!
                                        if Person_Profile(Subgroup_N_Work(CounterXX,CounterA,Gear),2)==2, Transmission_Probability = 0; end
                                    end
                                    if Person_Profile(Subgroup_N_Work(CounterXX,CounterA,Gear),2)>2, Transmission_Probability = Beta_Adult*T_P; end  
                                        Infective_Period = Person_Profile(Subgroup_N_Work(CounterB,CounterA,Gear),41)+Person_Profile(Subgroup_N_Work(CounterB,CounterA,Gear),42); %This calculates E2+I
                                        People_No = 1; 
                                        %Transmission_Probability = 1;
                                        %Infective_Period = 1;
                                        Person_Matrix(Subgroup_N_Work(CounterB,CounterA,Gear),Person_Profile(Subgroup_N_Work(CounterXX,CounterA,Gear),2)+8)=Person_Matrix(Subgroup_N_Work(CounterB,CounterA,Gear),Person_Profile(Subgroup_N_Work(CounterXX,CounterA,Gear),2)+8)+((Transmission_Probability/People_No)*Infective_Period); % Add 1 contact to Person_Matrix in the right field
                                    end
                                end
                        end
                    end
                end
                
                 % 5 = Transmission via Medium Groups
                % What Group is being indexed/extracted?: All people in medium group activities meeting today
                for Morning_Afternoon = 1:2 % Look at both morning and day Time periods (T1 and T2)
                    if Morning_Afternoon == 2, Gear = Weekday + 7; else, Gear = Weekday; end
                    for CounterA = 1:No_Subgroups_Social(Gear)
                        for CounterB = 1:Subgroup_N_Social_Rows(CounterA,Gear)
                            %  Additively calculate contacts for R0 for the Social Container and place them in the R0_Matrix_Social array
                                for CounterXX = 1:Subgroup_N_Social_Rows(CounterA,Gear) %Go through the whole group and manage transmission sequentially
                                    if CounterB ~= CounterXX
                                        % Calculate the transmission probability for this handshake:
                                        if Person_Profile(Subgroup_N_Social(CounterB,CounterA,Gear),43) == 1 %Is the Source Agent asymptomatic?
                                            T_P = 1 * Person_Profile(Subgroup_N_Social(CounterB,CounterA,Gear),44);
                                        else
                                            T_P = Perc_Asymptomatic_Transmission/100 * Person_Profile(Subgroup_N_Social(CounterB,CounterA,Gear),44);
                                        end

                                        if Person_Profile(Subgroup_N_Social(CounterXX,CounterA,Gear),2)==1, Transmission_Probability = Beta_E_0_4_Medium_Group*T_P; end
                                        if Person_Profile(Subgroup_N_Social(CounterXX,CounterA,Gear),2)==2, Transmission_Probability = Beta_E_5_19_Medium_Group*T_P; end
                                        if Person_Profile(Subgroup_N_Social(CounterXX,CounterA,Gear),2)==3, Transmission_Probability = Beta_E_Adult_Medium_Group*T_P; end 
                                        if Person_Profile(Subgroup_N_Social(CounterXX,CounterA,Gear),2)==4, Transmission_Probability = Beta_E_Older_Adult_Medium_Group*T_P; end 
                                        Infective_Period = Person_Profile(Subgroup_N_Social(CounterB,CounterA,Gear),41)+Person_Profile(Subgroup_N_Social(CounterB,CounterA,Gear),42); %This calculates E2+I
                                        People_No = 1;
                                        %Transmission_Probability = 1;
                                        %Infective_Period = 1;
                                        Person_Matrix(Subgroup_N_Social(CounterB,CounterA,Gear),Person_Profile(Subgroup_N_Social(CounterXX,CounterA,Gear),2)+8+4)=Person_Matrix(Subgroup_N_Social(CounterB,CounterA,Gear),Person_Profile(Subgroup_N_Social(CounterXX,CounterA,Gear),2)+8+4)+((Transmission_Probability/People_No)*Infective_Period);
                                    end
                                end
                        end
                    end
                end
                                        
                % 4 = Transmission via public transport
                % What Subgroup is being indexed/extracted?: Small Group Exposure Group                        
                for Morning_Afternoon = 1:2 % Look at both morning and day Time periods (T1 and T2)
                    
                    if Morning_Afternoon == 2, Gear = Weekday + 7; else, Gear = Weekday; end
                    for CounterA = 1:No_Subgroups_PublicT(Gear)
                        for CounterB = 1:Subgroup_N_PublicT_Rows(CounterA,Gear)
                           %  Additively calculate contacts for R0 for the PublicT Container and place them in the R0_Matrix_PublicT array
                                for CounterXX = 1:Subgroup_N_PublicT_Rows(CounterA,Gear) %Go through the whole group and determine contacts
                                    if CounterB ~= CounterXX
                                        
                                        % Calculate the transmission probability for this handshake:
                                        if Person_Profile(Subgroup_N_PublicT(CounterB,CounterA,Gear),43) == 1 %Is the Source Agent asymptomatic?
                                            T_P = 1 * Person_Profile(Subgroup_N_PublicT(CounterB,CounterA,Gear),44);
                                        else
                                            T_P = Perc_Asymptomatic_Transmission/100 * Person_Profile(Subgroup_N_PublicT(CounterB,CounterA,Gear),44);
                                        end
                                        %
                                        if Person_Profile(Subgroup_N_PublicT(CounterXX,CounterA,Gear),2)==1, Transmission_Probability = Beta_E_0_4_Small_Group*T_P; end
                                        if Person_Profile(Subgroup_N_PublicT(CounterXX,CounterA,Gear),2)==2, Transmission_Probability = Beta_E_5_19_Small_Group*T_P; end
                                        if Person_Profile(Subgroup_N_PublicT(CounterXX,CounterA,Gear),2)==3, Transmission_Probability = Beta_E_Adult_Small_Group*T_P; end 
                                        if Person_Profile(Subgroup_N_PublicT(CounterXX,CounterA,Gear),2)==4, Transmission_Probability = Beta_E_Older_Adult_Small_Group*T_P; end 
                                        Infective_Period = Person_Profile(Subgroup_N_PublicT(CounterB,CounterA,Gear),41)+Person_Profile(Subgroup_N_PublicT(CounterB,CounterA,Gear),42); %This calculates E2+I
                                        People_No = 1;
                                        %Transmission_Probability = 1;
                                        %Infective_Period = 1;
                                        Person_Matrix(Subgroup_N_PublicT(CounterB,CounterA,Gear),Person_Profile(Subgroup_N_PublicT(CounterXX,CounterA,Gear),2)+8+8)=Person_Matrix(Subgroup_N_PublicT(CounterB,CounterA,Gear),Person_Profile(Subgroup_N_PublicT(CounterXX,CounterA,Gear),2)+8+8)+((Transmission_Probability/People_No)*Infective_Period);
                                    end
                                end
                        end
                    end
                end
                
                % 2 = Transmission via Essential Activities
                % This includes food shopping, visiting doctors, pharmacies, etc. These interactions have been allocated to a medium-sized exposure group 
                % People who are engaged in Essential Activities today:
                for Morning_Afternoon = 1:2 % Look at both morning and day Time periods (T1 and T2)
                    
                    if Morning_Afternoon == 2, Gear = Weekday + 7; else, Gear = Weekday; end
                    for CounterA = 1:No_Subgroups_Essential(Gear)
                        for CounterB = 1:Subgroup_N_Essential_Rows(CounterA,Gear)
                           %  Additively calculate contacts for R0 for the Essential Container and place them in the R0_Matrix_Essential array
                                for CounterXX = 1:Subgroup_N_Essential_Rows(CounterA,Gear) %Go through the whole group and determine contacts
                                    if CounterB ~= CounterXX
                                         % Calculate the transmission probability for this handshake:
                            
                                        if Person_Profile(Subgroup_N_Essential(CounterB,CounterA,Gear),43) == 1 %Is the Source Agent asymptomatic?
                                            T_P = 1 * Person_Profile(Subgroup_N_Essential(CounterB,CounterA,Gear),44);
                                        else
                                            T_P = Perc_Asymptomatic_Transmission/100 * Person_Profile(Subgroup_N_Essential(CounterB,CounterA,Gear),44);
                                        end

                                        if Person_Profile(Subgroup_N_Essential(CounterXX,CounterA,Gear),2)==1, Transmission_Probability = Beta_E_0_4_Medium_Group*T_P; end
                                        if Person_Profile(Subgroup_N_Essential(CounterXX,CounterA,Gear),2)==2, Transmission_Probability = Beta_E_5_19_Medium_Group*T_P; end
                                        if Person_Profile(Subgroup_N_Essential(CounterXX,CounterA,Gear),2)==3, Transmission_Probability = Beta_E_Adult_Medium_Group*T_P; end 
                                        if Person_Profile(Subgroup_N_Essential(CounterXX,CounterA,Gear),2)==4, Transmission_Probability = Beta_E_Older_Adult_Medium_Group*T_P; end 
                                        Infective_Period = Person_Profile(Subgroup_N_Essential(CounterB,CounterA,Gear),41)+Person_Profile(Subgroup_N_Essential(CounterB,CounterA,Gear),42); %This calculates E2+I
                                        People_No = 1;
                                        %Transmission_Probability = 1;
                                        %Infective_Period = 1;
                                        Person_Matrix(Subgroup_N_Essential(CounterB,CounterA,Gear),Person_Profile(Subgroup_N_Essential(CounterXX,CounterA,Gear),2)+8+12)=Person_Matrix(Subgroup_N_Essential(CounterB,CounterA,Gear),Person_Profile(Subgroup_N_Essential(CounterXX,CounterA,Gear),2)+8+12)+((Transmission_Probability/People_No)*Infective_Period);
                                    end
                                end
                        end
                    end
                end
                
                % 3 = Transmission via Large Group Activity
                % This comprises going to large gatherings, such as shopping malls, market and other crowded areas. These interactions have been allocated to a large-sized exposure group 
               
                for Morning_Afternoon = 1:2 % Look at both morning and day Time periods (T1 and T2)
                    
                    if Morning_Afternoon == 2, Gear = Weekday + 7; else, Gear = Weekday; end
                    for CounterA = 1:No_Subgroups_Leisure(Gear)
                        for CounterB = 1:Subgroup_N_Leisure_Rows(CounterA,Gear)
                           %  Additively calculate contacts for R0 for the Leisure Container and place them in the R0_Matrix_Leisure array
                                for CounterXX = 1:Subgroup_N_Leisure_Rows(CounterA,Gear) %Go through the whole group and determine contacts
                                    if CounterB ~= CounterXX
                                        % Calculate the transmission probability for this handshake:
                            
                                        if Person_Profile(Subgroup_N_Leisure(CounterB,CounterA,Gear),43) == 1  %Is the Source Agent asymptomatic?
                                            T_P = 1 * Person_Profile(Subgroup_N_Leisure(CounterB,CounterA,Gear),44); 
                                        else
                                            T_P = Perc_Asymptomatic_Transmission/100 * Person_Profile(Subgroup_N_Leisure(CounterB,CounterA,Gear),44); 
                                        end

                                        if Person_Profile(Subgroup_N_Leisure(CounterXX,CounterA,Gear),2)==1, Transmission_Probability = Beta_E_0_4_Large_Group*T_P; end
                                        if Person_Profile(Subgroup_N_Leisure(CounterXX,CounterA,Gear),2)==2, Transmission_Probability = Beta_E_5_19_Large_Group*T_P; end
                                        if Person_Profile(Subgroup_N_Leisure(CounterXX,CounterA,Gear),2)==3, Transmission_Probability = Beta_E_Adult_Large_Group*T_P; end 
                                        if Person_Profile(Subgroup_N_Leisure(CounterXX,CounterA,Gear),2)==4, Transmission_Probability = Beta_E_Older_Adult_Large_Group*T_P; end
                                        Infective_Period = Person_Profile(Subgroup_N_Leisure(CounterB,CounterA,Gear),41)+Person_Profile(Subgroup_N_Leisure(CounterB,CounterA,Gear),42); %This calculates E2+I
                                        People_No = 1;
                                        %Transmission_Probability = 1;
                                        %Infective_Period = 1;
                                        Person_Matrix(Subgroup_N_Leisure(CounterB,CounterA,Gear),Person_Profile(Subgroup_N_Leisure(CounterXX,CounterA,Gear),2)+8+16)=Person_Matrix(Subgroup_N_Leisure(CounterB,CounterA,Gear),Person_Profile(Subgroup_N_Leisure(CounterXX,CounterA,Gear),2)+8+16)+((Transmission_Probability/People_No)*Infective_Period);
                                    end
                                end
                        end
                    end
                end
                
                % 5 = Transmission via friendship and kin groups
                % What Group is being indexed/extracted?: All people in known Friends groups meeting today
                
                Gear = Weekday; 
                    for CounterA = 1:No_Subgroups_Friends(Gear)
                        
                        %For Friends, we buid in a system whereby only a small number of people have contact in one visit. 
                        %For this we use the Friends_and_Kin_Visit_Size_M and Friends_and_Kin_Visit_Size_SD variables.
                        Friends_Visitor_N = abs(ceil(normrnd(Friends_and_Kin_Visit_Size_M,Friends_and_Kin_Visit_Size_SD)));
                        if Subgroup_N_Friends_Rows(CounterA,Gear) > Friends_Visitor_N
                            Friends_Visitor_Who = randperm(Subgroup_N_Friends_Rows(CounterA,Gear),Friends_Visitor_N);
                        else
                            Friends_Visitor_Who = Subgroup_N_Friends_Rows(CounterA,Gear);
                        end
                        for CounterB = 1:Subgroup_N_Friends_Rows(CounterA,Gear)
                            %New lines added that check if both the donor and the recipient are on the smaller list...
                            Is_Friend_Present = ismember(CounterB,Friends_Visitor_Who); % Check if friend is present in this group 
                            if Is_Friend_Present == 1 %Only proceed if the friend is present in the group
                                    for CounterXX = 1:Subgroup_N_Friends_Rows(CounterA,Gear) %Go through the whole group and manage transmission sequentially
                                        Is_Friend_Present = ismember(CounterXX,Friends_Visitor_Who); % Check if friend is present in this group
                                          
                                        if Is_Friend_Present == 1 %Only proceed if the friend is present in the group
                                            if CounterB ~= CounterXX
                                                 % Calculate the transmission probability for this handshake:
                                                if Person_Profile(Subgroup_N_Friends(CounterB,CounterA,Gear),43) == 1 %Is the Source Agent asymptomatic?
                                                    T_P = 1 * Person_Profile(Subgroup_N_Friends(CounterB,CounterA,Gear),44); 
                                                else
                                                    T_P = Perc_Asymptomatic_Transmission/100 * Person_Profile(Subgroup_N_Friends(CounterB,CounterA,Gear),44); 
                                                end

                                                if Person_Profile(Subgroup_N_Friends(CounterXX,CounterA,Gear),2)==1, Transmission_Probability = Beta_E_0_4_Friends_Group*T_P; end
                                                if Person_Profile(Subgroup_N_Friends(CounterXX,CounterA,Gear),2)==2, Transmission_Probability = Beta_E_5_19_Friends_Group*T_P; end
                                                if Person_Profile(Subgroup_N_Friends(CounterXX,CounterA,Gear),2)==3, Transmission_Probability = Beta_E_Adult_Friends_Group*T_P; end 
                                                if Person_Profile(Subgroup_N_Friends(CounterXX,CounterA,Gear),2)==4, Transmission_Probability = Beta_E_Older_Adult_Friends_Group*T_P; end 
                                                Infective_Period = Person_Profile(Subgroup_N_Friends(CounterB,CounterA,Gear),41)+Person_Profile(Subgroup_N_Friends(CounterB,CounterA,Gear),42); %This calculates E2+I
                                                People_No = 1;
                                                %Transmission_Probability = 1;
                                                %Infective_Period = 1;
                                                Person_Matrix(Subgroup_N_Friends(CounterB,CounterA,Gear),Person_Profile(Subgroup_N_Friends(CounterXX,CounterA,Gear),2)+8+20)=Person_Matrix(Subgroup_N_Friends(CounterB,CounterA,Gear),Person_Profile(Subgroup_N_Friends(CounterXX,CounterA,Gear),2)+8+20)+((Transmission_Probability/People_No)*Infective_Period);
                                            end
                                        end
                                    end
                            end
                        end
                    end
                
                
                % Transmission via Family Members
                for CounterA = 1:No_Subgroups_Family
                    for CounterB = 1:Subgroup_N_Family_Rows(CounterA)
                        
                        if Subgroup_N_Family(CounterB,CounterA) > 0 
                            %  Additively calculate contacts for R0 for the Family Container and place them in the R0_Matrix_Family array
                                for CounterXX = 1:Subgroup_N_Family_Rows(CounterA) %Go through the whole group and manage transmission sequentially
                                    if Subgroup_N_Family(CounterXX,CounterA) > 0 %Failsafe for 0 entries
                                        if CounterB ~= CounterXX

                                             % Calculate the transmission probability for this handshake:    
                                            if Person_Profile(Subgroup_N_Family(CounterB,CounterA),43) == 1 %Is the Source Agent asymptomatic?
                                                T_P = 1 * Person_Profile(Subgroup_N_Family(CounterB,CounterA),44);
                                            else
                                                T_P = Perc_Asymptomatic_Transmission/100 * Person_Profile(Subgroup_N_Family(CounterB,CounterA),44);
                                            end
                                            if Person_Profile(Subgroup_N_Family(CounterB,CounterA),2)<3, Transmission_Probability = Beta_Family_I_is_Child*T_P; end %Transmission probability here is based in whether the INFECTIVE person is child or adult!
                                            if Person_Profile(Subgroup_N_Family(CounterB,CounterA),2)>2, Transmission_Probability = Beta_Family_I_is_Adult*T_P; end

                                            Infective_Period = Person_Profile(Subgroup_N_Family(CounterB,CounterA),41)+Person_Profile(Subgroup_N_Family(CounterB,CounterA),42); %This calculates E2+I
                                            People_No = 1;
                                            %Transmission_Probability = 1;
                                            %Infective_Period = 1;
                                            Person_Matrix(Subgroup_N_Family(CounterB,CounterA),Person_Profile(Subgroup_N_Family(CounterXX,CounterA),2)+8+24)=Person_Matrix(Subgroup_N_Family(CounterB,CounterA),Person_Profile(Subgroup_N_Family(CounterXX,CounterA),2)+8+24)+((Transmission_Probability/People_No)*Infective_Period); 
                                        end
                                    end
                                end
                        end
                    end
                end
                                        
    end % End Day_Count Loop
    
           
    
         %% Now use Person_Matrix to obtain R0 Metrics:
         
        % First calculate mean: 
        
        % Add the relevant contacts into a 4x4 matrix according to age:
        
        Total_Contacts(1,1) = sum(Person_Matrix(Pop_Range_0_4_Start:Pop_Range_0_4_End,9))+sum(Person_Matrix(Pop_Range_0_4_Start:Pop_Range_0_4_End,13))+sum(Person_Matrix(Pop_Range_0_4_Start:Pop_Range_0_4_End,17))+sum(Person_Matrix(Pop_Range_0_4_Start:Pop_Range_0_4_End,21))+sum(Person_Matrix(Pop_Range_0_4_Start:Pop_Range_0_4_End,25))+sum(Person_Matrix(Pop_Range_0_4_Start:Pop_Range_0_4_End,29))+sum(Person_Matrix(Pop_Range_0_4_Start:Pop_Range_0_4_End,33));
        Total_Contacts(2,1) = sum(Person_Matrix(Pop_Range_5_19_Start:Pop_Range_5_19_End,9))+sum(Person_Matrix(Pop_Range_5_19_Start:Pop_Range_5_19_End,13))+sum(Person_Matrix(Pop_Range_5_19_Start:Pop_Range_5_19_End,17))+sum(Person_Matrix(Pop_Range_5_19_Start:Pop_Range_5_19_End,21))+sum(Person_Matrix(Pop_Range_5_19_Start:Pop_Range_5_19_End,25))+sum(Person_Matrix(Pop_Range_5_19_Start:Pop_Range_5_19_End,29))+sum(Person_Matrix(Pop_Range_5_19_Start:Pop_Range_5_19_End,33));
        Total_Contacts(3,1) = sum(Person_Matrix(Pop_Range_20_64_Start:Pop_Range_20_64_End,9))+sum(Person_Matrix(Pop_Range_20_64_Start:Pop_Range_20_64_End,13))+sum(Person_Matrix(Pop_Range_20_64_Start:Pop_Range_20_64_End,17))+sum(Person_Matrix(Pop_Range_20_64_Start:Pop_Range_20_64_End,21))+sum(Person_Matrix(Pop_Range_20_64_Start:Pop_Range_20_64_End,25))+sum(Person_Matrix(Pop_Range_20_64_Start:Pop_Range_20_64_End,29))+sum(Person_Matrix(Pop_Range_20_64_Start:Pop_Range_20_64_End,33));
        Total_Contacts(4,1) = sum(Person_Matrix(Pop_Range_65_Over_Start:Pop_Range_65_Over_End,9))+sum(Person_Matrix(Pop_Range_65_Over_Start:Pop_Range_65_Over_End,13))+sum(Person_Matrix(Pop_Range_65_Over_Start:Pop_Range_65_Over_End,17))+sum(Person_Matrix(Pop_Range_65_Over_Start:Pop_Range_65_Over_End,21))+sum(Person_Matrix(Pop_Range_65_Over_Start:Pop_Range_65_Over_End,25))+sum(Person_Matrix(Pop_Range_65_Over_Start:Pop_Range_65_Over_End,29))+sum(Person_Matrix(Pop_Range_65_Over_Start:Pop_Range_65_Over_End,33));
        Total_Contacts(1,2) = sum(Person_Matrix(Pop_Range_0_4_Start:Pop_Range_0_4_End,10))+sum(Person_Matrix(Pop_Range_0_4_Start:Pop_Range_0_4_End,14))+sum(Person_Matrix(Pop_Range_0_4_Start:Pop_Range_0_4_End,18))+sum(Person_Matrix(Pop_Range_0_4_Start:Pop_Range_0_4_End,22))+sum(Person_Matrix(Pop_Range_0_4_Start:Pop_Range_0_4_End,26))+sum(Person_Matrix(Pop_Range_0_4_Start:Pop_Range_0_4_End,30))+sum(Person_Matrix(Pop_Range_0_4_Start:Pop_Range_0_4_End,34));
        Total_Contacts(2,2) = sum(Person_Matrix(Pop_Range_5_19_Start:Pop_Range_5_19_End,10))+sum(Person_Matrix(Pop_Range_5_19_Start:Pop_Range_5_19_End,14))+sum(Person_Matrix(Pop_Range_5_19_Start:Pop_Range_5_19_End,18))+sum(Person_Matrix(Pop_Range_5_19_Start:Pop_Range_5_19_End,22))+sum(Person_Matrix(Pop_Range_5_19_Start:Pop_Range_5_19_End,26))+sum(Person_Matrix(Pop_Range_5_19_Start:Pop_Range_5_19_End,30))+sum(Person_Matrix(Pop_Range_5_19_Start:Pop_Range_5_19_End,34));
        Total_Contacts(3,2) = sum(Person_Matrix(Pop_Range_20_64_Start:Pop_Range_20_64_End,10))+sum(Person_Matrix(Pop_Range_20_64_Start:Pop_Range_20_64_End,14))+sum(Person_Matrix(Pop_Range_20_64_Start:Pop_Range_20_64_End,18))+sum(Person_Matrix(Pop_Range_20_64_Start:Pop_Range_20_64_End,22))+sum(Person_Matrix(Pop_Range_20_64_Start:Pop_Range_20_64_End,26))+sum(Person_Matrix(Pop_Range_20_64_Start:Pop_Range_20_64_End,30))+sum(Person_Matrix(Pop_Range_20_64_Start:Pop_Range_20_64_End,34));
        Total_Contacts(4,2) = sum(Person_Matrix(Pop_Range_65_Over_Start:Pop_Range_65_Over_End,10))+sum(Person_Matrix(Pop_Range_65_Over_Start:Pop_Range_65_Over_End,14))+sum(Person_Matrix(Pop_Range_65_Over_Start:Pop_Range_65_Over_End,18))+sum(Person_Matrix(Pop_Range_65_Over_Start:Pop_Range_65_Over_End,22))+sum(Person_Matrix(Pop_Range_65_Over_Start:Pop_Range_65_Over_End,26))+sum(Person_Matrix(Pop_Range_65_Over_Start:Pop_Range_65_Over_End,30))+sum(Person_Matrix(Pop_Range_65_Over_Start:Pop_Range_65_Over_End,34));
        Total_Contacts(1,3) = sum(Person_Matrix(Pop_Range_0_4_Start:Pop_Range_0_4_End,11))+sum(Person_Matrix(Pop_Range_0_4_Start:Pop_Range_0_4_End,15))+sum(Person_Matrix(Pop_Range_0_4_Start:Pop_Range_0_4_End,19))+sum(Person_Matrix(Pop_Range_0_4_Start:Pop_Range_0_4_End,23))+sum(Person_Matrix(Pop_Range_0_4_Start:Pop_Range_0_4_End,27))+sum(Person_Matrix(Pop_Range_0_4_Start:Pop_Range_0_4_End,31))+sum(Person_Matrix(Pop_Range_0_4_Start:Pop_Range_0_4_End,35));
        Total_Contacts(2,3) = sum(Person_Matrix(Pop_Range_5_19_Start:Pop_Range_5_19_End,11))+sum(Person_Matrix(Pop_Range_5_19_Start:Pop_Range_5_19_End,15))+sum(Person_Matrix(Pop_Range_5_19_Start:Pop_Range_5_19_End,19))+sum(Person_Matrix(Pop_Range_5_19_Start:Pop_Range_5_19_End,23))+sum(Person_Matrix(Pop_Range_5_19_Start:Pop_Range_5_19_End,27))+sum(Person_Matrix(Pop_Range_5_19_Start:Pop_Range_5_19_End,31))+sum(Person_Matrix(Pop_Range_5_19_Start:Pop_Range_5_19_End,35));
        Total_Contacts(3,3) = sum(Person_Matrix(Pop_Range_20_64_Start:Pop_Range_20_64_End,11))+sum(Person_Matrix(Pop_Range_20_64_Start:Pop_Range_20_64_End,15))+sum(Person_Matrix(Pop_Range_20_64_Start:Pop_Range_20_64_End,19))+sum(Person_Matrix(Pop_Range_20_64_Start:Pop_Range_20_64_End,23))+sum(Person_Matrix(Pop_Range_20_64_Start:Pop_Range_20_64_End,27))+sum(Person_Matrix(Pop_Range_20_64_Start:Pop_Range_20_64_End,31))+sum(Person_Matrix(Pop_Range_20_64_Start:Pop_Range_20_64_End,35));
        Total_Contacts(4,3) = sum(Person_Matrix(Pop_Range_65_Over_Start:Pop_Range_65_Over_End,11))+sum(Person_Matrix(Pop_Range_65_Over_Start:Pop_Range_65_Over_End,15))+sum(Person_Matrix(Pop_Range_65_Over_Start:Pop_Range_65_Over_End,19))+sum(Person_Matrix(Pop_Range_65_Over_Start:Pop_Range_65_Over_End,23))+sum(Person_Matrix(Pop_Range_65_Over_Start:Pop_Range_65_Over_End,27))+sum(Person_Matrix(Pop_Range_65_Over_Start:Pop_Range_65_Over_End,31))+sum(Person_Matrix(Pop_Range_65_Over_Start:Pop_Range_65_Over_End,35));
        Total_Contacts(1,4) = sum(Person_Matrix(Pop_Range_0_4_Start:Pop_Range_0_4_End,12))+sum(Person_Matrix(Pop_Range_0_4_Start:Pop_Range_0_4_End,16))+sum(Person_Matrix(Pop_Range_0_4_Start:Pop_Range_0_4_End,20))+sum(Person_Matrix(Pop_Range_0_4_Start:Pop_Range_0_4_End,24))+sum(Person_Matrix(Pop_Range_0_4_Start:Pop_Range_0_4_End,28))+sum(Person_Matrix(Pop_Range_0_4_Start:Pop_Range_0_4_End,32))+sum(Person_Matrix(Pop_Range_0_4_Start:Pop_Range_0_4_End,36));
        Total_Contacts(2,4) = sum(Person_Matrix(Pop_Range_5_19_Start:Pop_Range_5_19_End,12))+sum(Person_Matrix(Pop_Range_5_19_Start:Pop_Range_5_19_End,16))+sum(Person_Matrix(Pop_Range_5_19_Start:Pop_Range_5_19_End,20))+sum(Person_Matrix(Pop_Range_5_19_Start:Pop_Range_5_19_End,24))+sum(Person_Matrix(Pop_Range_5_19_Start:Pop_Range_5_19_End,28))+sum(Person_Matrix(Pop_Range_5_19_Start:Pop_Range_5_19_End,32))+sum(Person_Matrix(Pop_Range_5_19_Start:Pop_Range_5_19_End,36));
        Total_Contacts(3,4) = sum(Person_Matrix(Pop_Range_20_64_Start:Pop_Range_20_64_End,12))+sum(Person_Matrix(Pop_Range_20_64_Start:Pop_Range_20_64_End,16))+sum(Person_Matrix(Pop_Range_20_64_Start:Pop_Range_20_64_End,20))+sum(Person_Matrix(Pop_Range_20_64_Start:Pop_Range_20_64_End,24))+sum(Person_Matrix(Pop_Range_20_64_Start:Pop_Range_20_64_End,28))+sum(Person_Matrix(Pop_Range_20_64_Start:Pop_Range_20_64_End,32))+sum(Person_Matrix(Pop_Range_20_64_Start:Pop_Range_20_64_End,36));
        Total_Contacts(4,4) = sum(Person_Matrix(Pop_Range_65_Over_Start:Pop_Range_65_Over_End,12))+sum(Person_Matrix(Pop_Range_65_Over_Start:Pop_Range_65_Over_End,16))+sum(Person_Matrix(Pop_Range_65_Over_Start:Pop_Range_65_Over_End,20))+sum(Person_Matrix(Pop_Range_65_Over_Start:Pop_Range_65_Over_End,24))+sum(Person_Matrix(Pop_Range_65_Over_Start:Pop_Range_65_Over_End,28))+sum(Person_Matrix(Pop_Range_65_Over_Start:Pop_Range_65_Over_End,32))+sum(Person_Matrix(Pop_Range_65_Over_Start:Pop_Range_65_Over_End,36));        
        
       
      
        % Divide (contacts in each age group x infective period) by number of people in each age group:
        Total_Contacts(1,1) = Total_Contacts(1,1)/People_Age_No(1);
        Total_Contacts(2,1) = Total_Contacts(2,1)/People_Age_No(2);
        Total_Contacts(3,1) = Total_Contacts(3,1)/People_Age_No(3);
        Total_Contacts(4,1) = Total_Contacts(4,1)/People_Age_No(4);
        Total_Contacts(1,2) = Total_Contacts(1,2)/People_Age_No(1);
        Total_Contacts(2,2) = Total_Contacts(2,2)/People_Age_No(2);
        Total_Contacts(3,2) = Total_Contacts(3,2)/People_Age_No(3);
        Total_Contacts(4,2) = Total_Contacts(4,2)/People_Age_No(4);
        Total_Contacts(1,3) = Total_Contacts(1,3)/People_Age_No(1);
        Total_Contacts(2,3) = Total_Contacts(2,3)/People_Age_No(2);
        Total_Contacts(3,3) = Total_Contacts(3,3)/People_Age_No(3);
        Total_Contacts(4,3) = Total_Contacts(4,3)/People_Age_No(4);
        Total_Contacts(1,4) = Total_Contacts(1,4)/People_Age_No(1);
        Total_Contacts(2,4) = Total_Contacts(2,4)/People_Age_No(2);
        Total_Contacts(3,4) = Total_Contacts(3,4)/People_Age_No(3);
        Total_Contacts(4,4) = Total_Contacts(4,4)/People_Age_No(4);
        
        Total_Contacts = Total_Contacts/7; %Divide the whole matrix by 7 (7 days of the week)
        
        
        % Next calculate median:
        
        Medium_Columns(Pop_Range_0_4_Start:Pop_Range_0_4_End,1) = (Person_Matrix(Pop_Range_0_4_Start:Pop_Range_0_4_End,9))+(Person_Matrix(Pop_Range_0_4_Start:Pop_Range_0_4_End,13))+(Person_Matrix(Pop_Range_0_4_Start:Pop_Range_0_4_End,17))+(Person_Matrix(Pop_Range_0_4_Start:Pop_Range_0_4_End,21))+(Person_Matrix(Pop_Range_0_4_Start:Pop_Range_0_4_End,25))+(Person_Matrix(Pop_Range_0_4_Start:Pop_Range_0_4_End,29))+(Person_Matrix(Pop_Range_0_4_Start:Pop_Range_0_4_End,33));
        Medium_Columns(Pop_Range_5_19_Start:Pop_Range_5_19_End,1) = (Person_Matrix(Pop_Range_5_19_Start:Pop_Range_5_19_End,9))+(Person_Matrix(Pop_Range_5_19_Start:Pop_Range_5_19_End,13))+(Person_Matrix(Pop_Range_5_19_Start:Pop_Range_5_19_End,17))+(Person_Matrix(Pop_Range_5_19_Start:Pop_Range_5_19_End,21))+(Person_Matrix(Pop_Range_5_19_Start:Pop_Range_5_19_End,25))+(Person_Matrix(Pop_Range_5_19_Start:Pop_Range_5_19_End,29))+(Person_Matrix(Pop_Range_5_19_Start:Pop_Range_5_19_End,33));
        Medium_Columns(Pop_Range_20_64_Start:Pop_Range_20_64_End,1) = (Person_Matrix(Pop_Range_20_64_Start:Pop_Range_20_64_End,9))+(Person_Matrix(Pop_Range_20_64_Start:Pop_Range_20_64_End,13))+(Person_Matrix(Pop_Range_20_64_Start:Pop_Range_20_64_End,17))+(Person_Matrix(Pop_Range_20_64_Start:Pop_Range_20_64_End,21))+(Person_Matrix(Pop_Range_20_64_Start:Pop_Range_20_64_End,25))+(Person_Matrix(Pop_Range_20_64_Start:Pop_Range_20_64_End,29))+(Person_Matrix(Pop_Range_20_64_Start:Pop_Range_20_64_End,33));
        Medium_Columns(Pop_Range_65_Over_Start:Pop_Range_65_Over_End,1) = (Person_Matrix(Pop_Range_65_Over_Start:Pop_Range_65_Over_End,9))+(Person_Matrix(Pop_Range_65_Over_Start:Pop_Range_65_Over_End,13))+(Person_Matrix(Pop_Range_65_Over_Start:Pop_Range_65_Over_End,17))+(Person_Matrix(Pop_Range_65_Over_Start:Pop_Range_65_Over_End,21))+(Person_Matrix(Pop_Range_65_Over_Start:Pop_Range_65_Over_End,25))+(Person_Matrix(Pop_Range_65_Over_Start:Pop_Range_65_Over_End,29))+(Person_Matrix(Pop_Range_65_Over_Start:Pop_Range_65_Over_End,33));
        Medium_Columns(Pop_Range_0_4_Start:Pop_Range_0_4_End,2) = (Person_Matrix(Pop_Range_0_4_Start:Pop_Range_0_4_End,10))+(Person_Matrix(Pop_Range_0_4_Start:Pop_Range_0_4_End,14))+(Person_Matrix(Pop_Range_0_4_Start:Pop_Range_0_4_End,18))+(Person_Matrix(Pop_Range_0_4_Start:Pop_Range_0_4_End,22))+(Person_Matrix(Pop_Range_0_4_Start:Pop_Range_0_4_End,26))+(Person_Matrix(Pop_Range_0_4_Start:Pop_Range_0_4_End,30))+(Person_Matrix(Pop_Range_0_4_Start:Pop_Range_0_4_End,34));
        Medium_Columns(Pop_Range_5_19_Start:Pop_Range_5_19_End,2) = (Person_Matrix(Pop_Range_5_19_Start:Pop_Range_5_19_End,10))+(Person_Matrix(Pop_Range_5_19_Start:Pop_Range_5_19_End,14))+(Person_Matrix(Pop_Range_5_19_Start:Pop_Range_5_19_End,18))+(Person_Matrix(Pop_Range_5_19_Start:Pop_Range_5_19_End,22))+(Person_Matrix(Pop_Range_5_19_Start:Pop_Range_5_19_End,26))+(Person_Matrix(Pop_Range_5_19_Start:Pop_Range_5_19_End,30))+(Person_Matrix(Pop_Range_5_19_Start:Pop_Range_5_19_End,34));
        Medium_Columns(Pop_Range_20_64_Start:Pop_Range_20_64_End,2) = (Person_Matrix(Pop_Range_20_64_Start:Pop_Range_20_64_End,10))+(Person_Matrix(Pop_Range_20_64_Start:Pop_Range_20_64_End,14))+(Person_Matrix(Pop_Range_20_64_Start:Pop_Range_20_64_End,18))+(Person_Matrix(Pop_Range_20_64_Start:Pop_Range_20_64_End,22))+(Person_Matrix(Pop_Range_20_64_Start:Pop_Range_20_64_End,26))+(Person_Matrix(Pop_Range_20_64_Start:Pop_Range_20_64_End,30))+(Person_Matrix(Pop_Range_20_64_Start:Pop_Range_20_64_End,34));
        Medium_Columns(Pop_Range_65_Over_Start:Pop_Range_65_Over_End,2) = (Person_Matrix(Pop_Range_65_Over_Start:Pop_Range_65_Over_End,10))+(Person_Matrix(Pop_Range_65_Over_Start:Pop_Range_65_Over_End,14))+(Person_Matrix(Pop_Range_65_Over_Start:Pop_Range_65_Over_End,18))+(Person_Matrix(Pop_Range_65_Over_Start:Pop_Range_65_Over_End,22))+(Person_Matrix(Pop_Range_65_Over_Start:Pop_Range_65_Over_End,26))+(Person_Matrix(Pop_Range_65_Over_Start:Pop_Range_65_Over_End,30))+(Person_Matrix(Pop_Range_65_Over_Start:Pop_Range_65_Over_End,34));
        Medium_Columns(Pop_Range_0_4_Start:Pop_Range_0_4_End,3) = (Person_Matrix(Pop_Range_0_4_Start:Pop_Range_0_4_End,11))+(Person_Matrix(Pop_Range_0_4_Start:Pop_Range_0_4_End,15))+(Person_Matrix(Pop_Range_0_4_Start:Pop_Range_0_4_End,19))+(Person_Matrix(Pop_Range_0_4_Start:Pop_Range_0_4_End,23))+(Person_Matrix(Pop_Range_0_4_Start:Pop_Range_0_4_End,27))+(Person_Matrix(Pop_Range_0_4_Start:Pop_Range_0_4_End,31))+(Person_Matrix(Pop_Range_0_4_Start:Pop_Range_0_4_End,35));
        Medium_Columns(Pop_Range_5_19_Start:Pop_Range_5_19_End,3) = (Person_Matrix(Pop_Range_5_19_Start:Pop_Range_5_19_End,11))+(Person_Matrix(Pop_Range_5_19_Start:Pop_Range_5_19_End,15))+(Person_Matrix(Pop_Range_5_19_Start:Pop_Range_5_19_End,19))+(Person_Matrix(Pop_Range_5_19_Start:Pop_Range_5_19_End,23))+(Person_Matrix(Pop_Range_5_19_Start:Pop_Range_5_19_End,27))+(Person_Matrix(Pop_Range_5_19_Start:Pop_Range_5_19_End,31))+(Person_Matrix(Pop_Range_5_19_Start:Pop_Range_5_19_End,35));
        Medium_Columns(Pop_Range_20_64_Start:Pop_Range_20_64_End,3) = (Person_Matrix(Pop_Range_20_64_Start:Pop_Range_20_64_End,11))+(Person_Matrix(Pop_Range_20_64_Start:Pop_Range_20_64_End,15))+(Person_Matrix(Pop_Range_20_64_Start:Pop_Range_20_64_End,19))+(Person_Matrix(Pop_Range_20_64_Start:Pop_Range_20_64_End,23))+(Person_Matrix(Pop_Range_20_64_Start:Pop_Range_20_64_End,27))+(Person_Matrix(Pop_Range_20_64_Start:Pop_Range_20_64_End,31))+(Person_Matrix(Pop_Range_20_64_Start:Pop_Range_20_64_End,35));
        Medium_Columns(Pop_Range_65_Over_Start:Pop_Range_65_Over_End,3) = (Person_Matrix(Pop_Range_65_Over_Start:Pop_Range_65_Over_End,11))+(Person_Matrix(Pop_Range_65_Over_Start:Pop_Range_65_Over_End,15))+(Person_Matrix(Pop_Range_65_Over_Start:Pop_Range_65_Over_End,19))+(Person_Matrix(Pop_Range_65_Over_Start:Pop_Range_65_Over_End,23))+(Person_Matrix(Pop_Range_65_Over_Start:Pop_Range_65_Over_End,27))+(Person_Matrix(Pop_Range_65_Over_Start:Pop_Range_65_Over_End,31))+(Person_Matrix(Pop_Range_65_Over_Start:Pop_Range_65_Over_End,35));
        Medium_Columns(Pop_Range_0_4_Start:Pop_Range_0_4_End,4) = (Person_Matrix(Pop_Range_0_4_Start:Pop_Range_0_4_End,12))+(Person_Matrix(Pop_Range_0_4_Start:Pop_Range_0_4_End,16))+(Person_Matrix(Pop_Range_0_4_Start:Pop_Range_0_4_End,20))+(Person_Matrix(Pop_Range_0_4_Start:Pop_Range_0_4_End,24))+(Person_Matrix(Pop_Range_0_4_Start:Pop_Range_0_4_End,28))+(Person_Matrix(Pop_Range_0_4_Start:Pop_Range_0_4_End,32))+(Person_Matrix(Pop_Range_0_4_Start:Pop_Range_0_4_End,36));
        Medium_Columns(Pop_Range_5_19_Start:Pop_Range_5_19_End,4) = (Person_Matrix(Pop_Range_5_19_Start:Pop_Range_5_19_End,12))+(Person_Matrix(Pop_Range_5_19_Start:Pop_Range_5_19_End,16))+(Person_Matrix(Pop_Range_5_19_Start:Pop_Range_5_19_End,20))+(Person_Matrix(Pop_Range_5_19_Start:Pop_Range_5_19_End,24))+(Person_Matrix(Pop_Range_5_19_Start:Pop_Range_5_19_End,28))+(Person_Matrix(Pop_Range_5_19_Start:Pop_Range_5_19_End,32))+(Person_Matrix(Pop_Range_5_19_Start:Pop_Range_5_19_End,36));
        Medium_Columns(Pop_Range_20_64_Start:Pop_Range_20_64_End,4) = (Person_Matrix(Pop_Range_20_64_Start:Pop_Range_20_64_End,12))+(Person_Matrix(Pop_Range_20_64_Start:Pop_Range_20_64_End,16))+(Person_Matrix(Pop_Range_20_64_Start:Pop_Range_20_64_End,20))+(Person_Matrix(Pop_Range_20_64_Start:Pop_Range_20_64_End,24))+(Person_Matrix(Pop_Range_20_64_Start:Pop_Range_20_64_End,28))+(Person_Matrix(Pop_Range_20_64_Start:Pop_Range_20_64_End,32))+(Person_Matrix(Pop_Range_20_64_Start:Pop_Range_20_64_End,36));
        Medium_Columns(Pop_Range_65_Over_Start:Pop_Range_65_Over_End,4) = (Person_Matrix(Pop_Range_65_Over_Start:Pop_Range_65_Over_End,12))+(Person_Matrix(Pop_Range_65_Over_Start:Pop_Range_65_Over_End,16))+(Person_Matrix(Pop_Range_65_Over_Start:Pop_Range_65_Over_End,20))+(Person_Matrix(Pop_Range_65_Over_Start:Pop_Range_65_Over_End,24))+(Person_Matrix(Pop_Range_65_Over_Start:Pop_Range_65_Over_End,28))+(Person_Matrix(Pop_Range_65_Over_Start:Pop_Range_65_Over_End,32))+(Person_Matrix(Pop_Range_65_Over_Start:Pop_Range_65_Over_End,36));        
        
        Median_Contacts(1,1) = median(Medium_Columns(Pop_Range_0_4_Start:Pop_Range_0_4_End,1));
        Median_Contacts(2,1) = median(Medium_Columns(Pop_Range_5_19_Start:Pop_Range_5_19_End,1));
        Median_Contacts(3,1) = median(Medium_Columns(Pop_Range_20_64_Start:Pop_Range_20_64_End,1));
        Median_Contacts(4,1) = median(Medium_Columns(Pop_Range_65_Over_Start:Pop_Range_65_Over_End,1));
        Median_Contacts(1,2) = median(Medium_Columns(Pop_Range_0_4_Start:Pop_Range_0_4_End,2));
        Median_Contacts(2,2) = median(Medium_Columns(Pop_Range_5_19_Start:Pop_Range_5_19_End,2));
        Median_Contacts(3,2) = median(Medium_Columns(Pop_Range_20_64_Start:Pop_Range_20_64_End,2));
        Median_Contacts(4,2) = median(Medium_Columns(Pop_Range_65_Over_Start:Pop_Range_65_Over_End,2));
        Median_Contacts(1,3) = median(Medium_Columns(Pop_Range_0_4_Start:Pop_Range_0_4_End,3));
        Median_Contacts(2,3) = median(Medium_Columns(Pop_Range_5_19_Start:Pop_Range_5_19_End,3));
        Median_Contacts(3,3) = median(Medium_Columns(Pop_Range_20_64_Start:Pop_Range_20_64_End,3));
        Median_Contacts(4,3) = median(Medium_Columns(Pop_Range_65_Over_Start:Pop_Range_65_Over_End,3));
        Median_Contacts(1,4) = median(Medium_Columns(Pop_Range_0_4_Start:Pop_Range_0_4_End,4));
        Median_Contacts(2,4) = median(Medium_Columns(Pop_Range_5_19_Start:Pop_Range_5_19_End,4));
        Median_Contacts(3,4) = median(Medium_Columns(Pop_Range_20_64_Start:Pop_Range_20_64_End,4));
        Median_Contacts(4,4) = median(Medium_Columns(Pop_Range_65_Over_Start:Pop_Range_65_Over_End,4));
        
        Median_Contacts = Median_Contacts/7; %Divide the whole matrix by 7 (7 days of the week)
        
        MinPerc_Contacts(1,1) = prctile(Medium_Columns(Pop_Range_0_4_Start:Pop_Range_0_4_End,1),2.5);
        MinPerc_Contacts(2,1) = prctile(Medium_Columns(Pop_Range_5_19_Start:Pop_Range_5_19_End,1),2.5);
        MinPerc_Contacts(3,1) = prctile(Medium_Columns(Pop_Range_20_64_Start:Pop_Range_20_64_End,1),2.5);
        MinPerc_Contacts(4,1) = prctile(Medium_Columns(Pop_Range_65_Over_Start:Pop_Range_65_Over_End,1),2.5);
        MinPerc_Contacts(1,2) = prctile(Medium_Columns(Pop_Range_0_4_Start:Pop_Range_0_4_End,2),2.5);
        MinPerc_Contacts(2,2) = prctile(Medium_Columns(Pop_Range_5_19_Start:Pop_Range_5_19_End,2),2.5);
        MinPerc_Contacts(3,2) = prctile(Medium_Columns(Pop_Range_20_64_Start:Pop_Range_20_64_End,2),2.5);
        MinPerc_Contacts(4,2) = prctile(Medium_Columns(Pop_Range_65_Over_Start:Pop_Range_65_Over_End,2),2.5);
        MinPerc_Contacts(1,3) = prctile(Medium_Columns(Pop_Range_0_4_Start:Pop_Range_0_4_End,3),2.5);
        MinPerc_Contacts(2,3) = prctile(Medium_Columns(Pop_Range_5_19_Start:Pop_Range_5_19_End,3),2.5);
        MinPerc_Contacts(3,3) = prctile(Medium_Columns(Pop_Range_20_64_Start:Pop_Range_20_64_End,3),2.5);
        MinPerc_Contacts(4,3) = prctile(Medium_Columns(Pop_Range_65_Over_Start:Pop_Range_65_Over_End,3),2.5);
        MinPerc_Contacts(1,4) = prctile(Medium_Columns(Pop_Range_0_4_Start:Pop_Range_0_4_End,4),2.5);
        MinPerc_Contacts(2,4) = prctile(Medium_Columns(Pop_Range_5_19_Start:Pop_Range_5_19_End,4),2.5);
        MinPerc_Contacts(3,4) = prctile(Medium_Columns(Pop_Range_20_64_Start:Pop_Range_20_64_End,4),2.5);
        MinPerc_Contacts(4,4) = prctile(Medium_Columns(Pop_Range_65_Over_Start:Pop_Range_65_Over_End,4),2.5);
        
        MinPerc_Contacts = MinPerc_Contacts/7; %Divide the whole matrix by 7 (7 days of the week)
        
        MaxPerc_Contacts(1,1) = prctile(Medium_Columns(Pop_Range_0_4_Start:Pop_Range_0_4_End,1),97.5);
        MaxPerc_Contacts(2,1) = prctile(Medium_Columns(Pop_Range_5_19_Start:Pop_Range_5_19_End,1),97.5);
        MaxPerc_Contacts(3,1) = prctile(Medium_Columns(Pop_Range_20_64_Start:Pop_Range_20_64_End,1),97.5);
        MaxPerc_Contacts(4,1) = prctile(Medium_Columns(Pop_Range_65_Over_Start:Pop_Range_65_Over_End,1),97.5);
        MaxPerc_Contacts(1,2) = prctile(Medium_Columns(Pop_Range_0_4_Start:Pop_Range_0_4_End,2),97.5);
        MaxPerc_Contacts(2,2) = prctile(Medium_Columns(Pop_Range_5_19_Start:Pop_Range_5_19_End,2),97.5);
        MaxPerc_Contacts(3,2) = prctile(Medium_Columns(Pop_Range_20_64_Start:Pop_Range_20_64_End,2),97.5);
        MaxPerc_Contacts(4,2) = prctile(Medium_Columns(Pop_Range_65_Over_Start:Pop_Range_65_Over_End,2),97.5);
        MaxPerc_Contacts(1,3) = prctile(Medium_Columns(Pop_Range_0_4_Start:Pop_Range_0_4_End,3),97.5);
        MaxPerc_Contacts(2,3) = prctile(Medium_Columns(Pop_Range_5_19_Start:Pop_Range_5_19_End,3),97.5);
        MaxPerc_Contacts(3,3) = prctile(Medium_Columns(Pop_Range_20_64_Start:Pop_Range_20_64_End,3),97.5);
        MaxPerc_Contacts(4,3) = prctile(Medium_Columns(Pop_Range_65_Over_Start:Pop_Range_65_Over_End,3),97.5);
        MaxPerc_Contacts(1,4) = prctile(Medium_Columns(Pop_Range_0_4_Start:Pop_Range_0_4_End,4),97.5);
        MaxPerc_Contacts(2,4) = prctile(Medium_Columns(Pop_Range_5_19_Start:Pop_Range_5_19_End,4),97.5);
        MaxPerc_Contacts(3,4) = prctile(Medium_Columns(Pop_Range_20_64_Start:Pop_Range_20_64_End,4),97.5);
        MaxPerc_Contacts(4,4) = prctile(Medium_Columns(Pop_Range_65_Over_Start:Pop_Range_65_Over_End,4),97.5);
        
        MaxPerc_Contacts = MaxPerc_Contacts/7; %Divide the whole matrix by 7 (7 days of the week)
        
        % Calculate the dominant Eigenvalue for the array, which is R0:
        Mean_System_R0 = max(eig(Total_Contacts));
        Median_System_R0 = max(eig(Median_Contacts));
        Min_Perctile_System_R0 = max(eig(MinPerc_Contacts));
        Max_Perctile_System_R0 = max(eig(MaxPerc_Contacts));
        
        fprintf('%s\t %8.0f\t %s\t %8.5f\t %s\t %8.5f\t%s\t %8.5f\t%s\t %8.5f\t\n','Sydney_Phase:',Phase_Count,'Mean System R0:',Mean_System_R0,'Median System R0:',Median_System_R0,'2.5th Perctile System_R0:',Min_Perctile_System_R0,'97.5th Perctile System R0:',Max_Perctile_System_R0);
       
       % Create an output table which contains WAIFU matrix for medians:
        
                CNTR = 0;
                        for bb = 1:4
                            
                            CNTR = CNTR + 1;
                                if bb == 1, Table_Prep1{CNTR,1} = 'Contacts_0_4_Years'; end
                                if bb == 2, Table_Prep1{CNTR,1} = 'Contacts_5_19_Years'; end
                                if bb == 3, Table_Prep1{CNTR,1} = 'Contacts_20_64_Years'; end
                                if bb == 4, Table_Prep1{CNTR,1} = 'Contacts_65_Years_and_Over'; end
                            Table_Prep1{CNTR,2} = Median_Contacts(bb,1);
                            Table_Prep1{CNTR,3} = Median_Contacts(bb,2);
                            Table_Prep1{CNTR,4} = Median_Contacts(bb,3);
                            Table_Prep1{CNTR,5} = Median_Contacts(bb,4);
                        end
               
                Matrix_T = table;
                
                        
                        Matrix_T.Contacts_x_TP = Table_Prep1(:,1);
                        Matrix_T.Contacts_0_4_Years_x_TP = Table_Prep1(:,2);
                        Matrix_T.Contacts_5_19_Years_x_TP = Table_Prep1(:,3);
                        Matrix_T.Contacts_20_64_Years_x_TP = Table_Prep1(:,4);
                        Matrix_T.Contacts_65_Years_and_Over_x_TP = Table_Prep1(:,5);
                        
                        
                     
             Context_Designator = 'Sydney_';
             %Epi_File_Name = strcat('DESSABNeT_',Context_Designator,string(Population),'_',string(Phase_Count),'_Total_Contacts_4x4.xlsx');
             Epi_File_Name = strcat('DESSABNeT_',Context_Designator,string(Population),'_',string(Beta_C_Factor),'_',string(Phase_Count),'_Total_Contacts_4x4.xlsx');
             writetable(Matrix_T,Epi_File_Name); %,'Delimiter','\t','WriteRowNames',true);
             
             
 end 

                                       