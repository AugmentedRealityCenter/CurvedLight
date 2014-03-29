using UnityEngine;
using System.Collections;

public class Bound : MonoBehaviour {
	void Start () {
		MeshFilter[] meshes = FindObjectsOfType (typeof(MeshFilter)) as MeshFilter[];
		for (int i=0;i<meshes.Length;i++)
	    {
			  if(meshes[i].mesh){
				MeshHelper.Subdivide(meshes[i].mesh,4);
				meshes[i].mesh.bounds.Expand(150000);

			  }
		}
	}

	void Update () {

}

}