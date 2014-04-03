using UnityEngine;
using System.Collections;


public class Smooth_arc : MonoBehaviour {
	
	void Start()
	{
		MeshFilter meshfilter = gameObject.GetComponent<MeshFilter> ();
		Mesh mesh = meshfilter.mesh;
		MeshHelper.Subdivide(mesh,4);   // divides a single quad into 6x6 quads
		meshfilter.mesh = mesh;
	}
	
	// Update is called once per frame
	void Update () {
	
	}
}
