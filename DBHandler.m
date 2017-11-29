//
//  DBHandler.m
//
//
//

#import "DBHandler.h"



@implementation DBHandler

#define kDBName @"DatabaseName.Sqlite"// Change This with your databasename


-(DBHandler *) init
{
    return self;
}


+(NSString *) getDatabasePath:(NSString *)dbName
{
    // Get the path to the documents directory and append the databaseName
	NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDir = [documentPaths objectAtIndex:0];
    return [documentsDir stringByAppendingPathComponent:dbName];
}

+(void)checkAndCreateDB:(NSString *)dbName dbPath:(NSString *)dbPath
{
    BOOL success;
	
	NSFileManager *fileManager = [NSFileManager defaultManager];
	
	success = [fileManager fileExistsAtPath:dbPath];
	
	if(success) return;
	
	NSString *databasePathFromApp = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:dbName];
	
	[fileManager copyItemAtPath:databasePathFromApp toPath:dbPath error:nil];
	
}

+(NSMutableArray *)selectSpecificData:(NSString *)quer
{
    NSString *query =quer;
    
    NSMutableArray *mainArray = [[NSMutableArray alloc] init];
    NSMutableDictionary *subDic = [[NSMutableDictionary alloc] init];
    
    
    NSString *dbPath = [DBHandler getDatabasePath:kDBName];
    [DBHandler checkAndCreateDB:kDBName dbPath:dbPath];

    sqlite3 *database;
    NSString * myRowData=[[NSString alloc] initWithFormat:@"%@",@""];
    
    const char *sqlStatement;
    int columnCounter=0;
    // Open the database from the users filessytem
    if(sqlite3_open([dbPath UTF8String], &database) == SQLITE_OK)
    {
        sqlStatement=[[NSString stringWithFormat:@"%@",query ] UTF8String];
        sqlite3_stmt *compiledStatement;
        if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK)
        {
            columnCounter=sqlite3_column_count(compiledStatement);
            
            
            while(sqlite3_step(compiledStatement) == SQLITE_ROW)
            {
                for(int i=0;i<columnCounter;i++)
                {
                    NSString * test = ((char *)sqlite3_column_text(compiledStatement, i))  ? [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, i)] : @"";
                    NSString * colName = [NSString stringWithUTF8String:(char *)sqlite3_column_name(compiledStatement, i)];
                    myRowData = [myRowData stringByAppendingString:test];
                    
                    if(i != columnCounter )
                    {
                        [subDic setObject:myRowData forKey:colName];
                        myRowData = [[NSString alloc] initWithFormat:@""];
                    }
                }
                
                [mainArray addObject:subDic];
                subDic = nil;
                subDic = [[NSMutableDictionary alloc] init];
                
            }
            
        }
        
        sqlite3_finalize(compiledStatement);
    }
    sqlite3_close(database);
    
    return mainArray;
    
    return nil;
}

+(NSMutableArray *)selectDataFromTable:(NSString *)table
{
    NSString *query = [NSString stringWithFormat:@"SELECT * FROM %@",table];
    
    NSMutableArray *mainArray = [[NSMutableArray alloc] init];
    NSMutableDictionary *subDic = [[NSMutableDictionary alloc] init];
    
    
    NSString *dbPath = [DBHandler getDatabasePath:kDBName];
    [DBHandler checkAndCreateDB:kDBName dbPath:dbPath];
    
    sqlite3 *database;
    NSString * myRowData=[[NSString alloc] initWithFormat:@"%@",@""];
    
    const char *sqlStatement;
    int columnCounter=0;
    // Open the database from the users filessytem
    if(sqlite3_open([dbPath UTF8String], &database) == SQLITE_OK)
    {
        sqlStatement=[[NSString stringWithFormat:@"%@",query ] UTF8String];
        sqlite3_stmt *compiledStatement;
        if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK)
        {
            columnCounter=sqlite3_column_count(compiledStatement);
            
            
            while(sqlite3_step(compiledStatement) == SQLITE_ROW)
            {
                for(int i=0;i<columnCounter;i++)
                {
                    //NSString * test = @"Test";
                    
                    NSString * test = ((char *)sqlite3_column_text(compiledStatement, i))  ? [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, i)] : @"";
                    NSString * colName = [NSString stringWithUTF8String:(char *)sqlite3_column_name(compiledStatement, i)];
                    myRowData = [myRowData stringByAppendingString:test];
                    
                    if(i != columnCounter )
                    {
                        [subDic setObject:myRowData forKey:colName];
                        myRowData = [[NSString alloc] initWithFormat:@""];
                    }
                }
                
                [mainArray addObject:subDic];
                subDic = nil;
                subDic = [[NSMutableDictionary alloc] init];
                
            }
            
        }
        
        sqlite3_finalize(compiledStatement);
    }
    sqlite3_close(database);
    
    return mainArray;
    
}

+(void) InsertDatabase:(NSString*) queryString
{
    NSString *dbPath = [DBHandler getDatabasePath:kDBName];
    [DBHandler checkAndCreateDB:kDBName dbPath:dbPath];
    
    sqlite3 *database ;
    
    // Open the database from the users filessytem
    if(sqlite3_open([dbPath UTF8String], &database) == SQLITE_OK)
    {
        const char *sqlStmt=[queryString UTF8String];
        sqlite3_stmt *cmp_sqlStmt=nil;
        // preparing for execution of statement.
        if(sqlite3_prepare_v2(database, sqlStmt, -1, &cmp_sqlStmt, NULL)==SQLITE_OK)
            sqlite3_step(cmp_sqlStmt);
        //Reset the add statement.
        sqlite3_reset(cmp_sqlStmt);
    }
    sqlite3_close(database);
}

+(void) UpdateDatabase:(NSString*) queryString
{
    NSString *dbPath = [DBHandler getDatabasePath:kDBName];
    [DBHandler checkAndCreateDB:kDBName dbPath:dbPath];
    
    sqlite3 *database ;
    // Open the database from the users filessytem
    if(sqlite3_open([dbPath UTF8String], &database) == SQLITE_OK)
    {
        const char *sqlStmt=[queryString UTF8String];
        sqlite3_stmt *cmp_sqlStmt=nil;
        // preparing for execution of statement.
        if(sqlite3_prepare_v2(database, sqlStmt, -1, &cmp_sqlStmt, NULL)==SQLITE_OK)
            sqlite3_step(cmp_sqlStmt);
        //Reset the add statement.
        sqlite3_reset(cmp_sqlStmt);
    }
    sqlite3_close(database);
}

+(void) DeleteDatabase:(NSString*) queryString
{
    NSString *dbPath = [DBHandler getDatabasePath:kDBName];
    [DBHandler checkAndCreateDB:kDBName dbPath:dbPath];
    
    sqlite3 *database;
    
    // Open the database from the users filessytem
    if(sqlite3_open([dbPath UTF8String], &database) == SQLITE_OK)
    {
        const char *sqlStmt=[queryString UTF8String];
        sqlite3_stmt *cmp_sqlStmt=nil;
        // preparing for execution of statement.
        if(sqlite3_prepare_v2(database, sqlStmt, -1, &cmp_sqlStmt, NULL)==SQLITE_OK)
            sqlite3_step(cmp_sqlStmt);
        //Reset the add statement.
        sqlite3_reset(cmp_sqlStmt);
    }
    sqlite3_close(database);
}

-(NSString *) getDBPath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *insPath  = [NSString stringWithFormat:kDBName];
    NSString *destPath = [documentsDirectory stringByAppendingPathComponent:insPath];
    return destPath;
}

@end

