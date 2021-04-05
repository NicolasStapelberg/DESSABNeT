
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

     %% Social Restriction Parameters Module:
     
        % These values are for one Restriction Phase. The values entered here affect the weekly schedules of agents:

        
        % Discretionary Time:
        Perc_Leisure_Activity = 0; % Large Group Exposure
        Perc_Social_Activity = 23; % Medium Group Exposure
        Perc_Home_Activity = 77; % Solitary Home Activity
        
        % Essential Activities:
        Essential_Visits_per_Week = 3; % Number of visits for essential activities (medical, pharmacy, food shopping)
        
        % Social Activities:
        Friend_Contacts_per_Week = 3; % Number of friend and kin visits per week (these occur in the evenings and are separate from Discretionary Time activites above)
        
        % Work:
        Work_From_Home = 47.1; %Percentage of agents working from home, for those agents who are employed
        
        % Public Transport:
        Public_Transport = 14.1; % Percentage of the population that use public transport
        Other_Transport = 100-Public_Transport;
        
        % Schools:
        School_Open = 1; %1 = Schools are Open, 6 = Schools are shut.
        
