%% 
 % matlabUtilities: MATLAB Common Utilities 
 % Copyright (C) 2024 Salvatore Dello Iacono
 %
 %
 % This is free software; you can redistribute it and/or modify
 % it under the terms of the GNU General Public License as published by
 % the Free Software Foundation; either version 3 of the License, or
 % (at your option) any later version.
 %
 % This is distributed in the hope that it will be useful,
 % but WITHOUT ANY WARRANTY; without even the implied warranty of
 % MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 % GNU General Public License for more details.
 %
 %  You should have received a copy of the GNU General Public License
 %  along with this program.  If not, see <http://www.gnu.org/licenses/>.
 %

function tab2tabular( tbl, fName, varargin )
%TAB2TABULAR Convert a table to a LaTeX Tabular Structure
%   tbl: table to be converted
%   vars: list of variables to be inserted
    
    locFields = [ "Variables", "Headers", "Formats",  ...
                  "VarFunctions", "Conditioners", ...
                  "SortBy", ...
                  "ConsoleOutput" ];

    if ~istable( tbl )
        error( "ERROR: first argument must be a table!\n" );
    end

    % Check which locField is present in varargin
    locOpts = struct();
    vkindex = [];

    for idx=1:length(locFields)
        field = locFields(idx);

        loc =  find( cellfun(@(v) ( isstring(v) || ischar(v) ) && all( strcmpi( field, v ) ), varargin ) );
        if ~isempty(loc) && ~ismember(loc, vkindex) && (loc <= nargin-1) 
            locOpts.(field) = varargin{loc+1};
            vkindex = [vkindex loc loc+1];
        end
    end
    

    % Check if all variables are in Table!
    if isfield( locOpts, "Variables" )
        vars = locOpts.("Variables");
        if ~all( contains( vars, tbl.Properties.VariableNames ) )
            error( "ERROR: Variable not in table!\n" );
        end
    else
        vars = tbl.Properties.VariableNames;
    end
    
    nVars = length( vars );

    % Check headers
    if isfield( locOpts, "Headers" ) & ~isempty( locOpts.("Headers") )
        if length( locOpts.("Headers") ) ~= nVars 
            error( "ERROR: 'Headers' should have the same length as Variables!\n" );
        end
    end
    
    % Check 'Formats'
    formats = cell(1, nVars);
    for ivar=1:nVars
        formats{ivar} = "%f";
    end
    
    if isfield( locOpts, "Formats" ) && ~isempty( locOpts.("Formats") )
        opt = locOpts.("Formats");
        optClass = class( opt );
        
        if contains( optClass , ["cell", "array"] )
            % if Cell/Array it should have the same length as vars
            if length( opt ) ~= nVars 
                error( "ERROR: 'Formats' should have the same length as Variables!\n" );
            else 
                formats = opt;
            end
        elseif matches( optClass, "dictionary" )
            for ivar=1:nVars
                vName = vars{ivar};
                if isKey( opt, vName )
                    frmt = opt(vName);
                    if isa( frmt, 'cell' )
                        formats{ivar} = frmt{1};
                    else
                        formats{ivar} = frmt;
                    end
                end
            end
        elseif matches( optClass, "struct" )
            for ivar=1:nVars
                vName = vars{ivar};
                if isfield( opt, vName )
                    formats{ivar} = opt.(vName);
                end
            end
        end
    end
    
    % Check 'Conditioners'
    conditioners = cell(1, nVars);
    for ivar=1:nVars
        conditioners{ivar} = {};
    end

    if isfield( locOpts, "Conditioners" ) && ~isempty( locOpts.("Conditioners") )
        opt = locOpts.("Conditioners");
        optClass = class( opt );
        
        if contains( optClass , ["cell", "array"] )
            % if Cell/Array it should have the same length as vars
            if length( opt ) ~= nVars 
                error( "ERROR: 'Conditioners' should have the same length as Variables!\n" );
            else 
                conditioners = opt;
            end
        elseif matches( optClass, "dictionary" )
            for ivar=1:nVars
                vName = vars{ivar};
                if isKey( opt, vName )
                    cond = opt(vName);
                    if isa( frmt, 'cell' )
                        conditioners{ivar} = cond{1};
                    else
                        conditioners{ivar} = cond;
                    end
                end
            end
        elseif matches( optClass, "struct" )
            for ivar=1:nVars
                vName = vars{ivar};
                if isfield( opt, vName )
                    conditioners{ivar} = opt.(vName);
                end
            end
        end
    end
    
    % Check 'VarFunctions'
    varfuncs = cell(1, nVars);
    for ivar=1:nVars
        varfuncs{ivar} = @(x) x;
    end

    if isfield( locOpts, "VarFunctions" ) && ~isempty( locOpts.("VarFunctions") )
        opt = locOpts.("VarFunctions");
        optClass = class( opt );
        
        if matches( optClass , "cell" )
            % if Cell/Array it should have the same length as vars
            if length( opt ) ~= nVars 
                error( "ERROR: 'VarFunctions' should have the same length as Variables!\n" );
            else 
                varfuncs = opt;
                for ivar=1:nVars
                    if ~isa( varfuncs{ivar}, 'function_handle' )
                        error( "ERROR: 'VarFunctions' should all be function handlers!\n" );
                    end
                end
            end
        elseif matches( optClass, "dictionary" )
            for ivar=1:nVars
                vName = vars{ivar};
                if isKey( opt, vName )
                    cond = opt(vName);
                    if isa( frmt, 'cell' )
                        varfuncs{ivar} = cond{1};
                    else
                        varfuncs{ivar} = cond;
                    end
                    if ~isa( varfuncs{ivar}, 'function_handle' )
                        error( "ERROR: 'VarFunctions' should all be function handlers!\n" );
                    end
                end
            end
        elseif matches( optClass, "struct" )
            for ivar=1:nVars
                vName = vars{ivar};
                if isfield( opt, vName )
                    varfuncs{ivar} = opt.(vName);
                    if ~isa( varfuncs{ivar}, 'function_handle' )
                        error( "ERROR: 'VarFunctions' should all be function handlers!\n" );
                    end
                end
            end
        end
    end
    
    % Check if table has to be sorted
    if isfield( locOpts, "SortBy" ) && ~isempty( locOpts.("SortBy") )
        tbl = sortrows( tbl, locOpts.("SortBy") );
    end

    % NoOutput for DEBUG
    if isfield( locOpts, "ConsoleOutput" ) && ( locOpts.("ConsoleOutput") == true )
        fw = 1;
    else
        fw = fopen( fName, 'wt');
    end

    % Begin Print
    fprintf( fw, "\\begin{tabular}{%s}\n", repmat('c', 1, nVars ) );
    
    if isfield( locOpts, "Headers" )
        headers = locOpts.("Headers");

        for ivar = 1:nVars
            header = headers(ivar);
            
            if ivar == 1
                fprintf( fw, "\t" );
            end

            fprintf( fw, "\\textbf{%s}", header );

            if ivar == length( vars )
                fprintf( fw, " \\\\\n" );
            else
                fprintf( fw, " & " );
            end
        end
    end

    for irow = 1:height( tbl )
        for ivar = 1:nVars
            var = vars(ivar);
            
            if ivar == 1
                fprintf( fw, "\t" );
            end

            frmt = formats{ivar};
            
            rowVal = varfuncs{ivar}( tbl{irow, var} );

            cond = reshape( conditioners{ivar}, 2, [] )';
            if ~isempty( cond )
                for icond = 1:size( cond, 1 )
                    % Matches only the first one!
                    if isa(cond{icond,1}, 'function_handle') && (cond{icond,1}(rowVal) == true)
                        frmt = cond{icond,2};
                        break;
                    end
                end
            end
            
            if isa( frmt, 'function_handle' )
                 fprintf( fw, frmt(rowVal) );
            elseif isa( frmt, 'string' )
                fprintf( fw, frmt, rowVal );
            else
                error( "ERROR: 'Format' should be a format string or a function handler!\n" );
            end

            if ivar == nVars
                fprintf( fw, " \\\\\n" );
            else
                fprintf( fw, " & " );
            end

        end
    end

    fprintf( fw, "\\end{tabular}\n" );
end

