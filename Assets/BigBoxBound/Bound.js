#pragma strict

function Start () {
    for (var t: MeshFilter in GameObject.FindObjectsOfType(MeshFilter))
    {
	  var mesh : Mesh = t.mesh;
	  if(mesh){
	  	mesh.bounds.extents = Vector3(15000,15000,15000); 
	  }
	}
}

function Update () {

}