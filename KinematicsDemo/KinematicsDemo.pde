
Bone bone = new Bone(7);

Bone draggedBone;

float time = 0; // How many seconds have passed overall.

void setup(){
  size(1920, 1800);
  
  //bone.child = new Bone();
  //bone.child.parent = bone; // Set the child bone's parent property.
}

// Called every time the engine ticks. "Update"
void draw(){

  //background(128);
  
  time = millis()/1000.0; // Calc ime
  
  if(draggedBone != null) draggedBone.Drag();
  
  bone.calc();
  bone.draw();
  
}

void mousePressed(){
  //bone = new Bone(5); 
  
  Bone clickedBone = bone.OnClick();
  
  if(Keys.SHIFT()){
    if(clickedBone != null){

    }
  } else {
      
    draggedBone = clickedBone; // Start dragging.
  
  }
}
 
void mouseReleased(){
 draggedBone = null; // Stop dragging. 
}
