
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
        
    %% Build a Simulated Population: Friendship and Kin Groups    
        
              % Active ties are created for each person, e.g. kin and friends, where there is weekly 
              % social face to face contact. This is apart from work colleagues with daily workday contact, 
              % and family living in the same dwelling.
              % Children are not given social contacts as school friends are likely contacts, but this contact is only counted once per day.

                    % Friends and Kin Variables:
        
                    Friends_and_Kin_Group_Size_M = 20; 
                    Friends_and_Kin_Group_Size_SD = 2;
                    Friends_and_Kin_Visit_Size_M = 3;
                    Friends_and_Kin_Visit_Size_SD = 1;

           Person_Friend_Profile = Person_Profile(Person_Profile(:,2)>2,1); % Create a new array which only contains ID for adults
           Person_Friend_No = numel(Person_Friend_Profile(:,1)); %How many rows in this array? 
           Person_Friend_Profile = Person_Friend_Profile(randperm(Person_Friend_No),:); %Randomly shuffle Person_Friend_Profile using randperm
 
            Friendgroups = 0;
            
            
            for Big_Counter = 1:Person_Friend_No %Count through the Friend population
                
                    if Person_Profile(Person_Friend_Profile(Big_Counter,1),6)==0 %This person might already belong to a Friendgroup because of Friend_Mates loop, so check first
                        Friendgroups = Friendgroups + 1; %Here we start a new Friend group

                        Person_Profile(Person_Friend_Profile(Big_Counter,1),6)= Friendgroups; %Assign the current agent to a Friend group
                        
                        This_Friend_Group_Size = abs(round(normrnd(Friends_and_Kin_Group_Size_M,Friends_and_Kin_Group_Size_SD),0));
                        
                        Social_Network_Matrix(Big_Counter,3)=This_Friend_Group_Size; %This will show the group size for each agent, allowing a histogram to be produced
                       

                        if This_Friend_Group_Size > 1    
                            for Friends_Kin = 1:This_Friend_Group_Size-1 %Step through loop to allocate other agents to this group

                                if Big_Counter+Friends_Kin <= Person_Friend_No
                                    if Person_Profile(Person_Friend_Profile(Big_Counter+Friends_Kin,1),6)==0 %If the new agent not yet allocated

                                        Person_Profile(Person_Friend_Profile(Big_Counter+Friends_Kin,1),6)= Friendgroups; %Assign the current agent to a class
                                        Social_Network_Matrix(Big_Counter+Friends_Kin,3)=This_Friend_Group_Size; %This will show the Friendgroup size for each agent, allowing a histogram to be produced
                                        
                                    end  
                                end
                            end

                        end
                    end
               
            end
            
            
            
