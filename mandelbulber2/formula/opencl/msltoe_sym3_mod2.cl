/**
 * Mandelbulber v2, a 3D fractal generator  _%}}i*<.        ____                _______
 * Copyright (C) 2017 Mandelbulber Team   _>]|=||i=i<,     / __ \___  ___ ___  / ___/ /
 *                                        \><||i|=>>%)    / /_/ / _ \/ -_) _ \/ /__/ /__
 * This file is part of Mandelbulber.     )<=i=]=|=i<>    \____/ .__/\__/_//_/\___/____/
 * The project is licensed under GPLv3,   -<>>=|><|||`        /_/
 * see also COPYING file in this folder.    ~+{i%+++
 *
 * Msltoe_Julia_Bulb_Mod2
 * @reference
 * http://www.fractalforums.com/theory/choosing-the-squaring-formula-by-location/msg14198/#msg14198
 */

/* ### This file has been autogenerated. Remove this line, to prevent override. ### */

#ifndef DOUBLE_PRECISION
void MsltoeSym3Mod2Iteration(float4 *z, __constant sFractalCl *fractal, sExtendedAuxCl *aux)
{
	float4 c = aux->const_c;

	aux->r_dz = aux->r_dz * 2.0f * aux->r;

	float theta;
	float phi;
	float4 z2 = *z * *z;
	float r = z2.x + z2.y + z2.z;
	// if (r < 1e-21f)
	//	r = 1e-21f;
	float r1 = native_sqrt(mad(fractal->transformCommon.scale0, z2.y * z2.z, r));
	// if (r1 < 1e-21f)
	//	r1 = 1e-21f;
	if (z2.z < z2.y)
	{
		theta = 2.0f * atan2(z->y, z->x);
		phi = 2.0f * asin(native_divide(z->z, r1));
		z->x = r * native_cos(theta) * native_cos(phi);
		z->y = r * native_sin(theta) * native_cos(phi);
		z->z = -r * native_sin(phi);
	}
	else
	{
		theta = 2.0f * atan2(z->z, z->x);
		phi = 2.0f * asin(native_divide(z->y, r1));
		z->x = r * native_cos(theta) * native_cos(phi);
		z->y = -r * native_sin(phi);
		z->z = r * native_sin(theta) * native_cos(phi);
	}
	*z += fractal->transformCommon.additionConstant000;

	if (fractal->transformCommon.addCpixelEnabledFalse)
	{
		float4 tempFAB = c;
		if (fractal->transformCommon.functionEnabledx) tempFAB.x = fabs(tempFAB.x);
		if (fractal->transformCommon.functionEnabledy) tempFAB.y = fabs(tempFAB.y);
		if (fractal->transformCommon.functionEnabledz) tempFAB.z = fabs(tempFAB.z);

		tempFAB *= fractal->transformCommon.constantMultiplier000;
		z->x += copysign(tempFAB.x, z->x);
		z->y += copysign(tempFAB.y, z->y);
		z->z += copysign(tempFAB.z, z->z);
	}
	float lengthTempZ = length(-*z);
	// if (lengthTempZ > -1e-21f)
	//	lengthTempZ = -1e-21f;   //  *z is neg.)
	*z *= 1.0f + native_divide(fractal->transformCommon.offset, lengthTempZ);
	*z *= fractal->transformCommon.scale1;
	aux->DE = mad(aux->DE, fabs(fractal->transformCommon.scale1), 1.0f);
	aux->r_dz *= fabs(fractal->transformCommon.scale1);
}
#else
void MsltoeSym3Mod2Iteration(double4 *z, __constant sFractalCl *fractal, sExtendedAuxCl *aux)
{
	double4 c = aux->const_c;

	aux->r_dz = aux->r_dz * 2.0 * aux->r;

	double theta;
	double phi;
	double4 z2 = *z * *z;
	double r = z2.x + z2.y + z2.z;
	// if (r < 1e-21)
	//	r = 1e-21;
	double r1 = native_sqrt(mad(fractal->transformCommon.scale0, z2.y * z2.z, r));
	// if (r1 < 1e-21)
	//	r1 = 1e-21;
	if (z2.z < z2.y)
	{
		theta = 2.0 * atan2(z->y, z->x);
		phi = 2.0 * asin(native_divide(z->z, r1));
		z->x = r * native_cos(theta) * native_cos(phi);
		z->y = r * native_sin(theta) * native_cos(phi);
		z->z = -r * native_sin(phi);
	}
	else
	{
		theta = 2.0 * atan2(z->z, z->x);
		phi = 2.0 * asin(native_divide(z->y, r1));
		z->x = r * native_cos(theta) * native_cos(phi);
		z->y = -r * native_sin(phi);
		z->z = r * native_sin(theta) * native_cos(phi);
	}
	*z += fractal->transformCommon.additionConstant000;

	if (fractal->transformCommon.addCpixelEnabledFalse)
	{
		double4 tempFAB = c;
		if (fractal->transformCommon.functionEnabledx) tempFAB.x = fabs(tempFAB.x);
		if (fractal->transformCommon.functionEnabledy) tempFAB.y = fabs(tempFAB.y);
		if (fractal->transformCommon.functionEnabledz) tempFAB.z = fabs(tempFAB.z);

		tempFAB *= fractal->transformCommon.constantMultiplier000;
		z->x += copysign(tempFAB.x, z->x);
		z->y += copysign(tempFAB.y, z->y);
		z->z += copysign(tempFAB.z, z->z);
	}
	double lengthTempZ = length(-*z);
	// if (lengthTempZ > -1e-21)
	//	lengthTempZ = -1e-21;   //  *z is neg.)
	*z *= 1.0 + native_divide(fractal->transformCommon.offset, lengthTempZ);
	*z *= fractal->transformCommon.scale1;
	aux->DE = aux->DE * fabs(fractal->transformCommon.scale1) + 1.0;
	aux->r_dz *= fabs(fractal->transformCommon.scale1);
}
#endif
