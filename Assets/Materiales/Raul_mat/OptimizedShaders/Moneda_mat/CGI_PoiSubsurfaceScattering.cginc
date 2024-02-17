#ifndef SUBSURFACE
    #define SUBSURFACE
    float _SSSThicknessMod;
    float _SSSSCale;
    float _SSSPower;
    float _SSSDistortion;
    float4 _SSSColor;
    float _EnableSSS;
    #if defined(PROP_SSSTHICKNESSMAP) || !defined(OPTIMIZER_ENABLED)
        POI_TEXTURE_NOSAMPLER(_SSSThicknessMap);
    #endif
    float3 calculateSubsurfaceScattering()
    {
        #if defined(PROP_SSSTHICKNESSMAP) || !defined(OPTIMIZER_ENABLED)
            float SSS = 1 - POI2D_SAMPLER_PAN(_SSSThicknessMap, _MainTex, poiMesh.uv[(0.0 /*_SSSThicknessMapUV*/)], float4(0,0,0,0));
        #else
            float SSS = 1;
        #endif
        half3 vLTLight = poiLight.direction + poiMesh.normals[0] * (1.0 /*_SSSDistortion*/);
        half flTDot = pow(saturate(dot(poiCam.viewDir, -vLTLight)), (5.0 /*_SSSPower*/)) * (0.25 /*_SSSSCale*/);
        #ifdef FORWARD_BASE_PASS
            half3 fLT = (flTDot) * saturate(SSS + - 1 * (0.0 /*_SSSThicknessMod*/));
        #else
            half3 fLT = poiLight.attenuation * (flTDot) * saturate(SSS + - 1 * (0.0 /*_SSSThicknessMod*/));
        #endif
        return fLT * poiLight.color * float4(1,0,0,1) * poiLight.attenuation;
    }
#endif
