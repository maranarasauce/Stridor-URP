﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using UnityEngine;
//using Unity.Mathematics;

public class VolumetricRegisters
{
    public static List<VolumetricMedia> VolumetricMediaEntities = new List<VolumetricMedia>();
    public static List<BakedVolumetricArea> volumetricAreas = new List<BakedVolumetricArea>();

    public static bool _meshObjectsNeedRebuilding = true;


    public static void RegisterVolumetricArea(BakedVolumetricArea volumetricArea)
    {
#if UNITY_EDITOR
        if (volumetricArea.bakedTexture == null && Application.isPlaying) return; //quick check to make sure that this is valid
#else
        if (volumetricArea.bakedTexture == null) return; //quick check to make sure that this is valid
#endif
        volumetricAreas.Add(volumetricArea);
    }
    public static void UnregisterVolumetricArea(BakedVolumetricArea volumetricArea)
    {
        volumetricAreas.Remove(volumetricArea);
    }

    public static void RegisterParticipatingMedia(VolumetricMedia volumetricMedia)
    {
        VolumetricMediaEntities.Add(volumetricMedia);
    }
    public static void UnregisterParticipatingMedia(VolumetricMedia volumetricMedia)
    {
        VolumetricMediaEntities.Remove(volumetricMedia);
    }

}
