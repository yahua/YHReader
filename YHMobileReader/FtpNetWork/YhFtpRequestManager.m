//
//  YhFtpRequestManager.m
//  SimpleFTPSample
//
//  Created by 王时温 on 14-12-6.
//
//

#import "YhFtpRequestManager.h"

#define kFtpBaseUrl  @"ftp://192.168.152.1/"

@interface YhFtpRequestManager ()

@property (nonatomic, strong) NSOperationQueue *operationQueue;
@property (nonatomic, strong) NSURL *baseURL;

@end

@implementation YhFtpRequestManager

+ (id)manager {
    
    return [[self alloc] initWithBaseURL:nil];
}

- (id)init {
    return [self initWithBaseURL:nil];
}

- (id)initWithBaseURL:(NSURL *)url {
    
    self = [super init];
    if (!self) {
        return nil;
    }
    // Ensure terminal slash for baseURL path, so that NSURL +URLWithString:relativeToURL: works as expected
    if ([[url path] length] > 0 && ![[url absoluteString] hasSuffix:@"/"]) {
        url = [url URLByAppendingPathComponent:@""];
    }
    self.baseURL = url;
    self.operationQueue = [[NSOperationQueue alloc] init];
    return self;
}

- (YHFtpRequestOperation *)get:(NSString *)urlString
                       success:(FtpOperationSuccessBlock)sucessBlock
                       failuer:(FtpOperationFailuerBlock)failBlock {
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString relativeToURL:self.baseURL]];
    YHFtpRequestOperation *operation = [self FtpRequestOperationWithRequest:request sucess:^(id data) {
        if (sucessBlock) {
            sucessBlock(data);
        }
    } failure:^(NSError *msg) {
        if (failBlock) {
            failBlock(msg);
        }
    }];
    [self.operationQueue addOperation:operation];
                             
    return operation;
}


- (YHFtpRequestOperation *)FtpRequestOperationWithRequest:(NSURLRequest *)request
                                                   sucess:(FtpOperationSuccessBlock)sucess
                                                  failure:(FtpOperationFailuerBlock)failure {
    
    YHFtpRequestOperation *operation = [[YHFtpRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:sucess failure:failure];
    
    return operation;
}

@end
