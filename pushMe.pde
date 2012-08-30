// v0.9
// Calories.

Float s, e, lon, lat, time, cals, lastS, smax, latmax, latmin, lonmax, lonmin;
Float dDist, wDist, rDist, cDist, dTime, wTime, rTime, cTime;
Float wCals, rCals, cCals;
Float walkSlow, walkFast, runSlow, runFast, cycleSlow, cycleFast;
Float [] values;
PFont fontSmall, fontBig;
HashMap<Float, HashMap<Float, Float []>> master = new HashMap<Float, HashMap<Float, Float []>>();
PVector posn, l, lastR, lastP;
int wmeas;
//--------USER INPUT-------//
int trips = 7;             // <-- INPUT NUMBER OF SEPARATE TRIPS [trip1.csv, trip2.csv, trip3.csv...]
int kg = 70;
//-------------------------//

//----------------------------------------------------------------------------------------------------//
//----------------------------------------------------------------------------------------------------//
//----------------------------------------------------------------------------------------------------//
void setup()
{
  size(400, 600);
  background(255); 
  fill(0);
  strokeWeight(2);
  fill(220);
  noLoop();
  
  textAlign(CENTER);
  fontSmall = loadFont("Avenir-Book-13.vlw");
  fontBig = loadFont("AvenirNext-Bold-22.vlw");
  textFont(fontSmall, 12);
  textSize(12);
  fill(180);
  text("Activity by Distance", width/2, height-162);
  text("Activity by Time", width/2, height-82);
  
  dDist = 0.0;
  wDist = 0.0;
  rDist = 0.0;
  cDist = 0.0;
  dTime = 0.0;
  wTime = 0.0;
  rTime = 0.0;
  cTime = 0.0;
  time = 0.0;
  wCals = 0.0;
  rCals = 0.0;
  cCals = 0.0;
  cals = 0.0;
  lastP = null;
  wmeas = height/12;

  for (int i = 1; i <= trips; i++)
  {
    String input = "trip" + i + ".csv";
    Float j = new Float (i);
    loadEntries(input, j);
  }
  
  calSetup();
  
  int keywidth = (width-40)/5;
  int keyspace = keywidth/3;
  
  noStroke();
  textSize(12);
  
  fill(0);
  text("22/07/12", width/2-30, 20);
  text("-", width/2, 20);
  text("28/07/12", width/2+30, 20);
  
  fill(180);
  text("Driving", 20+keywidth/2, 40);
  text("Walking", 20+keywidth+keyspace+keywidth/2, 40);
  text("Running", 20+2*keywidth+2*keyspace+keywidth/2, 40);
  text("Cycling", 20+3*keywidth+3*keyspace+keywidth/2, 40);
  
  fill(245, 180, 60);
  rect(20, 45, keywidth, 10); 
  fill(43, 107, 145);
  rect(20+keywidth+keyspace, 45, keywidth, 10); 
  fill(85, 177, 85);
  rect(20+2*keywidth+2*keyspace, 45, keywidth, 10);  
  fill(233, 71, 123);
  rect(20+3*keywidth+3*keyspace, 45, keywidth, 10);
  
  stroke(200);
  strokeWeight(1);
  line(30, 70, width-30, 70);
  line(30, height-210, width-30, height-210);
  line(30, 70, 30, height-210);
  line(width-30, 70, width-30, height-210);
}

//----------------------------------------------------------------------------------------------------//
//----------------------------------------------------------------------------------------------------//
//----------------------------------------------------------------------------------------------------//
void draw()
{
  smooth();
  
  for (int i = 1; i <= trips; i++)
  {
    Float j = new Float (i);
    HashMap<Float, Float []> data = master.get(j);
    while (time/10 <= smax)
    {
      drawTrip(data);
      time++;
    }
    time = 0.0;
    lastP = null;
  }

  float mDist = dDist;
  if (wDist > mDist) mDist = wDist;
  else if (rDist > mDist) mDist = rDist;
  else if (cDist > mDist) mDist = cDist;
  
  float mTime = dTime;
  if (wTime > mTime) mTime = wTime;
  else if (rTime > mTime) mTime = rTime;
  else if (cTime > mTime) mTime = cTime;
   
  noSmooth();
  fill(245, 180, 60);
  stroke(245, 180, 60);
  rect(20, height-155, width-map(dDist, mDist, 0, 40, width), 10);
  rect(20, height-75, width-map(dTime, mTime, 0, 40, width), 10);
  
  fill(43, 107, 145);
  stroke(43, 107, 145);
  rect(20, height-140, width-map(wDist, mDist, 0, 40, width), 10);
  rect(20, height-60, width-map(wTime, mTime, 0, 40, width), 10);
  
  fill(85, 177, 85);
  stroke(85, 177, 85);
  rect(20, height-125, width-map(rDist, mDist, 0, 160, width), 10);
  rect(20, height-45, width-map(rTime, mTime, 0, 40, width), 10);
  
  fill(233, 71, 123);
  stroke(233, 71, 123);
  rect(20, height-110, width-map(cDist, mDist, 0, 40, width), 10);
  rect(20, height-30, width-map(cTime, mTime, 0, 40, width), 10);
  
  textFont(fontBig, 22);
  textSize(22);
  fill(0);
  text(Math.round(cals), width/2-20, height-182);
  fill(180);
  text("cals", width/2+20, height-182);
}

