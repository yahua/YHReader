//
//  FtpNetWorkManager.m
//  SimpleFTPSample
//
//  Created by 王时温 on 14-12-4.
//
//

#import "YHFtpRequestOperation.h"

@interface YHFtpRequestOperation () <
NSURLConnectionDataDelegate>

@property (nonatomic, strong) NSOutputStream            *outputStream;
@property (nonatomic, strong) NSInputStream             *inputStream;
@property (nonatomic, strong) NSMutableData             *listData;
@property (nonatomic, strong) NSData                    *responseData;
@property (nonatomic, strong) NSURLConnection           *connection;
@property (nonatomic, assign) long long                 totleLength;
@property (nonatomic, assign) long long                 totleWriteLength;

@property (nonatomic, copy) FtpOperationSuccessBlock  sucessBlock;
@property (nonatomic, copy) FtpOperationFailuerBlock  failBlock;
@property (nonatomic, copy) FtpOperationProgressBlock progressBlock;

@end

@implementation YHFtpRequestOperation

#pragma mark - Public

- (id)initWithGetUrl:(NSString *)urlString
             success:(FtpOperationSuccessBlock)sucessBlock
             failuer:(FtpOperationFailuerBlock)failBlock {
    
    self = [super init];
    if (self) {
        self.sucessBlock = sucessBlock;
        self.failBlock = failBlock;
        
        //文件写入路径
        self.outputStream = [NSOutputStream outputStreamToMemory];
        assert(self.outputStream);
        [self.outputStream open];
        
        //网络请求
        NSURL *url = [NSURL URLWithString:urlString];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        assert(request != nil);
        self.connection = [NSURLConnection connectionWithRequest:request delegate:self];
        assert(self.connection != nil);
    }
    return self;
}

- (id)initWithGetUrl:(NSString *)urlString
            progress:(FtpOperationProgressBlock)progressBlock
             failuer:(FtpOperationFailuerBlock)failBlock {
    
    self = [self initWithGetUrl:urlString success:nil failuer:failBlock];
    if (self) {
        self.progressBlock = progressBlock;
    }
    return self;
}

- (void)cancel {

    if (self.connection) {
        [self.connection cancel];
        self.connection = nil;
    }
    if (self.outputStream) {
        [self.outputStream close];
        self.outputStream = nil;
    }
    
    [super cancel];
}

#pragma mark - NSURLConnectionDataDelegate

- (void)connection:(NSURLConnection *)theConnection didReceiveResponse:(NSURLResponse *)response
// A delegate method called by the NSURLConnection when the request/response
// exchange is complete.
//
// For an HTTP request you would check [response statusCode] and [response MIMEType] to
// verify that this is acceptable data, but for an FTP request there is no status code
// and the type value is derived from the extension so you might as well pre-flight that.
//
// You could, use this opportunity to get [response expectedContentLength] and
// [response suggestedFilename], but I don't need either of these values for
// this sample.
{
#pragma unused(theConnection)
#pragma unused(response)
    
    assert(response != nil);
    NSLog(@"%llu", [response expectedContentLength]);
    self.totleLength = [response expectedContentLength];
    self.totleWriteLength = 0;
}

- (void)connection:(NSURLConnection *)theConnection didReceiveData:(NSData *)data
// A delegate method called by the NSURLConnection as data arrives.  We just
// write the data to the file.
{
#pragma unused(theConnection)
    NSUInteger      dataLength;
    const uint8_t * dataBytes;
    NSInteger       bytesWritten;
    NSUInteger      bytesWrittenSoFar;
    
    dataLength = [data length];
    dataBytes  = [data bytes];
    
    bytesWrittenSoFar = 0;
    do {
        bytesWritten = [self.outputStream write:&dataBytes[bytesWrittenSoFar] maxLength:dataLength - bytesWrittenSoFar];
        assert(bytesWritten != 0);
        if (bytesWritten <= 0) {
            break;
        } else {
            bytesWrittenSoFar += (NSUInteger) bytesWritten;
        }
        if (self.outputStream.streamError) {
            [self.connection cancel];
            [self performSelector:@selector(connection:didFailWithError:) withObject:self.connection withObject:self.outputStream.streamError];
            return;
        }
    } while (bytesWrittenSoFar != dataLength);
    
    dispatch_async(dispatch_get_main_queue(), ^{
       
        if (self.progressBlock) {
            self.totleWriteLength += dataLength;
            self.progressBlock(dataLength, self.totleWriteLength, self.totleLength);
        }
    });
}

- (void)connection:(NSURLConnection *)theConnection didFailWithError:(NSError *)error
// A delegate method called by the NSURLConnection if the connection fails.
// We shut down the connection and display the failure.  Production quality code
// would either display or log the actual error.
{
#pragma unused(theConnection)
#pragma unused(error)
    
    [self.outputStream close];
    if (self.responseData) {
        self.outputStream = nil;
    }
    self.connection = nil;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if (self.failBlock) {
            self.failBlock(@"网络获取失败");
        }
    });
}

- (void)connectionDidFinishLoading:(NSURLConnection *)theConnection
// A delegate method called by the NSURLConnection when the connection has been
// done successfully.  We shut down the connection with a nil status, which
// causes the image to be displayed.
{
#pragma unused(theConnection)
    
    self.responseData = [self.outputStream propertyForKey:NSStreamDataWrittenToMemoryStreamKey];
    [self.outputStream close];
    if (self.responseData) {
        self.outputStream = nil;
    }
    self.connection = nil;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if (self.sucessBlock) {
            self.sucessBlock(nil, self.responseData);
        }
    });
}

#pragma mark - NSStreamDelegate

- (void)stream:(NSStream *)aStream handleEvent:(NSStreamEvent)eventCode
// An NSStream delegate callback that's called when events happen on our
// network stream.
{
#pragma unused(aStream)
    assert(aStream == self.inputStream);
    
    switch (eventCode) {
        case NSStreamEventHasBytesAvailable: {
            NSInteger       bytesRead;
            uint8_t         buffer[32768];
            
            // Pull some data off the network.
            bytesRead = [self.inputStream read:buffer maxLength:sizeof(buffer)];
            if (bytesRead < 0) {
//                [self stopReceiveWithStatus:@"Network read error"];
            } else if (bytesRead == 0) {
                //[self stopReceiveWithStatus:nil]; success
            } else {
                assert(self.listData != nil);
                
                // Append the data to our listing buffer.
                
                [self.listData appendBytes:buffer length:(NSUInteger) bytesRead];
                
                // Check the listing buffer for any complete entries and update
                // the UI if we find any.
                
                //[self parseListData];
            }
        } break;
        case NSStreamEventHasSpaceAvailable: {
            assert(NO);     // should never happen for the output stream
        } break;
        case NSStreamEventErrorOccurred: {
            //[self stopReceiveWithStatus:@"Stream open error"];
        } break;
        case NSStreamEventEndEncountered: {
            // ignore
        } break;
        default: {
            assert(NO);
        } break;
    }
}

#pragma mark - Private

- (NSOutputStream *)outputStream {
    
    if (!_outputStream) {
        self.outputStream = [NSOutputStream outputStreamToMemory];
    }
    return _outputStream;
}

@end