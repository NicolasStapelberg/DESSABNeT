
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
        
     %% Build a Simulated Population: Building a Preschool, School and Occupational Network

            % Build Kindys and Schools first
            % Average class sizes are informed by Australian literature
            
            
            %% Variables:
            
            Preschool_Class_Size = 25;
            Preschool_Class_Size_Mean = 25;
            Preschool_Class_Size_SD = 2;
            Preschool_Class_Size_Cutoff = 10; %Preschool classes will not get smaller then this amount of agents

            School_Class_Size = 25;
            School_Class_Size_Mean = 25;
            School_Class_Size_SD = 2;
            School_Class_Size_Cutoff = 10; %School classes will not get smaller then this amount of agents

            Working_Group_Size = 25;
            Working_Group_Size_Mean = 10;
            Working_Group_Size_SD = 4;
            Work_Group_Size_Cutoff = 4; %Working groups will not get smaller then this amount of agents

            
            %% Calculate Group Sizes:
        
            Preschoolers = round(Perc_Under_5/100*Population,0);
            Schoolers = round(Perc_School_5_19/100*Population,0);
            Workers = round(((Perc_Adult_20_64/100 * ((Fulltime_Work+Parttime_Work)/100)) + (Perc_Over_65/100 * ((Aged_Fulltime_Work+Aged_Parttime_Work)/100)))*Population,0);
            
            % Agents are chosen randomly, so that we end up with many mixed groups
            % Allocate Preschoolers
            Kindygroups = 0;
            Person_Kindy_Profile = Person_Profile(Person_Profile(:,2)==1,1); % Create a new array which only contains ID for agents 0-4 age
            Person_Kindy_No = numel(Person_Kindy_Profile(:,1)); %How many rows in this array? 
            Person_Kindy_Profile = Person_Kindy_Profile(randperm(Person_Kindy_No),:); %Randomly shuffle Person_Kindy_Profile using randperm
            
            
            for Big_Counter = 1:Person_Kindy_No %Count through the Kindy population
                
                    if Person_Profile(Person_Kindy_Profile(Big_Counter,1),5)==0 %This person might already belong to a Kindygroup because of Kindy_Mates loop, so check first
                        Kindygroups = Kindygroups + 1; %Here we start a new Kindy class

                        Person_Profile(Person_Kindy_Profile(Big_Counter,1),5)= Kindygroups; %Assign the current agent to a Kindy class
                        
                        This_Kindy_Group_Size = abs(round(normrnd(Preschool_Class_Size_Mean,Preschool_Class_Size_SD),0)); %Create a random class size from a normal distribution
                        if This_Kindy_Group_Size < Preschool_Class_Size_Cutoff, This_Kindy_Group_Size = Preschool_Class_Size_Mean; end

                        Social_Network_Matrix(Big_Counter,2)=This_Kindy_Group_Size; %This will show the group size for each agent, allowing a histogram to be produced
                        

                        if This_Kindy_Group_Size > 1    
                            for Kindy_Mates = 1:This_Kindy_Group_Size-1 %Step through loop to allocate other agents to this class

                                if Big_Counter+Kindy_Mates <= Person_Kindy_No
                                    if Person_Profile(Person_Kindy_Profile(Big_Counter+Kindy_Mates,1),5)==0 %If the new agent not yet allocated

                                        Person_Profile(Person_Kindy_Profile(Big_Counter+Kindy_Mates,1),5)= Kindygroups; %Assign the current agent to a Kindy class
                                        Social_Network_Matrix(Big_Counter+Kindy_Mates,2)=This_Kindy_Group_Size; %This will show the Kindygroup size for each agent, allowing a histogram to be produced
                                        
                                    end  
                                end
                            end

                        end
                    end
               
            end
            
            
            
            
            %% Now allocate older children to classes
            Schoolgroups = Kindygroups; 
            
            Person_School_Profile = Person_Profile(Person_Profile(:,2)==2,1); % Create a new array which only contains ID for agents 5-19 age
            Person_School_No = numel(Person_School_Profile(:,1)); %How many rows in this array? 
            Person_School_Profile = Person_School_Profile(randperm(Person_School_No),:); %Randomly shuffle Person_School_Profile using randperm
            
            
            for Big_Counter = 1:Person_School_No %Count through the School population
                
                    if Person_Profile(Person_School_Profile(Big_Counter,1),5)==0 %This person might already belong to a Schoolgroup because of School_Mates loop, so check first
                        Schoolgroups = Schoolgroups + 1; %Here we start a new School class

                        Person_Profile(Person_School_Profile(Big_Counter,1),5)= Schoolgroups; %Assign the current agent to a School class
                        
                        This_School_Group_Size = abs(round(normrnd(School_Class_Size_Mean,School_Class_Size_SD),0)); %Create a random class size from a normal distribution
                        if This_School_Group_Size < School_Class_Size_Cutoff, This_School_Group_Size = School_Class_Size_Mean; end

                        Social_Network_Matrix(Big_Counter,2)=This_School_Group_Size; %This will show the group size for each agent, allowing a histogram to be produced
                        

                        if This_School_Group_Size > 1    
                            for School_Mates = 1:This_School_Group_Size-1 %Step through loop to allocate other agents to this class

                                if Big_Counter+School_Mates <= Person_School_No
                                    if Person_Profile(Person_School_Profile(Big_Counter+School_Mates,1),5)==0 %If the new agent not yet allocated

                                        Person_Profile(Person_School_Profile(Big_Counter+School_Mates,1),5)= Schoolgroups; %Assign the current agent to a class
                                        Social_Network_Matrix(Big_Counter+School_Mates,2)=This_School_Group_Size; %This will show the Schoolgroup size for each agent, allowing a histogram to be produced
                                        
                                    end  
                                end
                            end

                        end
                    end
               
            end
            
            
            
            %% Now allocate work groups
            Workgroups = Schoolgroups;
            Person_Work_Profile = Person_Profile(Person_Profile(:,3)==3 | Person_Profile(:,3)==4,1); % Create a new array which only contains ID for those working full time or part time
            Person_Work_No = numel(Person_Work_Profile(:,1)); %How many rows in this array? 
            Person_Work_Profile = Person_Work_Profile(randperm(Person_Work_No),:); %Randomly shuffle Person_Work_Profile using randperm
            
            
            for Big_Counter = 1:Person_Work_No %Count through the working population
                
                        if Person_Profile(Person_Work_Profile(Big_Counter,1),5)==0 %This person might already belong to a workgroup because of Work_Mates loop, so check first
                            Workgroups = Workgroups + 1; %Here we start a new workplace
                            
                            Person_Profile(Person_Work_Profile(Big_Counter,1),5)= Workgroups; %Assign the current adult to a workplace
                            This_Work_Group_Size = abs(round(normrnd(Working_Group_Size_Mean,Working_Group_Size_SD),0)); %Create a random workgroup size from a normal distribution
                            
                            if This_Work_Group_Size < Work_Group_Size_Cutoff, This_Work_Group_Size = round(Work_Group_Size_Cutoff+rand*Working_Group_Size_Mean,0); end %Redistribute but smooth curve a bit
                            
                            Social_Network_Matrix(Big_Counter,2)=This_Work_Group_Size; %This will show the workgroup size for each agent, allowing a histogram to be produced
                            if This_Work_Group_Size > 1    
                                for Work_Mates = 1:This_Work_Group_Size-1 %Step through loop to allocate other workers to this class
                                    
                                    if Big_Counter+Work_Mates <= Person_Work_No
                                        if Person_Profile(Person_Work_Profile(Big_Counter+Work_Mates,1),5)==0 %If the new worker not yet allocated
                                           
                                            Person_Profile(Person_Work_Profile(Big_Counter+Work_Mates,1),5)= Workgroups; %Assign the current adult to a workplace
                                            Social_Network_Matrix(Big_Counter+Work_Mates,2)=This_Work_Group_Size; %This will show the workgroup size for each agent, allowing a histogram to be produced
                                        end  
                                    end
                                end
                                
                            end
                        end
              
            end
            
            
                    
            %% Assign teachers, 2 per class, kindy or school

            for Class_Counter = 1:Schoolgroups % Schoolgroups continues to count from Kindygroups, so this number will include teachers for both age groups
                Teacher1 = floor(rand*Workers+1)+Kids;
                Teacher2 = floor(rand*Workers+1)+Kids;
                Person_Profile(Teacher1,5) = Class_Counter; 
                Person_Profile(Teacher1,7)=6; % Documenting these people as a teacher
                Person_Profile(Teacher2,5) = Class_Counter; 
                Person_Profile(Teacher2,7)=6; % Documenting these people as a teacher
                % Put in a "teacher" job in the right column for both teachers
            end

