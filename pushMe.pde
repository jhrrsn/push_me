Float [] s, lon, lat;
Float smax, latmax, latmin, lonmax, lonmin;
HashMap<Float, PVector> location = new HashMap<Float, PVector> ();
PVector posn, l, last;
float time;

void setup()
{
  size(600, 600);
  background(255);
  frameRate(120);
  loadLoc();
  for(float i = 0; i <= smax*100; i+=1) //Check for location every 10 milliseconds to end
  {
    if (location.containsKey(i/100))
    {
      l = location.get(i/100);
      if (latmax == null || l.x >= latmax) latmax = l.x; 
      if (latmin == null || l.x < latmin) latmin = l.x; 
      if (lonmax == null || l.y >= lonmax) lonmax = l.y;
      if (lonmin == null || l.y < lonmin) lonmin = l.y;
    }
  }
  smooth();
  strokeWeight(3);
  fill(220);
  text("pushMe Visualisation Platform", 10, 20);
  text("v. 0.1.0", 10, 35);
  time = 0;
  last = null;
}

void draw()
{
//  for(float i = 0; i <= smax*100; i+=1) //Check for location every 10 milliseconds to end
//  // ^^ instant map results ^^
  {
    if (location.containsKey(time/100))
    {
      posn = location.get(time/100);
      Float x = map(posn.x, latmin, latmax, 0+50, width-50);
      Float y = map(posn.y, lonmin, lonmax, 0+50, width-50);
      posn = new PVector(x, y);
      if (last != null) 
      {
        Float sp = (dist(last.x, last.y, posn.x, posn.y));
        if (sp > 0)
        {
          int col = int(map (sp, 0, 30, 0, 7));
          switch(col) {
            case 0:
              stroke(190, 255, 190);
              break;
            case 1:
              stroke(170, 255, 170);
              break;
            case 2:
              stroke(150, 240, 150);
              break;
            case 3:
              stroke(130, 220, 130);
              break;
            case 4:
              stroke(110, 200, 110);
              break;
            case 5:
              stroke(90, 180, 90);
              break;
            case 6:
              stroke(70, 160, 70);
              break;
            case 7:
              stroke(50, 140, 50);
              break;
          }
        }
        else noStroke();
      }
      if(last == null) point(x, y);
      else line(last.x, last.y, x, y);
      last = new PVector(x, y);
    }
    time++;
    if (time >= smax*100) setup();
  }
}

void loadLoc()
{
  String [] loc = loadStrings("sam6.csv");
  s = new Float[loc.length];
  lon = new Float[loc.length];
  lat = new Float[loc.length];
  
  for(int i = 1; i < loc.length; i++)
  {
    String [] tparse = split(loc[i], ",");
    String s_str = (tparse[0]);
    String lat_str = (tparse[4]);
    String lon_str = (tparse[5]);
    s_str = s_str.replace("\"", "");
    lat_str = lat_str.replace("\"", "");
    lon_str = lon_str.replace("\"", "");
    Float s = parseFloat(s_str);
    s = new Float ((Math.round(s*100)));
    s = s/100;
    Float lat = parseFloat(lat_str);
    Float lon = parseFloat(lon_str);
    location.put(s, new PVector(lat, lon));
    if(i == loc.length-1) 
    {
      smax = new Float (s);
    }
  }
}
