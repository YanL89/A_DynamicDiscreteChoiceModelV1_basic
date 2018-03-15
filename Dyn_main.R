rm(list=ls())
#-----------------------set work directory------------------------
setwd("C:/Users/Yan/Dynamic Modeling/dynamic discrete choice model_basic")

#-----------------------load source files-------------------------
source("models.R")
source("dyn.R")
source("dynData.R")
source("dynUtils.R")

source("args.R")
source("misc.R")
source("create_X.R")
source("LL.R")
source("SD.R")
source("deriv.R")

source("logit.R")

source("dyn2logitV2.R")

#--------------------define model specification---------------------
spec = list(
  #load data
  D = "Example_DataFiles/dyn",
  Time = "Example_DataFiles/time.txt",
  Global = "Example_DataFiles/global.txt",
  First = "Example_DataFiles/first.txt",
  choices = "Example_DataFiles/choice15.txt",
  # define independent attributes
  payoff_alt = c(),
  payoff_time = c("Vehicles"),
  payoff_global = c("Workers"),
  generic = list(),
  specific = list(c("VehPrice.1", "GasPrice.1"), c("ASC", "VehPrice.2"), c("ASC", "VehPrice.3", "range.3", "ElePrice.3")), # put variables here in one vector per alternative
  #restructure data
  modifyD = function(D,Time,Global,Z,t){
    allTime = Time_select_vars(Time, NULL, t, all = TRUE)
    Dyan = cbind(D[[t]], Global, allTime)
    return(Dyan)
  },
  #set basic parameters
  SD = "hessian",  
  ASC = FALSE, 
  nTime = 15,  #actual time periods = total time T - look ahead time period L
  nLook = 3,  #look ahead time period L
  stopAlt = c(1,2,3), # HERE, if you have more than one alternative 
  # that halts the decision process, put them in a vector 
  # like stopAlt = c(1,2,10) if alt 1, 2 and 10 are stopping alternatives
  outTime = 5 #time periods that halts the decision process
  #i.e., outTime = 0 means never be out-of-market
  #outTime >= nTime means once be out-of-market the decision maker will never return
)

#---------------------check model specification------------------------
spec = checkFillDynSpec(spec)

#--------------------------model estimation----------------------------
modelFns = dyn
D = NULL
Sys.time()
Mdyn = model(modelFns, spec, D)
Sys.time()
Mdyn

#--------------------------model application----------------------------
#ApplyMdyn = dynApply(Mdyn, spec)    #check function "dynApply" in source"dyn.R"
#ApplyMdyn = round(100*ApplyMdyn) / 100

#--------------------------calculate LL at 0----------------------------
#spec = checkFillDynSpec(spec)
#Args = dyn$computeArgs(spec,NULL)
#zero = rep(0, length(dyn$computeStart(spec,NULL)))
#cat("LL at 0: " ,sum(log(dyn$LLVec(zero,Args))),"\n")

#-----------------------comparision with logit----------------------------
#logitSpecData = dyn2logitV2(spec)
#specL = logitSpecData$specLogit
#DL = logitSpecData$D
#MLogit = model_logit(logit, specL, DL)
#MLogit