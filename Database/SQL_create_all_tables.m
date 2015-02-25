% ------------------------------------------------------------------------------
% SQL_create_all_tables
% ------------------------------------------------------------------------------
% 
% Create all the tables in the database
% 
% Uses SQL_tablecreatestring to retrieve the appropriate mySQL CREATE TABLE
% statements.
% 
%---HISTORY:
% Ben Fulcher, now uses SQL_TableCreateString, May 2013
% Romesh Abeysuriya, March 2013
% 
% ------------------------------------------------------------------------------
% Copyright (C) 2013, Romesh Abeysuriya
% Ben D. Fulcher <ben.d.fulcher@gmail.com>, <http://www.benfulcher.com>
% 
% If you use this code for your research, please cite:
% B. D. Fulcher, M. A. Little, N. S. Jones, "Highly comparative time-series
% analysis: the empirical structure of time series and their methods",
% J. Roy. Soc. Interface 10(83) 20130048 (2010). DOI: 10.1098/rsif.2013.0048
% 
% This work is licensed under the Creative Commons
% Attribution-NonCommercial-ShareAlike 3.0 Unported License. To view a copy of
% this license, visit http://creativecommons.org/licenses/by-nc-sa/3.0/ or send
% a letter to Creative Commons, 444 Castro Street, Suite 900, Mountain View,
% California, 94041, USA.
% ------------------------------------------------------------------------------

function SQL_create_all_tables()

% Specify the names of tables to create (should be valid names in SQL_TableCreateString)
TableNames = {'MasterOperations', ...     % MasterOperations Table
              'Operations', ...           % Operations Table
              'TimeSeries', ...           % TimeSeries Table
              'OperationKeywords', ...    % OperationKeywords Table
              'OpKeywordsRelate', ...     % OpKeywordsRelate Table
              'TimeSeriesKeywords', ...   % TimeSeriesKeywords
              'TsKeywordsRelate', ...     % TsKeywordsRelate Table
              'Results'};                 % Results Table
          
% Convert Table names to mySQL CREATE TABLE statements:
createString = arrayfun(@(x)SQL_TableCreateString(TableNames{x}),1:length(TableNames),'UniformOutput',0);

% ------------------------------------------------------------------------------
%% Write all of this to the database:
% ------------------------------------------------------------------------------
[dbc, dbname] = SQL_opendatabase; % opens dbc, the default database (named dbname)

fprintf(1,'Creating tables in %s:\n',dbname);
numPerLine = 5;
for j = 1:length(createString)
    [~, emsg] = mysql_dbexecute(dbc,createString{j});
    if isempty(emsg)
        if j == length(createString)
            fprintf(1,'%s.',TableNames{j})
        else
            fprintf(1,'%s, ',TableNames{j})
        end
    else
        fprintf(1,'**** Error creating table: %s\n',TableNames{j});
    end
    if (mod(j,numPerLine) == 0) && (j < length(createString))
        fprintf(1,'\n'); % Make new line to avoid cramping on display
    end
end
fprintf(1,'\nTables created in %s\n',dbname);

SQL_closedatabase(dbc) % close the connection to the database

end