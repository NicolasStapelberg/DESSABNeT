
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



     
        
%% Index Person_Profile into relevant groups for work and education:

                fprintf('%s\t','2) Initial Pre-Indexing of Population Groups...');
                fprintf('\n');
                
                

                Adult_Group = Person_Profile(Person_Profile(:,3)>2,:); % Index groups 
                [Adult_Group_Rows,~] = size(Adult_Group); %How many rows and columns?
                First_Half_Adult = sort(randperm(Adult_Group_Rows,round(Adult_Group_Rows/2,0)));

                School_Group = Person_Profile(Person_Profile(:,3)==1 | Person_Profile(:,3)==2,:); % Index groups 
                [School_Group_Rows,~] = size(School_Group); %How many rows and columns?

                Full_Time_Group = Person_Profile(Person_Profile(:,3)==4,:); % Index groups 
                [Full_Time_Group_Rows,~] = size(Full_Time_Group); %How many rows and columns?
                % Full time workers will work either Monday - Friday, or Wednesday to Sunday, split 50%/50%
                First_Half_FT = sort(randperm(Full_Time_Group_Rows,round(Full_Time_Group_Rows/2,0)));

                Part_Time_Group = Person_Profile(Person_Profile(:,3)==3,:); % Index groups 
                [Part_Time_Group_Rows,~] = size(Part_Time_Group); %How many rows and columns?
