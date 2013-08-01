/* --------------------------------------------------------------------------
 * SimpleOpenNI User Test
 *  --------------------------------------------------------------------------
 * Processing Wrapper for the OpenNI/Kinect library
 * http://code.google.com/p/simple-openni
 * --------------------------------------------------------------------------
 * prog:  Max Rheiner / Interaction Design / zhdk / http://iad.zhdk.ch/
 * date:  02/16/2011 (m/d/y)
 * ----------------------------------------------------------------------------
 */
import static java.lang.Double.*;
import org.json.*;
import java.util.*;
import java.util.Iterator;
import java.util.Map;
import java.util.Set;

import SimpleOpenNI.*;
int currentTime;
float mn;
PFont myFont;
PFont myFont2;
SimpleOpenNI  context;
boolean       autoCalib=true;
PImage img;
PImage[] foodImg;
PImage[] menuImg;
PImage[] btmImg;
float xoff = 0.0;
int money=0;
JSONObject json;
JSONObject SKELj;
Map<String, String> Image_map ;

int mx=0, my=0,mlx=0,mly=0,myfx=0,myfy=0,mylfx=0,mylfy=0;

float[][] circles;
int i = 10;
float newY;
String[] mp = new String[50];
String[] bodys = new String[20];

btn[] menuBtn = new btn[50];
resetBtn menuResetBtn, menuOkBtn;
int RhandZ=0, BodyZ=0;

String[] ary = "本作品承載的既不是文字也不是圖像我們企圖體現的是在文字與圖像相遇、詩句與錄像邂逅的時刻其所形成的當下狀態這是種無法說明的不確定性充滿流動感作者所關注的並非只是視覺本體論更是讓觀眾體現這些感受的過程我們藉以深刻思考「我」以及「其他」之間是否佔據著等量的篇幅；藉著這件作品身體成了媒介臉部神情成了載體我們透過面容與詩句互動揣測軀殼的意義文字本身僅是認知途徑朝著自己走過來的方向看看曾經的細心經營".split("");

int colorr=100;
void setup()
{



  Image_map =  new HashMap<String, String>();


  for (int i=0;i<mp.length;i++) mp[i]=null;
  mp[1]="SKEL_HEAD";
  mp[2]="SKEL_NECK";
  mp[6]="SKEL_LEFT_SHOULDER";
  mp[7]="SKEL_LEFT_ELBOW";
  mp[9]="SKEL_LEFT_HAND";
  mp[12]="SKEL_RIGHT_SHOULDER";
  mp[13]="SKEL_RIGHT_ELBOW";
  mp[15]="SKEL_RIGHT_HAND";
  mp[3]="SKEL_TORSO";
  mp[17]="SKEL_LEFT_HIP";
  mp[18]="SKEL_LEFT_KNEE";
  mp[20]="SKEL_LEFT_FOOT";
  mp[21]="SKEL_RIGHT_HIP";
  mp[22]="SKEL_RIGHT_KNEE";
  mp[24]="SKEL_RIGHT_FOOT";

  // println(SimpleOpenNI.SKEL_HEAD+" "+SimpleOpenNI.SKEL_NECK+" "+SimpleOpenNI.SKEL_LEFT_SHOULDER+" "+SimpleOpenNI.SKEL_LEFT_ELBOW+" "+SimpleOpenNI.SKEL_LEFT_HAND+" "+SimpleOpenNI.SKEL_RIGHT_SHOULDER+" "+SimpleOpenNI.SKEL_RIGHT_ELBOW+" "+SimpleOpenNI.SKEL_RIGHT_HAND+" "+SimpleOpenNI.SKEL_TORSO+" "+SimpleOpenNI.SKEL_LEFT_HIP+" "+SimpleOpenNI.SKEL_LEFT_KNEE+" "+SimpleOpenNI.SKEL_LEFT_FOOT+" "+SimpleOpenNI.SKEL_RIGHT_HIP+" "+SimpleOpenNI.SKEL_RIGHT_KNEE+" "+SimpleOpenNI.SKEL_RIGHT_FOOT);

  /*
  */





  foodImg = new PImage[50];


  //  foodImg[0]= loadImage("http://www.hollywoodreporter.com/sites/default/files/2012/12/img_logo_blue.jpg");


  btmImg = new PImage[2];
  btmImg[0]= loadImage("ok.png");
  btmImg[1]= loadImage("reset.png");


  context = new SimpleOpenNI(this, SimpleOpenNI.RUN_MODE_MULTI_THREADED);
  context.setMirror(true);


  // enable depthMap generation 
  if (context.enableDepth() == false)
  {
    println("Can't open the depthMap, maybe the camera is not connected!"); 
    exit();
    return;
  }
  context.enableRGB();
  // enable skeleton generation for all joints
  context.enableUser(SimpleOpenNI.SKEL_PROFILE_ALL);

  background(200, 0, 0);

  stroke(0, 0, 255);
  strokeWeight(3);
  smooth();

  size(context.depthWidth(), context.depthHeight());
  //    size(800, 600);

  img = loadImage("s.png");
  circles = new float[100][5];
  for (int x = 0; x < i; x ++) {
    circles[x][0] = random(100, width-100);
    circles[x][1] = 0;
    circles[x][2] = 0;
  }


  bodys[0]="SimpleOpenNI.SKEL_RIGHT_HIP";
  myFont = createFont("王漢宗中行書繁", 50);
  myFont2 = createFont("微軟正黑體", 20);


  menuImg = new PImage[50];
  int j = 0;
  menuImg[j++] = loadImage("日式料理/日式豬排飯.jpg");
  menuImg[j++] = loadImage("日式料理/生魚片.JPG");
  menuImg[j++] = loadImage("日式料理/和風沙拉.JPG");
  menuImg[j++] = loadImage("日式料理/拉麵.jpg");
  menuImg[j++] = loadImage("日式料理/茶碗蒸.jpg");
  menuImg[j++] = loadImage("日式料理/壽司.jpg");
  menuImg[j++] = loadImage("日式料理/蝦手卷.jpg");

  for (int i=0; i<50 ; i++)
  {
    menuBtn[i] = new btn( width-80, i*70, 70, 70, i*10);
  }


  fetchUserData();

  resetBtn menuResetBtn = new resetBtn(0, height-110, 100, 100);
  resetBtn menuOkBtn = new resetBtn( 0, 0+10, 100, 100 );
  println(menuResetBtn);
}

