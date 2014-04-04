using UnityEngine;
using System.Collections;


public class Smooth_arc_all : MonoBehaviour {
	
	void Start()
	{
		MeshFilter[] meshes = FindObjectsOfType (typeof(MeshFilter)) as MeshFilter[];
		for (int i=0;i<meshes.Length;i++)
		{
			if(meshes[i].mesh){
				MeshHelper.Subdivide(meshes[i].mesh,4);
				//meshes[i].mesh.bounds.Expand(15000);	
			}
		}
	}
	
	// Update is called once per frame
	void Update () {
		// boundsTarget is the center of the camera's frustum, in world coordinates:
	/*	Camera c = FindObjectOfType(typeof(Camera)) as Camera;
		Vector3 camPosition = c.transform.position;
		Vector3 normCamForward = Vector3.Normalize(c.transform.forward);
		float boundsDistance = (c.farClipPlane - c.nearClipPlane) / 2 + c.nearClipPlane;
		Vector3 boundsTarget = camPosition + (normCamForward * boundsDistance);
		
		// The game object's transform will be applied to the mesh's bounds for frustum culling checking.
		// We need to "undo" this transform by making the boundsTarget relative to the game object's transform:
		Vector3 realtiveBoundsTarget = this.transform.InverseTransformPoint(boundsTarget);

		MeshFilter[] meshes = FindObjectsOfType (typeof(MeshFilter)) as MeshFilter[];
		for (int i=0;i<meshes.Length;i++)
		{
			if(meshes[i].mesh){
				meshes[i].mesh.bounds = new Bounds(realtiveBoundsTarget, Vector3.one);	
			}
		}*/
	}
}
