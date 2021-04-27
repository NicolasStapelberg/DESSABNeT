# DESSABNeT Readme


## Application Description

DESSABNeT is a software package written in MATLAB which uses agent-based simulation to model the spread of any communicable disease through any city or regional population. Our initial work has been on modelling the spread of SARS-CoV-2 (COVID-19) in Australian cities.
DESSABNeT employs an agent-based model (ABM) simulate artificial societies composed of agents. Agents represent cyber individuals with particular demographic characteristics, modelled on real demographic data for a city or region, including total population number, age stratification within a population, household and family structure, proportion of people working full-time, part-time or being retired, and social structure such as number of social contacts per day.

Agents are individually modelled to belong to predetermined social networks where each agent is linked to other agents in subnetworks which we call “containers”, which represent family relationships, friendship and kin relationships and work or education relationships. Each agent will also have a predetermined weekly schedule that determines the frequency of family, social and workplace contacts, but also separate random contacts in large, medium and small contact groups. The schedule for each agent can be changed over time during a simulated disease outbreak, to model social restrictions.

Disease transmission is modelled by simulating the actual daily contact between all the agents in the simulation, depending on their social network and their random contact with other agents (for example while attending a large group gathering such as a football match, or smaller gatherings such as eating out). Given the large number of agents in the simulation of a large city such as Sydney, where we modelled the daily interactions of 5,320,000 people, a very rich and complex web of interactions occurs over time. 

In order to model disease spread, each agent-agent interaction carries a situation-dependent probability of passing on the disease if one agent is disease-positive and infective. The probability of disease transmission between two agents will differ depending on whether they are both attending a football match, or if they are family members living in the same household.

To model the disease status of each agent, SEIRD-M model is used, which refers to different disease “compartments” that each agent will be subject to. The compartments used are: Susceptible (), exposed but not infectious (), exposed and infectious (), infectious (), managed (), recovered () and dead ().  The managed compartment models quarantine, self-isolation for symptomatic persons recovering at home, or hospitalisation. Please note that compartments are different from containers.

The outputs of DESSABNeT are daily prevalence and incidence values for each of the SEIRD-M compartments. Daily incident and prevalent numbers for quarantined agents, agents treated at home, those hospitalised, Intensive Care Unit (ICU) admissions and deaths are recorded within the managed compartment. Daily incident transmissions and cumulative transmissions are also output for each container (e.g. transmissions occurring at home, at work, in friendship circles, etc.).

DESSABNeT also calculates daily R0 and Reff and uses a Who Acquires Infection From Whom Matrix to calculate a reproductive number for a given set of social restrictions.

It is important to note that DESSABNeT outputs are emergent properties of the system. DESSABNeT models of daily incident data of positive cases tends to reproduce the epidemiological curves we have become familiar with for COVID-19 in the scientific literature and the media, however DESSABNeT does not have a “formula” (e.g. differential equations) for producing such curves – they are emergent from the complex model.
 
## Model Validation and Examples

We have submitted the model validation for publication:

	N.J.C. Stapelberg, N.R. Smoll, M. Randall, D. Palipana, B. Bui, K. Macartney, G. Khandaker, A. Wattiaux (In Review). 
	A Discrete-Event, Simulated Social Agent-Based Network Transmission (DESSABNeT) Model for Communicable Diseases: 
	Method and Validation Using SARS-CoV-2 Data in Three Large Australian Cities. PlosOne
	
This paper provides a more detailed description of DESSABNeT and also shows examples of model outputs for three Australian cities: Sydney, Melbourne and Gold Coast.

## Features
	
DESSABNeT has the following features:

•	DESSABNeT can accurately model a wide range of social restrictions and also the easing or reversal of restrictions. 
Examples of modelled restrictions are: 

o	working from home, 

o	restricting social visits by friends, 

o	restricting either large (around 500 people or more), medium (between 20 and 500 people) or small (up to 20 people) public or private gatherings, 

o	restricting or modelling changes in public transport 