void draw()
{

  //println(SimpleOpenNI);
  // update the cam
  context.update();

  // draw depthImageMap
  background(255);


  image(context.rgbImage(), 0, 0, 100, 100);
  image(context.rgbImage(), 0, 0);



  // draw the skeleton if it's available
  int[] userList = context.getUsers();
  for (int i=0;i<userList.length;i++)
  {
    if (context.isTrackingSkeleton(userList[i]))
      drawSkeleton(userList[i]);
  }


  //Display created circles
  for (int x = 0; x < i; x ++) {
    currentTime = millis();
    newY = circles[x][1]+0.5*30*0.001*0.001*(currentTime-circles[x][2])*(currentTime-circles[x][2]);
    //    image(img, circles[x][0], newY, img.width/4, img.height/4);
  }

  //   image(img, 0, 0, width/2, height/2);

  textSize(15);
  fill(255);
  textAlign(CENTER, TOP);
  textFont(myFont);

  text("百度CLBC日式料理", width/2, 0);
  textFont(myFont2);

  text("當前價格: "+money+" 元", 170, height-50);
  
    drawMenu();

}

// draw the skeleton with the selected joints
void drawSkeleton(int userId)
{
  getBodyText(userId);
}

// -----------------------------------------------------------------
// SimpleOpenNI events

void onNewUser(int userId)
{
  fetchUserData();
  println("onNewUser - userId: " + userId);
  println("  start pose detection");

  if (autoCalib)
    context.requestCalibrationSkeleton(userId, true);
  else    
    context.startPoseDetection("Psi", userId);
}

void onLostUser(int userId)
{
  println("onLostUser - userId: " + userId);
}

void onExitUser(int userId)
{
  println("onExitUser - userId: " + userId);
}

void onReEnterUser(int userId)
{
  fetchUserData();
  println("onReEnterUser - userId: " + userId);
}

void onStartCalibration(int userId)
{
  println("onStartCalibration - userId: " + userId);
}

void onEndCalibration(int userId, boolean successfull)
{
  println("onEndCalibration - userId: " + userId + ", successfull: " + successfull);

  if (successfull) 
  { 
    println("  User calibrated !!!");
    context.startTrackingSkeleton(userId);
  } 
  else 
  { 
    println("  Failed to calibrate user !!!");
    println("  Start pose detection");
    context.startPoseDetection("Psi", userId);
  }
}

void onStartPose(String pose, int userId)
{


  println("onStartPose - userId: " + userId + ", pose: " + pose);
  println(" stop pose detection");

  context.stopPoseDetection(userId); 
  context.requestCalibrationSkeleton(userId, true);

  //    println("key：Item 1 對應的元素為：" + mp.get("SKEL_HEAD"));
}

void onEndPose(String pose, int userId)
{
  println("onEndPose - userId: " + userId + ", pose: " + pose);
}

