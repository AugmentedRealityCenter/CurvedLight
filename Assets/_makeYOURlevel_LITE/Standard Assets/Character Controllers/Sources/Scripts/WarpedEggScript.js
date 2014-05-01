#pragma strict

var count : int = 0;
var eggs : GameObject[]; // store the egg objects
private var rand1 : int; // num 1 active egg
private var rand2 : int; // num 2 active egg

function Start(){
	setCountText();
	eggs = GameObject.FindGameObjectsWithTag("Egg");
	if(eggs.Length == 0){
	Debug.Log("No such GameObjects tagged with Egg.");
	}
	// deactive all the eggs
	for( var i = 0; i < eggs.Length; i ++){
		eggs[i].SetActive(false);
	}
	// randomly pick up two eggs to be active
	// avoid generate one egg only
	rand1 = Random.Range(1,eggs.Length / 2);
	rand2 = Random.Range(eggs.Length / 2, eggs.Length);
	eggs[rand1].SetActive(true);
	eggs[rand2].SetActive(true);
}

function Update() {
}

function OnTriggerEnter (other : Collider) {
		// active another two eggs each time
		if(count >= 1 && count < 1000){ // set the maximum number for the count
			eggs[rand1].SetActive(false);
			eggs[rand2].SetActive(false);
			rand1 = Random.Range(1,eggs.Length);
			rand2 = Random.Range(1,eggs.Length);
			eggs[rand1].SetActive(true);
			eggs[rand2].SetActive(true);
		}
	if ( other.gameObject.tag == "Egg"){
			other.gameObject.SetActive(false);
			count = count + 1 ;
			setCountText();
	}	
}
function setCountText(){
	var t : TextMesh[];
	t = GameObject.FindObjectsOfType(TextMesh);
	for(var i=0;i<t.Length;i++){
		t[i].text = "Count: " + count.ToString();
	}
}