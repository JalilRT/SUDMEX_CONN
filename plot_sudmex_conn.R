
# data --------------------------------------------------------------------
setwd("~/Documents/data_report/")
pacman::p_load(tidyverse,viridis,ggpubr,cowplot)

demographics <- readxl::read_xlsx("Connectome_Consum_pattern 050219_rev.xlsx", sheet = 1) 
data_bold <- read_tsv("group_bold.tsv") %>% 
  select(group,fd_mean,tsnr,dvars_nstd)

data_T1W <- read_tsv("group_T1w.tsv") %>% 
  select(snr_total,cnr,efc)
data_T1W <- tibble(data_T1W, demographics[2])
data_T1W$group <- factor(data_T1W$group, levels = c("HC", "CUD"))

# graphs ------------------------------------------------------------------
# B O L D
plot_bold_fd <- ggdensity(data_bold,x="fd_mean",add="mean",rug = T,
                          fill = "group", xlab = "Framewise displacement",
                          palette = c("#3A5FCD", "#CD0000")) + labs(fill = "Group")
plot_bold_tsnr <- ggdensity(data_bold,x="tsnr",add="mean",rug = T,
                          fill = "group", xlab = "temporal Signal to Noise Ratio",
                          palette = c("#3A5FCD", "#CD0000"))
plot_bold_dvars <- ggdensity(data_bold,x="dvars_nstd",add="mean",rug = T,
                          fill = "group", xlab = "Successive difference images (sd)",
                          palette = c("#3A5FCD", "#CD0000"))      

# T1w
plot_T1w_snr <- ggdensity(data_T1W,x="snr_total",add="mean",rug = T,
          fill = "group", xlab = "Signal to Noise Ratio",
          palette = c("#3A5FCD", "#CD0000")) + labs(fill = "Group") 
plot_T1w_cnr <- ggdensity(data_T1W,x="cnr",add="mean",rug = T,
                      fill = "group", xlab = "Contrast to Noise Ratio",
                      palette = c("#3A5FCD", "#CD0000"))
plot_T1w_efc <- ggdensity(data_T1W,x="efc",add="mean",rug = T,
                      fill = "group", xlab = "Entropy-focus Criterion",
                      palette = c("#3A5FCD", "#CD0000"))      

Fig2 <- plot_grid(
  plot_T1w_snr + theme(legend.position="none"),
  plot_T1w_cnr + theme(legend.position="none") + ylab(element_blank()),
  plot_T1w_efc + theme(legend.position="none") + ylab(element_blank()),
  plot_bold_fd + theme(legend.position="none"),
  plot_bold_tsnr + theme(legend.position="none") + ylab(" "),
  plot_bold_dvars + theme(legend.position="none") + ylab(" "),
  align = 'vh', labels = "AUTO",
  hjust = -1, ncol = 3)

legend_b <- get_legend(plot_T1w_snr  +
                         theme(legend.position = "bottom"))

Fig2 <- plot_grid(Fig2, legend_b,ncol = 1, rel_heights = c(1, .1))
#ggsave("Fig2.tiff",Fig2,dpi = 300,height = 6,width = 11)

##### D W I #####
setwd("~/Documents/data_report/SNR/QA/")
QA.files<-list.files(getwd(),recursive = F, full.names = T,pattern = "*.csv") %>%
  sapply(function(x) read.csv(paste0(x), header = T),
         USE.NAMES = T, simplify = F)

group<-c("CUD","CUD","CUD","CUD","CUD","CUD","CUD","CUD","CUD","CUD","CUD","CUD","CUD","HC","HC","CUD","CUD",
         "CUD","CUD","CUD","HC","HC","CUD","HC","HC","HC","CUD","CUD","HC","HC","CUD","HC","HC","CUD","HC","CUD","CUD","CUD","CUD",
         "HC","HC","HC","CUD","CUD","HC","HC","CUD","CUD","CUD","HC","CUD","CUD","HC","CUD","HC","CUD","CUD","HC","CUD","CUD","CUD",
         "CUD","CUD","HC","CUD","HC","HC","CUD","CUD","HC","CUD","HC","HC","HC","HC","CUD","CUD","HC","HC","HC","HC","HC","HC","HC","HC",
         "CUD","CUD","HC","HC","CUD","CUD","CUD","HC","HC","HC","CUD","HC","HC","HC","CUD","HC","HC","CUD","HC","HC","CUD","CUD","HC","HC",
         "CUD","CUD","HC","HC","CUD","CUD","CUD","CUD","CUD","CUD","CUD","CUD","HC","HC","CUD","HC","HC","HC","HC","HC")

QA.table<-tibble(
  b0=sapply(1:length(QA.files), function(x) QA.files[[x]][1,2]),
  worst=sapply(1:length(QA.files), function(x) QA.files[[x]][2,2]),
  best=sapply(1:length(QA.files), function(x) QA.files[[x]][3,2]), group) 

QA<-QA.table %>% 
  gather("Case","SNR",c("b0","worst","best"))

QA.b0<-ggdensity(QA %>% filter(Case=="b0"),x="SNR",add="mean",rug = T,
                 fill = "group", xlab = "b0 SNR-value",
                 palette = c("#3A5FCD", "#CD0000"))
QA.worst<-ggdensity(QA %>% filter(Case=="worst"),x="SNR",add="mean",rug = T,
                    fill = "group", xlab = "Worst-case of SNR-value",
                    palette = c("#3A5FCD", "#CD0000"))
QA.best<-ggdensity(QA %>% filter(Case=="best"),x="SNR",add="mean",rug = T,
                   fill = "group", xlab = "Best-case of SNR-value",
                   palette = c("#3A5FCD", "#CD0000"))

QA.diff<-plot_grid(
  QA.b0 + theme(legend.position="none"),
  QA.worst + theme(legend.position="none"),
  QA.best + theme(legend.position="none",),
  align = 'vh', labels = c("A", "B", "C"),
  hjust = -1, nrow = 1)

legend_b <- get_legend(plot_T1w_snr  +
                         theme(legend.position = "top"))

Fig3<-plot_grid(QA.diff, legend_b,ncol = 1, rel_heights = c(1, .1))
#ggsave("../../Fig3.tiff",Fig3,dpi = 300,height = 6,width = 11)

