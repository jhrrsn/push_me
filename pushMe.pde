// v0.7
// New display method, multiple route viewing.

Float s, e, lon, lat, time, lastS, smax, latmax, latmin, lonmax, lonmin;
Float [] values;
HashMap<Float, HashMap<Float, Float []>> master = new HashMap<Float, HashMap<Float, Float []>>();
PVector posn, l, lastR, lastP;
int wmeas;

//----------------------------------------------------------------------------------------------------//
//----------------------------------------------------------------------------------------------------//
//----------------------------------------------------------------------------------------------------//
void setup()
{
  size(600, 600);
  background(255);
  
  for (int i = 1; i <= 3; i++)
  {
    String input = "test" + i + ".csv"; // Test1 = Shaun, Test2 = Rachel, Test3 = Walking round Cobalt Quarter
    Float j = new Float (i);
    loadEntries(input, j);
  }

  fill(0);
  
  smooth();
  strokeWeight(2);
  fill(220);
  textAlign(LEFT);
  textSize(12);
  fill(180);
  text("pushMe Visualisation Platform", 10, 20);
  text("v0.7", 10, 35);
  time = 0.0;
  lastP = null;
  wmeas = height/12;
  noLoop();
}

//----------------------------------------------------------------------------------------------------//
//----------------------------------------------------------------------------------------------------//
//----------------------------------------------------------------------------------------------------//
void draw()
{
  
  for (int i = 1; i <= 3; i++)
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
}

//----------------------------------------------------------------------------------------------------//
//----------------------------------------------------------------------------------------------------//
//----------------------------------------------------------------------------------------------------//
void loadEntries(String input, Float j)
{
  HashMap<Float, Float []> data = new HashMap<Float, Float []>();
  float speed;
  String [] entries = loadStrings(input);
  
  for(int i = 2; i < entries.length; i++)
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
    if(lastR != null)
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
      
      speed = d / t;
      all[2] = speed;
      if (speed > 0 && nrg < 2 && ent > 6) all[3] = 1.0; // Driving
      else if (speed > 0 && nrg > 2 && ent > 6) all[3] = 2.0; // Foot
      else if (speed > 0 && ent < 6) all[3] = 3.0; // Cycling
      else all[3] = 0.0; //Stationary
    }
    
    if(i == entries.length-1) 
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
    Float x = map(values[0], latmin, latmax, 0+10, width-10);
    Float y = map(values[1], lonmin, lonmax, 0+10, height-10);
    posn = new PVector(x, y);
    noStroke();    
    
    if (lastP != null) 
    {
      Float spd = values[2];
      Float mode = values[3];
      if (mode != null && mode == 1.0)
      {
        int colD = int(map (spd, 0, 25, 0, 6));
        switch(colD) {
          case 0:
            stroke(255, 195, 198);
            break;
          case 1:
            stroke(255, 150, 156);
            break;
          case 2:
            stroke(255, 101, 113);
            break;
          case 3:
            stroke(255, 34, 65);
            break;
          case 4:
            stroke(247, 0, 43);
            break;
          case 5:
            stroke(217, 0, 0);
            break;
          case 6:
            stroke(172, 0, 0);
            break;
          default:
            noStroke();
            break;
        }
      }
      
      else if (mode != null && mode == 2.0)
      {
        int col = int(map (spd, 0.5, 3, 0, 6));
        switch(col) {
          case 0:
            stroke(186, 248, 249);
            break;
          case 1:
            stroke(158, 248, 227);
            break;
          case 2:
            stroke(132, 247, 192);
            break;
          case 3:
            stroke(95, 208, 147);
            break;
          case 4:
            stroke(79, 185, 106);
            break;
          case 5:
            stroke(67, 156, 71);
            break;
          case 6:
            stroke(57, 133, 54);
            break;
          default:
            noStroke();
            break;
        }
      }
      else if (mode != null && mode == 3.0)
      {
        int col = int(map (spd, 0.5, 3, 0, 6));
        switch(col) {
          case 0:
            stroke(186, 248, 249);
            break;
          case 1:
            stroke(158, 248, 227);
            break;
          case 2:
            stroke(132, 247, 192);
            break;
          case 3:
            stroke(95, 208, 147);
            break;
          case 4:
            stroke(79, 185, 106);
            break;
          case 5:
            stroke(67, 156, 71);
            break;
          case 6:
            stroke(57, 133, 54);
            break;
          default:
            noStroke();
            break;
        }
      }
      else noStroke();
    }
    strokeWeight(2);
    if(lastP == null) point(x, y);
    else line(lastP.x, lastP.y, x, y);
    lastP = new PVector(x, y);
  }
}
