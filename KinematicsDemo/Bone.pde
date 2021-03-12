
class Bone{
  
  // properties?
  
  // Relative direction the bone points in radians.
  // If the direction is 0, it points where the parent points.
  float dir = random(-1, 1); 
  
  // The length of the bone in pixels.
  float mag = random(50, 150);
  
  // References to parent and child bones.
  // Linked list data structure.
  Bone parent;
  ArrayList<Bone> children = new ArrayList<Bone>();
  
  boolean isRevolute = true; // Can it spin?
  boolean isPrismatic = true; // Can move?
  
  float wiggleOffset = random(0, 6.28);
  float wiggleAmp = random(.5f, 2);
  float wiggleTimeScale = random(.25f, 1);
  
  // Cached / derived values.
  PVector worldStart; // Start of bone in world space.
  PVector worldEnd; // End of bone in world space.
  float worldDir = 0; // World-space angle of the bone.
  int boneDepth = 0; // The number of parents a bone has
  
  Bone(Bone parent){
    this.parent = parent;
    
    int num = 0;
    Bone p = parent;
    while(p != null){
     num++;
     p = p.parent;
    }
    boneDepth = num;
  }
  
  Bone(int chainLength){
    if(chainLength > 1){
        AddBone(chainLength - 1);
      }
  }
  
  void AddBone(int chainLength){
    
    if(chainLength < 1) chainLength = 1;
    
    int numOfChildren = (int)random(1, 4);
    
    for(int i = 0; i < numOfChildren; i++){
      Bone newBone = new Bone(this);
      
      children.add(newBone);
      
      //newBone.parent = this;
      
      if(chainLength > 1){
         newBone.AddBone(chainLength - 1); 
      }
    }
  }
  

  void draw(){   
    calc();
    // TODO: draw line from bone start, to bone end.
    
    //line(worldStart.x, worldStart.y, worldEnd.x, worldEnd.y);
    
    fill(100, random(0, 255), 100);
    ellipse(worldStart.x, worldStart.y, 20, 20);
    
    for(Bone child : children) child.draw();
    
    fill(100, random(0, 255), 100);
    ellipse(worldEnd.x, worldEnd.y, 10, 10);
  }
  
  void calc(){
    // Calc bone start.
    
    if(parent != null){
     worldStart = parent.worldEnd;
     worldDir = parent.worldDir + dir;
    } else { // If we don't have a parent, use default values.
      worldStart = new PVector(100, 100);  
      worldDir = dir; 
    }
    
    //worldDir += sin(time) * (boneDepth + 1) / 10.0;
    worldDir += sin((time + wiggleOffset) * wiggleTimeScale) * wiggleAmp;
    
    // Calc bone end.
    PVector localEnd = PVector.fromAngle(worldDir); //new PVector(mag * cos(worldDir), mag * sin(worldDir));
    localEnd.mult(mag);
    
    worldEnd = PVector.add(worldStart, localEnd);
    
    for(Bone child : children) child.calc();   
  }
  
  Bone OnClick(){
    PVector mouse = new PVector(mouseX, mouseY);
    
    PVector vToMouse = PVector.sub(mouse, worldEnd);
    
    if(vToMouse.magSq() < 20 * 20) return this; // If dis to mouse is less than 20 pixels, return this bone.
    
    // Checks all child bones to see which was clicked.
    for(Bone child : children){
      Bone b = child.OnClick();
      if(b != null) return b;
    }
    
    return null;
  }
  
  void RemoveFromParent(){
   if(parent == null) return;
   
   parent.children.remove(this);
  }
  
  void Drag(){
   PVector mouse = new PVector(mouseX, mouseY);
   
   PVector vToMouse = PVector.sub(mouse, worldStart);
   
   if(isRevolute){
     if(parent != null){
       dir = atan2(vToMouse.y, vToMouse.x) - parent.worldDir;
      } else {
       dir = vToMouse.heading(); 
      }
   }
    if(isPrismatic) mag = vToMouse.mag();
  }
  
}
