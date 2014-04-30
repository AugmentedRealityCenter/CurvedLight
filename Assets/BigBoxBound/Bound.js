#pragma strict

function Start () {
    for (var t: Mesh in GameObject.FindObjectsOfType(Mesh))
    {
	  var mesh : Mesh = t;
	  if(mesh){
	  	//mesh.bounds.Expand(Vector3(20000,20000,20000));
	  	mesh.bounds.extents = Vector3(15000,15000,15000); 
	  }
	}
}

function Update () {

}