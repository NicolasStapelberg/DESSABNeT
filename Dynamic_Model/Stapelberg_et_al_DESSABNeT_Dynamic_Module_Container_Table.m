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
    
    
      %% Calculate and Present Container Data, Create Table and Save it to File:
      
        
        
        for Context_Counter = 1:Global_N_Contexts
             Container(Run_Counter,1,Context_Counter)=Run_Counter;
             Transmission_Total = Transmission_Kindy(Context_Counter) + Transmission_School(Context_Counter) + Transmission_Work(Context_Counter) + Transmission_Social(Context_Counter) + Transmission_Public_T(Context_Counter) + Transmission_Essential(Context_Counter) + Transmission_Leisure(Context_Counter) + Transmission_Friends(Context_Counter) + Transmission_Family(Context_Counter);
             Container(Run_Counter,2,Context_Counter)=Transmission_Total;
             Container(Run_Counter,3,Context_Counter)=Transmission_Family(Context_Counter);
             Container(Run_Counter,4,Context_Counter)=Transmission_Friends(Context_Counter);
             Container(Run_Counter,5,Context_Counter)=Transmission_Work(Context_Counter);
             Container(Run_Counter,6,Context_Counter)=Transmission_School(Context_Counter);
             Container(Run_Counter,7,Context_Counter)=Transmission_Kindy(Context_Counter);
             
             Container(Run_Counter,8,Context_Counter)=Transmission_Public_T(Context_Counter);
             Container(Run_Counter,9,Context_Counter)=Transmission_Essential(Context_Counter);
             Container(Run_Counter,10,Context_Counter)=Transmission_Social(Context_Counter);
             Container(Run_Counter,11,Context_Counter)=Transmission_Leisure(Context_Counter);
             
             Container(Run_Counter,12,Context_Counter)=Transmissions_Avoided(Context_Counter);
             Container(Run_Counter,13,Context_Counter)=R_Number/Population*100;
             Container(Run_Counter,14,Context_Counter)=R_Zero(Day_Count); 
             Container(Run_Counter,15,Context_Counter)=Context_Counter;
        end

             
       if Run_Counter == How_Many_Runs
          for Context_Counter = 1:Global_N_Contexts 
            for Col_Ctr = 2:12
              Container(Run_Counter+1,Col_Ctr,Context_Counter) = round(mean(Container(:,Col_Ctr,Context_Counter)),2);
              Container(Run_Counter+2,Col_Ctr,Context_Counter) = round(100*mean(Container(:,Col_Ctr,Context_Counter))/mean(Container(:,2,Context_Counter)),2);
            end 
          end
          Container(Run_Counter+1,1,1) = 0;
          Container(Run_Counter+1,13,3) = 0;
          Container(Run_Counter+1,14,3) = 0;
          Container(Run_Counter+2,1,1) = 0;
          Container(Run_Counter+2,13,3) = 0;
          Container(Run_Counter+2,14,3) = 0;
          
          Container_T = table;
              Container_T.Run_No=Container(:,1,1);
              for Context_Counter = 1:Global_N_Contexts
                  if Context_Counter == 1
                    Container_T.Total_Transmission_1=Container(:,2,Context_Counter);
                    Container_T.Transmission_Family_1=Container(:,3,Context_Counter);
                    Container_T.Transmission_Friends_1=Container(:,4,Context_Counter);
                    Container_T.Transmission_Work_1=Container(:,5,Context_Counter);
                    Container_T.Transmission_School_1=Container(:,6,Context_Counter);
                    Container_T.Transmission_Preschool_1=Container(:,7,Context_Counter);
                    Container_T.Transmission_Public_T_1=Container(:,8,Context_Counter);
                    Container_T.Transmission_Essential_1=Container(:,9,Context_Counter);
                    Container_T.Transmission_Groups_100_People_1=Container(:,10,Context_Counter);
                    Container_T.Transmission_Groups_500_People_1=Container(:,11,Context_Counter);
                    Container_T.Transmissions_Avoided_1=Container(:,12,Context_Counter);
                  end
                  if Context_Counter == 2
                    Container_T.Total_Transmission_2=Container(:,2,Context_Counter);
                    Container_T.Transmission_Family_2=Container(:,3,Context_Counter);
                    Container_T.Transmission_Friends_2=Container(:,4,Context_Counter);
                    Container_T.Transmission_Work_2=Container(:,5,Context_Counter);
                    Container_T.Transmission_School_2=Container(:,6,Context_Counter);
                    Container_T.Transmission_Preschool_2=Container(:,7,Context_Counter);
                    Container_T.Transmission_Public_T_2=Container(:,8,Context_Counter);
                    Container_T.Transmission_Essential_2=Container(:,9,Context_Counter);
                    Container_T.Transmission_Groups_100_People_2=Container(:,10,Context_Counter);
                    Container_T.Transmission_Groups_500_People_2=Container(:,11,Context_Counter);
                    Container_T.Transmissions_Avoided_2=Container(:,12,Context_Counter);
                  end
                  if Context_Counter == 3
                    Container_T.Total_Transmission_3=Container(:,2,Context_Counter);
                    Container_T.Transmission_Family_3=Container(:,3,Context_Counter);
                    Container_T.Transmission_Friends_3=Container(:,4,Context_Counter);
                    Container_T.Transmission_Work_3=Container(:,5,Context_Counter);
                    Container_T.Transmission_School_3=Container(:,6,Context_Counter);
                    Container_T.Transmission_Preschool_3=Container(:,7,Context_Counter);
                    Container_T.Transmission_Public_T_3=Container(:,8,Context_Counter);
                    Container_T.Transmission_Essential_3=Container(:,9,Context_Counter);
                    Container_T.Transmission_Groups_100_People_3=Container(:,10,Context_Counter);
                    Container_T.Transmission_Groups_500_People_3=Container(:,11,Context_Counter);
                    Container_T.Transmissions_Avoided_3=Container(:,12,Context_Counter);
                  end
                  if Context_Counter == 4
                    Container_T.Total_Transmission_4=Container(:,2,Context_Counter);
                    Container_T.Transmission_Family_4=Container(:,3,Context_Counter);
                    Container_T.Transmission_Friends_4=Container(:,4,Context_Counter);
                    Container_T.Transmission_Work_4=Container(:,5,Context_Counter);
                    Container_T.Transmission_School_4=Container(:,6,Context_Counter);
                    Container_T.Transmission_Preschool_4=Container(:,7,Context_Counter);
                    Container_T.Transmission_Public_T_4=Container(:,8,Context_Counter);
                    Container_T.Transmission_Essential_4=Container(:,9,Context_Counter);
                    Container_T.Transmission_Groups_100_People_4=Container(:,10,Context_Counter);
                    Container_T.Transmission_Groups_500_People_4=Container(:,11,Context_Counter);
                    Container_T.Transmissions_Avoided_4=Container(:,12,Context_Counter);
                  end
                  if Context_Counter == 5
                    Container_T.Total_Transmission_5=Container(:,2,Context_Counter);
                    Container_T.Transmission_Family_5=Container(:,3,Context_Counter);
                    Container_T.Transmission_Friends_5=Container(:,4,Context_Counter);
                    Container_T.Transmission_Work_5=Container(:,5,Context_Counter);
                    Container_T.Transmission_School_5=Container(:,6,Context_Counter);
                    Container_T.Transmission_Preschool_5=Container(:,7,Context_Counter);
                    Container_T.Transmission_Public_T_5=Container(:,8,Context_Counter);
                    Container_T.Transmission_Essential_5=Container(:,9,Context_Counter);
                    Container_T.Transmission_Groups_100_People_5=Container(:,10,Context_Counter);
                    Container_T.Transmission_Groups_500_People_5=Container(:,11,Context_Counter);
                    Container_T.Transmissions_Avoided_5=Container(:,12,Context_Counter);
                  end
                  if Context_Counter == 6
                    Container_T.Total_Transmission_6=Container(:,2,Context_Counter);
                    Container_T.Transmission_Family_6=Container(:,3,Context_Counter);
                    Container_T.Transmission_Friends_6=Container(:,4,Context_Counter);
                    Container_T.Transmission_Work_6=Container(:,5,Context_Counter);
                    Container_T.Transmission_School_6=Container(:,6,Context_Counter);
                    Container_T.Transmission_Preschool_6=Container(:,7,Context_Counter);
                    Container_T.Transmission_Public_T_6=Container(:,8,Context_Counter);
                    Container_T.Transmission_Essential_6=Container(:,9,Context_Counter);
                    Container_T.Transmission_Groups_100_People_6=Container(:,10,Context_Counter);
                    Container_T.Transmission_Groups_500_People_6=Container(:,11,Context_Counter);
                    Container_T.Transmissions_Avoided_6=Container(:,12,Context_Counter);
                  end
                  if Context_Counter == 7
                    Container_T.Total_Transmission_7=Container(:,2,Context_Counter);
                    Container_T.Transmission_Family_7=Container(:,3,Context_Counter);
                    Container_T.Transmission_Friends_7=Container(:,4,Context_Counter);
                    Container_T.Transmission_Work_7=Container(:,5,Context_Counter);
                    Container_T.Transmission_School_7=Container(:,6,Context_Counter);
                    Container_T.Transmission_Preschool_7=Container(:,7,Context_Counter);
                    Container_T.Transmission_Public_T_7=Container(:,8,Context_Counter);
                    Container_T.Transmission_Essential_7=Container(:,9,Context_Counter);
                    Container_T.Transmission_Groups_100_People_7=Container(:,10,Context_Counter);
                    Container_T.Transmission_Groups_500_People_7=Container(:,11,Context_Counter);
                    Container_T.Transmissions_Avoided_7=Container(:,12,Context_Counter);
                  end
                  if Context_Counter == 8
                    Container_T.Total_Transmission_8=Container(:,2,Context_Counter);
                    Container_T.Transmission_Family_8=Container(:,3,Context_Counter);
                    Container_T.Transmission_Friends_8=Container(:,4,Context_Counter);
                    Container_T.Transmission_Work_8=Container(:,5,Context_Counter);
                    Container_T.Transmission_School_8=Container(:,6,Context_Counter);
                    Container_T.Transmission_Preschool_8=Container(:,7,Context_Counter);
                    Container_T.Transmission_Public_T_8=Container(:,8,Context_Counter);
                    Container_T.Transmission_Essential_8=Container(:,9,Context_Counter);
                    Container_T.Transmission_Groups_100_People_8=Container(:,10,Context_Counter);
                    Container_T.Transmission_Groups_500_People_8=Container(:,11,Context_Counter);
                    Container_T.Transmissions_Avoided_8=Container(:,12,Context_Counter);
                  end
                  if Context_Counter == 9
                    Container_T.Total_Transmission_9=Container(:,2,Context_Counter);
                    Container_T.Transmission_Family_9=Container(:,3,Context_Counter);
                    Container_T.Transmission_Friends_9=Container(:,4,Context_Counter);
                    Container_T.Transmission_Work_9=Container(:,5,Context_Counter);
                    Container_T.Transmission_School_9=Container(:,6,Context_Counter);
                    Container_T.Transmission_Preschool_9=Container(:,7,Context_Counter);
                    Container_T.Transmission_Public_T_9=Container(:,8,Context_Counter);
                    Container_T.Transmission_Essential_9=Container(:,9,Context_Counter);
                    Container_T.Transmission_Groups_100_People_9=Container(:,10,Context_Counter);
                    Container_T.Transmission_Groups_500_People_9=Container(:,11,Context_Counter);
                    Container_T.Transmissions_Avoided_9=Container(:,12,Context_Counter);
                  end
                  if Context_Counter == 10
                    Container_T.Total_Transmission_10=Container(:,2,Context_Counter);
                    Container_T.Transmission_Family_10=Container(:,3,Context_Counter);
                    Container_T.Transmission_Friends_10=Container(:,4,Context_Counter);
                    Container_T.Transmission_Work_10=Container(:,5,Context_Counter);
                    Container_T.Transmission_School_10=Container(:,6,Context_Counter);
                    Container_T.Transmission_Preschool_10=Container(:,7,Context_Counter);
                    Container_T.Transmission_Public_T_10=Container(:,8,Context_Counter);
                    Container_T.Transmission_Essential_10=Container(:,9,Context_Counter);
                    Container_T.Transmission_Groups_100_People_10=Container(:,10,Context_Counter);
                    Container_T.Transmission_Groups_500_People_10=Container(:,11,Context_Counter);
                    Container_T.Transmissions_Avoided_10=Container(:,12,Context_Counter);
                  end
              end
              Container_T.Total_Perc_Infected_3=Container(:,13,Global_N_Contexts);
              Container_T.Cumulative_R_Zero_Run_3=Container(:,14,Global_N_Contexts);

              Container_File_Name = strcat('DESSABNeT_',Context_Designator,string(Population),'_Container_Data_Table.xlsx');
              writetable(Container_T,Container_File_Name); %,'Delimiter','\t','WriteRowNames',true);   
       end
             
            
             
             
               
            

