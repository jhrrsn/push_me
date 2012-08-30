setwd("~/Documents/PushMe/Data")
require(ggplot2)
require(reshape2)
require(splines)
require(signal)
require(entropy)
require(RSEIS)
rm(results)
results = data.frame("time"=0, "meanX"=0, "meanY"=0, "meanZ"=0, "sdX"=0, "sdY"=0, "sdZ"=0, "sdT"=0, "energyX"=0, "energyY"=0, "energyZ"=0, "energyT"=0, "lat"=mean(sample$Latitude[1:140]), "lon"=mean(sample$Longitude[1:140]), "entropyX"=0, "entropyY"=0, "entropyZ"=0, "entropyT"=0)

# Read in .csv file.
sample=read.csv('rDrive1.csv')

# State sample-specific variables
time = sample$Elapsed.Time

# Split sensor output into 3 dataframes
dX=data.frame(x=time, y=sample$X)
dY=data.frame(x=time, y=sample$Y)
dZ=data.frame(x=time, y=sample$Z)
ntot = floor(nrow(sample)/140)

for(u in seq(140, 140*(ntot-1), by = 140)) {
  
  # Define range of samples
  rangeS = u:(u+140)
  
  # Location
  mlat = mean(sample$Latitude[rangeS])
  mlon = mean(sample$Longitude[rangeS])
  
  # Create interpolated spline along raw values for each sensor
  interpX = interpSpline(dX$x[rangeS], dX$y[rangeS])
  interpY = interpSpline(dY$x[rangeS], dY$y[rangeS])
  interpZ = interpSpline(dZ$x[rangeS], dZ$y[rangeS])
  
  # Resample along spline, with a number of segments proportional to the range that the data covers
  resampleX = predict(interpX, nseg = 128)
  resampleX = data.frame(x=resampleX$x, y=resampleX$y)
  resampleY = predict(interpY, nseg = 128)
  resampleY = data.frame(x=resampleY$x, y=resampleY$y)
  resampleZ = predict(interpZ, nseg = 128)
  resampleZ = data.frame(x=resampleZ$x, y=resampleZ$y)
  
  # Calculate means of signal components
  meanX = mean(resampleX$y)
  meanY = mean(resampleY$y)
  meanZ = mean(resampleZ$y)
  
  # Calculate standard deviation of signal components
  sdX = sd(resampleX$y)
  sdY = sd(resampleY$y)
  sdZ = sd(resampleZ$y)
  
  # Calculate energy proxy and information entropy from fourier transform
  window = 128
  freq = 20
  start = 0
  
  fftX = Mod(fft(resampleX$y-mean(resampleX$y)))
  fftY = Mod(fft(resampleY$y-mean(resampleY$y)))
  fftZ = Mod(fft(resampleZ$y-mean(resampleZ$y)))
  
  energyX = sum(fftX)/window
  energyY = sum(fftY)/window
  energyZ = sum(fftZ)/window
  
  entropyX = entropy(fftX)
  entropyY = entropy(fftY)
  entropyZ = entropy(fftZ)
  
  row = nrow(results)+1
  results[row,1] = time[u]
  results[row,2] = meanX
  results[row,3] = meanY
  results[row,4] = meanZ
  results[row,5] = sdX
  results[row,6] = sdY
  results[row,7] = sdZ
  results[row,8] = sqrt((sdX^2)+(sdY^2)+(sdZ^2))
  results[row,9] = energyX
  results[row,10] = energyY
  results[row,11] = energyZ
  results[row,12] = sqrt((energyX^2)+(energyY^2)+(energyZ^2))
  results[row,13] = mlat
  results[row,14] = mlon
  results[row,15] = entropyX
  results[row,16] = entropyY
  results[row,17] = entropyZ
  results[row,18] = sqrt((entropyX^2)+(entropyY^2)+(entropyZ^2))
  
  cat("Pass",nrow(results)-1,"of",ntot-1,"Complete ","[",u,"to",u+140,"]","\n")
}
print("Run Complete")