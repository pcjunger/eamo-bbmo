# Junger et al. (2025) Ecological processes shaping marine microbial assemblages diverge between equatorial and temperate time-series
# This script reproduces:
# - Figure 1
# - Supplementary Figures S1 and S2

#### loading required libraries ####
library(tidyverse)
library(pastecs)
library(stringr)
library(vegan)
library(scales)
library(ggrepel)
library(ggsn)
library(maps)
library(mapdata)
library(ggpubr)

#scientific notation function
scientific_10x <- function(x) {
  sapply(x, function(i) {
    if (is.na(i) || i == 0) return(as.character(i))
    exponent <- floor(log10(abs(i)))
    coef <- i / 10^exponent
    as.expression(bquote(.(coef) %*% 10^.(exponent)))
  })
}

#### data input ####
zenodo_url <- "https://zenodo.org/records/16861237/files/eamo-bbmo_env-diversity.csv"
envdata = read.csv(zenodo_url, header=TRUE)
envdata$date<-as.Date(envdata$date) #transforming into date format YYYY-MM-DD
stations <- envdata %>% select(MO,lat,long) %>% distinct(MO, lat, long, .keep_all = T)

#Defina qual sera a area usada como base do mapa
area <-map_data("world")
area_2<- area %>% filter(long>=-75 & long<=35) %>% filter(lat>=-65 & lat<=65)

############### Plotting figures ###############
station_colors <- c("BBMO" = "blue", "EAMO" = "orange")

#### Figure 1 - Map with locations and main variables in each observatory ####

#map
Fig1a<- ggplot() + geom_polygon(data = area_2,
                             aes(x=long, y = lat, group = group),
                             fill = "darkgrey", color = "darkgrey") + #change color of the background and border
  coord_fixed(1.1) + #to make the map more proportional
  geom_polygon(data = area_2, 
               aes(x = long, y = lat, group = group), 
               color = "lightgrey", fill = NA, linewidth = 0.04) + #borders colour and thickness
  geom_hline(yintercept= 0, linetype= 'dashed')+
  annotate("text", x=-65, y=3, label="Equator",fontface = 'italic', size=3)+
  geom_point(data = stations, aes(x = long, y = lat,color = MO), 
             size = 3, #point size
             alpha = 0.8) + #transparency
  scale_color_manual(values = station_colors)+
  geom_label_repel(data=stations, aes(x=long, y=lat, label=MO,color=MO),fontface = "bold")+ #to avoid overlap of the points lables
  theme_bw() +
  labs(x="Longitude", y = "Latitude") + #name of the axis
  theme(text = element_text(size=20), #text size adjustments
        plot.title = element_text(size=20),
        axis.text.x = element_text(size = 16),
        axis.text.y = element_text(size = 16),
        axis.title.x = element_text(size = 18),
        axis.title.y = element_text(size = 18),
        legend.position =  "none")

#Plotting environmental and biological data
#my theme for plots
my_theme<-theme(legend.position = "bottom",axis.text= element_text(size=12),strip.background = element_rect("white"), strip.text = element_text(size=14),axis.title = element_text(size=14), legend.text = element_text(size=12))

#plot distribution depths
##Water temperature
Fig1b1<-envdata %>%
  filter(!is.na(temp)) %>% 
  ggplot(aes(date,temp)) + 
  geom_path(aes(color=station))+
  geom_point(aes(color=station))+
  scale_color_manual(values = c("blue","orange"))+
  labs(x=" ", y = "Water temperature (°C)",color="") + #name of the axis
  theme_bw()+
  my_theme

##Daylength
Fig1b2<-ggplot(data=envdata, aes(date,daylength)) + 
  geom_path(aes(color=station))+
  geom_point(aes(color=station))+
  scale_color_manual(values = c("blue","orange"))+
  labs(x=" ", y = "Daylength (h)",color="") + #name of the axis
  theme_bw()+
  my_theme

##chla
Fig1b3<-envdata %>%
  ggplot(aes(date,chla_sat)) + 
  geom_path(aes(color=station))+
  geom_point(aes(color=station))+
  scale_color_manual(values = c("blue","orange"))+
  labs(x=" ", 
       y = expression("Chlorophyll-a" ~ (µg ~ L^-1)),
       color="") + #name of the axis
  theme_bw()+
  my_theme   

##NO3
Fig1b4<-envdata %>% 
  filter(NO3 != "NA") %>% 
  ggplot(aes(date,NO3)) + 
  geom_path(aes(color=station))+
  geom_point(aes(color=station))+
  scale_color_manual(values = c("blue","orange"))+
  labs(x=" ", 
       y = expression("Nitrate" ~ (µg ~ L^-1)),
       color="") + #name of the axis
  theme_bw()+
  my_theme   

