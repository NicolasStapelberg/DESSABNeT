
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

        
    
        % -	This model will use a simulation of population movement, using actual 
        %    demographic data to make assumptions about the daily movements of people based on demographic factors such as household size or employment statistics.
        % -	The model of transmission is a modified SIERD+M model, establishing numeric relationships between 
        %   susceptible (S), exposed (E), infected (I), recovered (R) and Managed (M) cohorts in the population. 
        
        % -	Contact between people is simulated for the entire population, for every day in a series of days. 
        %   Each contact will carry a probability of infection calculated based on variables pertinent to transmission, 
        %   taking into account the status/ Container of involved persons
        
        clearvars

        fprintf('%s\t','DESSABNeT Population Setup. Copyright Chris Stapelberg 2020, All Rights Reserved');
        fprintf('\n');
        
        
        %% Load Demographic Data:
        
           
            Stapelberg_et_al_DESSABNeT_Setup_Demographic_Data_Sydney
            
            Person_Profile = zeros(Population,50);
            Person_Profile_11_31 = zeros(Population,21);
            Social_Network_Matrix = zeros(Population,3); % For Histograms: Column1 = family numbers, Column2 = Workgroup/Class Size numbers, Column 3 = Social/Kin numbers

        

        %% Build a Simulated Population:
        
            Stapelberg_et_al_DESSABNeT_Setup_ID_Age_Workforce
            Stapelberg_et_al_DESSABNeT_Setup_Family_ID
            Stapelberg_et_al_DESSABNeT_Setup_School_Work_ID
            Stapelberg_et_al_DESSABNeT_Setup_Friends_Kin_ID
            Stapelberg_et_al_DESSABNeT_Setup_Job_Type
            Stapelberg_et_al_DESSABNeT_Population_Indexing
            
         %% Set up Fixed Disease Dynamic Variables:
         
            Stapelberg_et_al_DESSABNeT_Setup_Exposure_Groups
            Stapelberg_et_al_DESSABNeT_Setup_Disease_Dynamic_Vars

                 % First save a global file:
                 File_Name = strcat('2021_DESSABNeT_Population_Setup_Global_',string(Population),'_v7_3.mat');
                 save (File_Name, '-v7.3')
            
                 
             %% Load Social Restriction Data for Phase1:
                %load('DESSABNeT_Population_Setup_Global_5312000_v7_3.mat')
               
                Stapelberg_et_al_DESSABNeT_Setup_Social_Restr_Ph1_Syd
                Context_Variable = 'Phase1';   

             %% Set up Dependent Columns and Weekly Schedules for All Agents: (Takes into Account Social Restrictions)

                Stapelberg_et_al_DESSABNeT_Setup_Public_Transport
                Stapelberg_et_al_DESSABNeT_Setup_Weekly_Schedules
                figure,histogram(Person_Profile(:,11:31))


             %% Save Population Variables

             
                
                
                 fprintf('%s','5) Saving Workspace Variables to File for ');
                 fprintf('%s\t',Context_Variable);
                 fprintf('\n');
                 fprintf('\n');
                 
                 
                 
                 %Save Context File
                 File_Name = strcat('2021_DESSABNeT_Population_Indexed_Variables_',Context_Variable,'_',string(Population),'_v7_3.mat');
                 save (File_Name, 'No_Subgroups_Work','Subgroup_N_Work_Rows','Subgroup_N_Work','No_Subgroups_Social','Subgroup_N_Social_Rows','Subgroup_N_Social','No_Subgroups_PublicT','Subgroup_N_PublicT_Rows','Subgroup_N_PublicT','No_Subgroups_Essential','Subgroup_N_Essential_Rows','Subgroup_N_Essential','No_Subgroups_Leisure','Subgroup_N_Leisure_Rows','Subgroup_N_Leisure','No_Subgroups_Friends','Subgroup_N_Friends_Rows','Subgroup_N_Friends','No_Subgroups_Family','Subgroup_N_Family_Rows','Subgroup_N_Family', '-v7.3')

                 File_Name = strcat('2021_DESSABNeT_Person_Profile_',Context_Variable,'_',string(Population),'_v7_3.mat');
                 save (File_Name,'Person_Profile','-v7.3')

                 
             %% Load Social Restriction Data for Phase3:
               
                Stapelberg_et_al_DESSABNeT_Setup_Social_Restr_Ph3_Syd
                Context_Variable = 'Phase3';   

             %% Set up Dependent Columns and Weekly Schedules for All Agents: (Takes into Account Social Restrictions)
                Person_Profile(:,8)=0; % Zero Public Transport Column
                Person_Profile(:,11:31)=0; % Zero Weekly Schedule
                Stapelberg_et_al_DESSABNeT_Setup_Public_Transport
                Stapelberg_et_al_DESSABNeT_Setup_Weekly_Schedules
                figure,histogram(Person_Profile(:,11:31)) % PLOT FOR CHILDREN AND ADULTS!
                

             %% Save Population Variables

                 fprintf('%s','5) Saving Workspace Variables to File for ');
                 fprintf('%s\t',Context_Variable);
                 fprintf('\n');
                 fprintf('\n');
                 
                 %Save Context File
                 File_Name = strcat('2021_DESSABNeT_Population_Indexed_Variables_',Context_Variable,'_',string(Population),'_v7_3.mat');
                 save (File_Name, 'No_Subgroups_Work','Subgroup_N_Work_Rows','Subgroup_N_Work','No_Subgroups_Social','Subgroup_N_Social_Rows','Subgroup_N_Social','No_Subgroups_PublicT','Subgroup_N_PublicT_Rows','Subgroup_N_PublicT','No_Subgroups_Essential','Subgroup_N_Essential_Rows','Subgroup_N_Essential','No_Subgroups_Leisure','Subgroup_N_Leisure_Rows','Subgroup_N_Leisure','No_Subgroups_Friends','Subgroup_N_Friends_Rows','Subgroup_N_Friends','No_Subgroups_Family','Subgroup_N_Family_Rows','Subgroup_N_Family', '-v7.3')


                 File_Name = strcat('2021_DESSABNeT_Person_Profile_',Context_Variable,'_',string(Population),'_v7_3.mat');
                 save (File_Name,'Person_Profile','-v7.3')

                 
                 
              
             %% Load Social Restriction Data for Phase4:
                
                Stapelberg_et_al_DESSABNeT_Setup_Social_Restr_Ph4_Syd
                Context_Variable = 'Phase4';   

             %% Set up Dependent Columns and Weekly Schedules for All Agents: (Takes into Account Social Restrictions)
                Person_Profile(:,8)=0; % Zero Public Transport Column
                Person_Profile(:,11:31)=0; % Zero Weekly Schedule
                Stapelberg_et_al_DESSABNeT_Setup_Public_Transport
                Stapelberg_et_al_DESSABNeT_Setup_Weekly_Schedules
                figure,histogram(Person_Profile(:,11:31)) % PLOT FOR CHILDREN AND ADULTS!
                

             %% Save Population Variables

                 fprintf('%s','5) Saving Workspace Variables to File for ');
                 fprintf('%s\t',Context_Variable);
                 fprintf('\n');
                 fprintf('\n');
                 
                 %Save Context File
                 File_Name = strcat('2021_DESSABNeT_Population_Indexed_Variables_',Context_Variable,'_',string(Population),'_v7_3.mat');
                 save (File_Name, 'No_Subgroups_Work','Subgroup_N_Work_Rows','Subgroup_N_Work','No_Subgroups_Social','Subgroup_N_Social_Rows','Subgroup_N_Social','No_Subgroups_PublicT','Subgroup_N_PublicT_Rows','Subgroup_N_PublicT','No_Subgroups_Essential','Subgroup_N_Essential_Rows','Subgroup_N_Essential','No_Subgroups_Leisure','Subgroup_N_Leisure_Rows','Subgroup_N_Leisure','No_Subgroups_Friends','Subgroup_N_Friends_Rows','Subgroup_N_Friends','No_Subgroups_Family','Subgroup_N_Family_Rows','Subgroup_N_Family', '-v7.3')

                 File_Name = strcat('2021_DESSABNeT_Person_Profile_',Context_Variable,'_',string(Population),'_v7_3.mat');
                 save (File_Name,'Person_Profile','-v7.3')
           