void getBodyText(int userId)
{


  for (int i =0 ; i < 40 ;i++)
  {
    PVector jointPos = new PVector();
    context.getJointPositionSkeleton(userId, i, jointPos);


    PVector jointPos_Proj = new PVector();

    context.convertRealWorldToProjective( jointPos, jointPos_Proj);


    noStroke();
    fill(200, 0, 0);
    float myX= jointPos_Proj.x, myY=jointPos_Proj.y, myZ=jointPos_Proj.z;

    if ( i == 15) //hand
    {
      mx = (int)myX;
      my = (int)myY;
      RhandZ = (int)myZ;
    }
    if ( i == 9) // left hand
    {
      mlx = (int)myX;
      mly = (int)myY;
    }
    if ( i==3)
    {
      BodyZ = (int)myZ;
    }
    if(i==20)
    {
        myfx = (int)myX;
      myfy = (int)myY;
   }
    //    println(BodyZ+" "+RhandZ);
    textSize(15);
    textFont(myFont);

    if ( isNaN(myX)  ) 
    {
      //      println("NAN");
      continue;
    }

    if (myZ>1300)
    {
      colorr =colorr +100;
      // println(myZ);
    }
    else
    {
      colorr =colorr - 100;
    }

    if ( myX> width/2)
    {
      fill(255, 255, 255);
    }
    else
    {
      fill(colorr, 0, 0);
    }
    for (int j=0; j<1;j++)
    {   
      if (myX < 0 )return;

      //  mn = map(  abs(myX)+abs(myY), 0, width+height, 0, ary.length);
      //      println(myX +" "+myY+" "+  mn);
      //  println(myZ); //1000 = 1 m
      //
      //      text( ary[ int(mn-1) ], (int)myX+j*20, (nt)myY+j*20); 
      //   println(mp[i]);
      // String temp = SKELj.getString( mp[i]  ).toString();
      //      foodImg[ mp[i] ] = temp;
      if (foodImg[i]!=null)
        image( foodImg[i], myX, myY, 50 * (myZ/1000), 50 * (myZ/1000));
    }
  }
}

void drawMenu()
{
  //  img = "0.png"

  //  println("===");
  for (int i=0; i<7; i++)
  {
    //    println(i);
    if ( menuImg[i] == null ) break;
    //menuBtn[i] = new btn( width-10-50, i*50+10, 50, 50);
    image( menuImg[i], menuBtn[i].x, menuBtn[i].y, menuBtn[i].w, menuBtn[i].h);
    menuBtn[i].overRect( mx, my );
    menuBtn[i].display();
    //    println( i+": "+   menuBtn[i].overRect( mx , my   



    





       image(btmImg[0], 0, 0+10, 100, 100); //ok





  //  myfx=mouseX;  myfx=mouseY;
    if ( myfx<100 && myfy>height-100)
    {
      image(btmImg[1], 0, height-80, 100+10, 100+10); //reset
      tint(100, 153, 204);  // Tint blue

      for (int k=0; k<menuBtn.length;k++)
      {
        menuBtn[k].buy=0;
      }
      money=0;
    }
    else
    {
      noTint();
      image(btmImg[1], 0, height-80, 100, 100); //reset
    }

    //    println(menuResetBtn);
    //    menuResetBtn.overRect(mx, my);
    //    menuOkBtn.overRect(mx, my);
  }
}


void fetchUserData()
{
  json = loadJSONObject("http://healthapp.duapp.com/getdata.php");
  //  int id = json.getInt("id");
  //  String species = json.getString("species");
  //  SKELj = json.getJSONObject("SKEL");
  println(json);

  String temp = json.getString("head"); 
  foodImg[1]= loadImage(temp+".png"); 

  temp  = json.getString("chest");
  foodImg[3]= loadImage(temp+".png"); 

  temp  = json.getString("belly");
  foodImg[17]= loadImage(temp+".png"); 
  foodImg[21]= loadImage(temp+".png"); 

  temp  = json.getString("hand");
  foodImg[9]= loadImage(temp+".png"); 
  foodImg[15]= loadImage(temp+".png"); 

  temp  = json.getString("leg");
  foodImg[22]= loadImage(temp+".png"); 
  foodImg[24]= loadImage(temp+".png"); 
  foodImg[18]= loadImage(temp+".png"); 
  foodImg[20]= loadImage(temp+".png"); 
  /*
  for (int i=0; i<40; i++)
   {
   if (mp[i]!=null)
   {
   //      println(i  );
   foodImg[i] = loadImage( SKELj.getString( mp[i]  ).toString() );
   
   Image_map.put( SKELj.getString( mp[i]  ).toString(), SKELj.getString( mp[i]  ).toString()  );
   
   // menu_images[i] = SKELj.getString( mp[i]  ).toString()
   //
   }
   // SKELj.getString( mp[i]  ).toString()
   }
   */

  //////////
  /*
  Collection collection = Image_map.values();
   Iterator iterator = collection.iterator();
   int i=0;
   while (iterator.hasNext ()) {
   //        Image_map[i]=
   //                image( loadImage( iterator.next().toString() ), width-100, i*50+10, 50, 50);
   menuImg[i] = loadImage( iterator.next().toString() );
   i++;
   //println(i);
   //     System.out.println(iterator.next());
   }
   */
}

