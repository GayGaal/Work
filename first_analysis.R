## this code is created to produce an analysis of downloaded data from VK ##
## to run this correctly, the filename should ALWAYS be 'posts.csv'       ##
## reading the file
post<-read.csv("posts.csv", header=TRUE, na.strings="")
## removing unneeded colums, like 'Type', 'Clear_eng', 'Delay'
post[c(2:7,17:19)]<-list(NULL)
## preparing the names
names<-c("Date", "Commenters", "Comments", "Admin_commetns", "Agent_comments", "Shares", "Likes", "Votes", "Active_users", "Engagements", "Reach")
## setting proper names
colnames(post)<-names
## removing NAs with 0
post[is.na(post)] <- 0
## performing operations with dates and times to obtain additional data 
post$Time <- as.POSIXct(strftime(post$Date, format="%H:%M:%S"), format="%H:%M:%S")
post$Date <- as.POSIXct(strptime(post$Date, format="%Y-%m-%d %H:%M:%S"))
## cleaning the data
post<-subset(post, post$Engagements < 1000)
## obtaining the weekdays
weekday<-as.factor(weekdays(post$Date))
levels(weekday) <- c("Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday")
post$Weekday<-weekday
## plotting the needed graphs                                             ##
## plotting the graph with all engagements
png("engagements.png", width=1000, height=1000)
with(post, plot(Time, Engagements, pch=16, col="purple", ylab="Engagements"))
dev.off()
## plotting the grapth with engagements by type
png("engagements_types.png", width=1000, height=1000)
with(post, plot(Time, Engagements, type="n"))
with(post, points(Time, Likes, pch=16, col="blue"))
with(post, points(Time, Comments, pch=15, col="green"))
with(post, points(Time, Shares, pch=17, col="red"))
dev.off()
## plotting the weekday data
png("weekday_engagements.png", width=1000, height=1000)
with(post, plot(Weekday, Engagements, ylab="Engagements", col="purple"))
dev.off()
##plotting all four graphs together
png("weekday_engagements_type.png", width=1000, height=1000)
par(mfrow=c(2,2))
with(post, plot(Weekday, Engagements, ylab="Engagements", col="purple"))
with(post, plot(Weekday, Likes, ylab="Likes", col="blue"))
with(post, plot(Weekday, Comments, ylab="Comments", col="green"))
with(post, plot(Weekday, Shares, ylab="Shares", col="red"))
dev.off()