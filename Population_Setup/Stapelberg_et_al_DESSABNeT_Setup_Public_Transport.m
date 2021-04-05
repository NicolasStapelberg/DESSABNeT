
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
        
     %% Build a Simulated Population: Public Transport
     
             % Work out who uses public transport:
                for Counter4 = 1:Population 
                    if Person_Profile(Counter4,2) == 1,Person_Profile(Counter4,8)=1; end 
                    if Person_Profile(Counter4,2) == 2,Person_Profile(Counter4,8)=1; end 
                    if Person_Profile(Counter4,2) > 2
                        if Person_Profile(Counter4,8) == 0 
                              Person_Profile(Counter4,8) = sum(rand >= cumsum([0,Other_Transport/100, Public_Transport/100])); 
                              
                        end
                    end
                end

