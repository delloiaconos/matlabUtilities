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
    
    locFields = [ "Variables", "Headers", "Formats", "Conditioner", "NoOutput" ];
    locOpts = struct();
    
    vkindex = [];
    
    if ~istable( tbl )
        error( "ERROR: first argument must be a table!\n" );
    end

    % Check which locField is present in varargin
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
    
    % Check headers
    if isfield( locOpts, "Headers" )
        if length( locOpts.("Headers") ) ~= length( vars ) 
            error( "ERROR: 'Headers' should have the same length as Variables!\n" );
        end
    end
    
    nVars = length( vars );
    % Check Formats
    formats = cell(nVars, 1);
    for ii=1:nVars
        formats{ii} = "%f";
    end
    
    if isfield( locOpts, "Formats" )
        clsFormats = class( locOpts.("Formats") );
        if contains( clsFormats , ["cell", "array"] )
            % if Cell/Array it should have the same length as vars
            if length( locOpts.("Formats") ) ~= nVars 
                error( "ERROR: 'Formats' should have the same length as Variables!\n" );
            else 
                formats = locOpts.("Formats");
            end
        elseif matches( clsFormats, "dictionary" )
            dd = locOpts.("Formats");
            for ii=1:nVars
                vName = vars{ii};
                if isKey( dd, vName )
                    frmt = dd(vName);
                    if isa( frmt, 'cell' )
                        formats{ii} = frmt{1};
                    else
                        formats{ii} = frmt;
                    end
                end
            end
        end
        % TODO: Struct!
    end
    
    % Check Conditioner
    if isfield( locOpts, "Conditioner" )
        if length( locOpts.("Conditioner") ) ~= nVars
            error( "ERROR: 'Conditioner' should have the same length as Variables!\n" );
        end
    end

    % NoOutput for DEBUG
    if isfield( locOpts, "NoOutput" ) && ( locOpts.("NoOutput") == true )
        fw = 1;
    else
        fw = fopen( fName, 'wt');
    end
    

    % Begin Print
    fprintf( fw, "\\begin{tabular}{%s}\n", repmat('c',1, length(vars) ) );
    
    if isfield( locOpts, "Headers" )
        headers = locOpts.("Headers");

        for ivar = 1:length(vars)
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
        for ivar = 1:length(vars)
            var = vars(ivar);
            
            if ivar == 1
                fprintf( fw, "\t" );
            end

            frmt = formats{ivar};
            
            rowVal = tbl{irow, var};

            if isfield( locOpts, "Conditioner" )
                cond = locOpts.("Conditioner");
                cond = reshape( cond{ivar}, 2, [] )';
                if ~isempty( cond )
                    for icon = 1:size( cond, 1 )
                        % Matches only the first one!
                        if isa( cond{icon,1}, 'function_handle' ) && ( cond{icon,1}(rowVal) == true )
                            frmt = cond{icon,2};
                            break;
                        end
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

            if ivar == length( vars )
                fprintf( fw, " \\\\\n" );
            else
                fprintf( fw, " & " );
            end

        end
    end

    fprintf( fw, "\\end{tabular}\n" );
end

