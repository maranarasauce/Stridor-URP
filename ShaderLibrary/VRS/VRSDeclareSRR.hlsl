/*****************************************************************************
*                                                                            *
* Parameters and Shading Rate Texture for Nvidia API Variable Rate Shading	 *
*                                                                            *
******************************************************************************/

#if !defined(SLZ_VRS_NVAPI)
#define(SLZ_VRS_NVAPI)

TEXTURE2D_X(<uint> _SRRTexture);

// Radii of the crossing ellipsoids that define the shading rate
float4 _VRSRadii;
#define vrsOuterRadiusU _VRSRadii.x
#define vrsOuterRadiusV _VRSRadii.y
#define vrsInnerRadiusU _VRSRadii.z
#define vrsInnerRadiusV _VRSRadii.w

#define vrsOuterRadiusMinor _VRSRadii.x
#define vrsOuterRadiusMajor _VRSRadii.y
#define vrsInnerRadiusMinor _VRSRadii.z
#define vrsInnerRadiusMajor _VRSRadii.w

float4 _SRImageTileSize; // Tile width, tile height, 1/tile width, 1/tile height

// Each pair of numbers represents a shading rate width, height for a given
// integer value from the shading rate lookup table. Packed into float4's
// so index 0 contains the values for 0 and 1, 1 contains 2 and 3, and so on
CBUFFER_START(VRS_SRR_LUT)
	float4 shadingRate[4]; 
CBUFFER_END
// MSAA limits the maximum shading rate, index of the max shading rate found in the last value of shadingRate
#define _MaxShadingRateIndex shadingRate[3].w

uint GetShadingIndex(uint2 screenCoords)
{
	return LOAD_TEXTURE2D_X_LOD(_SRRTexture, screenCoords, 0u).r;
}

float2 GetShadingRate(uint shadingRateIndex)
{
	uint indexDiv2 = shadingRateIndex >> 1u;
	indexDiv2 = min(3u, indexDiv2); //Let the compiler know that our index is always less than 4
	float2 shadingRateValue = shadingRateIndex & 1u ? shadingRate[indexDiv2].zw : shadingRate[indexDiv2].xy;
	return shadingRateValue;
}

float2 GetShadingRateFromCoords(uint2 screenCoords)
{
#if SHADER_API_VULKAN
	int shadingRateIndex = (int)GetShadingIndex(screenCoords);
	return float2(1<<((shadingRateIndex >> 2) & 3), 1 << (shadingRateIndex & 3));
#else
	uint shadingRateIndex = GetShadingIndex(screenCoords);
	return GetShadingRate(shadingRateIndex);
#endif
}

float2 GetShadingRateNormalizedUV(float2 normalizedScreenUVs)
{
	uint2 screenCoords = normalizedScreenUVs * (_ScreenParams.xy * _SRImageTileSize.zw);
	return GetShadingRateFromCoords(screenCoords);
}

uint GetShadingIndexNormalizedUV(float2 normalizedScreenUVs)
{
	uint2 screenCoords = normalizedScreenUVs * (_ScreenParams.xy * _SRImageTileSize.zw);
	return GetShadingIndex(screenCoords);
}

#endif