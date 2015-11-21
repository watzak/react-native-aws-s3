//
//  RNAWSS3Upload.m
//  RNAWSS3Upload
//
//  Created by watzak on 12/11/15.
//  Copyright © 2015 watzak. All rights reserved.
//

#import "RNAWSS3Upload.h"
#import <AWSCore/AWSCore.h>
#import <AWSCognito/AWSCognito.h>
#import <AWSS3/AWSS3.h>

@implementation RNAWSS3Upload

// Expose this module to the React Native bridge
RCT_EXPORT_MODULE()

// thanks to Mattt Thompson
// https://mobile.awsblog.com/blog/tag/iOS
RCT_EXPORT_METHOD(upload:(NSString*)path
                  andPoolId:(NSString*)poolId
                  andBucket:(NSString*)bucket
                  andKey:(NSString*)key
                  andFormat:(NSString*)format
                  ) {
    
    // Initialize the Amazon Cognito credentials provider
    
    AWSCognitoCredentialsProvider *credentialsProvider = [[AWSCognitoCredentialsProvider alloc]
                                                          initWithRegionType:AWSRegionEUWest1
                                                          identityPoolId:poolId];
    
    AWSServiceConfiguration *configuration = [[AWSServiceConfiguration alloc] initWithRegion:AWSRegionUSEast1 credentialsProvider:credentialsProvider];
    
    [AWSServiceManager defaultServiceManager].defaultServiceConfiguration = configuration;

    
    NSURL *fileURL = [NSURL URLWithString:path];
    AWSS3TransferUtility *transferUtility = [AWSS3TransferUtility defaultS3TransferUtility];
    [[transferUtility uploadFile:fileURL
                          bucket:bucket
                             key:key
                     contentType:format
                      expression:nil
                completionHander:nil] continueWithBlock:^id(AWSTask *task) {
        if (task.error) {
            NSLog(@"Error: %@", task.error);
        }
        if (task.exception) {
            NSLog(@"Exception: %@", task.exception);
        }
        if (task.result) {
            AWSS3TransferUtilityUploadTask *uploadTask = task.result;
            // Do something with uploadTask.
        }
        
        return nil;
    }];
   
}

@end
