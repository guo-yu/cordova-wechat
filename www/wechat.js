var exec = require('cordova/exec');

module.exports = Wechat;

var shareTypes = {
  session:  0, // 聊天界面
  timelime: 1, // 朋友圈
  favorite: 2  // 收藏
};

var mediaTypes = {
  app:     1,
  emotion: 2,
  file:    3,
  image:   4,
  music:   5,
  video:   6,
  webpage: 7
};

function Wechat(appId) {
  if (!appId)
    throw new Error('Wechat.init(); appId is required!');
  this.appId = appId;
  this.events = {};
}

Wechat.prototype.on = on;
Wechat.prototype.share = share;

function on(eventName, callback) {
  this.events[eventName] = callback;
}

/**
 * [Core Share Function]
 * @param  {[String]} type      [Share type]
 * @param  {[Object]} message   [Share message object]
 * @param  {[Function]} success [Event be triggered, optional]
 * @param  {[Function]} error   [Event be triggered, optional]
 * @example
 *   Wechat.share('timeline', {
 *     title: "Message",
 *     description: "Message Description (optional)",
 *     mediaTagName: "Media Tag Name (optional)",
 *     thumb: "http://ImagePath",
 *     media: {
 *       type: 'webpage',   // webpage
 *       webpageUrl: "https://github.com" // uri to be shared.
 *     }
 *   }, function() {
 *     console.log("Shared.");
 *   }, function(reason) {
 *     console.log("Sharing Failed: " + reason);
 *   });
 */
function share(type, message, success, error) {
  var context = {};
  var callbacks = {};
  callbacks.success = success && isFunction(success) ? 
    success : this.events.success;
  callbacks.error = error && isFunction(error) ? 
    error : this.events.error;

  // Replace share type with real share type Number
  context.scene = type && shareTypes[type] ? 
    shareTypes[type] : shareTypes.timeline;

  // Replace media with real type, the type Number
  if (message && message.media) {
    message.media.type = message.media.type && mediaTypes[message.media.type] ?
      mediaTypes[message.media.type] : mediaTypes.webpage;
  }

  context.message = message;

  exec(
    callbacks.success, 
    callbacks.error, 
    "Wechat", 
    "share", 
    [context]
  );
}

function isFunction(fn) {
  return fn && typeof(fn) === 'function';
}