o	and even the wearing of masks 

•	It can also model scenarios such as COVID-19 vaccination scenarios to determine herd immunity, for example

•	The model can fluidly transitioning between social restriction phases within the same simulation 

•	Because of its granularity (modelling the activities of individual people or agents) our system can work accurately 
in low prevalence settings 

•	DESSABNeT uses containers, each with different transmission probabilities. Containers could theoretically be as numerous as required to simulate different transmission scenarios, for example different workplaces such as healthcare settings (e.g. hospitals), aged care facilities 

•	Finally, the software is able to run using widely available, modest computing resources and can be run off a laptop 
if required
	
## Installation

To run the Matlab code, you will require Matlab 2019 or above.

The code is provided as .m Matlab code files, which will run, using Matlab, on any platform which supports Matlab.

## Configuration Setup
	
Matlab .m files can be loaded directly into Matlab and run.

## Usage
	
The DESSABNeT package has two main components:

•	DESSABNeT Population Setup (PS), creates social networks and weekly timetables of activity for all agents in the model. It also creates restriction scenarios as required, which are output as separate files

•	DESSABNeT Dynamic Model (DM), takes output files with variable values from DESSABNeT PS and then runs the simulation for a specific number of days. DESSABNeT DM can run a specific scenario multiple times (e.g. 100 times) to generate statistically valid data if required. It can also step through a certain 
variable (e.g. percentage of agents working from home) to model different values for a variable of interest.

Both DESSABNeT Population Setup and DESSABNeT Dynamic Model rely on multiple code modules which reside in the same folder. Settings (e.g. demographic settings) can be changed throughout the different modules, although only one master program is required to either build a Population Setup or run a Dynamic Model.

## Testing and Running DESSABNeT: Step by Step Instructions

Run DESSABNeT Population Setup first: All files are located in the following folder:

DESSABNET_Population_Setup_Final_2021

Step 1: Open Stapelberg_et_al_DESSABNeT_Setup_Demographic_Data_Sydney.m

Set values for the demographic variables, e.g. population size. In the current file these variables all have values based on demographic data for Sydney. We recommend that to rapidly trial the software, a small Population value such as 10,000 agents should be entered. 

Step 2: Open and run the file Stapelberg_et_al_DESSABNeT_Population_Setup_Master_Sydney.m 
This is a master file that will automatically run the other modules (.m files in the same folder) as required.

Step 3: DESSABNeT Population Setup generates setup files for each city/location as an output:
Examples of output files for Sydney are as follows, using a trial population of 10,000 agents:

2021_DESSABNeT_Population_Setup_Global_10000_v7_3.mat
2021_DESSABNeT_Population_Indexed_Variables_Phase1_10000_v7_3.mat
2021_DESSABNeT_Population_Indexed_Variables_Phase3_10000_v7_3.mat
2021_DESSABNeT_Population_Indexed_Variables_Phase4_10000_v7_3.mat
2021_DESSABNeT_Person_Profile_Phase1_10000_v7_3.mat
2021_DESSABNeT_Person_Profile_Phase3_10000_v7_3.mat
2021_DESSABNeT_Person_Profile_Phase4_10000_v7_3.mat

