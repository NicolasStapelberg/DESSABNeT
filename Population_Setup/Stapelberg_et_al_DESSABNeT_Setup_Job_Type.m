
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

        
     %% Build a Simulated Population: Job Type

                %% Variables:
        
                    Large_Contact = 25; % Job with contact with up to 200 members of the public per diem
                    Medium_Contact = 32; % Job with contact with up to 50 members of the public per diem
                    Low_Contact = 43; % Job with contact with up to 20 members of the public per diem

            %% Now create job type to determine contact with the public during work
            
            % This module has the capacity to create specific groups such as teachers or healthcare workers. Not all functionality is used in this version. 

                % Person_Profile(:,7) = 1  Preschool
                % Person_Profile(:,7) = 2  School
                % Person_Profile(:,7) = 3  People in contact with up to 200 people/day (25%)
                % Person_Profile(:,7) = 4  People in contact with up to 50 people/day (32%)
                % Person_Profile(:,7) = 5  People in contact with up to 20 people/day (43%)
                % Person_Profile(:,7) = 6  Teachers
                % Person_Profile(:,7) = 7  Healthcare workers
                % Person_Profile(:,7) = 8  Retired
                % Person_Profile(:,7) = 9  Unemployed

                % Person_Profile(:,3) = 1 toddler at preschool
                % Person_Profile(:,3) = 2 child at school
                % Person_Profile(:,3) = 3 adult part time work
                % Person_Profile(:,3) = 4 adult full time work
                % Person_Profile(:,3) = 5 adult unemployed

                % Person_Profile(:,3) = 3 older adult part time work
                % Person_Profile(:,3) = 4 older adult full time work
                % Person_Profile(:,3) = 6 older adult retired

                for Counter3 = 1:Population
                    if Person_Profile(Counter3,2) == 1,Person_Profile(Counter3,7)=1; end 
                    if Person_Profile(Counter3,2) == 2,Person_Profile(Counter3,7)=2; end 
                    if Person_Profile(Counter3,2) > 2
                        if Person_Profile(Counter3,3) == 3  %part time workers
                            if Person_Profile(Counter3,7) == 0 
                                Person_Profile(Counter3,7) = sum(rand >= cumsum([0,Large_Contact/100, Medium_Contact/100, Low_Contact/100]))+2; 
                            end
                        end
                        if Person_Profile(Counter3,3) == 4  %full time workers
                            if Person_Profile(Counter3,7) == 0 
                                Person_Profile(Counter3,7) = sum(rand >= cumsum([0,Large_Contact/100, Medium_Contact/100, Low_Contact/100]))+2; 
                            end
                        end

                        if Person_Profile(Counter3,3) == 6,Person_Profile(Counter3,7)=8; end 
                        if Person_Profile(Counter3,3) == 5,Person_Profile(Counter3,7)=9; end 
                    end
                end
