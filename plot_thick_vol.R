setwd("~/Documents/data_report/")
pacman::p_load(tidyverse,viridis,ggpubr,cowplot)

datasa<-list.files("avgsubject2", pattern = "*.txt",recursive = F,full.names = T)
colthick<-lapply(datasa[c(2,4)], function(x) read.table(x,header = T)) %>% map(~.x[[36]])
meanthick<-data.frame(t(do.call("rbind",colthick)))
colnames(meanthick)<-c("Left","Right")
cmthick<-meanthick %>%gather("Hemisphere","Thickness",c("Left","Right"))
##
meanT<-tibble(Mean=rowMeans(meanthick))
controlN<-c(1,4,5,7,21,22,28,29,31,32,33,36,37,40,41,43,48,49,
            50,53,54,58,61,64,67,74,76,77,80,82,83,84,85,89,90,
            91,92,93,94,95,96,100,101,105,106,107,109,111,112,
            115,116,118,119,122,123,126,127,137,138,140,141,142)
meanTG<-tibble(rbind(controlThick=meanT[controlN,],CUDThick=meanT[-controlN,]),
       Group=c(rep(x="HC",nrow(meanT[controlN,])),
         rep(x="CUD",nrow(meanT[-controlN,]))))
#ggdensity(cmthick,x="Thickness",add="mean",rug = T,fill = "Hemisphere")
coco<-ggviolin(meanTG, x = "Group", y = "Mean", fill = "Group",legend="none",xlab = "",
         add = "boxplot", add.params = list(fill = "white"),ylab = "Cortical Thickness (mm)",
         palette = c("#3A5FCD", "#CD0000"))
##
SubCortV<-lapply(datasa[7], function(x) read.table(x,header = T)) %>% map(~.x[[56]]) 
SubCortV<-t(do.call("rbind",SubCortV))
SubCortV<-SubCortV/1000
TotCortV<-lapply(datasa[7], function(x) read.table(x,header = T)) %>% map(~.x[[57]]) 
TotCortV<-t(do.call("rbind",TotCortV))
TotCortV<-TotCortV/1000
CortV<-data.frame(SubCortV,TotCortV)
CortV<-CortV %>%gather("Brain","Volume",c("SubCortV","TotCortV"))

#
VolCort<-tibble(Volume=c(TotCortV[controlN,],TotCortV[-controlN,]),
               Group=c(rep(x="HC",nrow(meanT[controlN,])),
                       rep(x="CUD",nrow(meanT[-controlN,]))))
VolSC<-tibble(Volume=c(SubCortV[controlN,],SubCortV[-controlN,]),
                Group=c(rep(x="HC",nrow(meanT[controlN,])),
                        rep(x="CUD",nrow(meanT[-controlN,]))))
#
corto<-ggviolin(VolCort, y = "Volume", x = "Group", fill = "Group",show.legend = FALSE,
         add = "boxplot", add.params = list(fill = "white"),xlab = "Group",
         legend="none",ylab = expression(paste("Cortical Volume ",cm^3,sep="")),
         palette = c("#3A5FCD", "#CD0000"))
subo<-ggviolin(VolSC, y = "Volume", x = "Group", fill = "Group",show.legend = FALSE,
         add = "boxplot", add.params = list(fill = "white"),xlab = "",
         legend="none",ylab = expression(paste("Subcortical Volume ",cm^3,sep="")),
         palette = c("#3A5FCD", "#CD0000"))

#### Taken together
C_fig<-plot_grid(coco,corto,subo,ncol = 3)
A.1<-ggdraw()+draw_image("avgHC/lh.png",scale = 0.9)
A.2<-ggdraw()+draw_image("avgHC/rh.png",scale = 0.9)
A.3<-ggdraw()+draw_image("avgHC/up.png")
A.4<-ggdraw()+draw_image("avgHC/down.png")

B.1<-ggdraw()+draw_image("avgCUD/lh.png",scale = 0.9)
B.2<-ggdraw()+draw_image("avgCUD/rh.png",scale = 0.9)
B.3<-ggdraw()+draw_image("avgCUD/up.png")
B.4<-ggdraw()+draw_image("avgCUD/down.png")

A_fig<-plot_grid(A.1,A.2,A.3,A.4,ncol = 2)
B_fig<-plot_grid(B.1,B.2,B.3,B.4,ncol = 2)

Afig<-plot_grid(A_fig,B_fig,ncol = 2,labels = "AUTO")

Fig1<-plot_grid(Afig,C_fig,labels = c("","C"),ncol = 1)

#ggsave("thick.png",Fig1,dpi = 300,height = 6,width = 8)
