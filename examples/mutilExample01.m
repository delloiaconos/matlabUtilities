
%%
 %   @file    mutilExample01.m
 %   @brief   matlabUtility Example 1 file.
 %   @details matlabUtility file, this script is a simple example of how to 
 %            use the function tab2tabular.
 %
 
clear all;
close all;
clc;

%% Include matlabUtilities
addpath( '../utilities' );

%%  *********************************************************************   
 %                               Example 01
 %  *********************************************************************  

a2t = @( T ) array2table( T );

% Preparing Data
tblT = table();

tblT(:, "Var1" ) = a2t( rand( [100, 1 ] ) );
tblT(:, "Var2" ) = a2t( rand( [100, 1 ] ) );
tblT(:, "Var3" ) = a2t( rand( [100, 1 ] ) );


%% Export Table to LaTeX Tabular!
tab2tabular( tblT, fullfile( "../Outputs/", "table.txt" ), ...
            "NoOutput", true, ...
            "Variables", ["Var1", "Var2", "Var3"], ...
            "Headers", ["Variable #1", "Variable #2", "Variable #3"], ...
            "Formats", ["%0.1f", "%0.1f", "%0.2f"], ...
            "Conditioner", { { @(x) x < 0.9, "\\textbf{%0.1f}", @(x) x < 0.6, "\\textit{%0.1f}", @(x) x < 0.3, "\\cellcolor{blue!25}%0.1fd"}, ...
                             {}, ...
                             {} } ...
           );

