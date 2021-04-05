
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


%% Build a Simulated Population: ID, Age and Workforce Participation

                fprintf('%s\t','1) Building Social Networks...');
                fprintf('\n');

        % Here we attempt to build a simulated population, down to indivduals who
        % have credible profiles but where the cumulative statistics match real data
        % This is done by creating a loop which works through each person in the modelled population, one
        % person at a time
        % We assign a probability of each characteristic and then use a random
        % number generator to "roll the dice" to see what characteristics each
        % person ends up with. Some characteristics follow from others. By
        % assigning age first, characterstics such as attending school etc. will
        % follow from this.
        % Each person is assigned a PersonID (their number in the loop), so that they can be tracked through
        % processes such as assigning them a family, workplace and
        % friendship groups, but also so that they can be tracked over time.
        % PersonID is a matrix which stores relevant
        % information about each agent, creating a person profile
     
        % PersonID is Person_Profile(Popn_Counter,1)
        % Agegroup (1-4) is Person_Profile(Popn_Counter,2)
        % What people do during the day is recorded in Person_Profile(Popn_Counter,3)

            for Popn_Counter = 1:Population

                Person_Profile(Popn_Counter,1) = Popn_Counter; %This is the PersonID
                

                Person_Profile(Popn_Counter,2) = sum(Popn_Counter/Population >= cumsum([0,Perc_Under_5/100, Perc_School_5_19/100, Perc_Adult_20_64/100, Perc_Over_65/100])); %Establish age group

                % Pre-school, School, Employent (including tertiary/vocational education):

                if Person_Profile(Popn_Counter,2) == 1, Person_Profile(Popn_Counter,3) = 1; end % Simplification: All toddlers are in kindy/preschool
                if Person_Profile(Popn_Counter,2) == 2, Person_Profile(Popn_Counter,3) = 2; end % Simplification: All children/ young people attend school/ education
                if Person_Profile(Popn_Counter,2) == 3 
                    Person_Profile(Popn_Counter,3) = sum(rand >= cumsum([0,Parttime_Work/100, Fulltime_Work/100, Unemployed/100])); 
                    Person_Profile(Popn_Counter,3) = Person_Profile(Popn_Counter,3) + 2;
                end


                if Person_Profile(Popn_Counter,2) == 4  % Statistics are reworked for Adults over 65 to factor in retired vs working
                    Person_Profile(Popn_Counter,3) = sum(rand >= cumsum([0, Aged_Parttime_Work/100, Aged_Fulltime_Work/100,Retired/100])); 
                    Person_Profile(Popn_Counter,3) = Person_Profile(Popn_Counter,3) + 2;
                    if Person_Profile(Popn_Counter,3) == 5, Person_Profile(Popn_Counter,3) = 6; end
                end

                % Person_Profile(:,3) = 1 toddler at preschool
                % Person_Profile(:,3) = 2 child at school
                % Person_Profile(:,3) = 3 adult part time work
                % Person_Profile(:,3) = 4 adult full time work
                % Person_Profile(:,3) = 5 adult unemployed

                % Person_Profile(:,3) = 3 older adult part time work
                % Person_Profile(:,3) = 4 older adult full time work
                % Person_Profile(:,3) = 6 older adult retired

            end
