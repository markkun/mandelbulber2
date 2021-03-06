/**
 * Mandelbulber v2, a 3D fractal generator  _%}}i*<.        ____                _______
 * Copyright (C) 2020 Mandelbulber Team   _>]|=||i=i<,     / __ \___  ___ ___  / ___/ /
 *                                        \><||i|=>>%)    / /_/ / _ \/ -_) _ \/ /__/ /__
 * This file is part of Mandelbulber.     )<=i=]=|=i<>    \____/ .__/\__/_//_/\___/____/
 * The project is licensed under GPLv3,   -<>>=|><|||`        /_/
 * see also COPYING file in this folder.    ~+{i%+++
 *
 * TransfDEControlsIteration
 *

 * This file has been autogenerated by tools/populateUiInformation.php
 * from the file "fractal_transf_de_controls.cpp" in the folder formula/definition
 * D O    N O T    E D I T    T H I S    F I L E !
 */

REAL4 TransfDEControlsIteration(REAL4 z, __constant sFractalCl *fractal, sExtendedAuxCl *aux)
{
	REAL colorAdd = 0.0f;
	REAL rd = 0.0f;
	REAL4 tZ;
	// distance functions
	switch (fractal->combo4.combo4)
	{
		case multi_combo4Cl_type1:
		default: rd = aux->DE0; break;
		case multi_combo4Cl_type2:
			tZ = fabs(z);
			rd = max(tZ.x, max(tZ.y, tZ.z)); // infnorm
			break;
		case multi_combo4Cl_type3:
			tZ = z * z;
			rd = max(native_sqrt(tZ.x + tZ.y), max(native_sqrt(tZ.y + tZ.z), native_sqrt(tZ.z + tZ.x)));
			break;
		case multi_combo4Cl_type4:
			rd = length(z); // eucli norm
			break;
	}
	// tweaks
	rd += fractal->transformCommon.offset0;
	aux->DE += fractal->analyticDE.offset0;

	// out distance functions
	if (fractal->transformCommon.functionEnabledAy)
	{
		rd = rd / aux->DE; // same as an uncondtional aux->dist
	}
	if (fractal->transformCommon.functionEnabledBFalse)
	{
		REAL rxy = native_sqrt(z.x * z.x + z.y * z.y);
		REAL pkD = max(rxy - fractal->transformCommon.offsetA1, fabs(rxy * z.z) / rd);
		rd = pkD / aux->DE;
	}
	if (fractal->transformCommon.functionEnabledCFalse)
	{
		rd = 0.5f * rd * log(rd) / aux->DE;
	}

	if (fractal->transformCommon.functionEnabledMFalse)
	{
		REAL mixA;
		REAL mixB;
		REAL rxy;
		switch (fractal->combo3.combo3)
		{
			case multi_combo3Cl_type1:
			default:
				mixA = rd;
				mixB = 0.5f * rd * log(rd);
				break;
			case multi_combo3Cl_type2:
				rxy = native_sqrt(z.x * z.x + z.y * z.y);
				mixA = max(rxy - fractal->transformCommon.offsetA1, fabs(rxy * z.z) / rd);
				mixB = rd;
				break;
			case multi_combo3Cl_type3:
				mixA = 0.5f * rd * log(rd);
				rxy = native_sqrt(z.x * z.x + z.y * z.y);
				mixB = max(rxy - fractal->transformCommon.offsetA1, fabs(rxy * z.z) / rd);
				break;
		}
		rd = (mixA + (mixB - mixA) * fractal->transformCommon.scale1) / aux->DE;
	}
	REAL colorDist = aux->dist;
	if (!fractal->transformCommon.functionEnabledFalse)
	{
		aux->colorHybrid = rd; // aux->colorHybrid temp
	}
	else
	{
		int tempC = fractal->transformCommon.int3X;
		if (aux->i < tempC || rd < aux->colorHybrid)
		{
			aux->colorHybrid = rd;
		}
	}
	aux->dist = aux->colorHybrid;

	// aux->color
	if (fractal->foldColor.auxColorEnabled)
	{
		if (fractal->foldColor.auxColorEnabledFalse)
		{
			colorAdd += fractal->foldColor.difs0000.x * fabs(z.x * z.y); // fabs(zc.x * zc.y)
			colorAdd += fractal->foldColor.difs0000.y * max(z.x, z.y);	 // max(z.x, z.y);
			colorAdd += fractal->foldColor.difs0000.z * (z.x * z.x + z.y * z.y);
			// colorAdd += fractal->foldColor.difs0000.w * fabs(zc.x * zc.y);
		}
		colorAdd += fractal->foldColor.difs1;
		if (fractal->foldColor.auxColorEnabledA)
		{
			if (colorDist != aux->dist) aux->color += colorAdd;
		}
		else
			aux->color += colorAdd;
	}
	return z;
}