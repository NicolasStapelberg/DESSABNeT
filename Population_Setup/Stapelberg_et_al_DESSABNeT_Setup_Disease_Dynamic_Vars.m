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


    %% Set Up Disease Dynamic Variables Which are Pre-Allocated:  
        
        
        %% Covid19 Variables: 
       
        Infection_to_Contagious_Days_M = 2; 
        Infection_to_Contagious_Days_SD = 0;
        Transmission_Days_M = 7.5; 
        Transmission_Days_SD = 3.75;
        
        Perc_Adult_Symptomatic_Cases = 85;
        Perc_Child_Symptomatic_Cases = 85;
        Perc_Asymptomatic_Transmission = 30; % The probability of transmission for asymptomatic/presymptomatic agents was set as 0.3 of that of symptomatic individuals = 30%
      
        Super_Spreader_Cutoff = 3.5; % Currently not used
        Super_Spreader_Mean = 0.3; % Currently not used 
         

         for Variable_Counter = 1:Population
                %Assign E1, E2 and I days to each Agent
                %Calculate the lognormal random distribution for E1. The actual mean = 5, SD = 3 (we take the log of these)
                
                Person_Profile(Variable_Counter,40) = normrnd(1.609,1.0986);
                if Person_Profile(Variable_Counter,40) > 2.639, Person_Profile(Variable_Counter,41) = rand * 2.639; end
                Person_Profile(Variable_Counter,40) = round(exp(Person_Profile(Variable_Counter,40)),0);
                if Person_Profile(Variable_Counter,40) < 1 
                    Person_Profile(Variable_Counter,40) = round(rand*13,0)+1;
                end
                
                %Assign E2:
                if Person_Profile(Variable_Counter,40) > 2
                    Person_Profile(Variable_Counter,41) = 2;
                    Person_Profile(Variable_Counter,40) = Person_Profile(Variable_Counter,40)-2;
                else
                    Person_Profile(Variable_Counter,41) = 1;
                end
                %Assign I: 
                Person_Profile(Variable_Counter,42) = normrnd(1.609,1.0986);
                if Person_Profile(Variable_Counter,42) > 2.3026, Person_Profile(Variable_Counter,42) = rand * 2.3026; end
                Person_Profile(Variable_Counter,42) = round(exp(Person_Profile(Variable_Counter,42)),0);
                if Person_Profile(Variable_Counter,42) < 1 
                    Person_Profile(Variable_Counter,42) = round(rand*9,0)+1;
                end
                
                
    

            %% Disease Dynamics: Symptomatic and Asymptomatic Cases

                % Have a column which records the people infected by each personID. 

                    if Person_Profile(Variable_Counter,2) < 3 % Young children and children: Who will be a symptomatic or asymptomatic case?
                        Person_Profile(Variable_Counter,43) = sum(rand >= cumsum([0,Perc_Child_Symptomatic_Cases/100,(100-Perc_Child_Symptomatic_Cases)/100]));
                    end
                    if Person_Profile(Variable_Counter,2) > 2 % Adults: Who will be a symptomatic or asymptomatic case?
                        Person_Profile(Variable_Counter,43) = sum(rand >= cumsum([0,Perc_Adult_Symptomatic_Cases/100,(100-Perc_Adult_Symptomatic_Cases)/100]));
                    end                                
                   
              
                %% This is a section where we calculate Superspreader Status

                % (This code not currently used)
                %Assign superspreader variable to all people. Mostly this will be = 1, but can be as high as Super_Spreader_Cutoff
                Super_Spreader = lognrnd(Super_Spreader_Mean,1);
                if Super_Spreader < 1, Super_Spreader = rand * Super_Spreader_Cutoff; end
                if Super_Spreader > Super_Spreader_Cutoff, Super_Spreader = rand * Super_Spreader_Cutoff; end
                Person_Profile(Variable_Counter,44) = Super_Spreader;
                
                % Pre-allocate column 45, days to when agents seek medical attention.
                
                
                Person_Profile(Variable_Counter,45) = normrnd(log(5),log(1.3));
                Person_Profile(Variable_Counter,45) = round(exp(Person_Profile(Variable_Counter,45)),0); 
                Person_Profile(Variable_Counter,48) = Person_Profile(Variable_Counter,45); 
         end
           

                