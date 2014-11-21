#import "CDVWechat.h"

@implementation CDVWechat

- (void)share:(CDVInvokedUrlCommand *)command 
{
  [WXApi registerApp:self.wechatAppId];

  CDVPluginResult *result = nil;

  // If Wechat have not be installed in user's mobile phone
  if (![WXApi isWXAppInstalled]) {
    result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"未安装微信"];

    [self error:result callbackId:command.callbackId];
    return;
  }

  // Check arguments
  NSDictionary *params = [command.arguments objectAtIndex:0];
  if (!params) {
    result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"参数错误"];

    [self error:result callbackId:command.callbackId];
    return ;
  }
  
  // Save the callback id
  // TODO: remove callbackId function
  self.currentCallbackId = command.callbackId;
  
  SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
  
  // Check the scene
  if ([params objectForKey:@"scene"]) {
    req.scene = [[params objectForKey:@"scene"] integerValue];
  } else {
    req.scene = WXSceneTimeline;
  }
  
  // Check if a message or a text
  NSDictionary *message = [params objectForKey:@"message"];

  if (message) {
    req.bText = NO;

    [self.commandDelegate runInBackground:^{
      req.message = [self buildSharingMessage:message];
      [WXApi sendReq:req];
    }];
  } else {
    req.bText = YES;
    req.text = [params objectForKey:@"text"];

    [WXApi sendReq:req];
  }
}
