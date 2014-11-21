#import "CDVWechat.h"

@implementation CDVWechat

#pragma mark "API"

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

#pragma mark "WXApiDelegate"

- (void)onResp:(BaseResp *)resp
{
  CDVPluginResult *result = nil;
    
  BOOL success = NO;

  if([resp isKindOfClass:[SendMessageToWXResp class]]) {
    switch (resp.errCode) {
      case WXSuccess:
        result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
        success = YES;
      break;
      
      case WXErrCodeCommon:
        result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"普通错误类型"];
      break;
      
      case WXErrCodeUserCancel:
        result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"用户点击取消并返回"];
      break;
      
      case WXErrCodeSentFail:
        result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"发送失败"];
      break;
      
      case WXErrCodeAuthDeny:
        result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"授权失败"];
      break;
      
      case WXErrCodeUnsupport:
        result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"微信不支持"];
      break;
    }
  }
    
  if (!result) {
    result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Unknown"];
  }
    
  if (success) {
    [self success:result callbackId:self.currentCallbackId];
  } else {
    [self error:result callbackId:self.currentCallbackId];
  }
    
  self.currentCallbackId = nil;
}

#pragma mark "CDVPlugin Overrides"

- (void)handleOpenURL:(NSNotification *)notification
{
  NSURL* url = [notification object];
  
  if ([url isKindOfClass:[NSURL class]] && [url.scheme isEqualToString:self.wechatAppId]) {
    [WXApi handleOpenURL:url delegate:self];
  }
}

#pragma mark "Private methods"

- (NSString *)wechatAppId
{
  if (!_wechatAppId) {
    CDVViewController *viewController = (CDVViewController *)self.viewController;
    _wechatAppId = [viewController.settings objectForKey:@"wechatappid"];
  }

  return _wechatAppId;
}

- (WXMediaMessage *)buildSharingMessage:(NSDictionary *)message
{
  WXMediaMessage *wxMediaMessage = [WXMediaMessage message];
  wxMediaMessage.title = [message objectForKey:@"title"];
  wxMediaMessage.description = [message objectForKey:@"description"];
  wxMediaMessage.mediaTagName = [message objectForKey:@"mediaTagName"];
  [wxMediaMessage setThumbImage:[self getUIImageFromURL:[message objectForKey:@"thumb"]]];
    
  // Media parameters
  id mediaObject = nil;
  NSDictionary *media = [message objectForKey:@"media"];
    
  // Check types
  NSInteger type = [[media objectForKey:@"type"] integerValue];
  switch (type) {
    case CDVWXSharingTypeApp:
    break;

    case CDVWXSharingTypeEmotion:
    break;
    
    case CDVWXSharingTypeFile:
    break;
    
    case CDVWXSharingTypeImage:
    break;
    
    case CDVWXSharingTypeMusic:
    break;
    
    case CDVWXSharingTypeVideo:
    break;
    
    case CDVWXSharingTypeWebPage:
    default:
    mediaObject = [WXWebpageObject object];
    ((WXWebpageObject *)mediaObject).webpageUrl = [media objectForKey:@"webpageUrl"];
  }

  wxMediaMessage.mediaObject = mediaObject;
  return wxMediaMessage;
}

- (UIImage *)getUIImageFromURL:(NSString *)thumb
{
  NSURL *thumbUrl = [NSURL URLWithString:thumb];
  NSData *data = nil;
  
  if ([thumbUrl isFileURL]) {
    data = [NSData dataWithContentsOfFile:thumb]; // Local file
  } else {
    data = [NSData dataWithContentsOfURL:thumbUrl];
  }

  return [UIImage imageWithData:data];
}

@end
