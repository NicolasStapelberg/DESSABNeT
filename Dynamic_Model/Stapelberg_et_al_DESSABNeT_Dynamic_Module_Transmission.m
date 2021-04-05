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
    

    %% Transmission Code Module
    
    % This module is the engine of the dynamic model simulation, because all transmissions (transmissions in each container every day) are coded for here. 
             
                % 0 = Susceptible (S)
                % 1 = Exposure1 or incubation period and is determined on a lognormal distibution ending in 14 days (minus 2 days = 12 days max)
                % 2 = Exposure2. Agents are shedding virus but not yet symptomatic. This is fixed at 2 days.
                % 3 = Infective (I) period. This is currently set at 10 days. Agents are shedding virus
                % 4 = Recovered (R)
                % 5 = Managed (M)
                % 6 = Death (D)
                
                % As a baseline, everyone is susceptible

              
                if Day_Count == 1 % This will zero these values at the start of a run.
                    People_No = 1;
                    Daily_I1_Number= 0;
                    Daily_I2_Number= 0;
                    Daily_I3_Number= 0;
                    Daily_I4_Number= 0;
                    Daily_M_Total_Number= 0;
                    Daily_Community_Incidence= 0;
                    Daily_R_Number= 0;
                    Daily_M_Number= 0;
                    Daily_D_Number= 0;

                    Daily_People_in_Quarantine= 0;


                    Daily_Rx_Home_Kindy= 0;
                    Daily_Rx_Home_School= 0;
                    Daily_Rx_Home_Adult= 0;
                    Daily_Rx_Home_Older_Adult= 0;
                    Daily_Hosp_Kindy= 0;
                    Daily_Hosp_School= 0;
                    Daily_Hosp_Adult= 0;
                    Daily_Hosp_Older_Adult= 0;
                    Daily_ICU_Kindy= 0;
                    Daily_ICU_School= 0;
                    Daily_ICU_Adult= 0;
                    Daily_ICU_Older_Adult= 0;
                    Daily_Death_Kindy= 0;
                    Daily_Death_School= 0;
                    Daily_Death_Adult= 0;
                    Daily_Death_Older_Adult= 0;
                end
                
                %Reset arrays for Reff calculation to 0 for this day:
                Daily_Persons_Infected_x_IP=0;
               
                
                
                
                
            for CounterS = 1:Population
                Person_Profile(CounterS,10)=Person_Profile(CounterS,10)+1; %This counter advances by 1 each day
                
                if Person_Profile(CounterS,9) == 3 
                    if Person_Profile(CounterS,10) > round(Person_Profile(CounterS,42)*Contact_Tracing_Factor,0) % Multiply by a factor which accounts for contact tracing to shorten infectivity period 
                        Person_Profile(CounterS,9) = 4; % Here people go from I to Recovered (R) 
                        Person_Profile(CounterS,10) = 1; % Reset the day counter every transition
                        Person_Profile(CounterS,39) = 0; % Returning traveller status reset...
                        Daily_R_Number= Daily_R_Number+1;
                    end
                end
                
                if Person_Profile(CounterS,9) == 2 
                    if Person_Profile(CounterS,10) > round(Person_Profile(CounterS,41)*Contact_Tracing_Factor,0)
                        Person_Profile(CounterS,9) = 3; % Here people go from E2 to I (Infective)
                        Person_Profile(CounterS,10) = 1;
                        Daily_I3_Number= Daily_I3_Number+1;
                        if Person_Profile(CounterS,43)==1 && Person_Profile(CounterS,39) ~= 1
                            Daily_I4_Number = Daily_I4_Number + 1;
                        end
                    end
                end
                
                if Person_Profile(CounterS,9) == 1 % This is E1 = Exposure or incubation period...
                    if Person_Profile(CounterS,10) > Person_Profile(CounterS,40)
                        Person_Profile(CounterS,9) = 2; % Here people go from E1 to E2, where E2 = The last 2 days calculated for E1 
                        Person_Profile(CounterS,10) = 1;
                        Daily_I2_Number = Daily_I2_Number+1;
                    end
                end

            end

            %% Calculate Daily Contacts:

           % 1) For each day, examine all groups/containers separately
           % 2) Identify each individual group and its members
           % 3) Establish transmission probability for that group
           % 4) Simulate infection transmission based on daily contact in groups and transmission probability 



                % Workday Contacts

                    % Person_Profile(:,3) = 1 toddler at preschool
                    % Person_Profile(:,3) = 2 child at school
                    % Person_Profile(:,3) = 3 adult part time work
                    % Person_Profile(:,3) = 4 adult full time work
                    % Person_Profile(:,3) = 5 adult unemployed

                    % Person_Profile(:,3) = 3 older adult part time work
                    % Person_Profile(:,3) = 4 older adult full time work
                    % Person_Profile(:,3) = 6 older adult retired

             
                    
            %% Here each group in each container is examined:
                    
                % 1 = Transmission via workplace and school classroom groups
                % What Group is being indexed/extracted?: All people working today, in daycare or schools
                for Morning_Afternoon = 1:2 % Look at both morning and day Time periods (T1 and T2)
                    
                    if Morning_Afternoon == 2, Gear = Weekday + 7; else, Gear = Weekday; end
                    for CounterA = 1:No_Subgroups_Work(Gear)
                        Infected_No = 0;
                        Recovered_No = 0;
                        Transmission_No = 0;
                        Transmission_Probability = 0;
                        for CounterB = 1:Subgroup_N_Work_Rows(CounterA,Gear)
                            
                            if Person_Profile(Subgroup_N_Work(CounterB,CounterA,Gear),9) == 2 || Person_Profile(Subgroup_N_Work(CounterB,CounterA,Gear),9) == 3 %This is the Source Agent: Both E2 and I are infective
                                if Person_Profile(Subgroup_N_Work(CounterB,CounterA,Gear),36)<3 && Person_Profile(Subgroup_N_Work(CounterB,CounterA,Gear),49)==0 % Only count as Potential E2 or I if agent is not self-isolating OR managed
                                    Daily_Infectors(Person_Profile(Subgroup_N_Work(CounterB,CounterA,Gear),1),Day_Count) = 1;
                                end
                                    for CounterXX = 1:Subgroup_N_Work_Rows(CounterA,Gear) %Go through the whole group and manage transmission sequentially
                                        if Person_Profile(Subgroup_N_Work(CounterXX,CounterA,Gear),9) == 0 %This is the Recipient Agent: Only suscpetible people can get infected
                                            
                                            if Person_Profile(Subgroup_N_Work(CounterB,CounterA,Gear),43) == 1 %Is the Source Agent asymptomatic?    
                                                T_P = 1 * Person_Profile(Subgroup_N_Work(CounterB,CounterA,Gear),44); % Multiply by personal Superspreader Factor
                                            else
                                                T_P = Perc_Asymptomatic_Transmission/100 * Person_Profile(Subgroup_N_Work(CounterB,CounterA,Gear),44); % Multiply by personal Superspreader Factor
                                            end
                                            if School_Open == 1 % Check if schools are open...
                                                if Person_Profile(Subgroup_N_Work(CounterXX,CounterA,Gear),2)==1, Transmission_Probability = sum(rand >= cumsum([0,Beta_Kindy*T_P,(1-Beta_Kindy*T_P)])); end %This is dependent on the Recipient (Chang et al., 2020) not the Source Agent!
                                                if Person_Profile(Subgroup_N_Work(CounterXX,CounterA,Gear),2)==2, Transmission_Probability = sum(rand >= cumsum([0,Beta_School*T_P,(1-Beta_School*T_P)])); end
                                            end
                                            if Person_Profile(Subgroup_N_Work(CounterXX,CounterA,Gear),2)>2, Transmission_Probability = sum(rand >= cumsum([0,Beta_Adult*T_P,(1-Beta_Adult*T_P)])); end  
                                            

                                            if Transmission_Probability == 1
                                                
                                                if Person_Profile(Subgroup_N_Work(CounterB,CounterA,Gear),36)<3 && Person_Profile(Subgroup_N_Work(CounterB,CounterA,Gear),49)==0 % Only transmit virus if the person is not self-isolating OR managed
                                                    Person_Profile(Subgroup_N_Work(CounterXX,CounterA,Gear),9)=1; % This person now becomes infected - the Recipient Agent
                                                    if Person_Profile(Subgroup_N_Work(CounterB,CounterA,Gear),39) == 0 % Only count an infection if it is community acquired (i.e. not a returning traveller)
                                                        Person_Profile(Subgroup_N_Work(CounterB,CounterA,Gear),32) = Person_Profile(Subgroup_N_Work(CounterB,CounterA,Gear),32) + 1;
                                                        Person_Profile(Subgroup_N_Work(CounterB,CounterA,Gear),46) = Person_Profile(Subgroup_N_Work(CounterB,CounterA,Gear),46) + 1;
                                                        % The next 3 lines contribute to the building of a contact matrix which allows daily R0 to be calculated:
                                                        Infective_Period = Person_Profile(Subgroup_N_Work(CounterB,CounterA,Gear),41)+Person_Profile(Subgroup_N_Work(CounterB,CounterA,Gear),42); %This calculates E2+I
                                                        Daily_Persons_Infected_x_IP=Daily_Persons_Infected_x_IP+Infective_Period;
                                                        Daily_Infections(Person_Profile(Subgroup_N_Work(CounterB,CounterA,Gear),1),Day_Count) = Daily_Infections(Person_Profile(Subgroup_N_Work(CounterB,CounterA,Gear),1),Day_Count)+1;
                                                    end
                                                   
                                                    Transmission_No = Transmission_No + 1;
                                                    Daily_I1_Number = Daily_I1_Number + 1;
                                                    
                                                    
                                                    if Person_Profile(Subgroup_N_Work(CounterXX,CounterA,Gear),2)==1, Transmission_Kindy(Context_No) = Transmission_Kindy(Context_No)+1; end
                                                    if Person_Profile(Subgroup_N_Work(CounterXX,CounterA,Gear),2)==2, Transmission_School(Context_No) = Transmission_School(Context_No)+1; end
                                                    if Person_Profile(Subgroup_N_Work(CounterXX,CounterA,Gear),2)>2, Transmission_Work(Context_No) = Transmission_Work(Context_No)+1; end

                                                    Transmission_Probability = 0;
                                                else
                                                    if Person_Profile(Subgroup_N_Work(CounterB,CounterA,Gear),49)==1
                                                        Transmissions_Avoided(Context_No) = Transmissions_Avoided(Context_No) + 1;
                                                    end
                                                end
                                                    
                                            end
                                        end
                                    end
                                   
                            end
                        end
                    end
                end


                % 5 = Transmission via Medium Groups
                % What Group is being indexed/extracted?: All people in known medium (random contact) groups meeting today
                for Morning_Afternoon = 1:2 % Look at both morning and day Time periods (T1 and T2)
                    if Morning_Afternoon == 2, Gear = Weekday + 7; else, Gear = Weekday; end
                    for CounterA = 1:No_Subgroups_Social(Gear)
                        Infected_No = 0;
                        Recovered_No = 0;
                        Transmission_No = 0;
                        Transmission_Probability = 0;
                        for CounterB = 1:Subgroup_N_Social_Rows(CounterA,Gear)
                            if Person_Profile(Subgroup_N_Social(CounterB,CounterA,Gear),9) == 2 || Person_Profile(Subgroup_N_Social(CounterB,CounterA,Gear),9) == 3 %Both E2 and I are infective
                                
                                if Person_Profile(Subgroup_N_Social(CounterB,CounterA,Gear),36)<3 && Person_Profile(Subgroup_N_Social(CounterB,CounterA,Gear),49)==0 % Only count as Potential E2 or I if agent is not self-isolating OR managed
                                    Daily_Infectors(Person_Profile(Subgroup_N_Social(CounterB,CounterA,Gear),1),Day_Count) = 1;
                                end
                                    for CounterXX = 1:Subgroup_N_Social_Rows(CounterA,Gear) %Go through the whole group and manage transmission sequentially
                                        if Person_Profile(Subgroup_N_Social(CounterXX,CounterA,Gear),9) == 0
                                            if Person_Profile(Subgroup_N_Social(CounterB,CounterA,Gear),43) == 1 %Is the Source Agent asymptomatic?
                                                T_P = 1 * Person_Profile(Subgroup_N_Social(CounterB,CounterA,Gear),44);
                                            else
                                                T_P = Perc_Asymptomatic_Transmission/100 * Person_Profile(Subgroup_N_Social(CounterB,CounterA,Gear),44);
                                            end

                                            if Person_Profile(Subgroup_N_Social(CounterXX,CounterA,Gear),2)==1, Transmission_Probability = sum(rand >= cumsum([0,Beta_E_0_4_Medium_Group*T_P,(1-Beta_E_0_4_Medium_Group*T_P)])); end
                                            if Person_Profile(Subgroup_N_Social(CounterXX,CounterA,Gear),2)==2, Transmission_Probability = sum(rand >= cumsum([0,Beta_E_5_19_Medium_Group*T_P,(1-Beta_E_5_19_Medium_Group*T_P)])); end
                                            if Person_Profile(Subgroup_N_Social(CounterXX,CounterA,Gear),2)==3, Transmission_Probability = sum(rand >= cumsum([0,Beta_E_Adult_Medium_Group*T_P,(1-Beta_E_Adult_Medium_Group*T_P)])); end 
                                            if Person_Profile(Subgroup_N_Social(CounterXX,CounterA,Gear),2)==4, Transmission_Probability = sum(rand >= cumsum([0,Beta_E_Older_Adult_Medium_Group*T_P,(1-Beta_E_Older_Adult_Medium_Group*T_P)])); end 


                                            if Transmission_Probability == 1
                                                if Person_Profile(Subgroup_N_Social(CounterB,CounterA,Gear),36)<3 && Person_Profile(Subgroup_N_Social(CounterB,CounterA,Gear),49)==0 % Only transmit virus if the person is not self-isolating or managed
                                                    Person_Profile(Subgroup_N_Social(CounterXX,CounterA,Gear),9)=1; % This person now becomes infected
                                                    if Person_Profile(Subgroup_N_Social(CounterB,CounterA,Gear),39) == 0 % Only count an infection if it is community acquired (i.e. not a returning traveller)
                                                        Person_Profile(Subgroup_N_Social(CounterB,CounterA,Gear),32) = Person_Profile(Subgroup_N_Social(CounterB,CounterA,Gear),32) + 1;
                                                        Person_Profile(Subgroup_N_Social(CounterB,CounterA,Gear),46) = Person_Profile(Subgroup_N_Social(CounterB,CounterA,Gear),46) + 1;
                                                        % The next 3 lines contribute to the building of a contact matrix which allows daily R0 to be calculated:
                                                        Infective_Period = Person_Profile(Subgroup_N_Social(CounterB,CounterA,Gear),41)+Person_Profile(Subgroup_N_Social(CounterB,CounterA,Gear),42); %This calculates E2+I
                                                        Daily_Persons_Infected_x_IP=Daily_Persons_Infected_x_IP+Infective_Period;
                                                        Daily_Infections(Person_Profile(Subgroup_N_Social(CounterB,CounterA,Gear),1),Day_Count) = Daily_Infections(Person_Profile(Subgroup_N_Social(CounterB,CounterA,Gear),1),Day_Count)+1;
                                                    end
                                                   
                                                    Transmission_No = Transmission_No + 1;
                                                    Daily_I1_Number = Daily_I1_Number + 1;
                                                    
                                                    
                                                    
                                                    Transmission_Social(Context_No) = Transmission_Social(Context_No)+1;
                                                    Transmission_Probability = 0;
                                                else
                                                    if Person_Profile(Subgroup_N_Social(CounterB,CounterA,Gear),49)==1
                                                        Transmissions_Avoided(Context_No) = Transmissions_Avoided(Context_No) + 1;
                                                    end
                                                end
                                            end
                                        end
                                    end
                                    
                            end
                        end
                    end
                end


                % 4 = Transmission via public transport
                % What Subgroup is being indexed/extracted?: Small Group Exposure Group
               for Morning_Afternoon = 1:2 % Look at both morning and day Time periods (T1 and T2)
                    if Morning_Afternoon == 2, Gear = Weekday + 7; else, Gear = Weekday; end
                    for CounterA = 1:No_Subgroups_PublicT(Gear)
                        Infected_No = 0;
                        Recovered_No = 0;
                        Transmission_No = 0;
                        Transmission_Probability = 0;
                        for CounterB = 1:Subgroup_N_PublicT_Rows(CounterA,Gear)
                            if Person_Profile(Subgroup_N_PublicT(CounterB,CounterA,Gear),9) == 2 || Person_Profile(Subgroup_N_PublicT(CounterB,CounterA,Gear),9) == 3 
                                
                                if Person_Profile(Subgroup_N_PublicT(CounterB,CounterA,Gear),36)<3 && Person_Profile(Subgroup_N_PublicT(CounterB,CounterA,Gear),49)==0 % Only count as Potential E2 or I if agent is not self-isolating OR managed
                                    Daily_Infectors(Person_Profile(Subgroup_N_PublicT(CounterB,CounterA,Gear),1),Day_Count) = 1;
                                end
                                    for CounterXX = 1:Subgroup_N_PublicT_Rows(CounterA,Gear) %Go through the whole group and manage transmission sequentially
                                        if Person_Profile(Subgroup_N_PublicT(CounterXX,CounterA,Gear),9) == 0
                                            if Person_Profile(Subgroup_N_PublicT(CounterB,CounterA,Gear),43) == 1 %Is the Source Agent asymptomatic?
                                                T_P = 1 * Person_Profile(Subgroup_N_PublicT(CounterB,CounterA,Gear),44);
                                            else
                                                T_P = Perc_Asymptomatic_Transmission/100 * Person_Profile(Subgroup_N_PublicT(CounterB,CounterA,Gear),44);
                                            end
                                            
                                            if Person_Profile(Subgroup_N_PublicT(CounterXX,CounterA,Gear),2)==1, Transmission_Probability = sum(rand >= cumsum([0,Beta_E_0_4_Small_Group*T_P,(1-Beta_E_0_4_Small_Group*T_P)])); end
                                            if Person_Profile(Subgroup_N_PublicT(CounterXX,CounterA,Gear),2)==2, Transmission_Probability = sum(rand >= cumsum([0,Beta_E_5_19_Small_Group*T_P,(1-Beta_E_5_19_Small_Group*T_P)])); end
                                            if Person_Profile(Subgroup_N_PublicT(CounterXX,CounterA,Gear),2)==3, Transmission_Probability = sum(rand >= cumsum([0,Beta_E_Adult_Small_Group*T_P,(1-Beta_E_Adult_Small_Group*T_P)])); end 
                                            if Person_Profile(Subgroup_N_PublicT(CounterXX,CounterA,Gear),2)==4, Transmission_Probability = sum(rand >= cumsum([0,Beta_E_Older_Adult_Small_Group*T_P,(1-Beta_E_Older_Adult_Small_Group*T_P)])); end 
                                            

                                            if Transmission_Probability == 1
                                                
                                                if Person_Profile(Subgroup_N_PublicT(CounterB,CounterA,Gear),36)<3 && Person_Profile(Subgroup_N_PublicT(CounterB,CounterA,Gear),49)==0 % Only transmit virus if the person is not self-isolating or admitted
                                                   
                                                    Person_Profile(Subgroup_N_PublicT(CounterXX,CounterA,Gear),9)=1; % This person now becomes infected
                                                    if Person_Profile(Subgroup_N_PublicT(CounterB,CounterA,Gear),39) == 0 % Only count an infection if it is community acquired (i.e. not a returning traveller)
                                                        Person_Profile(Subgroup_N_PublicT(CounterB,CounterA,Gear),32) = Person_Profile(Subgroup_N_PublicT(CounterB,CounterA,Gear),32) + 1;
                                                        Person_Profile(Subgroup_N_PublicT(CounterB,CounterA,Gear),46) = Person_Profile(Subgroup_N_PublicT(CounterB,CounterA,Gear),46) + 1;
                                                        % The next 3 lines contribute to the building of a contact matrix which allows daily R0 to be calculated:
                                                        Infective_Period = Person_Profile(Subgroup_N_PublicT(CounterB,CounterA,Gear),41)+Person_Profile(Subgroup_N_PublicT(CounterB,CounterA,Gear),42); %This calculates E2+I
                                                        Daily_Persons_Infected_x_IP=Daily_Persons_Infected_x_IP+Infective_Period;
                                                        Daily_Infections(Person_Profile(Subgroup_N_PublicT(CounterB,CounterA,Gear),1),Day_Count) = Daily_Infections(Person_Profile(Subgroup_N_PublicT(CounterB,CounterA,Gear),1),Day_Count)+1;
                                                    end
                                                   
                                                    Transmission_No = Transmission_No + 1;
                                                    Daily_I1_Number = Daily_I1_Number + 1;
                                                    
                                                    Transmission_Public_T(Context_No) = Transmission_Public_T(Context_No)+1;
                                                    Transmission_Probability = 0;
                                                else
                                                    
                                                    if Person_Profile(Subgroup_N_PublicT(CounterB,CounterA,Gear),49)==1
                                                        
                                                        Transmissions_Avoided(Context_No) = Transmissions_Avoided(Context_No) + 1;
                                                    end
                                                end
                                            end
                                        end
                                    end
                                    
                            end
                        end
                    end
                end


                % 2 = Transmission via Essential Activities
                % This includes food shopping, visiting doctors, pharmacies, etc. These interactions have been allocated to a medium-sized exposure group 
                % People who are engaged in Essential Activities today:
               for Morning_Afternoon = 1:2 % Look at both morning and day Time periods (T1 and T2)
                    if Morning_Afternoon == 2, Gear = Weekday + 7; else, Gear = Weekday; end
                    for CounterA = 1:No_Subgroups_Essential(Gear)
                        Infected_No = 0;
                        Recovered_No = 0;
                        Transmission_No = 0;
                        Transmission_Probability = 0;
                        for CounterB = 1:Subgroup_N_Essential_Rows(CounterA,Gear)
                            if Person_Profile(Subgroup_N_Essential(CounterB,CounterA,Gear),9) == 2 || Person_Profile(Subgroup_N_Essential(CounterB,CounterA,Gear),9) == 3 
                                if Person_Profile(Subgroup_N_Essential(CounterB,CounterA,Gear),36)<3 && Person_Profile(Subgroup_N_Essential(CounterB,CounterA,Gear),49)==0 % Only count as Potential E2 or I if agent is not self-isolating OR managed
                                    Daily_Infectors(Person_Profile(Subgroup_N_Essential(CounterB,CounterA,Gear),1),Day_Count) = 1;
                                end
                                    for CounterXX = 1:Subgroup_N_Essential_Rows(CounterA,Gear) %Go through the whole group and manage transmission sequentially
                                        if Person_Profile(Subgroup_N_Essential(CounterXX,CounterA,Gear),9) == 0
                                            if Person_Profile(Subgroup_N_Essential(CounterB,CounterA,Gear),43) == 1 %Is the Source Agent asymptomatic?
                                                T_P = 1 * Person_Profile(Subgroup_N_Essential(CounterB,CounterA,Gear),44);
                                            else
                                                T_P = Perc_Asymptomatic_Transmission/100 * Person_Profile(Subgroup_N_Essential(CounterB,CounterA,Gear),44);
                                            end

                                            if Person_Profile(Subgroup_N_Essential(CounterXX,CounterA,Gear),2)==1, Transmission_Probability = sum(rand >= cumsum([0,Beta_E_0_4_Medium_Group*T_P,(1-Beta_E_0_4_Medium_Group*T_P)])); end
                                            if Person_Profile(Subgroup_N_Essential(CounterXX,CounterA,Gear),2)==2, Transmission_Probability = sum(rand >= cumsum([0,Beta_E_5_19_Medium_Group*T_P,(1-Beta_E_5_19_Medium_Group*T_P)])); end
                                            if Person_Profile(Subgroup_N_Essential(CounterXX,CounterA,Gear),2)==3, Transmission_Probability = sum(rand >= cumsum([0,Beta_E_Adult_Medium_Group*T_P,(1-Beta_E_Adult_Medium_Group*T_P)])); end 
                                            if Person_Profile(Subgroup_N_Essential(CounterXX,CounterA,Gear),2)==4, Transmission_Probability = sum(rand >= cumsum([0,Beta_E_Older_Adult_Medium_Group*T_P,(1-Beta_E_Older_Adult_Medium_Group*T_P)])); end 


                                            if Transmission_Probability == 1
                                                if Person_Profile(Subgroup_N_Essential(CounterB,CounterA,Gear),36)<3 && Person_Profile(Subgroup_N_Essential(CounterB,CounterA,Gear),49)==0  % Only transmit virus if the person is not self-isolating or admitted
                                                    Person_Profile(Subgroup_N_Essential(CounterXX,CounterA,Gear),9)=1; % This person now becomes infected
                                                    if Person_Profile(Subgroup_N_Essential(CounterB,CounterA,Gear),39) == 0 % Only count an infection if it is community acquired (i.e. not a returning traveller)
                                                        Person_Profile(Subgroup_N_Essential(CounterB,CounterA,Gear),32) = Person_Profile(Subgroup_N_Essential(CounterB,CounterA,Gear),32) + 1;
                                                        Person_Profile(Subgroup_N_Essential(CounterB,CounterA,Gear),46) = Person_Profile(Subgroup_N_Essential(CounterB,CounterA,Gear),46) + 1;
                                                        % The next 3 lines contribute to the building of a contact matrix which allows daily R0 to be calculated:
                                                        Infective_Period = Person_Profile(Subgroup_N_Essential(CounterB,CounterA,Gear),41)+Person_Profile(Subgroup_N_Essential(CounterB,CounterA,Gear),42); %This calculates E2+I
                                                        Daily_Persons_Infected_x_IP=Daily_Persons_Infected_x_IP+Infective_Period;
                                                        Daily_Infections(Person_Profile(Subgroup_N_Essential(CounterB,CounterA,Gear),1),Day_Count) = Daily_Infections(Person_Profile(Subgroup_N_Essential(CounterB,CounterA,Gear),1),Day_Count)+1;
                                                    end
                                                  
                                                    Transmission_No = Transmission_No + 1;
                                                    Daily_I1_Number = Daily_I1_Number + 1;
                                                    
                                                    Transmission_Essential(Context_No) = Transmission_Essential(Context_No)+1;
                                                    Transmission_Probability = 0;
                                                else
                                                    if Person_Profile(Subgroup_N_Essential(CounterB,CounterA,Gear),49)==1
                                                        Transmissions_Avoided(Context_No) = Transmissions_Avoided(Context_No) + 1;
                                                    end
                                                end    
                                            end
                                        end
                                    end
                                    
                            end
                        end
                    end
                end


                % 3 = Transmission via Large Group Activity (Random Contacts, Large Shopping Centres, Sporting Events, etc.)
                % This comprises going to large gatherings, such as shopping malls, market and other crowded areas. These interactions have been allocated to a large-sized exposure group 
                
                for Morning_Afternoon = 1:2 % Look at both morning and day Time periods (T1 and T2)
                    if Morning_Afternoon == 2, Gear = Weekday + 7; else, Gear = Weekday; end
                    for CounterA = 1:No_Subgroups_Leisure(Gear)
                        Infected_No = 0;
                        Recovered_No = 0;
                        Transmission_No = 0;
                        Transmission_Probability = 0;
                        for CounterB = 1:Subgroup_N_Leisure_Rows(CounterA,Gear)
                            if Person_Profile(Subgroup_N_Leisure(CounterB,CounterA,Gear),9) == 2 || Person_Profile(Subgroup_N_Leisure(CounterB,CounterA,Gear),9) == 3
                                if Person_Profile(Subgroup_N_Leisure(CounterB,CounterA,Gear),36)<3 && Person_Profile(Subgroup_N_Leisure(CounterB,CounterA,Gear),49)==0 % Only count as Potential E2 or I if agent is not self-isolating OR managed
                                    Daily_Infectors(Person_Profile(Subgroup_N_Leisure(CounterB,CounterA,Gear),1),Day_Count) = 1;
                                end
                                    for CounterXX = 1:Subgroup_N_Leisure_Rows(CounterA,Gear) %Go through the whole group and manage transmission sequentially
                                        if Person_Profile(Subgroup_N_Leisure(CounterXX,CounterA,Gear),9) == 0
                                            if Person_Profile(Subgroup_N_Leisure(CounterB,CounterA,Gear),43) == 1  %Is the Source Agent asymptomatic?
                                                T_P = 1 * Person_Profile(Subgroup_N_Leisure(CounterB,CounterA,Gear),44); 
                                            else
                                                T_P = Perc_Asymptomatic_Transmission/100 * Person_Profile(Subgroup_N_Leisure(CounterB,CounterA,Gear),44); 
                                            end

                                            if Person_Profile(Subgroup_N_Leisure(CounterXX,CounterA,Gear),2)==1, Transmission_Probability = sum(rand >= cumsum([0,Beta_E_0_4_Large_Group*T_P,(1-Beta_E_0_4_Large_Group*T_P)])); end
                                            if Person_Profile(Subgroup_N_Leisure(CounterXX,CounterA,Gear),2)==2, Transmission_Probability = sum(rand >= cumsum([0,Beta_E_5_19_Large_Group*T_P,(1-Beta_E_5_19_Large_Group*T_P)])); end
                                            if Person_Profile(Subgroup_N_Leisure(CounterXX,CounterA,Gear),2)==3, Transmission_Probability = sum(rand >= cumsum([0,Beta_E_Adult_Large_Group*T_P,(1-Beta_E_Adult_Large_Group*T_P)])); end 
                                            if Person_Profile(Subgroup_N_Leisure(CounterXX,CounterA,Gear),2)==4, Transmission_Probability = sum(rand >= cumsum([0,Beta_E_Older_Adult_Large_Group*T_P,(1-Beta_E_Older_Adult_Large_Group*T_P)])); end

                                            if Transmission_Probability == 1
                                                if Person_Profile(Subgroup_N_Leisure(CounterB,CounterA,Gear),36)<3 && Person_Profile(Subgroup_N_Leisure(CounterB,CounterA,Gear),49)==0 % Only transmit virus if the person is not self-isolating or admitted
                                                    Person_Profile(Subgroup_N_Leisure(CounterXX,CounterA,Gear),9)=1; % This person now becomes infected
                                                    if Person_Profile(Subgroup_N_Leisure(CounterB,CounterA,Gear),39) == 0 % Only count an infection if it is community acquired (i.e. not a returning traveller)
                                                        Person_Profile(Subgroup_N_Leisure(CounterB,CounterA,Gear),32) = Person_Profile(Subgroup_N_Leisure(CounterB,CounterA,Gear),32) + 1;
                                                        Person_Profile(Subgroup_N_Leisure(CounterB,CounterA,Gear),46) = Person_Profile(Subgroup_N_Leisure(CounterB,CounterA,Gear),46) + 1;
                                                        % The next 3 lines contribute to the building of a contact matrix which allows daily R0 to be calculated:
                                                        Infective_Period = Person_Profile(Subgroup_N_Leisure(CounterB,CounterA,Gear),41)+Person_Profile(Subgroup_N_Leisure(CounterB,CounterA,Gear),42); %This calculates E2+I
                                                        Daily_Persons_Infected_x_IP=Daily_Persons_Infected_x_IP+Infective_Period;
                                                        Daily_Infections(Person_Profile(Subgroup_N_Leisure(CounterB,CounterA,Gear),1),Day_Count) = Daily_Infections(Person_Profile(Subgroup_N_Leisure(CounterB,CounterA,Gear),1),Day_Count)+1;
                                                    end
                                                    
                                                    Transmission_No = Transmission_No + 1;
                                                    Daily_I1_Number = Daily_I1_Number + 1;
                                                    
                                                    Transmission_Leisure(Context_No) = Transmission_Leisure(Context_No)+1;
                                                    Transmission_Probability = 0;
                                                else
                                                    if Person_Profile(Subgroup_N_Leisure(CounterB,CounterA,Gear),49)==1
                                                        Transmissions_Avoided(Context_No) = Transmissions_Avoided(Context_No) + 1;
                                                    end
                                                end
                                            end
                                        end
                                    end
                                   
                            end
                        end
                    end
                end
                
                

              % 5 = Transmission via friendship and kin groups
                % What Group is being indexed/extracted?: All people in known Friends groups meeting in the evening
               
                    Gear = Weekday; 
                    for CounterA = 1:No_Subgroups_Friends(Gear)
                        Infected_No = 0;
                        Recovered_No = 0;
                        Transmission_No = 0;
                        Transmission_Probability = 0;
                        %For Friends, we buid in a system whereby only a small number of people have contact in one visit. 
                        %For this we use the Friends_and_Kin_Visit_Size_M and Friends_and_Kin_Visit_Size_SD variables.
                        Friends_Visitor_N = abs(ceil(normrnd(Friends_and_Kin_Visit_Size_M,Friends_and_Kin_Visit_Size_SD)));
                        if Subgroup_N_Friends_Rows(CounterA,Gear) > Friends_Visitor_N
                            Friends_Visitor_Who = randperm(Subgroup_N_Friends_Rows(CounterA,Gear),Friends_Visitor_N);
                        else
                            Friends_Visitor_Who = Subgroup_N_Friends_Rows(CounterA,Gear);
                        end
                          
                        
                        for CounterB = 1:Subgroup_N_Friends_Rows(CounterA,Gear)
                            % These lines check if both the donor and the recipient are on the smaller list...
                            Is_Friend_Present = ismember(CounterB,Friends_Visitor_Who); % Check if friend is present in this group
                                
                            if Is_Friend_Present == 1 %Only proceed if the friend is present in the group
                                if Person_Profile(Subgroup_N_Friends(CounterB,CounterA,Gear),9) == 2 || Person_Profile(Subgroup_N_Friends(CounterB,CounterA,Gear),9) == 3
                                    if Person_Profile(Subgroup_N_Friends(CounterB,CounterA,Gear),36)<3 && Person_Profile(Subgroup_N_Friends(CounterB,CounterA,Gear),49)==0 % Only count as Potential E2 or I if agent is not self-isolating OR managed
                                        Daily_Infectors(Person_Profile(Subgroup_N_Friends(CounterB,CounterA,Gear),1),Day_Count) = 1;
                                    end
                                    
                                    for CounterXX = 1:Subgroup_N_Friends_Rows(CounterA,Gear) %Go through the whole group and manage transmission sequentially
                                        Is_Friend_Present = ismember(CounterXX,Friends_Visitor_Who); % Check if friend is present in this group
                                            
                                        if Is_Friend_Present == 1 %Only proceed if the friend is present in the group

                                            if Person_Profile(Subgroup_N_Friends(CounterXX,CounterA,Gear),9) == 0
                                                if Person_Profile(Subgroup_N_Friends(CounterB,CounterA,Gear),43) == 1 %Is the Source Agent asymptomatic?
                                                    T_P = 1 * Person_Profile(Subgroup_N_Friends(CounterB,CounterA,Gear),44); 
                                                else
                                                    T_P = Perc_Asymptomatic_Transmission/100 * Person_Profile(Subgroup_N_Friends(CounterB,CounterA,Gear),44); 
                                                end

                                                if Person_Profile(Subgroup_N_Friends(CounterXX,CounterA,Gear),2)==1, Transmission_Probability = sum(rand >= cumsum([0,Beta_E_0_4_Friends_Group*T_P,(1-Beta_E_0_4_Friends_Group*T_P)])); end
                                                if Person_Profile(Subgroup_N_Friends(CounterXX,CounterA,Gear),2)==2, Transmission_Probability = sum(rand >= cumsum([0,Beta_E_5_19_Friends_Group*T_P,(1-Beta_E_5_19_Friends_Group*T_P)])); end
                                                if Person_Profile(Subgroup_N_Friends(CounterXX,CounterA,Gear),2)==3, Transmission_Probability = sum(rand >= cumsum([0,Beta_E_Adult_Friends_Group*T_P,(1-Beta_E_Adult_Friends_Group*T_P)])); end 
                                                if Person_Profile(Subgroup_N_Friends(CounterXX,CounterA,Gear),2)==4, Transmission_Probability = sum(rand >= cumsum([0,Beta_E_Older_Adult_Friends_Group*T_P,(1-Beta_E_Older_Adult_Friends_Group*T_P)])); end 


                                                if Transmission_Probability == 1
                                                    if Person_Profile(Subgroup_N_Friends(CounterB,CounterA,Gear),36)<3 && Person_Profile(Subgroup_N_Friends(CounterB,CounterA,Gear),49)==0 % Only transmit virus if the person is not self-isolating or admitted
                                                        Person_Profile(Subgroup_N_Friends(CounterXX,CounterA,Gear),9)=1; % This person now becomes infected
                                                        if Person_Profile(Subgroup_N_Friends(CounterB,CounterA,Gear),39) == 0 % Only count an infection if it is community acquired (i.e. not a returning traveller)
                                                            Person_Profile(Subgroup_N_Friends(CounterB,CounterA,Gear),32) = Person_Profile(Subgroup_N_Friends(CounterB,CounterA,Gear),32) + 1;
                                                            Person_Profile(Subgroup_N_Friends(CounterB,CounterA,Gear),46) = Person_Profile(Subgroup_N_Friends(CounterB,CounterA,Gear),46) + 1;
                                                            % The next 3 lines contribute to the building of a contact matrix which allows daily R0 to be calculated:
                                                            Infective_Period = Person_Profile(Subgroup_N_Friends(CounterB,CounterA,Gear),41)+Person_Profile(Subgroup_N_Friends(CounterB,CounterA,Gear),42); %This calculates E2+I
                                                            Daily_Persons_Infected_x_IP=Daily_Persons_Infected_x_IP+Infective_Period;
                                                            Daily_Infections(Person_Profile(Subgroup_N_Friends(CounterB,CounterA,Gear),1),Day_Count) = Daily_Infections(Person_Profile(Subgroup_N_Friends(CounterB,CounterA,Gear),1),Day_Count)+1;
                                                        end
                                                        
                                                        Transmission_No = Transmission_No + 1;
                                                        Daily_I1_Number = Daily_I1_Number + 1;
                                                        
                                                        Transmission_Friends(Context_No) = Transmission_Friends(Context_No)+1;
                                                        Transmission_Probability = 0;
                                                    else
                                                        if Person_Profile(Subgroup_N_Friends(CounterB,CounterA,Gear),49)==1
                                                            Transmissions_Avoided(Context_No) = Transmissions_Avoided(Context_No) + 1;
                                                        end
                                                    end
                                                end
                                            end
                                        end
                                    end
                                    
                                end
                            end
                        end
                    end




                % Transmission via Family Members - This block must be calculated last
                %
                    for CounterA = 1:No_Subgroups_Family
                        
                        Infected_No = 0;
                        Recovered_No = 0;
                        Transmission_No = 0;
                        Transmission_Probability = 0;
                        for CounterB = 1:Subgroup_N_Family_Rows(CounterA)
                           
                            if Subgroup_N_Family(CounterB,CounterA) > 0 %Failsafe 
                                if Person_Profile(Subgroup_N_Family(CounterB,CounterA),9) == 2 || Person_Profile(Subgroup_N_Family(CounterB,CounterA),9) == 3
                                    if Person_Profile(Subgroup_N_Family(CounterB,CounterA),36)<3 && Person_Profile(Subgroup_N_Family(CounterB,CounterA),49)==0 % Only count as Potential E2 or I if agent is not self-isolating OR managed
                                        Daily_Infectors(Person_Profile(Subgroup_N_Family(CounterB,CounterA),1),Day_Count) = 1;
                                    end
                                        
                                        for CounterXX = 1:Subgroup_N_Family_Rows(CounterA) %Go through the whole group and manage transmission sequentially
                                            if Subgroup_N_Family(CounterXX,CounterA)~=0 %Failsafe
                                                if Person_Profile(Subgroup_N_Family(CounterXX,CounterA),9) == 0 %If receiving person is susceptible
                                                    if Person_Profile(Subgroup_N_Family(CounterB,CounterA),43) == 1 %Is the Source Agent asymptomatic?
                                                        T_P = 1 * Person_Profile(Subgroup_N_Family(CounterB,CounterA),44);
                                                    else
                                                        T_P = Perc_Asymptomatic_Transmission/100 * Person_Profile(Subgroup_N_Family(CounterB,CounterA),44);
                                                    end
                                                    if Person_Profile(Subgroup_N_Family(CounterB,CounterA),2)<3, Transmission_Probability = sum(rand >= cumsum([0,Beta_Family_I_is_Child*T_P,(1-Beta_Family_I_is_Child*T_P)])); end %Transmission probability here is based in whether the INFECTIVE person is child or adult!
                                                    if Person_Profile(Subgroup_N_Family(CounterB,CounterA),2)>2, Transmission_Probability = sum(rand >= cumsum([0,Beta_Family_I_is_Adult*T_P,(1-Beta_Family_I_is_Adult*T_P)])); end
                                                    if Transmission_Probability == 1

                                                        if Person_Profile(Subgroup_N_Family(CounterB,CounterA),36)<3 && Person_Profile(Subgroup_N_Family(CounterB,CounterA),49)==0 % Only transmit virus if the person is not self-isolating or admitted
                                                            Person_Profile(Subgroup_N_Family(CounterXX,CounterA),9)=1; % This person now becomes infected
                                                            if Person_Profile(Subgroup_N_Family(CounterB,CounterA),39) == 0 % Only count an infection if it is community acquired (i.e. not a returning traveller)
                                                                Person_Profile(Subgroup_N_Family(CounterB,CounterA),32) = Person_Profile(Subgroup_N_Family(CounterB,CounterA),32) + 1;
                                                                Person_Profile(Subgroup_N_Family(CounterB,CounterA),46) = Person_Profile(Subgroup_N_Family(CounterB,CounterA),46) + 1;
                                                                % The next 3 lines contribute to the building of a contact matrix which allows daily R0 to be calculated:
                                                                Infective_Period = Person_Profile(Subgroup_N_Family(CounterB,CounterA),41)+Person_Profile(Subgroup_N_Family(CounterB,CounterA),42); %This calculates E2+I
                                                                Daily_Persons_Infected_x_IP=Daily_Persons_Infected_x_IP+Infective_Period;
                                                                Daily_Infections(Person_Profile(Subgroup_N_Family(CounterB,CounterA),1),Day_Count) = Daily_Infections(Person_Profile(Subgroup_N_Family(CounterB,CounterA),1),Day_Count)+1;
                                                            end
                                                            
                                                            Transmission_No = Transmission_No + 1;
                                                            Daily_I1_Number = Daily_I1_Number + 1;
                                                            
                                                            Transmission_Family(Context_No) = Transmission_Family(Context_No)+1;
                                                            Transmission_Probability = 0;
                                                        else
                                                            if Person_Profile(Subgroup_N_Family(CounterB,CounterA),49)==1
                                                                Transmissions_Avoided(Context_No) = Transmissions_Avoided(Context_No) + 1;
                                                            end
                                                        end
                                                    end
                                                end
                                            else
                                                % Error check message removed
                                            end
                                        end
                                        
                                end
                            end
                        end
                    end
               

               
