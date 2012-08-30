Float s, e, lon, lat, time, lastS, smax, latmax, latmin, lonmax, lonmin;
Float [] values;
HashMap<Float, Float []> data = new HashMap<Float, Float []>(); //Time:Float Array - Lat|Lon|Energy
PVector posn, l, lastR, lastP, TEST;

void setup()
{
  size(600, 600);
  background(255);
  frameRate(120);
  loadEntries();
  smooth();
  strokeWeight(2);
  fill(220);
  text("pushMe Visualisation Platform", 10, 20);
  text("v. 0.2.0", 10, 35);
  time = 0.0;
  lastP = null;
}

void draw()
{   

  if (data.containsKey(time/100))
  {
    values = data.get(time/100);
    
    Float x = map(values[0], latmin, latmax, 0+50, width-50);
    Float y = map(values[1], lonmin, lonmax, 0+50, width-50);
    posn = new PVector(x, y);
    noStroke();
    if (lastP != null) 
    {
      Float tm = values[2];
      if (tm > 0)
      {
        int col = int(map (tm, 5, 15, 0, 6));
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
//            noStroke();
            stroke(0);
            break;
        }
      }
      else noStroke();
    }
    if(lastP == null) point(x, y);
    else line(lastP.x, lastP.y, x, y);
    lastP = new PVector(x, y);
  }
  
  time++;
  if (time >= smax*100) setup();
  
  noStroke();
  fill(255);
  rect(width-60, height-30, 60, 30);
  fill(180);
  text(time/100, width-50, height-20);

}

void loadEntries()
{
  String [] entries = loadStrings("resultsW.csv");
  
  for(int i = 1; i < entries.length; i++)
  {
    String [] tparse = split(entries[i], ","); // Split row i of the imported .csv into columns, by the separator ","
    Float s = parseFloat(tparse[1]);
    s = new Float ((Math.round(s*100)));
    s = s/100;
    Float e = parseFloat(tparse[12]);
    Float lat = parseFloat(tparse[13]);
    Float lon = parseFloat(tparse[14]);
    PVector loc = new PVector(lat, lon);
    
    // Colculate speed
    if(lastR != null)
    {
      // Calculate change in time
      Float t = s - lastS;
      
      // Declare variables
      float lat1 = lastR.x;
      float lat2 = lat;
      float lon1 = lastR.y;
      float lon2 = lon;
      double R = Math.toRadians(6371);
      
      // Calculate great circle distance (Haversine formula)
      double dLat = Math.toRadians(lat2 - lat1);
      double dLon = Math.toRadians(lon2 - lon1);
      double l1 = Math.toRadians(lat1);
      double l2 = Math.toRadians(lat2);
      
      double a = ((Math.sin(dLat/2) * Math.sin(dLat/2)) + (Math.sin(dLon/2) * Math.sin(dLon/2) * Math.cos(l1) * Math.cos(l2)));
      double c = (2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a)));
      double d = R * c;
      println(Math.toDegrees(d)*1000);
    }
    
    //Create Float array with segment parameters
    Float [] all = new Float[entries.length];
    all[0] = lat;
    all[1] = lon;
    all[2] = e;
    
    data.put(s, all);
    
    if(i == entries.length-1) 
    {
      smax = new Float (s);
    }
    if (latmax == null || lat >= latmax) latmax = lat; 
    if (latmin == null || lat < latmin) latmin = lat; 
    if (lonmax == null || lon >= lonmax) lonmax = lon;
    if (lonmin == null || lon < lonmin) lonmin = lon;
    
    lastS = s;
    lastR = new PVector(lat, lon);
  }
}
