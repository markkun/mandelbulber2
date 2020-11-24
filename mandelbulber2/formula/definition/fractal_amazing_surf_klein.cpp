/**
 * Mandelbulber v2, a 3D fractal generator  _%}}i*<.         ______
 * Copyright (C) 2020 Mandelbulber Team   _>]|=||i=i<,      / ____/ __    __
 *                                        \><||i|=>>%)     / /   __/ /___/ /_
 * This file is part of Mandelbulber.     )<=i=]=|=i<>    / /__ /_  __/_  __/
 * The project is licensed under GPLv3,   -<>>=|><|||`    \____/ /_/   /_/
 * see also COPYING file in this folder.    ~+{i%+++
 *
 * amazing surf Mod4 based on Mandelbulber3D. Formula proposed by Kali, with features added by
 * DarkBeam
 * This formula has a c.x c.y SWAP
 * @reference
 * http://www.fractalforums.com/mandelbulb-3d/custom-formulas-and-transforms-release-t17106/
 */

#include "all_fractal_definitions.h"

cFractalAmazingSurfKlein::cFractalAmazingSurfKlein() : cAbstractFractal()
{
	nameInComboBox = "Amazing Surf - Klein";
	internalName = "amazing_surf_klein";
	internalID = fractal::amazingSurfKlein;
	DEType = analyticDEType;
	DEFunctionType = linearDEFunction;
	cpixelAddition = cpixelDisabledByDefault;
	defaultBailout = 100.0;
	DEAnalyticFunction = analyticFunctionLinear;
	coloringFunction = coloringFunctionDefault;
}

void cFractalAmazingSurfKlein::FormulaCode(CVector4 &z, const sFractal *fractal, sExtendedAux &aux)
{
	double colorAdd = 0.0;

	// sphere inversion
	if (fractal->transformCommon.sphereInversionEnabledFalse
			&& aux.i >= fractal->transformCommon.startIterationsX
			&& aux.i < fractal->transformCommon.stopIterations1)
	{
		z += fractal->transformCommon.offset000;
		double rr = z.Dot(z);
		z *= fractal->transformCommon.scaleG1 / rr;
		aux.DE *= (fractal->transformCommon.scaleG1 / rr);
		z += fractal->transformCommon.additionConstant000 - fractal->transformCommon.offset000;
		z *= fractal->transformCommon.scaleA1;
		aux.DE *= fractal->transformCommon.scaleA1;
	}

double rr = 0.0;
	int count =  fractal->transformCommon.stopIterations15;
	int k;
	for (k = 0; k <= count; k++)
	{
		CVector4 oldZ = z;
		z.x = fabs(z.x + fractal->transformCommon.additionConstant111.x)
					- fabs(z.x - fractal->transformCommon.additionConstant111.x) - z.x;
		z.y = fabs(z.y + fractal->transformCommon.additionConstant111.y)
					- fabs(z.y - fractal->transformCommon.additionConstant111.y) - z.y;
		if (fractal->transformCommon.functionEnabledJFalse)
			z.z = fabs(z.z + fractal->transformCommon.additionConstant111.z)
					- fabs(z.z - fractal->transformCommon.additionConstant111.z) - z.z;
		CVector4 zCol = z;

		z += fractal->transformCommon.offsetA000;
		double r2 = z.Dot(z);
		double rrCol = r2;
		double MinRR = 0.0;
		double dividend = r2 < MinRR ? MinRR : min(r2, 1.0);

		// scale
		double useScale = 1.0;

		useScale = (aux.actualScaleA + fractal->transformCommon.scale1) / dividend;
		z *= useScale;
		aux.DE = aux.DE * fabs(useScale) + fractal->analyticDE.tweak005;
		if (fractal->transformCommon.functionEnabledKFalse)
		{
			// update actualScaleA for next iteration
			double vary = fractal->transformCommon.scaleVary0
										* (fabs(aux.actualScaleA) - fractal->transformCommon.scaleC1);
			aux.actualScaleA -= vary;
		}

		if (fractal->transformCommon.rotation2EnabledFalse)
		{
			z = fractal->transformCommon.rotationMatrix.RotateVector(z);
		}

		z += fractal->transformCommon.additionConstantA000;


	}

	if (fractal->transformCommon.functionEnabled)
	{

		z.x = fabs(z.x + fractal->transformCommon.offset222.x)
				- fabs(z.x - fractal->transformCommon.offset222.x) - z.x;

		z.y = fabs(z.y + fractal->transformCommon.offset222.y)
				- fabs(z.y - fractal->transformCommon.offset222.y) - z.y;

		double rr = z.Dot(z);
		double rrCol = rr;
		double MinRR = 0.0;
		double dividend = rr < MinRR ? MinRR : min(rr, 1.0);

		z *= fractal->transformCommon.scale2;
		aux.DE *= fractal->transformCommon.scale2;
	}

	/*if (fractal->foldColor.auxColorEnabledFalse)
	{
		if (zCol.x != oldZ.x)
			colorAdd += fractal->mandelbox.color.factor.x
									* (fabs(zCol.x) - fractal->transformCommon.additionConstant111.x);
		if (zCol.y != oldZ.y)
			colorAdd += fractal->mandelbox.color.factor.y
									* (fabs(zCol.y) - fractal->transformCommon.additionConstant111.y);
		if (zCol.z != oldZ.z)
			colorAdd += fractal->mandelbox.color.factor.z
									* (fabs(zCol.z) - fractal->transformCommon.additionConstant111.z);
		if (rrCol > fractal->transformCommon.minR2p25)
			colorAdd +=
				fractal->mandelbox.color.factorSp2 * (fractal->transformCommon.minR2p25 - rrCol) / 100.0;
		aux.color += colorAdd;
	}*/
}
