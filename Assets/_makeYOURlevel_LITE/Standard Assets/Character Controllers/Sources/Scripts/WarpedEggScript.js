#pragma strict

// Does this script currently respond to input?
var count : int = 0;
var counttext : GUIText;
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
	rand1 = Random.Range(1,5);
	rand2 = Random.Range(5,10);
	eggs[rand1].SetActive(true);
	eggs[rand2].SetActive(true);
}

function Update() {
}

function OnTriggerEnter (other : Collider) {
		// active another two eggs each time
		if(count >= 1 && count < 100){ // set the maximum number for the count
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
	counttext.text = "Count: " + count.ToString();
}