##PO4
Fig1b5<-envdata %>%  
  filter(PO4 != "NA") %>% 
  ggplot(aes(date,PO4)) + 
  geom_path(aes(color=station))+
  geom_point(aes(color=station))+
  scale_color_manual(values = c("blue","orange"))+
  labs(x=" ", 
       y = expression("Phosphate" ~ (µg ~ L^-1)),
       color="") + #name of the axis
  theme_bw()+
  my_theme

##SIO2
Fig1b6<-envdata %>%  
  filter(Si != "NA") %>% 
  ggplot(aes(date,Si)) + 
  geom_path(aes(color=station))+
  geom_point(aes(color=station))+
  scale_color_manual(values = c("blue","orange"))+
  labs(x=" ", 
       y = expression("Silicate" ~ (µg ~ L^-1)),
       color="") + #name of the axis
  theme_bw()+
  my_theme   

## Flow cytometric abundances
#Heterotrophic bacteria
Fig1b7<-envdata %>%  
  filter(BA != "NA") %>% 
  ggplot(aes(date, BA/1e5)) + 
  geom_path(aes(color=station))+
  geom_point(aes(color=station))+
  scale_color_manual(values = c("blue","orange"))+
  #scale_y_continuous(labels = scientific_10x) +
  labs(x = " ", 
       y = expression(atop("Bacterial abundance", ("" %*% 10^5 ~ cells ~ mL^-1))),
       color = "") +
  theme_bw() +
  my_theme

#Synechococcus
Fig1b8<-envdata %>%  
  filter(synecho != "NA") %>% 
  ggplot(aes(date,synecho/1e5)) + 
  geom_path(aes(color=station))+
  geom_point(aes(color=station))+
  scale_color_manual(values = c("blue","orange"))+
  #scale_y_continuous(labels = scientific_10x) +
  labs(x = " ", 
       y = expression(atop(italic("Synechococcus"), ("" %*% 10^5 ~ cells ~ mL^-1))),
       color = "") +
  theme_bw() +
  my_theme

#Phototrophic picoeukaryotes
Fig1b9<-envdata %>%  
  filter(peuk != "NA") %>% 
  ggplot(aes(date,peuk/1e4)) + 
  geom_path(aes(color=station))+
  geom_point(aes(color=station))+
  scale_color_manual(values = c("blue","orange"))+
  #scale_y_continuous(labels = scientific_10x) +
  labs(x=" ", 
       y = expression(atop("Phototrophic\npicoeukaryotes", ("" %*% 10^4 ~ cells ~ mL^-1))),
       color="") + #name of the axis
  theme_bw()+
  my_theme   

#Arranging Fig 1 panel 
# Left column: 4 plots
Fig1b <- ggarrange(Fig1b1, Fig1b2, Fig1b3, Fig1b8, 
                   align = 'hv', ncol = 1, 
                   common.legend = TRUE, legend = "none")

# Right column: 4 plots
Fig1c <- ggarrange(Fig1b4, Fig1b5, Fig1b6, Fig1b9, 
                   align = 'hv', ncol = 1, 
                   common.legend = TRUE, legend = "none")

# Middle column: map on top, plot below
Fig1a2 <- ggarrange(Fig1a, Fig1b7, ncol = 1, 
                    heights = c(3, 1),widths = c(3,1))  # Map 3x larger than bottom plot

# Combine all three columns
ggarrange(Fig1b, Fig1a2, Fig1c, 
          ncol = 3, 
          widths = c(1, 1.3, 1),  # Middle column slightly wider
          align = 'hv')

# NOTE: Fig1b7 was manually adjusted with Inkscape

###### Supplementary figures ######
## Fig S1 - Boxplots with all environmental variables (BBMO vs EAMO)
##editing databases from wide to long format
plot_base <- envdata %>%
  dplyr::select(temp,daylength,sal,chla_sat,secchi,NH4,NO2,NO3,PO4,Si,MO,BA,synecho,peuk,BP,station,season,month) %>%
  gather(key = variable, value = value, -station, -MO, -season,-month)

