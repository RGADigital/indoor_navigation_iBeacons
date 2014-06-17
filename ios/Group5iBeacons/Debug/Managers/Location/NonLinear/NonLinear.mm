//
//  NonLinear.m
//  Group5iBeacons
//
//  Created by Nemanja Joksovic on 6/11/14.
//  Copyright (c) 2014 John Tubert. All rights reserved.
//

#import "NonLinear.h"

#include <iostream>

#include "LevenbergMarquardt.h"

@implementation NonLinear

+ (Location *)determine:(NSArray *)transmissions
{
    if (!transmissions || [transmissions count] == 0) {
        return nil;
    }
    else {
        int count = (int)[transmissions count];
        
        Eigen::VectorXd x(2);
        x << 0, 0;

        Eigen::MatrixXd matrix([transmissions count], 3);

        for (int i = 0; i < count; i++) {
            Transmission *transmission = transmissions[i];

            Eigen::VectorXd t(3);
            t << transmission.beacon.location.x,
                  transmission.beacon.location.y,
                   transmission.accuracy;
            
            matrix.row(i) = t;
        }
        
        distance_functor functor(matrix, count);
        Eigen::NumericalDiff<distance_functor> numDiff(functor);
        Eigen::LevenbergMarquardt<Eigen::NumericalDiff<distance_functor>,double> lm(numDiff);
        lm.parameters.maxfev = 2000;
        lm.parameters.xtol = 1.49012e-08;
        lm.parameters.ftol = 1.49012e-08;
        lm.parameters.gtol = 0;
        lm.parameters.epsfcn = 0;
        Eigen::LevenbergMarquardtSpace::Status ret = lm.minimize(x);

        if (ret == 1) {
            return [[Location alloc] initWithX:x[0] y:x[1] z:0];
        }
        else {
            return nil;
        }
    }
}

@end
