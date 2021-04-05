
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
        
     %% Build a Simulated Population: Family Structures
     
 
            % This module allocates agents to nuclear families and dwellings.
            

           Family_Adults=0;
           Family_Children=0;
           Person_1_Households = 0;
           Person_2_Households = 0;
           Person_3_Households = 0;
           Person_4_Households = 0;
           Person_5_Households = 0;
           Person_6_Households = 0;
           
           No_People_in_Houshold_1_Actual = 0;
           No_People_in_Houshold_2_Actual = 0;
           No_People_in_Houshold_3_Actual = 0;
           No_People_in_Houshold_4_Actual = 0;
           No_People_in_Houshold_5_Actual = 0;
           No_People_in_Houshold_6_Actual = 0;
            
           
           % Calculate how many people in the various households and sum these. This will exceed the population, so a correction 
           % is applied to get the actual N of people in each dwelling. This number is not rounded for greater accuracy.
           People_Expected_Houshold_1 = (Household_Size_1_Person/100*1*Population);
           People_Expected_Houshold_2 = (Household_Size_2_Person/100*2*Population);
           People_Expected_Houshold_3 = (Household_Size_3_Person/100*3*Population);
           People_Expected_Houshold_4 = (Household_Size_4_Person/100*4*Population);
           People_Expected_Houshold_5 = (Household_Size_5_Person/100*5*Population);
           People_Expected_Houshold_6 = (Household_Size_6_Person/100*6*Population);

           Total_People_Expected_Household = People_Expected_Houshold_1+People_Expected_Houshold_2+People_Expected_Houshold_3+People_Expected_Houshold_4+People_Expected_Houshold_5+People_Expected_Houshold_6;

           People_Expected_Houshold_1_Corr = round(People_Expected_Houshold_1/Total_People_Expected_Household*Population,0);
           People_Expected_Houshold_2_Corr = round(People_Expected_Houshold_2/Total_People_Expected_Household*Population,0);
           People_Expected_Houshold_3_Corr = round(People_Expected_Houshold_3/Total_People_Expected_Household*Population,0);
           People_Expected_Houshold_4_Corr = round(People_Expected_Houshold_4/Total_People_Expected_Household*Population,0);
           People_Expected_Houshold_5_Corr = round(People_Expected_Houshold_5/Total_People_Expected_Household*Population,0);
           People_Expected_Houshold_6_Corr = round(People_Expected_Houshold_6/Total_People_Expected_Household*Population,0);
           
           Actual_Households_1P = round(People_Expected_Houshold_1_Corr/1,0);
           Actual_Households_2P = round(People_Expected_Houshold_2_Corr/2,0);
           Actual_Households_3P = round(People_Expected_Houshold_3_Corr/3,0);
           Actual_Households_4P = round(People_Expected_Houshold_4_Corr/4,0);
           Actual_Households_5P = round(People_Expected_Houshold_5_Corr/5,0);
           Actual_Households_6P = round(People_Expected_Houshold_6_Corr/6,0);
           
           Household_3_to_6 = People_Expected_Houshold_3_Corr+People_Expected_Houshold_4_Corr+People_Expected_Houshold_5_Corr+People_Expected_Houshold_6_Corr;
           
           Kids = round((Perc_Under_5+Perc_School_5_19)/100*Population,0); 
           
           
           Person_Family_Profile = Person_Profile(Person_Profile(:,2)>2,1); % Create a new array which only contains ID for adults
           Person_Family_No = numel(Person_Family_Profile(:,1)); %How many rows in this array? 
           Person_Family_Profile = Person_Family_Profile(randperm(Person_Family_No),:); %Randomly shuffle Person_Family_Profile using randperm
            
           
           for Fam_Counter = 1:Families_with_Children % This will be the number of families with children
               % Fam_Counter will become the "Family ID" for families of 2 adults and 1.8 children per family on average
               % Family structures are more complicated, this is a simplification for the simulation
               Family_Children=Family_Children+1;
               Family_Adults=Family_Adults+1;
               Person_Profile(Fam_Counter,4)=Fam_Counter; 
               % Now we add a second child into some families
               No_of_Kids = 1;
               if Families_with_Children < Kids
                    if Fam_Counter < Kids-Families_with_Children
                        Person_Profile(Fam_Counter+Families_with_Children,4)=Fam_Counter;
                        No_of_Kids = 2;
                    end
               end
               % Add adults to each family
               % We do the allocation of families with varying numbers of people as per census statistics as this is the most accurate.
               
               
               %Select randomly how many people this family will have:
               Household_Sum = sum(rand >= cumsum([0, People_Expected_Houshold_3_Corr/Household_3_to_6,People_Expected_Houshold_4_Corr/Household_3_to_6,People_Expected_Houshold_5_Corr/Household_3_to_6,People_Expected_Houshold_6_Corr/Household_3_to_6]));
               

               %Now we progressively add adults to the family. Here there are 2 kids per family. So if the family size is 3, 
               %then 1 adult is added, if the family size is 6, then 4 adults are added
               
               
               
               if Household_Sum == 1 % 3 Family Members
                   if Person_3_Households < Actual_Households_3P
                       Person_3_Households = Person_3_Households + 1; % Count the families with 3 people in their household
                       No_People_in_Houshold_3_Actual = No_People_in_Houshold_3_Actual + 3;
                       
                       Person_Profile(Person_Family_Profile(Family_Adults,1),4)=Fam_Counter;
                       if No_of_Kids == 1
                           Family_Adults=Family_Adults+1;
                           
                           Person_Profile(Person_Family_Profile(Family_Adults,1),4)=Fam_Counter;
                       end
                   else
                       Household_Sum = 2; % If these family numbers are full, fill the next family number
                   end
               end
               if Household_Sum == 2 % 4 Family Members
                   if Person_4_Households < Actual_Households_4P
                       Person_4_Households = Person_4_Households + 1;
                       No_People_in_Houshold_4_Actual = No_People_in_Houshold_4_Actual + 4;
                       
                       Person_Profile(Person_Family_Profile(Family_Adults,1),4)=Fam_Counter;
                       Family_Adults=Family_Adults+1;
                       
                       Person_Profile(Person_Family_Profile(Family_Adults,1),4)=Fam_Counter;
                       if No_of_Kids == 1
                           Family_Adults=Family_Adults+1;
                           
                           Person_Profile(Person_Family_Profile(Family_Adults,1),4)=Fam_Counter;
                       end
                   else
                       Household_Sum = 3; % If these family numbers are full, fill the next family number
                   end
               end
               if Household_Sum == 3 % 5 Family Members
                   if Person_5_Households < Actual_Households_5P
                       Person_5_Households = Person_5_Households + 1;
                       No_People_in_Houshold_5_Actual = No_People_in_Houshold_5_Actual + 5;
                       
                       Person_Profile(Person_Family_Profile(Family_Adults,1),4)=Fam_Counter;
                       Family_Adults=Family_Adults+1;
                       
                       Person_Profile(Person_Family_Profile(Family_Adults,1),4)=Fam_Counter;
                       Family_Adults=Family_Adults+1;
                       
                       Person_Profile(Person_Family_Profile(Family_Adults,1),4)=Fam_Counter;
                       if No_of_Kids == 1
                           Family_Adults=Family_Adults+1;
                           
                           Person_Profile(Person_Family_Profile(Family_Adults,1),4)=Fam_Counter;
                       end
                   else
                       Household_Sum = 4; % If these family numbers are full, fill the next family number
                   end
               end
               if Household_Sum == 4 % 6 Family Members
                   if Person_6_Households < Actual_Households_6P
                       Person_6_Households = Person_6_Households + 1;
                       No_People_in_Houshold_6_Actual = No_People_in_Houshold_6_Actual + 6;
                       
                       Person_Profile(Person_Family_Profile(Family_Adults,1),4)=Fam_Counter;
                       Family_Adults=Family_Adults+1;
                       
                       Person_Profile(Person_Family_Profile(Family_Adults,1),4)=Fam_Counter;
                       Family_Adults=Family_Adults+1;
                       
                       Person_Profile(Person_Family_Profile(Family_Adults,1),4)=Fam_Counter;
                       Family_Adults=Family_Adults+1;
                       
                       Person_Profile(Person_Family_Profile(Family_Adults,1),4)=Fam_Counter;
                       if No_of_Kids == 1
                           Family_Adults=Family_Adults+1;
                           
                           Person_Profile(Person_Family_Profile(Family_Adults,1),4)=Fam_Counter;
                       end
                   end
               end
     
           end
           All_Familes = Families_with_Children; %This tracks the total families in the population
           
            
           %The remaining people are assigned as per the statistics of family size, from 6 down to 1.
           % First check how many people you already have in families of 6. If this number is at the correct demographic number/level, 
           % then move on the the next family size. If not, fill it up with adults.
           
           
           
           if Person_6_Households < Actual_Households_6P
               for Family_Cntr = (Person_6_Households+1):Actual_Households_6P %This counts up in families
                   Person_6_Households = Person_6_Households + 1; % Keep counting households with x people
                   All_Familes = All_Familes+1; % This provides a running count of family ID codes
                   for Fam_Cntr2 = 1:6
                        Family_Adults = Family_Adults+1; % This provides a running count of agents
                        if Family_Adults <= Person_Family_No
                            
                            Person_Profile(Person_Family_Profile(Family_Adults,1),4)=All_Familes;
                            No_People_in_Houshold_6_Actual = No_People_in_Houshold_6_Actual + 1;
                        end
                   end
               end
           end
           if Person_5_Households < Actual_Households_5P
               for Family_Cntr = (Person_5_Households+1):Actual_Households_5P %This counts up in families
                   Person_5_Households = Person_5_Households + 1; % Keep counting households with x people
                   All_Familes = All_Familes+1; % This provides a running count of family ID codes
                   for Fam_Cntr2 = 1:5
                        Family_Adults = Family_Adults+1; % This provides a running count of agents
                        if Family_Adults <= Person_Family_No
                            
                            Person_Profile(Person_Family_Profile(Family_Adults,1),4)=All_Familes;
                            No_People_in_Houshold_5_Actual = No_People_in_Houshold_5_Actual + 1;
                        end 
                   end
               end
           end
           if Person_4_Households < Actual_Households_4P
               for Family_Cntr = (Person_4_Households+1):Actual_Households_4P %This counts up in families
                   Person_4_Households = Person_4_Households + 1; % Keep counting households with x people
                   All_Familes = All_Familes+1; % This provides a running count of family ID codes
                   for Fam_Cntr2 = 1:4
                        Family_Adults = Family_Adults+1; % This provides a running count of agents
                        if Family_Adults <= Person_Family_No
                            
                            Person_Profile(Person_Family_Profile(Family_Adults,1),4)=All_Familes;
                            No_People_in_Houshold_4_Actual = No_People_in_Houshold_4_Actual + 1;
                        end
                   end
               end
           end
           if Person_3_Households < Actual_Households_3P
               for Family_Cntr = (Person_3_Households+1):Actual_Households_3P %This counts up in families
                   Person_3_Households = Person_3_Households + 1; % Keep counting households with x people
                   All_Familes = All_Familes+1; % This provides a running count of family ID codes
                   for Fam_Cntr2 = 1:3
                        Family_Adults = Family_Adults+1; % This provides a running count of agents
                        if Family_Adults <= Person_Family_No
                            
                            Person_Profile(Person_Family_Profile(Family_Adults,1),4)=All_Familes;
                            No_People_in_Houshold_3_Actual = No_People_in_Houshold_3_Actual + 1;
                        end 
                   end
               end
           end
           if Person_2_Households < Actual_Households_2P
               for Family_Cntr = (Person_2_Households+1):Actual_Households_2P %This counts up in families
                   Person_2_Households = Person_2_Households + 1; % Keep counting households with x people
                   All_Familes = All_Familes+1; % This provides a running count of family ID codes
                   for Fam_Cntr2 = 1:2
                        Family_Adults = Family_Adults+1; % This provides a running count of agents
                        if Family_Adults <= Person_Family_No
                            
                            Person_Profile(Person_Family_Profile(Family_Adults,1),4)=All_Familes;
                            No_People_in_Houshold_2_Actual = No_People_in_Houshold_2_Actual + 1;
                        end 
                   end
               end
           end
          
           % Allocate all remaining agents to 1-person families:
           for Count_X = 1:Population
               if Person_Profile(Count_X,4)==0
                   Person_1_Households = Person_1_Households + 1; % Keep counting households with x people
                   All_Familes = All_Familes+1; % This gives us all families with kids + other families
                   Family_Adults = Family_Adults+1; % This provides a running count of agents
                   Person_Profile(Count_X,4) = All_Familes;
                   No_People_in_Houshold_1_Actual = No_People_in_Houshold_1_Actual + 1;
               end
           end
           
           
               
           
