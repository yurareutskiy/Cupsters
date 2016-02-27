//
//  CPService.h
//  CloudPaymentsAPI
//
//  Created by Oleg Fedjakin on 9/6/14.
//  Copyright (c) 2014 Binira. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSDataENBase64.h"

typedef enum {
	CPCardTypeAmericanExpress,
	CPCardTypeDinersClub,
	CPCardTypeCarteBlanche,
	CPCardTypeMasterCard,
	CPCardTypeMaestro,
	CPCardTypeEnRoute,
	CPCardTypeJCB,
	CPCardTypeDiscover,
	CPCardTypeVisa,
	CPCardTypeUnknown
} CPCardType;

@interface CPService : NSObject {
    NSMutableArray *keyRefs;
}

+(BOOL) isCardNumberValid: (NSString *) cardNumberString;

/**
 * Create cryptogram
 *	cardNumberString	valid card number stirng
 *	expDateString 		string in format YYMM
 * 	CVVString			3-digit number
 * 	storePublicID		public_id of store
 */
-(NSString *) makeCardCryptogramPacket: (NSString *) cardNumberString andExpDate: (NSString *) expDateString andCVV: (NSString *) CVVString andStorePublicID: (NSString *) storePublicIDString;

+(CPCardType) cardTypeFromCardNumber:(NSString *)cardNumberString;

@end