These are Matlab files which save array and variable values (see https://au.mathworks.com/help/matlab/import_export/load-parts-of-variables-from-mat-files.html)
These files should be placed into the DESSABNeT Dynamic Model folder to run a Dynamic Model for that city/location. Place or copy the .mat files into the following folder:

DESSABNET_Dynamic_Model_Final_2021

Step 4: Now Run DESSABNeT Dynamic Model. In the folder DESSABNET_Dynamic_Model_Final_2021, open the following file in Matlab: 
Stapelberg_et_al_DESSABNeT_Dynamic_Master_Cases_Load_Sydney.m
This is again a master file which will run the other modules in the same folder.

Step 5: Set up the number of runs required. If you wish to lengthen the number of days that the simulation will run for, additional data for each day should be added to the file:

covid_19_interstate_overseas_case_numbers_Sydney.xlsx

You can set the first day for each change in social restrictions which you wish to add

Step 6: Run Stapelberg_et_al_DESSABNeT_Dynamic_Master_Cases_Load_Sydney.m

DESSABNeT will output the following data files:

DESSABNeT__Sydney_31-Mar-2021_1_10000_All_Epi_Daily_Outputs_Table.xlsx
DESSABNeT__Sydney_31-Mar-2021_1_10000_Mean_Daily_Outputs_Table.xlsx
DESSABNeT__Sydney_31-Mar-2021_1_10000_Median_Daily_Outputs_Table.xlsx
DESSABNeT__Sydney_31-Mar-2021_1_10000_2p5_Percentile_Daily_Outputs_Table.xlsx
DESSABNeT__Sydney_31-Mar-2021_1_10000_97p5_Percentile_Daily_Outputs_Table.xlsx
DESSABNeT__Sydney_31-Mar-2021_1_10000_Container_Data_Table.xlsx

Finally, the file:

Stapelberg_et_al_DESSABNeT_Dynamic_R0_Matrix_Calc_Sydney5

can be run as a stand-alone program. It will calculate the WAIFU Matrix and R0 for the given city and the current restrictions in place.


## Collaborators

The Complex Systems Modelling Group Members involved in the DESSABNeT project are:

	•	Nicolas J.C. Stapelberg 1,2 
	•	Nicolas R. Smoll 3,4 
	•	Marcus Randall 5
	•	Dinesh Palipana 1
	•	Bryan Bui 1
	•	Kristine Macartney 6
	•	Gulam Khandaker 4
	•	Andre Wattiaux 1

	1 Gold Coast Health, 1 Hospital Blvd, Southport, Queensland, Australia, 4215
	2 Bond University Faculty of Health Sciences & Medicine, 14 University Drive, 
	    Robina, Queensland, Australia, 4226 
	3 Melbourne School of Population and Global Health, University of Melbourne, 
	    207 Bouverie Street Carlton, Victoria, Australia, 3053 
	4 Central Queensland Public Health Unit, Central Queensland Hospital and Health Service, 
	    82-86 Bolsover Street, Rockhampton, Queensland, Australia, 4700
	5 Bond University Business School, 14 University Drive, Robina, Queensland, Australia, 4226 
	6 National Centre for Immunisation Research and Surveillance (NCIRS), 
	    Cnr Haweksbury Road & Hainsworth Street, Westmead New South Wales, Australia, 2145

## Contributing
	
We encourage use of the DESSABNeT Platform.

Guides for forking code can be found at: https://guides.github.com/

With any use of the code, or publication or other outputs arising from it, please cite the following paper:

	N.J.C. Stapelberg, N.R. Smoll, M. Randall, D. Palipana, B. Bui, K. Macartney, G. Khandaker, A. Wattiaux (In Review). 
	A Discrete-Event, Simulated Social Agent-Based Network Transmission (DESSABNeT) Model for Communicable Diseases: 
	Method and Validation Using SARS-CoV-2 Data in Three Large Australian Cities. PlosOne


## Licence
	
DESSABNeT Dynamic Model. Copyright (C) Nicolas J. C. Stapelberg 2020, 2021, All Rights Reserved 

This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. 
See the GNU General Public License for more details: Please access <https://www.gnu.org/licenses/>.  

If you use this software, please cite the following peer-reviewed paper: 

	N.J.C. Stapelberg, N.R. Smoll, M. Randall, D. Palipana, B. Bui, K. Macartney, G. Khandaker, A. Wattiaux (In Review). 
	A Discrete-Event, Simulated Social Agent-Based Network Transmission (DESSABNeT) Model for Communicable Diseases: 
	Method and Validation Using SARS-CoV-2 Data in Three Large Australian Cities. PlosOne

## Contact Information
	
Please contact Professor Nicolas (Chris) Stapelberg at:

cstapelb@bond.edu.au
 
