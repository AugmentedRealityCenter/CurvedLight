// uScript Action Node
// (C) 2012 Detox Studios LLC
#if UNITY_3_5
using UnityEngine;
using System.Collections;

[NodePath("Actions/Application/Quality Settings")]

[NodeCopyright("Copyright 2011 by Detox Studios LLC")]
[NodeToolTip("Gets the LOD Bias from the current Quality Settings.")]
[NodeAuthor("Detox Studios LLC", "http://www.detoxstudios.com")]
[NodeHelp("http://www.uscript.net/docs/index.php?title=Node_Reference_Guide")]

[FriendlyName("Get LOD Bias", "Gets the LOD Bias multiplier from the current Quality Settings.")]
public class uScriptAct_QualitySettingsGetLodBias : uScriptLogic
{
   public bool Out { get { return true; } }

   public void In([FriendlyName("Value", "The current value for this quality setting level.")] out float Value)
   {
      Value = QualitySettings.lodBias;
   }
}
#endif