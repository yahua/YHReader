//
//  YHFtpLogic.m
//  SimpleFTPSample
//
//  Created by 王时温 on 14-12-7.
//
//

#import "YHFtpLogic.h"

@implementation YHFtpLogic

+ (NSArray *)parserFileModelWithData:(NSData *)data {
    
    NSMutableArray *    newEntries;
    NSUInteger          offset;
    
    // We accumulate the new entries into an array to avoid a) adding items to the
    // table one-by-one, and b) repeatedly shuffling the listData buffer around.
    
    newEntries = [NSMutableArray array];
    assert(newEntries != nil);
    
    offset = 0;
    do {
        CFIndex         bytesConsumed;
        CFDictionaryRef thisEntry;
        
        thisEntry = NULL;
        
        assert(offset <= [data length]);
        bytesConsumed = CFFTPCreateParsedResourceListing(NULL, &((const uint8_t *) data.bytes)[offset], (CFIndex) ([data length] - offset), &thisEntry);
        if (bytesConsumed > 0) {
            
            // It is possible for CFFTPCreateParsedResourceListing to return a
            // positive number but not create a parse dictionary.  For example,
            // if the end of the listing text contains stuff that can't be parsed,
            // CFFTPCreateParsedResourceListing returns a positive number (to tell
            // the caller that it has consumed the data), but doesn't create a parse
            // dictionary (because it couldn't make sense of the data).  So, it's
            // important that we check for NULL.
            
            if (thisEntry != NULL) {
                
                // Try to interpret the name as UTF-8, which makes things work properly
                // with many UNIX-like systems, including the Mac OS X built-in FTP
                // server.  If you have some idea what type of text your target system
                // is going to return, you could tweak this encoding.  For example,
                // if you know that the target system is running Windows, then
                // NSWindowsCP1252StringEncoding would be a good choice here.
                //
                // Alternatively you could let the user choose the encoding up
                // front, or reencode the listing after they've seen it and decided
                // it's wrong.
                //
                // Ain't FTP a wonderful protocol!
                
                YHFtpFileModel *model = [self entryByReencodingNameInEntry:(__bridge NSDictionary *) thisEntry encoding:NSUTF8StringEncoding];
                
                [newEntries addObject:model];
            }
            
            // We consume the bytes regardless of whether we get an entry.
            
            offset += (NSUInteger) bytesConsumed;
        }
        
        if (thisEntry != NULL) {
            CFRelease(thisEntry);
        }
        
        if (bytesConsumed == 0) {
            // We haven't yet got enough data to parse an entry.  Wait for more data
            // to arrive.
            break;
        } else if (bytesConsumed < 0) {
            // We totally failed to parse the listing.  Fail.
            [newEntries removeAllObjects];
            break;
        }
    } while (YES);
    
    return newEntries;
}

+ (NSString *)stringForFileSize:(unsigned long long)size {
    
    double  fileSize;
    NSString *  result;
    
    fileSize = (double)size;
    if (size == 1) {
        result = @"1 byte";
    } else if (size < 1024) {
        result = [NSString stringWithFormat:@"%llu bytes", size];
    } else if (fileSize < (1024.0 * 1024.0 * 0.1)) {
        result = [self stringForNumber:fileSize / 1024.0 asUnits:@"KB"];
    } else if (fileSize < (1024.0 * 1024.0 * 1024.0 * 0.1)) {
        result = [self stringForNumber:fileSize / (1024.0 * 1024.0) asUnits:@"MB"];
    } else {
        result = [self stringForNumber:fileSize / (1024.0 * 1024.0 * 1024.0) asUnits:@"MB"];
    }
    return result;
}

#pragma mark - Private

+ (YHFtpFileModel *)entryByReencodingNameInEntry:(NSDictionary *)entry encoding:(NSStringEncoding)newEncoding
// CFFTPCreateParsedResourceListing always interprets the file name as MacRoman,
// which is clearly bogus <rdar://problem/7420589>.  This code attempts to fix
// that by converting the Unicode name back to MacRoman (to get the original bytes;
// this works because there's a lossless round trip between MacRoman and Unicode)
// and then reconverting those bytes to Unicode using the encoding provided.
{
    NSData *        nameData;
    NSString *      newName;
    
    newName = nil;
    
    // Try to get the name, convert it back to MacRoman, and then reconvert it
    // with the preferred encoding.
    
    NSString *oldName = [entry objectForKey:(id) kCFFTPResourceName];
    if (oldName != nil) {
        assert([oldName isKindOfClass:[NSString class]]);
        nameData = [oldName dataUsingEncoding:NSMacOSRomanStringEncoding];
        if (nameData != nil) {
            newName = [[NSString alloc] initWithData:nameData encoding:newEncoding];
            if (!newName) {
                
                newName = [[NSString alloc] initWithData:nameData encoding:CFStringConvertEncodingToNSStringEncoding (kCFStringEncodingGB_18030_2000)];
            }
        }
    }
    
    // If the above failed, just return the entry unmodified.  If it succeeded,
    // make a copy of the entry and replace the name with the new name that we
    // calculated.
    
    if (newName == nil) {
        assert(NO);                 // in the debug builds, if this fails, we should investigate why
    }
        
    NSMutableDictionary *newEntry = [entry mutableCopy];
    assert(newEntry != nil);
        

    YHFtpFileModel *fileModel = [[YHFtpFileModel alloc] init];
    @try {
        
        fileModel.fileName = [newName stringByDeletingPathExtension];
        NSNumber *sizeNum = [newEntry objectForKey:(id)kCFFTPResourceSize];
        fileModel.fileSize = [sizeNum unsignedLongLongValue];
        fileModel.fileSizeStr = [self stringForFileSize:fileModel.fileSize];
        fileModel.fileDate = [newEntry objectForKey:(id)kCFFTPResourceModDate];
        
    }
    @catch (NSException *exception) {
        
    }
    return fileModel;

}

+ (NSString *)stringForNumber:(double)num asUnits:(NSString *)units
{
    NSString *  result;
    double      fractional;
    double      integral;
    
    fractional = modf(num, &integral);
    if ( (fractional < 0.1) || (fractional > 0.9) ) {
        result = [NSString stringWithFormat:@"%.0f %@", round(num), units];
    } else {
        result = [NSString stringWithFormat:@"%.1f %@", num, units];
    }
    return result;
}

@end