##### BBMO vs EAMO - GENERAL #####
plot_base %>% 
  dplyr::mutate(variable=fct_relevel(variable,c("temp","daylength","sal","secchi", "NH4","NO2","NO3","PO4","Si","chla_sat","BA","synecho","peuk","BP"))) %>% 
  dplyr::mutate(variable=dplyr::recode(variable,"temp"="Temperature (C°)","daylength"="Daylength (h)","sal"="Salinity (PSU)","chla_sat" = "Chlorophyll-a (µg/L)",
                         "secchi"="Secchi (m)","NH4"="Ammonium (µg/L)","NO2"="Nitrite (µg/L)","NO3"="Nitrate (µg/L)","PO4"="Phosphate (µg/L)","Si"="Silicate (µg/L)",
                         "BA"="Bacterial abundance\n(cells/mL)","synecho"="Synechococcus\n(cells/mL)","peuk"="Picoeukaryotes\n(cells/mL)","BP"="Bacterial production\n(ugC/L/d)")) %>% 
  ggplot(aes(y=value, x=MO,fill=station))+
  geom_jitter(alpha=0.6,size=0.8,width = 0.2)+
  geom_boxplot(outlier.shape = NA,alpha=0.7,notch = TRUE)+
  facet_wrap(~variable, scales="free",strip.position = "left",ncol=7)+
  scale_fill_manual(values = c("blue", "orange"))+
  theme_bw()+
  theme(plot.title = element_text(size=12,face="bold"),
        strip.text = element_text(face="bold", size=10),
        strip.background = element_blank(),
        strip.placement = "outside",
        panel.border = element_rect(colour = "black", fill=NA, size=0.5),
        axis.line = element_line(colour = "black", size=0.2),
        legend.position = "bottom",
        legend.text = element_text(size=11),
        axis.text.y = element_text(size=10, color="black"),
        axis.text.x = element_text(size=10, color="black"),
        axis.title=element_text(size=11)) +
  labs(x= " ", y = "",fill="")

####statistical comparison
eamo_data<-envdata %>% filter(MO %in% "EAMO")
bbmo_data<-envdata %>% filter(MO %in% "BBMO")

t.test(bbmo_data$temp, eamo_data$temp) #t = -15.582, df = 51.156, p-value < 2.2e-16
t.test(bbmo_data$daylength, eamo_data$daylength) #t = 1.6674, df = 43.386, p-value = 0.1026
t.test(bbmo_data$sal, eamo_data$sal) #t = 13.574, df = 31.262, p-value = 1.194e-14
t.test(bbmo_data$secchi, eamo_data$secchi) #t = 18.533, df = 70.484, p-value < 2.2e-16
t.test(bbmo_data$NH4, eamo_data$NH4) #t = -2.1303, df = 65.202, p-value = 0.03692
t.test(bbmo_data$NO2, eamo_data$NO2) #t = 2.839, df = 57.176, p-value = 0.006255
t.test(bbmo_data$NO3, eamo_data$NO3) #t = -1.2954, df = 37.505, p-value = 0.2031
t.test(bbmo_data$PO4, eamo_data$PO4) #t = 1.9617, df = 61.285, p-value = 0.05434
t.test(bbmo_data$Si, eamo_data$Si) #t = -5.9053, df = 24.798, p-value = 3.783e-06
t.test(bbmo_data$chla_sat, eamo_data$chla_sat) #t = -6.9563, df = 33.592, p-value = 5.418e-08
t.test(bbmo_data$BA, eamo_data$BA) #t = 0.59374, df = 41.359, p-value = 0.5559
t.test(bbmo_data$synecho, eamo_data$synecho) #t = -8.8677, df = 47.292, p-value = 1.264e-11
t.test(bbmo_data$peuk, eamo_data$peuk) #t = 2.9007, df = 48.458, p-value = 0.005584
t.test(bbmo_data$BP, eamo_data$BP) #t = 0.69094, df = 67.189, p-value = 0.492

##Fig S2
#Oscillation Index
clima<-envdata %>%  
  mutate(o_index = case_when(MO == "BBMO" ~ "Western Mediterranean Oscillation Index",
                             MO == "EAMO" ~ "Southern Oscillation Index"), 
         o_index_2 = case_when(MO == "BBMO" ~ "WMOI",MO == "EAMO" ~ "SOI")) %>%
  ggplot(aes(date,oscillation_index)) + 
  geom_path(aes(color=o_index_2))+
  geom_point(aes(color=o_index_2))+
  scale_color_manual(values = c("orange","blue"))+
  labs(x=" ", y = "Oscillation index",color="",title = "B") + #name of the axis
  theme_bw()+
  my_theme   

##Rainfall
meteo<-envdata %>%  
  ggplot(aes(date,rainfall)) + 
  geom_path(aes(color=station))+
  geom_point(aes(color=station))+
  scale_color_manual(values = c("blue","orange"))+
  labs(x=" ", y = "Rainfall (mm)",color="",title = "A") + #name of the axis
  theme_bw()+
  my_theme

fig_S2<-ggarrange(meteo, clima, align = "hv",ncol=1)
