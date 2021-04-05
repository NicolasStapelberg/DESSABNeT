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

        
        %% Variables for Random Contact in Groups:

                Small_Group_Exposure = 20; 
                Small_Group_Array = zeros(Small_Group_Exposure,3); 
                Medium_Group_Exposure = 100; 
                Medium_Group_Array = zeros(Medium_Group_Exposure,3);
                Large_Group_Exposure = 500; 
                Large_Group_Array = zeros(Large_Group_Exposure,3);

        %% Allocate Exposure Groups All Adults
                
                [Person_Profile_Rows,~] = size(Person_Profile); 
                S_G_No = round(Person_Profile_Rows/Small_Group_Exposure,0);
                for CounterY = 1:Person_Profile_Rows  
                    S_Group = randi(S_G_No);   
                    Person_Profile(CounterY,33)=S_Group;    
                end

                M_G_No = round(Person_Profile_Rows/Medium_Group_Exposure,0);
                for CounterY = 1:Person_Profile_Rows  
                    M_Group = randi(M_G_No);   
                    Person_Profile(CounterY,34)=M_Group;    
                end

                L_G_No = round(Person_Profile_Rows/Large_Group_Exposure,0);
                for CounterY = 1:Person_Profile_Rows  
                    L_Group = randi(L_G_No);   
                    Person_Profile(CounterY,35)=L_Group;    
                end
                