//----------------------------------------------------------------------------------------------------//
//----------------------------------------------------------------------------------------------------//
//----------------------------------------------------------------------------------------------------//
void loadEntries(String input, Float j)
{
  HashMap<Float, Float []> data = new HashMap<Float, Float []>();
  float speed;
  String [] entries = loadStrings(input);
  for (int i = 2; i < entries.length; i++)
  {
    String [] tparse = split(entries[i], ","); // Split row i of the imported .csv into columns, by the separator ","
    Float s = parseFloat(tparse[1]);
    s = new Float ((Math.round(s*10)));
    s = s/10;
    Float nrg = parseFloat(tparse[12]);
    Float ent = parseFloat(tparse[18]);
    Float lat = parseFloat(tparse[13]);
    Float lon = parseFloat(tparse[14]);
    PVector loc = new PVector(lat, lon);

    //Create float array with segment parameters
    Float [] all = new Float[5];
    all[0] = lat;
    all[1] = lon;
    if (latmax == null || lat >= latmax) latmax = lat; 
    if (latmin == null || lat < latmin) latmin = lat; 
    if (lonmax == null || lon >= lonmax) lonmax = lon;
    if (lonmin == null || lon < lonmin) lonmin = lon;

    // Colculate speed
    if (lastR != null)
    {
      // Calculate change in time
      float t = s - lastS;

      // Declare variables
      float lat1 = lastR.x;
      float lat2 = lat;
      float lon1 = lastR.y;
      float lon2 = lon;
      double R = Math.toRadians(6371);

      // Calculate great circle distance (Haversine formula)
      // Haversine formula - R. W. Sinnott, "Virtues of the Haversine", Sky and Telescope, vol 68, no 2, 1984
      double dLat = Math.toRadians(lat2 - lat1);
      double dLon = Math.toRadians(lon2 - lon1);
      double l1 = Math.toRadians(lat1);
      double l2 = Math.toRadians(lat2);

      double a = ((Math.sin(dLat/2) * Math.sin(dLat/2)) + (Math.sin(dLon/2) * Math.sin(dLon/2) * Math.cos(l1) * Math.cos(l2)));
      double c = (2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a)));
      double out = R * c;
      float d = (float)(Math.toDegrees(out)*1000);
      all[4] = d;

      speed = d / t;
      all[2] = speed;
      if (speed > 0 && nrg < 2 && ent > 6) all[3] = 1.0; // Driving
      else if (speed > 0 && nrg < 10 && ent > 6) all[3] = 2.0; // Walking
      else if (speed > 0 && nrg > 10 && ent > 6) all[3] = 3.0; // Running
      else if (speed > 0 && ent < 6) all[3] = 4.0; // Cycling
      else all[3] = 0.0; //Stationary
    }

    if (i == entries.length-1) 
    {
      if (smax == null || s > smax) smax = s;
    }

    data.put(s, all);

    lastS = s;
    lastR = new PVector(lat, lon);
  }
  master.put(j, data);
}



//----------------------------------------------------------------------------------------------------//
//----------------------------------------------------------------------------------------------------//
//----------------------------------------------------------------------------------------------------//
void drawTrip (HashMap<Float, Float []> drawing)
{
  if (drawing.containsKey(time/10))
  {
    values = drawing.get(time/10);
    Float x = map(values[0], latmin, latmax, 0+50, width-50);
    Float y = map(values[1], lonmin, lonmax, 0+80, height-220);
    posn = new PVector(x, y);
    noStroke();    

    if (lastP != null) 
    {
      Float spd = values[2];
      Float mode = values[3];
      if (mode != null && mode == 1.0) // Driving
      {
        dDist = dDist + values[4];
        dTime = dTime + (values[4]/spd);
        stroke(245, 180, 60);        
      }

      else if (mode != null && mode == 2.0) // Walking
      {
        wDist = wDist + values[4];
        wTime = wTime + (values[4]/spd);
        float calHr = map(spd, 0.7, 2, walkSlow, walkFast);
        float calThis = (values[4]/spd) * (calHr/3600);
        cals = cals + calThis;
        stroke(43, 107, 145);
      }
      
      else if (mode != null && mode == 3.0) // Running
      {
        rDist = rDist + values[4];
        rTime = rTime + (values[4]/spd);
        float calHr = map(spd, 2, 4, runSlow, runFast);
        float calThis = (values[4]/spd) * (calHr/3600);
        cals = cals + calThis;
        stroke(85, 177, 85);
      }
      
      else if (mode != null && mode == 4.0) // Cycling
      {
        cDist = cDist + values[4];
        cTime = cTime + (values[4]/spd);
        float calHr = map(spd, 4, 8, cycleSlow, cycleFast);
        float calThis = (values[4]/spd) * (calHr/3600);
        cals = cals + calThis;
        stroke(233, 71, 123);
      }
      else noStroke();
    }
    if (lastP == null) point(x, y);
    else line(lastP.x, lastP.y, x, y);
    lastP = new PVector(x, y);
  }
}

void calSetup()
{
  // Walking
  walkSlow = map(kg, 58, 90, 140, 230);
  walkFast = map(kg, 58, 90, 470, 750);
  // Running
  runSlow = map(kg, 58, 90, 500, 745);
  runFast = map(kg, 58, 90, 1000, 1670);
  // Cycling
  cycleSlow = map(kg, 58, 90, 230, 370);
  cycleFast = map(kg, 58, 90, 700, 1100);
}
