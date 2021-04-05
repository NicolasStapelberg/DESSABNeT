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
    
    
        %% Medical Sequelae Code Block
        
            % This module identifies new infective cases and allocates them to a hospital stay and possibly ICU, where some people then die
          
            
            

                Days_Hospital_ALOS = 11; 
                Days_Hosp_ALOS_ICU = 8;
                Days_Illness_to_ICU = 12;
                Days_ICU_to_Death = 2;
                Days_Hospital_Residual_ALOS = 1; % Days_Illness_to_ICU - Days_Hospital_ALOS

                Perc_Hospitalisation_Under_5 = 0.06; %Percentage of symptomatic infected
                Perc_Hospitalisation_School_5_19 = 0.06; 
                Perc_Hospitalisation_Adult_20_64 = 5.874; 
                Perc_Hospitalisation_Over_65 = 44.63; 

                Perc_ICU_of_Admitted_Under_5 = 33.333; %Proportion of admitted cases requiring ICU
                Perc_ICU_of_Admitted_School_5_19 = 33.333;
                Perc_ICU_of_Admitted_Adult_20_64 = 29.385;
                Perc_ICU_of_Admitted_Over_65 = 29.363;

                Perc_Death_Rate_ICU_0_4 = 0; %Proportion of ICU cases who died
                Perc_Death_Rate_ICU_5_19 = 0.1;
                Perc_Death_Rate_ICU_20_64 = 3.544;
                Perc_Death_Rate_ICU_Over_65 = 31.9;
        
                
                if Day_Count == 1 % This will zero these values at the start of a run.
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
                    
                    Daily_Community_Incidence = 0;
                    Daily_M_Number = 0;
                    
                end
                
          
          % If an agent is symptomatic, it is assumed they will seek medical attention 
          % If an agent is asymptomatic, they won't know to seek medical attention
          

          %% Code for Person_Profile(:,36):
            %{    
            0 = Null
            1 = Infected but hasn't seen a doctor yet 
            
            3 = Admitted to Hospital
            4 = Admitted to ICU
            5 = Died
            6 = Self-Isolation because not feeling well.
            7 = Continued Hospital Admission
            8 = Continued ICU Admission
            9 = ICU and dying
            %}
          
          %% Code for Person_Profile(:,9):
                % 0 = Susceptible (S)
                % 1 = Exposure1 or incubation period and is determined on a lognormal distibution ending in 14 days (minus 2 days = 12 days max)
                % 2 = Exposure2. Agents are shedding virus but not yet symptomatic. This is fixed at 2 days.
                % 3 = Infective (I) period. This is currently set at 10 days. Agents are shedding virus
                % 4 = Recovered (R)
                % 5 = Managed (M)
                % 6 = Death (D)    
                
                
          for CounterID = 1:Population
                % If the counters are > 0, then keep counting.
                if Person_Profile(CounterID,38) > 0  % This is a counter for number of days spent in a given medical scenario, e.g. a medical bed
                   Person_Profile(CounterID,38)=Person_Profile(CounterID,38)+1; %Advance Person_Profile(CounterID,38) for evey infected agent, every day.
                   Person_Profile(CounterID,48)=Person_Profile(CounterID,48)+1; %Advance Person_Profile(CounterID,38) for evey infected agent, every day.
                end
                
              % We only check people who are infective here, as agents in E2 are asymptomatic
              % Returning travellers also end up in hospital, inflating the M container. Quarantine must also be added to the M container, thus agents can't be double counted.
               if Person_Profile(CounterID,9)==3 && Person_Profile(CounterID,43) == 1 %Calculate only for cases of Infection && Only if this person is symptomatic will they seek medical attention.  
                   %% Person_Profile(CounterID,36) = 0: When do Agents seek Medical Attention?
                   if Person_Profile(CounterID,36) == 0 
                          Person_Profile(CounterID,36) = 1;
                          if Person_Profile(CounterID,45) == 0, Person_Profile(CounterID,45)=1; end 
                          Person_Profile(CounterID,37) = Person_Profile(CounterID,45); % Column 45 lists days to seek medical attention/ get a test
                          Person_Profile(CounterID,38) = 1;
                          Person_Profile(CounterID,48) = 1;
                   end
               end
               %}
                  %% Person_Profile(CounterID,36) = 1: Hospital or Home?
                  if Person_Profile(CounterID,36)== 1 && Person_Profile(CounterID,38) == Person_Profile(CounterID,37) % Column 45 lists days to seek medical attention/ get a test
                  
                  % This Agent now moves to the Managed Container
                  Person_Profile(CounterID,9) = 5;
                  Daily_M_Number = Daily_M_Number + 1;
                  Person_Profile(CounterID,49)=0; Person_Profile(CounterID,50)=0; %Take the person out of quarantine
                  if Person_Profile(CounterID,39) ~= 1,Daily_Community_Incidence = Daily_Community_Incidence + 1; end %Only count the person towards Daily_Community_Incidence if they are not a Returning Traveller
                  

                          % Descision Point: Hospital or Home?
                          if Person_Profile(CounterID,2)==1, Hosp1 = sum(rand >= cumsum([0,Perc_Hospitalisation_Under_5/100, (100-Perc_Hospitalisation_Under_5)/100]));end
                          if Person_Profile(CounterID,2)==2, Hosp1 = sum(rand >= cumsum([0,Perc_Hospitalisation_School_5_19/100, (100-Perc_Hospitalisation_School_5_19)/100]));end
                          if Person_Profile(CounterID,2)==3, Hosp1 = sum(rand >= cumsum([0,Perc_Hospitalisation_Adult_20_64/100, (100-Perc_Hospitalisation_Adult_20_64)/100]));end
                          if Person_Profile(CounterID,2)==4, Hosp1 = sum(rand >= cumsum([0,Perc_Hospitalisation_Over_65/100, (100-Perc_Hospitalisation_Over_65)/100]));end

                          if Hosp1 == 2 % Positive but not admitted. Go home and rest for as long as symptomatic 
                              Person_Profile(CounterID,36) = 6;
                              Person_Profile(CounterID,37) = Person_Profile(CounterID,42); %Agents will isolate as long as they feel unwell
                              Person_Profile(CounterID,38) = 1;
                              %Person_Profile(CounterID,49) = 1; % Person is effectively quarantined
                              %
                              if Person_Profile(CounterID,2)==1, Daily_Rx_Home_Kindy = Daily_Rx_Home_Kindy + 1; end
                              if Person_Profile(CounterID,2)==2, Daily_Rx_Home_School = Daily_Rx_Home_School + 1; end
                              if Person_Profile(CounterID,2)==3, Daily_Rx_Home_Adult = Daily_Rx_Home_Adult + 1; end
                              if Person_Profile(CounterID,2)==4, Daily_Rx_Home_Older_Adult = Daily_Rx_Home_Older_Adult + 1; end
                              %}
                          end
                          if Hosp1 == 1 % Admitted to Hospital
                              
                              if Person_Profile(CounterID,2)==1, Daily_Hosp_Kindy = Daily_Hosp_Kindy + 1; end
                              if Person_Profile(CounterID,2)==2, Daily_Hosp_School = Daily_Hosp_School + 1; end
                              if Person_Profile(CounterID,2)==3, Daily_Hosp_Adult = Daily_Hosp_Adult + 1; end
                              if Person_Profile(CounterID,2)==4, Daily_Hosp_Older_Adult = Daily_Hosp_Older_Adult + 1; end
                              Person_Profile(CounterID,36) = 7;
                              
                              Hosp_Norm_Rand = normrnd(log(Days_Hospital_ALOS),log(1.2)); % Create log-normal distribution of length of stay
                              Hosp_Norm_Rand = round(exp(Hosp_Norm_Rand),0);
                              if Hosp_Norm_Rand == 0, Hosp_Norm_Rand = 1; end
                              Person_Profile(CounterID,37) = Hosp_Norm_Rand;
                              Person_Profile(CounterID,38) = 1;
                          end
                  end
                          
                  %% Person_Profile(CounterID,36) = 6: Treatment at Home
                  if Person_Profile(CounterID,36)==6
                        if Person_Profile(CounterID,38) == Person_Profile(CounterID,37)
                            
                            Person_Profile(CounterID,36) = 0; % Discharge and return to the community
                            Person_Profile(CounterID,37) = 0; % Reset to 0
                            Person_Profile(CounterID,38) = 0; % Reset to 0
                            % This Agent now moves to the Recovered Container
                            Person_Profile(CounterID,9) = 4;
                        end
                  end
                  
                  %% Person_Profile(CounterID,36) = 7: Hospitalisation and DC from both Medical Ward
                  if Person_Profile(CounterID,36)==7
                        if Person_Profile(CounterID,38) == Person_Profile(CounterID,37)
                                  % Descision point: Admission to ICU OR hospital?
                                  if Person_Profile(CounterID,2)==1, Hosp_ICU = sum(rand >= cumsum([0,Perc_ICU_of_Admitted_Under_5/100, (100-Perc_ICU_of_Admitted_Under_5)/100]));end
                                  if Person_Profile(CounterID,2)==2, Hosp_ICU = sum(rand >= cumsum([0,Perc_ICU_of_Admitted_School_5_19/100, (100-Perc_ICU_of_Admitted_School_5_19)/100]));end
                                  if Person_Profile(CounterID,2)==3, Hosp_ICU = sum(rand >= cumsum([0,Perc_ICU_of_Admitted_Adult_20_64/100, (100-Perc_ICU_of_Admitted_Adult_20_64)/100]));end
                                  if Person_Profile(CounterID,2)==4, Hosp_ICU = sum(rand >= cumsum([0,Perc_ICU_of_Admitted_Over_65/100, (100-Perc_ICU_of_Admitted_Over_65)/100]));end

                                  if Hosp_ICU == 1 % Admission to ICU
                                          if Person_Profile(CounterID,2)==1, Daily_ICU_Kindy = Daily_ICU_Kindy + 1; end
                                          if Person_Profile(CounterID,2)==2, Daily_ICU_School = Daily_ICU_School + 1; end
                                          if Person_Profile(CounterID,2)==3, Daily_ICU_Adult = Daily_ICU_Adult + 1; end
                                          if Person_Profile(CounterID,2)==4, Daily_ICU_Older_Adult = Daily_ICU_Older_Adult + 1; end
                                          
                                          Person_Profile(CounterID,36) = 4;
                                          ICU_Norm_Rand = normrnd(log(Days_Hosp_ALOS_ICU),log(1.2)); % Create log-normal distribution of LOS
                                          ICU_Norm_Rand = round(exp(ICU_Norm_Rand),0);
                                          if ICU_Norm_Rand == 0, ICU_Norm_Rand = 1; end
                                          Person_Profile(CounterID,37) = ICU_Norm_Rand;
                                          Person_Profile(CounterID,38) = 1;
                                  end
                                  if Hosp_ICU == 2 % Discharge from hospital
                                        Person_Profile(CounterID,36) = 0; % Discharge and return to the community
                                        Person_Profile(CounterID,37) = 0; % Reset to 0
                                        Person_Profile(CounterID,38) = 0; % Reset to 0
                                        % This Agent now moves to the Recovered Container
                                        Person_Profile(CounterID,9) = 4;
                                  end
                                  
                        end   
                                  
                  end
                  
                  %% Person_Profile(CounterID,36) = 4: Treatment and DC ICU
                  if Person_Profile(CounterID,36)==4
                        if Person_Profile(CounterID,38) == Person_Profile(CounterID,37)
                              % Descision Point: Death or ICU?    
                              if Person_Profile(CounterID,2)==1, Death = sum(rand >= cumsum([0,Perc_Death_Rate_ICU_0_4/100, (100-Perc_Death_Rate_ICU_0_4)/100]));end
                              if Person_Profile(CounterID,2)==2, Death = sum(rand >= cumsum([0,Perc_Death_Rate_ICU_5_19/100, (100-Perc_Death_Rate_ICU_5_19)/100]));end
                              if Person_Profile(CounterID,2)==3, Death = sum(rand >= cumsum([0,Perc_Death_Rate_ICU_20_64/100, (100-Perc_Death_Rate_ICU_20_64)/100]));end
                              if Person_Profile(CounterID,2)==4, Death = sum(rand >= cumsum([0,Perc_Death_Rate_ICU_Over_65/100, (100-Perc_Death_Rate_ICU_Over_65)/100]));end

                              if Death == 1 % ICU and Death
                                  Person_Profile(CounterID,36) = 9; % Agent will die after set number of days in ICU
                                  Death_Norm_Rand = normrnd(log(Days_ICU_to_Death),log(1.2)); % Create log-normal distribution of length of stay
                                  Death_Norm_Rand = round(exp(Death_Norm_Rand),0);
                                  if Death_Norm_Rand == 0, Death_Norm_Rand = 1; end
                                  Person_Profile(CounterID,37) = Death_Norm_Rand;
                                  Person_Profile(CounterID,38) = 1;
                              end
                              if Death == 2 % Agent will survive, Discharge from ICU
                                    Person_Profile(CounterID,36) = 0; % Discharge and return to the community
                                    Person_Profile(CounterID,37) = 0; % Reset to 0
                                    Person_Profile(CounterID,38) = 0; % Reset to 0
                                    % This Agent now moves to the Recovered Container
                                    Person_Profile(CounterID,9) = 4;
                              end
                        end
                  end
                  
                  
                  
                  %% Person_Profile(CounterID,36) = 9: ICU and Death
                  if Person_Profile(CounterID,36)==9
                        if Person_Profile(CounterID,38) == Person_Profile(CounterID,37)
                            if Person_Profile(CounterID,2)==1, Daily_Death_Kindy = Daily_Death_Kindy + 1; end
                            if Person_Profile(CounterID,2)==2, Daily_Death_School = Daily_Death_School + 1; end
                            if Person_Profile(CounterID,2)==3, Daily_Death_Adult = Daily_Death_Adult + 1; end
                            if Person_Profile(CounterID,2)==4, Daily_Death_Older_Adult = Daily_Death_Older_Adult + 1; end
                            Person_Profile(CounterID,36) = 5; % Death of Agent
                            Person_Profile(CounterID,37) = 0; 
                            Person_Profile(CounterID,38) = 0;
                            % This Agent now moves to the Death Container
                            Person_Profile(CounterID,9) = 6;
                            Daily_D_Number = Daily_D_Number + 1;
                        end
                  end
                  
          end
         
          