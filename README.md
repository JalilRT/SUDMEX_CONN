# SUDMEX_CONN

## Abstract
Cocaine use disorder (CUD) is a substance use disorder (SUD) characterized by compulsion to seek, use and abuse of cocaine, with severe health and economic consequences for the patients, their families and society. Due to the lack of successful treatments and high relapse rate, more research is needed to understand this and other SUD. Here, we present the SUDMEX CONN dataset, a Mexican open dataset of CUD patients and matched healthy controls that includes demographic, cognitive, clinical, and magnetic resonance imaging (MRI) data. MRI data includes: 1) structural (T1-weighted), 2) multishell high-angular resolution diffusion-weighted (DWI-HARDI) and 3) functional (resting state fMRI) sequences. The repository contains unprocessed MRI data available in brain imaging data structure (BIDS) format with corresponding metadata available at the OpenNeuro data sharing platform. Researchers can pursue brain variability between these groups or use a single group for a larger population sample.

## Links

[Preprint](https://www.medrxiv.org/content/10.1101/2021.09.03.21263048v1)
[MRI data](https://openneuro.org/datasets/ds003346)
[Clinical and cognitive measures](http://doi.org/10.5281/zenodo.5123331)

## Description
Code for extracting and ploting QC values for SUDMEX CONN: The Mexican MRI dataset of patients with cocaine use disorder

## Extracting QC valus

### Cortical thickness & volume

### MRIQC

## Figures 

Loading and plotting thickness and graphs:

```
Rscript plot_thick_vol.R
```

Loading and plotting BOLD, T1w and diffusion imaging parameters:

```
Rscript plot_sudmex_conn.R
```
