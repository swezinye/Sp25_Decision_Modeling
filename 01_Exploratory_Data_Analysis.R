library(ggplot2) # loading the library or use the libary

plot(AirPassengers)

#R Environment
#R Data Structure ( Objects)
# R functions
# R Classes --> very rare 

var1 <- c("welcome message", "Some name")
var1

var2<- c(2,4,6,8,10)
var2**3
#Atomic data type and complex data types . 
#logical ( binary operation , o & 1 , true false )
#numeric ( integers vs decimal/float/real-number)
#Character ( string and characters) 
#Factor 
#complex type -> data frame ( row by column represetation)
# List ( Not stricitly row by column)

# matrix ( strictly numerical)
# complex ( a+ bi, 2+3i) - mostly use for Eng application 

var3<-c(TRUE, FALSE, T,F)

class(var3)
class(plot(AirPassengers))

?matrix() # retrieve description of commend 
matrix(data = c(10,20,30,40),
       nrow = 2, 
       ncol = 2,
       byrow = TRUE)

# carete a 2x 2 matrix with four number 10,20,30,40
# var4<-matrix(c(10,20,30,40),nrow =2,ncol=2, byrow = TRUE,dimnames = list(c("row1","row2"),c("C.1","c.2")))
var4<-matrix(data = c(10,20,30,40),
            nrow = 2, 
            ncol = 2,
            byrow = TRUE)

var5<-seq(0,1,0.0001)
var5<-rep(0,1000)
head(var5,10)
var6<- matrix(data=var5,
              nrow=100,
              ncol=100)

#Create a data frame ( Rows by column representation)
#Data frame is a special type of list 
var7<-data.frame(student_name = c( "A1","A2","A3","A4","A5","A6"),
           math = c(88,99,44,55,99,66),
           science = c(44,33,55,66,77,88))
View(var7) # view with table format
?readRDS
saveRDS(var7, "Dummy.rds")


