STRUT_FOOT__DIST = function(l) {
	l.STRUT = l[which(l$WELLS=="STRUT"),]
	l.FOOT  = l[which(l$WELLS=="FOOT"),]
	res = createDist(l.STRUT, l.FOOT)
	return(res)
}

BATH_TRAP_PALM__RATIO = function(l) {
	l.BATH <<- l[which(l$WELLS=="BATH"),]
	l.TRAP <<- l[which(l$WELLS=="TRAP"),]
	l.PALM <<- l[which(l$WELLS=="PALM"),]
	d1 = createDist(l.BATH, l.PALM)
	d2 = createDist(l.BATH, l.TRAP)
	res = c()
	for(i in 1:length(d1)) { for(j in 1:length(d2)) {
		res = c(res, d1[i]/d2[j])
	}}
	return(res)
}

#HAPPY_KIT_FLEECE__RATIO = function(l) {
#  l.HAPPY   <<- l[which(l$WELLS=="HAPPY"),]
#  l.KIT     <<- l[which(l$WELLS=="KIT"),]
#  l.FLEECE  <<- l[which(l$WELLS=="FLEECE"),]
#  d1 = createDist(l.HAPPY, l.KIT)
#  d2 = createDist(l.HAPPY, l.FLEECE)
#  res = c()
#  for(i in 1:length(d1)) { for(j in 1:length(d2)) {
#    res = c(res, d1[i]/d2[j])
#  }}
#  return(res)
#}

HAPPY_KIT_FLEECE__RATIO = function(l) {
  l.HAPPY   <<- l[which(l$WELLS=="HAPPY"),]
  l.KIT     <<- l[which(l$WELLS=="KIT"),]
  l.FLEECE  <<- l[which(l$WELLS=="FLEECE"),]
  res = c()
  for(i in 1:length(l.HAPPY[,1])) { for(j in 1:length(l.KIT[,1])) { for(k in 1:length(l.FLEECE[,1])) {
    tmp = createDist(l.HAPPY[i,], l.KIT[j,])[[1]]/createDist(l.HAPPY[i,], l.FLEECE[k,])[[1]]
    res = c(res, tmp)
  }}}
  return(res)
}

FOOT_GOOSE__DIST = function(l) {
  l.FOOT = l[which(l$WELLS=="FOOT"),]
  l.GOOSE  = l[which(l$WELLS=="GOOSE"),]
  res = createDist(l.FOOT, l.GOOSE)
  return(res)
}

LOT_THOUGHT__DIST = function(l) {
  l.LOT = l[which(l$WELLS=="LOT" | l$WELLS=="CLOTH"),]
  l.THOUGHT  = l[which(l$WELLS=="THOUGHT"),]
  res = createDist(l.LOT, l.THOUGHT)
  res = mean(res)
  return(res)
}

GOAT__DIPHTHONG = function(l) {
  l.GOAT = l[which(l$WELLS=="GOAT"),]
  res = createDiphthongDist(l.GOAT)
  return(res)
}

FACE__DIPHTHONG = function(l) {
  l.FACE = l[which(l$WELLS=="FACE"),]
  res = createDiphthongDist(l.FACE)
  return(res)
}

################################

numFeatures = 3
featureFunctions = list(STRUT_FOOT__DIST, BATH_TRAP_PALM__RATIO, FOOT_GOOSE__DIST, GOAT__DIPHTHONG, FACE__DIPHTHONG, LOT_THOUGHT__DIST)
featureNames = list("STRUT.FOOT", "BATH", "FOOT.GOOSE", "GOAT", "FACE", "LOT.THOUGHT")

################################

getFeatures = function(data, fFeature) {
	res = fFeature(data)
	return(res)
}

runFeature = function(featureID, sp, pop_n) {
  #featureID = n indicated the nth feature (see part between hash-lines above)
  #sp = the speaker's name
  #pop = the population's names
  
  obs <<- distances[which(distances$SPEAKER==sp & distances$FEATURE.NAME==featureNames[featureID]),"FEATURE.VALUE"]
  pop <<- distances[which(distances$SPEAKER %in% pop_n & distances$FEATURE.NAME==featureNames[featureID]),"FEATURE.VALUE"]
  
  obs.avg = mean(obs, na.rm=T)
  
  fit = bestFit(pop)
  p_obs = getFitImage(fit, obs.avg)
  #DEPRECATED
  #fit = fitGauss(pop)
  #p_obs = dnorm(obs, mean=fit[1], sd=fit[2])
  return(p_obs)
}
