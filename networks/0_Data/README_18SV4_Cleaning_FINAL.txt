#Pedro C. Junger; 17/04/2024
######### Cleaning samples ###########
N of samples (raw data): 141 samples

#### 1) Metazoa, Fungi, Streptophyta and NAs removed

#### 2) Removing probably contaminated very bad quality samples:
BL-20140621-18SV4-022-3-SRF: 345 reads after cleaning
BL-20140804-18SV4-022-3-SRF: 172 reads after cleaning

#N = 139 samples

#### 3) Samples removed due to low reads (<8,180 total reads). These:

BL-20150415-18SV4-022-3-SRF: 5631 reads after cleaning

#N = 138 samples

#### 4) Second filter of samples removed due to low reads (<9,579 total reads). These:

BL-20140916-18SV4-022-3-SRF: 8180 reads after cleaning
BL-20131105-18SV4-3-200-SRF: 8900 reads after cleaning
BL-20131204-18SV4-3-200-SRF: 8912 reads after cleaning

#N= 135 samples

#### 5) Remove extra samples due to contamination (high n of reads of fungi + low evenness) that were too different from the others in ordination plot (NMDS):

BL.20140505.18SV4.022.3.SRF
BL.20140602.18SV4.022.3.SRF
BL.20140707.18SV4.022.3.SRF
EA.20140707.18SV4.022.3.SRF
EA.20140326.18SV4.022.3.SRF

#Final N = 130 samples

