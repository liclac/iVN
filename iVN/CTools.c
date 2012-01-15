//
//  CTools.c
//  iVN
//
//  Created by Johannes Ekberg on 2012-01-15.
//  Copyright (c) 2012 MacaroniCode Software. All rights reserved.
//

#include <stdio.h>
#include "CTools.h"

int numdigits(int n)
{
	int count = 0;
	do
	{
		++count;
		n /= 10;
	}
	while(n > 0);
	
	return count;
}