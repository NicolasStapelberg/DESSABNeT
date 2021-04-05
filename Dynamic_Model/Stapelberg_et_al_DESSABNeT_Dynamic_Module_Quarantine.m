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

%% Quarantine and Isolation Module


    
    for CounterQ = 1:Population
        
        
          if Person_Profile(CounterQ,49)==1 % Person is in isolation/quarantine
              
              % Counter:
              Person_Profile(CounterQ,50) = Person_Profile(CounterQ,50) + 1; % Keep counting
              if Person_Profile(CounterQ,50) == 14
                  Person_Profile(CounterQ,49) = 0; %Come out of Quarantine
                  Person_Profile(CounterQ,50) = 0;
              end
              
               % Calculate Incident Values when people are on their first day of quarantine:
              if Person_Profile(CounterQ,50) == 1 
                  
                  Daily_People_in_Quarantine = Daily_People_in_Quarantine + 1; 
                  
                  if Person_Profile(CounterQ,39) ~= 1,Daily_M_Number = Daily_M_Number + 1; end %Only count the person towards Daily M if they are not a Returning Traveller

              end
          end
    end
