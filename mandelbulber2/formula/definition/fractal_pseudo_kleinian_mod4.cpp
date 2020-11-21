/**
 * Mandelbulber v2, a 3D fractal generator  _%}}i*<.         ______
 * Copyright (C) 2020 Mandelbulber Team   _>]|=||i=i<,      / ____/ __    __
 *                                        \><||i|=>>%)     / /   __/ /___/ /_
 * This file is part of Mandelbulber.     )<=i=]=|=i<>    / /__ /_  __/_  __/
 * The project is licensed under GPLv3,   -<>>=|><|||`    \____/ /_/   /_/
 * see also COPYING file in this folder.    ~+{i%+++
 *
 * Pseudo Kleinian, Knighty - Theli-at's Pseudo Kleinian (Scale 1 JuliaBox + Something
 * @reference https://github.com/Syntopia/Fragmentarium/blob/master/
 * Fragmentarium-Source/Examples/Knighty%20Collection/PseudoKleinian.frag
 */

#include "all_fractal_definitions.h"

cFractalPseudoKleinianMod4::cFractalPseudoKleinianMod4() : cAbstractFractal()
{
	nameInComboBox = "Pseudo Kleinian - Mod 4";
	internalName = "pseudo_kleinian_mod4";
	internalID = fractal::pseudoKleinianMod4;
	DEType = analyticDEType;
	DEFunctionType = pseudoKleinianDEFunction;
	cpixelAddition = cpixelDisabledByDefault;
	defaultBailout = 100.0;
	DEAnalyticFunction = analyticFunctionPseudoKleinian;
	coloringFunction = coloringFunctionDefault;
}

void cFractalPseudoKleinianMod4::FormulaCode(
	CVector4 &z, const sFractal *fractal, sExtendedAux &aux)
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
		z += fractal->transformCommon.additionConstantP000 - fractal->transformCommon.offset000;
		z *= fractal->transformCommon.scaleA1;
		aux.DE *= fractal->transformCommon.scaleA1;
	}

	// box offset
	if (aux.i >= fractal->transformCommon.startIterationsM
			&& aux.i < fractal->transformCommon.stopIterationsM)
	{
		z.x -= fractal->transformCommon.constantMultiplier000.x * sign(z.x);
		z.y -= fractal->transformCommon.constantMultiplier000.y * sign(z.y);
		z.z -= fractal->transformCommon.constantMultiplier000.z * sign(z.z);
	}

	// Pseudo kleinian
	double k = 0.0;
	z = fabs(z + fractal->transformCommon.additionConstant0777)
			- fabs(z - fractal->transformCommon.additionConstant0777) - z;

	k = max(fractal->transformCommon.minR05 / z.Dot(z), 1.0);
	z *= k;
	aux.DE *= k;

	z += fractal->transformCommon.additionConstant000;//mmmmmmmmmmmmmmmmmmmmmmmmmmmmmm

	if (fractal->transformCommon.functionEnabledGFalse
			&& aux.i >= fractal->transformCommon.startIterationsG
			&& aux.i < fractal->transformCommon.stopIterationsG)
	{
		z.x += aux.pos_neg * fractal->transformCommon.additionConstantA000.x;
		z.y += aux.pos_neg * fractal->transformCommon.additionConstantA000.y;
		z.z += aux.pos_neg * fractal->transformCommon.additionConstantA000.z;

		aux.pos_neg *= fractal->transformCommon.scaleNeg1;
	}

	if (fractal->transformCommon.functionEnabledFFalse
			&& aux.i >= fractal->transformCommon.startIterationsF
			&& aux.i < fractal->transformCommon.stopIterationsF)
	{
		z = fabs(z + fractal->transformCommon.offsetA000)
				- fabs(z - fractal->transformCommon.offsetA000) - z;
	}

	if (fractal->transformCommon.functionEnabledxFalse) z.x = -z.x;
	if (fractal->transformCommon.functionEnabledyFalse) z.y = -z.y;
	if (fractal->transformCommon.functionEnabledzFalse) z.z = -z.z;

	aux.pseudoKleinianDE = fractal->analyticDE.scale1; // pK DE
	// color
	if (fractal->foldColor.auxColorEnabledFalse)
	{
		colorAdd += fractal->foldColor.difs0000.x * fabs(z.x);
		colorAdd += fractal->foldColor.difs0000.y * fabs(z.y);
		colorAdd += fractal->foldColor.difs0000.z * fabs(z.z);
		colorAdd += fractal->foldColor.difs0000.w * k;

		aux.color += colorAdd;
	}
}
