#ifndef POI_PARALLAX
    #define POI_PARALLAX
    #if defined(PROP_PARALLAXHEIGHTMAP) || !defined(OPTIMIZER_ENABLED)
        UNITY_DECLARE_TEX2D_NOSAMPLER(_ParallaxHeightMap); float4 _ParallaxHeightMap_ST;
    #endif
    #if defined(PROP_PARALLAXHEIGHTMAPMASK) || !defined(OPTIMIZER_ENABLED)
        POI_TEXTURE_NOSAMPLER(_ParallaxHeightMapMask);
    #endif
    float2 _ParallaxHeightMapPan;
    float _ParallaxStrength;
    float _ParallaxHeightMapEnabled;
    float _ParallaxUV;
    float _ParallaxInternalMapEnabled;
    #if defined(PROP_PARALLAXINTERNALMAP) || !defined(OPTIMIZER_ENABLED)
        UNITY_DECLARE_TEX2D_NOSAMPLER(_ParallaxInternalMap); float4 _ParallaxInternalMap_ST;
    #endif
    #if defined(PROP_PARALLAXINTERNALMAPMASK) || !defined(OPTIMIZER_ENABLED)
        POI_TEXTURE_NOSAMPLER(_ParallaxInternalMapMask);
    #endif
    float _ParallaxInternalIterations;
    float _ParallaxInternalMinDepth;
    float _ParallaxInternalMaxDepth;
    float _ParallaxInternalMinFade;
    float _ParallaxInternalMaxFade;
    float4 _ParallaxInternalMinColor;
    float4 _ParallaxInternalMaxColor;
    float4 _ParallaxInternalPanSpeed;
    float4 _ParallaxInternalPanDepthSpeed;
    float _ParallaxInternalHeightmapMode;
    float _ParallaxInternalHeightFromAlpha;
    float GetParallaxHeight(float2 uv)
    {
        #if defined(PROP_PARALLAXHEIGHTMAP) || !defined(OPTIMIZER_ENABLED)
            return clamp(UNITY_SAMPLE_TEX2D_SAMPLER(_ParallaxHeightMap, _MainTex, TRANSFORM_TEX(uv, _ParallaxHeightMap) + _Time.x * float4(0,0,0,0)).g, 0, .99999);
        #else
            return 0;
        #endif
    }
    float2 ParallaxRaymarching(float2 viewDir)
    {
        float2 uvOffset = 0;
        float stepSize = 0.1;
        float2 uvDelta = viewDir * (stepSize * (0.0 /*_ParallaxStrength*/));
        float stepHeight = 1;
        float surfaceHeight = GetParallaxHeight(poiMesh.uv[(0.0 /*_ParallaxUV*/)]);
        float2 prevUVOffset = uvOffset;
        float prevStepHeight = stepHeight;
        float prevSurfaceHeight = surfaceHeight;
        for (int i = 1; i < 10 && stepHeight > surfaceHeight; i ++)
        {
            prevUVOffset = uvOffset;
            prevStepHeight = stepHeight;
            prevSurfaceHeight = surfaceHeight;
            uvOffset -= uvDelta;
            stepHeight -= stepSize;
            surfaceHeight = GetParallaxHeight(poiMesh.uv[(0.0 /*_ParallaxUV*/)] + uvOffset);
        }
        float prevDifference = prevStepHeight - prevSurfaceHeight;
        float difference = surfaceHeight - stepHeight;
        float t = prevDifference / (prevDifference + difference);
        uvOffset = prevUVOffset -uvDelta * t;
        #if defined(PROP_PARALLAXHEIGHTMAPMASK) || !defined(OPTIMIZER_ENABLED)
            return uvOffset *= POI2D_SAMPLER_PAN(_ParallaxHeightMapMask, _MainTex, poiMesh.uv[(0.0 /*_ParallaxHeightMapMaskUV*/)], float4(0,0,0,0)).r;
        #else
            return uvOffset;
        #endif
    }
    void calculateandApplyParallax()
    {
        
        if ((1.0 /*_ParallaxHeightMapEnabled*/))
        {
            float2 parallaxOffset = ParallaxRaymarching(poiCam.tangentViewDir.xy);
            
            if((0.0 /*_ParallaxUV*/) == 0)
            {
                poiMesh.uv[0] += parallaxOffset;
            }
            
            if((0.0 /*_ParallaxUV*/) == 1)
            {
                poiMesh.uv[1] += parallaxOffset;
            }
            
            if((0.0 /*_ParallaxUV*/) == 2)
            {
                poiMesh.uv[2] += parallaxOffset;
            }
            
            if((0.0 /*_ParallaxUV*/) == 3)
            {
                poiMesh.uv[3] += parallaxOffset;
            }
        }
    }
    void calculateAndApplyInternalParallax(inout float4 finalColor)
    {
        #if defined(_PARALLAXMAP)
            
            if((0.0 /*_ParallaxInternalMapEnabled*/))
            {
                float3 parallax = 0;
                for (int j = (1.0 /*_ParallaxInternalIterations*/); j > 0; j --)
                {
                    float ratio = (float)j / (1.0 /*_ParallaxInternalIterations*/);
                    float2 parallaxOffset = _Time.y * (float4(0,0,0,0) + (1 - ratio) * float4(0,0,0,0));
                    float fade = lerp((0.0 /*_ParallaxInternalMinFade*/), (1.0 /*_ParallaxInternalMaxFade*/), ratio);
                    #if defined(PROP_PARALLAXINTERNALMAP) || !defined(OPTIMIZER_ENABLED)
                        float4 parallaxColor = UNITY_SAMPLE_TEX2D_SAMPLER(_ParallaxInternalMap, _MainTex, TRANSFORM_TEX(poiMesh.uv[0], _ParallaxInternalMap) + lerp((0.0 /*_ParallaxInternalMinDepth*/), (1.0 /*_ParallaxInternalMaxDepth*/), ratio) * - poiCam.tangentViewDir.xy + parallaxOffset);
                    #else
                        float4 parallaxColor = 0;
                    #endif
                    float3 parallaxTint = lerp(float4(1,1,1,1), float4(1,1,1,1), ratio);
                    float parallaxHeight;
                    if((0.0 /*_ParallaxInternalHeightFromAlpha*/))
                    {
                        parallaxTint *= parallaxColor.rgb;
                        parallaxHeight = parallaxColor.a;
                    }
                    else
                    {
                        parallaxHeight = parallaxColor.r;
                    }
                    
                    if ((0.0 /*_ParallaxInternalHeightmapMode*/) == 1)
                    {
                        parallax = lerp(parallax, parallaxTint * fade, parallaxHeight >= 1 - ratio);
                    }
                    else
                    {
                        parallax += parallaxTint * parallaxHeight * fade;
                    }
                }
                #if defined(PROP_PARALLAXINTERNALMAPMASK) || !defined(OPTIMIZER_ENABLED)
                    finalColor.rgb += parallax * POI2D_SAMPLER_PAN(_ParallaxInternalMapMask, _MainTex, poiMesh.uv[(0.0 /*_ParallaxInternalMapMaskUV*/)], float4(0,0,0,0)).r;
                #else
                    finalColor.rgb += parallax;
                #endif
            }
        #endif
    }
#endif
