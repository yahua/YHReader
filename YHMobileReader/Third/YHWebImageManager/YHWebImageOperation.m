//
//  YHWebImageOperation.m
//  YHMobileReader
//
//  Created by 王时温 on 15-1-2.
//  Copyright (c) 2015年 压花. All rights reserved.
//

#import "YHWebImageOperation.h"

@interface YHWebImageOperation ()

@property (nonatomic, retain) NSURLConnection *connection;
@property (nonatomic, retain) NSMutableData *receivedData;
@property (nonatomic, copy) NSString *filePath;

@property (nonatomic, copy) WebImageOperationSuccessBlock  sucessBlock;
@property (nonatomic, copy) WebImageOperationFailuerBlock  failBlock;

@end

@implementation YHWebImageOperation

+ (NSThread *)networkThread {
    static NSThread *networkThread = nil;
    static dispatch_once_t oncePredicate;
    
    dispatch_once(&oncePredicate, ^{
        networkThread =
        [[NSThread alloc] initWithTarget:self
                                selector:@selector(networkThreadMain:)
                                  object:nil];
        [networkThread start];
    });
    
    return networkThread;}

+ (void)networkThreadMain:(id)unused {
    do {
        @autoreleasepool {
            [[NSThread currentThread] setName:@"YHWebImageThread"];
            [[NSRunLoop currentRunLoop] run];
        }
    } while (YES);
}

- (void)cancel {
    
    if (self.connection) {
        [self.connection cancel];
        self.connection = nil;
    }

    [super cancel];
}

- (id)initWithRequest:(NSURLRequest *)urlRequest {
    
    self = [super init];
    if (self) {
        [self startRequest:urlRequest];
    }
    return self;
}

- (void)setCompletionBlockWithSuccess:(WebImageOperationSuccessBlock)success
                              failure:(WebImageOperationFailuerBlock)failure {
    
    self.sucessBlock = success;
    self.failBlock = failure;
}

#pragma mark NSURLConnection delegate methods

- (void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    /* This method is called when the server has determined that it has
	 enough information to create the NSURLResponse. It can be called
	 multiple times, for example in the case of a redirect, so each time
	 we reset the data capacity. */
    
	/* create the NSMutableData instance that will hold the received data */
    
	long long contentLength = [response expectedContentLength];
	if (contentLength == NSURLResponseUnknownLength) {
		contentLength = 500000;
	}
	self.receivedData = [NSMutableData dataWithCapacity:(NSUInteger)contentLength];
}


- (void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    /* Append the new data to the received data. */
    [self.receivedData appendData:data];
}


- (void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
	
	self.connection = nil;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if (self.failBlock) {
            self.failBlock(error);
        }
    });
}

- (void) connectionDidFinishLoading:(NSURLConnection *)connection
{
	self.connection = nil;
    if ([[NSFileManager defaultManager] fileExistsAtPath:self.filePath] == NO) {
		/* file doesn't exist, so create it */
		[[NSFileManager defaultManager] createFileAtPath:self.filePath
												contents:self.receivedData
											  attributes:nil];
	}
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.sucessBlock) {
            self.sucessBlock(self.filePath);
        }
    });
}

#pragma mark - Private

- (void)startRequest:(NSURLRequest *)request {
    
    NSString *cachePath = [self getCachePath];
    NSString *fileName = [NSString md5:[request.URL absoluteString]];
    self.filePath = [cachePath stringByAppendingPathComponent:fileName];
    if ([[NSFileManager defaultManager] fileExistsAtPath:self.filePath]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.sucessBlock) {
                self.sucessBlock(self.filePath);
            }
        });
        return;
    }
    //网络请求
    assert(request != nil);
    self.connection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:NO];
    assert(self.connection != nil);
    
    [self performSelector:@selector(scheduleInCurrentThread)
                 onThread:[[self class] networkThread]
               withObject:nil
            waitUntilDone:YES];
}

- (void)scheduleInCurrentThread {
    
    [self.connection scheduleInRunLoop:[NSRunLoop currentRunLoop]
                               forMode:NSRunLoopCommonModes];
    [self.connection start];
}

- (NSString *)getCachePath
{
	/* create path to cache directory inside the application's Documents directory */
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *dataPath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"URLCache"];
    
	/* check for existence of cache directory */
	if ([[NSFileManager defaultManager] fileExistsAtPath:dataPath]) {
		return dataPath;
	}
    
	/* create a new cache directory */
	if ([[NSFileManager defaultManager] createDirectoryAtPath:dataPath
								   withIntermediateDirectories:NO
													attributes:nil
														 error:nil]) {
		
		return dataPath;
	}
    return nil;
}

@end
