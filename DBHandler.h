//
//  DBHandler.h

#import <Foundation/Foundation.h>
#import <sqlite3.h>



@interface DBHandler : NSObject{
     sqlite3 *database;
     NSString *path;
 }


////////////////all methods for
+(NSString *) getDatabasePath:(NSString *)dbName;
+(void)checkAndCreateDB:(NSString *)dbName dbPath:(NSString *)dbPath;
+(void) InsertDatabase:(NSString*) queryString;
+(void) UpdateDatabase:(NSString*) queryString;
+(void) DeleteDatabase:(NSString*) queryString;
+(NSMutableArray *)selectDataFromTable:(NSString *)table;
+(NSMutableArray *)selectSpecificData:(NSString *)quer;
-(NSString *) getDBPath;




@end
