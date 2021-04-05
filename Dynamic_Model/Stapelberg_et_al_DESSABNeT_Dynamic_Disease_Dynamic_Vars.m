       

%% DESSABNeT Dynamic Model. Copyright (C) Nicolas J. C. Stapelberg 2020, 2021, All Rights Reserved 

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

    %% Set Up Disease Dynamic Variables Which Are Pre-Allocated:   
        
        
        %% Covid19 Variables: 
       
        Perc_Adult_Symptomatic_Cases = 85; 
        Perc_Child_Symptomatic_Cases = 85; 
        Perc_Asymptomatic_Transmission = 30; % The probability of transmission for asymptomatic/presymptomatic agents was set as 0.3 of that of symptomatic individuals = 30%
      
        Super_Spreader_Cutoff = 1; % Superspreader variables not used in this version.
        Super_Spreader_Mean = 0.3; % Superspreader variables not used in this version.
         

         for Variable_Counter = 1:Population
                

            %% Disease Dynamics: Symptomatic and Asymptomatic Cases

                
                    if Person_Profile(Variable_Counter,2) < 3 % Young children and children: Who will be a symptomatic or asymptomatic case?
                        Person_Profile(Variable_Counter,43) = sum(rand >= cumsum([0,Perc_Child_Symptomatic_Cases/100,(100-Perc_Child_Symptomatic_Cases)/100]));
                    end
                    if Person_Profile(Variable_Counter,2) > 2 % Adults: Who will be a symptomatic or asymptomatic case?
                        Person_Profile(Variable_Counter,43) = sum(rand >= cumsum([0,Perc_Adult_Symptomatic_Cases/100,(100-Perc_Adult_Symptomatic_Cases)/100]));
                    end                                
                   
              
                %% This is a section where we can calculate Superspreader Status. (Not currently used)

                % Preallocate a personal Scaling factor to each person = Transmission_Potency_Factor !!!
                %Assign superspreader variable to all people. Mostly this will be = 1, but can be as high as Super_Spreader_Cutoff
                
                Person_Profile(Variable_Counter,44) = 1;
                
                
                 % Pre-allocate column 45, days to when agents seek medical attention.
                
              
                Person_Profile(Variable_Counter,45) = normrnd(log(4.6),log(1.3));
                Person_Profile(Variable_Counter,45) = round(exp(Person_Profile(Variable_Counter,45)),0); 
               
                
         end
         % Calculate Mean Infective Period  
         
         Mean_Infective_Period = (sum(Person_Profile(:,41))+sum(Person_Profile(:,45)))/Population; 
         
         
                