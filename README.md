## Prior Notice

Due to **confidentially** of internal data which obtained from the company, within this repository, I will *not provide the raw data* that used in the analysis. Instead, I will provide which data I used to define some variables in the codes, in case you want to use the codes to your analysis.
* ```Data FABA``` is the raw data I used in the analysis.
* ```Scaled Phase One``` is the first phase data that has been standardized.
* ```Scaled Phase Two``` is the second phase data that has been standardized.
* ```data_bersih``` is the in-control data (phase one) that obtained from variability monitoring using MEWMV.
* ```SSR1_v2``` is the **transformed data of phase one** used Spatial Signed Rank method.
* ```SSR2``` is the **transformed data of phase two** used Spatial Signed Rank menthod.
* ```clean2``` is the in-control data for phase two which obtained after the mean monitoring.
* ```clean1``` is the in-control data for phase one which obtained after the mean monitoring.

### ANALYSIS
The analysis should be conduct per phase. Here's the right steps:
1. Statistics Descriptive
2. MEWMV for Phase One
3. SSRM for Phase One
4. MEWMV for Phase Two
5. SSRM for Phase Two
6. Process Capability
