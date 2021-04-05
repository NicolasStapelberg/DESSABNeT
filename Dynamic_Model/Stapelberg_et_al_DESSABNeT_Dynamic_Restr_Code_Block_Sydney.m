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

                         

            %% Module to Change Restrictions on the Appropriate Day:
                            
                            if Day_Count == Day_One_of_B
                                Contact_Tracing_Factor = Contact_Tracing_Factor_On;
                                Context_No = Context_No+1;
                                No_Subgroups_Work=Index_Variables_B.No_Subgroups_Work;
                                Subgroup_N_Work_Rows=Index_Variables_B.Subgroup_N_Work_Rows;
                                Subgroup_N_Work=Index_Variables_B.Subgroup_N_Work;
                                No_Subgroups_Social=Index_Variables_B.No_Subgroups_Social;
                                Subgroup_N_Social_Rows=Index_Variables_B.Subgroup_N_Social_Rows;
                                Subgroup_N_Social=Index_Variables_B.Subgroup_N_Social;
                                No_Subgroups_PublicT=Index_Variables_B.No_Subgroups_PublicT;
                                Subgroup_N_PublicT_Rows=Index_Variables_B.Subgroup_N_PublicT_Rows;
                                Subgroup_N_PublicT=Index_Variables_B.Subgroup_N_PublicT;
                                No_Subgroups_Essential=Index_Variables_B.No_Subgroups_Essential;
                                Subgroup_N_Essential_Rows=Index_Variables_B.Subgroup_N_Essential_Rows;
                                Subgroup_N_Essential=Index_Variables_B.Subgroup_N_Essential;
                                No_Subgroups_Leisure=Index_Variables_B.No_Subgroups_Leisure;
                                Subgroup_N_Leisure_Rows=Index_Variables_B.Subgroup_N_Leisure_Rows;
                                Subgroup_N_Leisure=Index_Variables_B.Subgroup_N_Leisure;
                                No_Subgroups_Friends=Index_Variables_B.No_Subgroups_Friends;
                                Subgroup_N_Friends_Rows=Index_Variables_B.Subgroup_N_Friends_Rows;
                                Subgroup_N_Friends=Index_Variables_B.Subgroup_N_Friends;
                                No_Subgroups_Family=Index_Variables_B.No_Subgroups_Family;
                                Subgroup_N_Family_Rows=Index_Variables_B.Subgroup_N_Family_Rows;
                                Subgroup_N_Family=Index_Variables_B.Subgroup_N_Family;
                                
                                fprintf('%s\t','Phase2  Phase3'); 
                            end
                            if Day_Count == Day_One_of_C
                                Contact_Tracing_Factor = Contact_Tracing_Factor_On;
                                Context_No = Context_No+1;
                                No_Subgroups_Work=Index_Variables_C.No_Subgroups_Work;
                                Subgroup_N_Work_Rows=Index_Variables_C.Subgroup_N_Work_Rows;
                                Subgroup_N_Work=Index_Variables_C.Subgroup_N_Work;
                                No_Subgroups_Social=Index_Variables_C.No_Subgroups_Social;
                                Subgroup_N_Social_Rows=Index_Variables_C.Subgroup_N_Social_Rows;
                                Subgroup_N_Social=Index_Variables_C.Subgroup_N_Social;
                                No_Subgroups_PublicT=Index_Variables_C.No_Subgroups_PublicT;
                                Subgroup_N_PublicT_Rows=Index_Variables_C.Subgroup_N_PublicT_Rows;
                                Subgroup_N_PublicT=Index_Variables_C.Subgroup_N_PublicT;
                                No_Subgroups_Essential=Index_Variables_C.No_Subgroups_Essential;
                                Subgroup_N_Essential_Rows=Index_Variables_C.Subgroup_N_Essential_Rows;
                                Subgroup_N_Essential=Index_Variables_C.Subgroup_N_Essential;
                                No_Subgroups_Leisure=Index_Variables_C.No_Subgroups_Leisure;
                                Subgroup_N_Leisure_Rows=Index_Variables_C.Subgroup_N_Leisure_Rows;
                                Subgroup_N_Leisure=Index_Variables_C.Subgroup_N_Leisure;
                                No_Subgroups_Friends=Index_Variables_C.No_Subgroups_Friends;
                                Subgroup_N_Friends_Rows=Index_Variables_C.Subgroup_N_Friends_Rows;
                                Subgroup_N_Friends=Index_Variables_C.Subgroup_N_Friends;
                                No_Subgroups_Family=Index_Variables_C.No_Subgroups_Family;
                                Subgroup_N_Family_Rows=Index_Variables_C.Subgroup_N_Family_Rows;
                                Subgroup_N_Family=Index_Variables_C.Subgroup_N_Family;
                                
                                fprintf('%s','Phase4'); 
                            end
                            
                          
                           
                           %Progression of days
                            Weekday = Weekday + 1;
                            if Weekday == 8, Weekday = 1; end
