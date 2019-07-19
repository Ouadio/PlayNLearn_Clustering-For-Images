library(jpeg, warn.conflicts = FALSE)
library(imager, warn.conflicts = FALSE)
library(OpenImageR)

  

getImage = function(path , show = F){
  image = OpenImageR::readImage(path)
  #Reducing image size for faster computations and display
  myHeight = 400
  ratio = dim(image)[1]/myHeight
  reduced = OpenImageR::resizeImage(image, height  = round(dim(image)[2]/ratio), width =myHeight )
  if(show){
    OpenImageR::imageShow(reduced)
  }
    
  return(reduced)

  
}


kmeansImage = function(image = image, k = 5){
  #'A clustering based on pixels' RGB values + grayscale Image aggregation
  #'The resulting picture is represented using only K colors
  imageDf = array(image, dim = c(dim(image)[1]*dim(image)[2], dim(image)[3]))
  imageDf = data.frame(imageDf)
  names(imageDf) = c("Red","Green","Blue")
  myKmeans = kmeans(imageDf, centers = k, iter.max = 1000, 
                    algorithm = "MacQueen", nstart =5 )
  
  myCenters = myKmeans$centers   #centroids values 
  myClusters = myKmeans$cluster  
  
  clustered = vector(mode = "numeric", length= length(myClusters)) 
  colorsVect = vector(mode = "numeric", length = length(myClusters))
  for (i in 1:nrow(myCenters)){
    indexes = which(myClusters==i)
    clustered[indexes] = mean(myCenters[i,])
    colorsVect[indexes] = rgb(red = myCenters[i,1], green = myCenters[i,2], 
                              blue = myCenters[i,3])
  }
  #Reconstruction of the 2D Matrix (image)
  unflattened = matrix(clustered, byrow = FALSE, ncol = ncol(image))
  return(unflattened)
  
}


kmeansImageCol = function(image = image, k = 5, pixW = 1, xCordW = 0.6, yCordW = 0.6){
  #'A clustering based on pixels' spacial coordinates (spacial proximity) and RGB values (color proximity)
  #'Varying the weights will give variant importances to the different variables (coordinates >> pixel values) or vice-vers-ca 
  #'The resulting image is represented using only k x 3 colors values

  imageDf = pixW*array(image, dim = c(dim(image)[1]*dim(image)[2], dim(image)[3]))
  imageDf = data.frame(imageDf)
  xCoord = rep(c(1:dim(image)[1]), dim(image)[2])
  xCoord = xCordW*xCoord/max(xCoord)
  yCoord = rep(c(1:dim(image)[2]), each = dim(image)[1])
  yCoord = yCordW*yCoord/max(yCoord)
  imageDf = data.frame(cbind(imageDf, xCoord, yCoord))
  myKm = kmeans(imageDf, centers = k, iter.max = 400,  algorithm = "MacQueen")
  myCenters = myKm$centers/pixW
  myClusters = myKm$cluster
  
  #colorsVect = vector(mode = "numeric", length = length(myClusters))
  clusteredR = vector(mode = "numeric", length =  nrow(imageDf)) 
  clusteredG = vector(mode = "numeric", length =  nrow(imageDf)) 
  clusteredB = vector(mode = "numeric", length =  nrow(imageDf)) 
  
  for (i in 1:nrow(myCenters)){
    indexes = which(myClusters==i)
    clusteredR[indexes] = myCenters[i,1]
    clusteredG[indexes] = myCenters[i,2]
    clusteredB[indexes] = myCenters[i,3]
    }
  
  unflattenedR = matrix(clusteredR, byrow = FALSE, ncol = ncol(image))
  unflattenedG = matrix(clusteredG, byrow = FALSE, ncol = ncol(image))
  unflattenedB = matrix(clusteredB, byrow = FALSE, ncol = ncol(image))
  
  finalResult = array(c(unflattenedR, unflattenedG, unflattenedB), dim = c(dim(image)[1], dim(image)[2],3))
  
  return(finalResult)
  
}









