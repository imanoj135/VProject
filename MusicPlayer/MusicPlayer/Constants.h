//
//  Constants.h
//  MusicPlayer
//
//  Created by Manoj kumar on 1/30/17.
//  Copyright © 2017 Manoj kumar. All rights reserved.
//

#ifndef Constants_h
#define Constants_h

#define kAPPNAME @"Music Player"

//WebService Errors and constants
#define kTimeoutInterval 120.0
#define kAccept          @"Accept"
#define kContentType     @"Content-Type"
#define kApplicationType @"application/json"
#define kError401        @"Error 401--Unauthorized"
#define kError400        @"Error 400  Page Not Found"
#define kError403        @"Error 403--Forbidden"
#define kSSOString       @"https://sso"
#define kPost            @"POST"
#define kGet             @"GET"

#define kERROR_INVALID_RESPONSE_ERROR      @"INVALID_RESPONSE"
#define kERROR_DOMAIN_PAGE_NOT_FOUND       @"PAGE_NOT_FOUND"
#define kERROR_DOMAIN_ACCESS_DENIED        @"ACCESS_DENIED"
#define kERROR_DOMAIN_SESSION_EXPIRED      @"SESSION_EXPIRED"

//Webservice Response keynames
#define kTABLECELL_IMAGEURL @"url"
#define kTABLECELL_TEXT @"text"

#endif /* Constants_h */
