
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


%% Demographic Variables (Most Variables are in Percentages)

%% City or Region: Sydney

        % Population Size
        
        % It is recommended that a smaller population size be trialled
        % first, as the full population of a large city can take many hours
        % to set up.
        
        Population = 10000; %5312000 is the Sydney Population size used.
        
        % Age Composition:
        
        Perc_Under_5 = 6.4;
        Perc_School_5_19 = 18.2;
        Perc_Adult_20_64 = 61.4;
        Perc_Over_65 = 13.9;
        Perc_20_49 = 44.3;
        
        % Family and Household Size
        
        Children_Per_Family = 1.8;
        
        Families_with_Children = round((Perc_Under_5+Perc_School_5_19)/100*Population/Children_Per_Family,0);
        
        Household_Size_1_Person = 21.6; 
        Household_Size_2_Person = 29.9; 
        Household_Size_3_Person = 17.6;
        Household_Size_4_Person = 18.1;
        Household_Size_5_Person = 8;
        Household_Size_6_Person = 4.8;
        
        % Employment, Education and Working Groups

        Fulltime_Work = 61.2; % For people aged 15 and over - this will be modified here to people over 20
        Parttime_Work = 30.9;
        Unemployed = 100 - (Fulltime_Work+Parttime_Work); % 5.9;

        Retired = 76.7; % https://www.aihw.gov.au/reports/older-people/older-australia-at-a-glance/contents/social-and-economic-engagement/employment-and-economic-participation
        Aged_Parttime_Work = (100-Retired)*Parttime_Work/100;
        Aged_Fulltime_Work = (100-Retired)*Fulltime_Work/100;

        % Public Transport Use:
        
        Public_Transport = 22.9; 
        Other_Transport = 100-Public_Transport;
     


        
        