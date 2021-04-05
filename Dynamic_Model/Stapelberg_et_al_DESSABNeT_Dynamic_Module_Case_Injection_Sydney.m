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
    
    
%% Overseas Traveller "Case Injection" Module:
            
            % Here known overseas positive cases are "injected" into the population
            
            
                if Spreadsheet_Numbers(Day_Count,5) > 0 %Column 5 has the returned travellers
                    for TT = 1:Spreadsheet_Numbers(Day_Count,5)
                        Chosen=randi(Population-Adult_Carriers-1);
                        if Person_Profile(Chosen+Adult_Carriers,43)==2
                            Person_Profile(Chosen+Adult_Carriers,43)=1; %If the person was asymptomatic they become symptomatic
                        end
                        Person_Profile(Chosen+Adult_Carriers,9)=3; %Agents are allocated to I because they are known to be infected when they enter Australia.
                        Person_Profile(Chosen+Adult_Carriers,10) = 1;
                        Person_Profile(Chosen+Adult_Carriers,39) = 1;
                        if Day_Count == 17, Context_No = 2; end
                        if Day_Count > 16 % (Sydney After day 16 overseas travellers must isolate, so agents go into quarantine)
                            
                                Person_Profile(Chosen+Adult_Carriers,49) = 1;  % Quarantine
                                
                            
                        end
                        
                    end
                end
                
               