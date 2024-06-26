---
title: "BatchQC Report"
date: "2024-01-26"
output: 
  html_vignette:
    toc: true
    toc_depth: 2
    template: batchQC.html
    self_contained: no
    lib_dir: libs
---


Summary
=======
## Confounding
### Number of samples in each Batch and Condition

-----------------------------------------------------
        &nbsp;           Batch a   Batch b   Batch c 
----------------------- --------- --------- ---------
 **Condition control**      1         1         1    

   **Condition enu**        1         1         1    
-----------------------------------------------------

### Measures of confounding between Batch and Condition

----------------------------------------------------------------------
            &nbsp;                Standardized Pearson     Cramer's V 
                                 Correlation Coefficient              
------------------------------- ------------------------- ------------
  **Confounding Coefficients                0                  0      
 (0=no confounding, 1=complete                                        
        confounding)**                                                
----------------------------------------------------------------------

## Variation Analysis
### Variation explained by Batch and Condition
![](/Users/ronaldcutler/Dropbox (EinsteinMed)/Vijg-lab/Projects/mutation accumulation/231009 multiple ENU analysis/14-bulk-rna-analysis/3-differential-expression/batchqc/corrected_files/figure-html/unnamed-chunk-4-1.png)<!-- -->


------------------------------------------------------------
   &nbsp;      Full (Condition+Batch)   Condition    Batch  
------------- ------------------------ ----------- ---------
  **Min.**               0                  0          0    

 **1st Qu.**           13.23              13.2       0.003  

 **Median**            42.71              42.64      0.01   

  **Mean**             44.02              43.98     0.04077 

 **3rd Qu.**           72.53              72.48      0.029  

  **Max.**              100               99.98      7.079  
------------------------------------------------------------

## P-value Analysis
### Distribution of Batch and Condition Effect p-values Across Genes

---------------------------------------------------------------------------------------------
         &nbsp;             Min.      1st Qu.   Median    Mean    3rd Qu.   Max.    Ps<0.05  
------------------------ ----------- --------- -------- -------- --------- ------ -----------
   **Batch P-values**     1.104e-06   0.9993    0.9998   0.9979   0.9999     1     0.0002718 

 **Condition P-values**   9.322e-11   0.1484    0.3467   0.4032   0.6367     1      0.09195  
---------------------------------------------------------------------------------------------

![](/Users/ronaldcutler/Dropbox (EinsteinMed)/Vijg-lab/Projects/mutation accumulation/231009 multiple ENU analysis/14-bulk-rna-analysis/3-differential-expression/batchqc/corrected_files/figure-html/unnamed-chunk-7-1.png)<!-- -->

![](/Users/ronaldcutler/Dropbox (EinsteinMed)/Vijg-lab/Projects/mutation accumulation/231009 multiple ENU analysis/14-bulk-rna-analysis/3-differential-expression/batchqc/corrected_files/figure-html/unnamed-chunk-8-1.png)<!-- -->


Differential Expression
=======================
## Expression Plot
Boxplots for all values for each of the samples and are colored by batch membership.

![](/Users/ronaldcutler/Dropbox (EinsteinMed)/Vijg-lab/Projects/mutation accumulation/231009 multiple ENU analysis/14-bulk-rna-analysis/3-differential-expression/batchqc/corrected_files/figure-html/unnamed-chunk-10-1.png)<!-- -->

## LIMMA

--------------------------------------------------------------------------------------------------
       &nbsp;          Condition: enu (logFC)   AveExpr     t       P.Value    adj.P.Val     B    
--------------------- ------------------------ --------- -------- ----------- ----------- --------
 **ENSG00000065308**           623.5             7224     46.75    4.232e-05    0.2863     -4.23  

 **ENSG00000072840**           153.8             3932     35.22    9.272e-05    0.2863     -4.23  

 **ENSG00000248905**           180.6              459     34.35    9.934e-05    0.2863     -4.23  

 **ENSG00000100842**           -126.8            583.1    -31.91   0.0001218    0.2863     -4.231 

 **ENSG00000071564**           -115.9            1664     -26.78   0.0001977    0.2863     -4.231 

 **ENSG00000116489**           -139.2            2518     -26.37   0.0002063    0.2863     -4.231 

 **ENSG00000138443**           -103.3            1154     -25.98   0.000215     0.2863     -4.231 

 **ENSG00000141985**           -303.4            2683     -25.44   0.000228     0.2863     -4.231 

 **ENSG00000071242**           -220.1            3578     -24.69   0.0002475    0.2863     -4.232 

 **ENSG00000113719**           222.5             5266     23.25    0.0002924    0.2863     -4.232 
--------------------------------------------------------------------------------------------------


Median Correlations
===================
This plot helps identify outlying samples.
![](/Users/ronaldcutler/Dropbox (EinsteinMed)/Vijg-lab/Projects/mutation accumulation/231009 multiple ENU analysis/14-bulk-rna-analysis/3-differential-expression/batchqc/corrected_files/figure-html/unnamed-chunk-13-1.png)<!-- -->


Heatmaps
========
## Heatmap
This is a heatmap of the given data matrix showing the batch effects and variations with different conditions.
![](/Users/ronaldcutler/Dropbox (EinsteinMed)/Vijg-lab/Projects/mutation accumulation/231009 multiple ENU analysis/14-bulk-rna-analysis/3-differential-expression/batchqc/corrected_files/figure-html/unnamed-chunk-15-1.png)<!-- -->

## Sample Correlations
This is a heatmap of the correlation between samples.
![](/Users/ronaldcutler/Dropbox (EinsteinMed)/Vijg-lab/Projects/mutation accumulation/231009 multiple ENU analysis/14-bulk-rna-analysis/3-differential-expression/batchqc/corrected_files/figure-html/unnamed-chunk-16-1.png)<!-- -->


Circular Dendrogram
===================
This is a Circular Dendrogram of the given data matrix colored by batch to show the batch effects.
![](/Users/ronaldcutler/Dropbox (EinsteinMed)/Vijg-lab/Projects/mutation accumulation/231009 multiple ENU analysis/14-bulk-rna-analysis/3-differential-expression/batchqc/corrected_files/figure-html/unnamed-chunk-18-1.png)<!-- -->


PCA: Principal Component Analysis
=================================
## PCA
This is a plot of the top two principal components colored by batch to show the batch effects.
![](/Users/ronaldcutler/Dropbox (EinsteinMed)/Vijg-lab/Projects/mutation accumulation/231009 multiple ENU analysis/14-bulk-rna-analysis/3-differential-expression/batchqc/corrected_files/figure-html/unnamed-chunk-20-1.png)<!-- -->

## Explained Variation

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 &nbsp;    Proportion of Variance (%)   Cumulative Proportion of   Percent Variation Explained by   Percent Variation Explained by   Condition Significance   Percent Variation Explained by   Batch Significance (p-value) 
                                              Variance (%)           Either Condition or Batch                Condition                    (p-value)                      Batch                                             
--------- ---------------------------- -------------------------- -------------------------------- -------------------------------- ------------------------ -------------------------------- ------------------------------
 **PC1**             44.75                       44.75                          95.7                             95.7                       0.02193                         0                             0.9997            

 **PC2**             29.88                       74.63                          1.6                              1.6                         0.8741                         0                               1               

 **PC3**             25.33                       99.96                          2.8                              2.8                         0.8341                         0                               1               

 **PC4**            0.03057                      99.99                          100                               0                          0.6197                        100                            3e-05             

 **PC5**            0.008804                      100                           100                               0                          0.8512                        100                            1e-05             

 **PC6**           6.853e-28                      100                            64                              32.7                        0.3097                        31.3                           0.5344            
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


Shape
=====
This is a heatmap plot showing the variation of gene expression mean, variance, skewness and kurtosis between samples grouped by batch to see the batch effects variation
![](/Users/ronaldcutler/Dropbox (EinsteinMed)/Vijg-lab/Projects/mutation accumulation/231009 multiple ENU analysis/14-bulk-rna-analysis/3-differential-expression/batchqc/corrected_files/figure-html/unnamed-chunk-23-1.png)<!-- -->

```
## Note: Sample-wise p-value is calculated for the variation across samples on the measure across genes. Gene-wise p-value is calculated for the variation of each gene between batches on the measure across each batch. If the data is quantum normalized, then the Sample-wise measure across genes is same for all samples and Gene-wise p-value is a good measure.
```


Combat Plots
============
This is a plot showing whether parametric or non-parameteric prior is appropriate for this data. It also shows the Kolmogorov-Smirnov test comparing the parametric and non-parameteric prior distribution.

```
## Found 3 batches
## Adjusting for 1 covariate(s) or covariate level(s)
## Standardizing Data across genes
## Fitting L/S model and finding priors
```

![](/Users/ronaldcutler/Dropbox (EinsteinMed)/Vijg-lab/Projects/mutation accumulation/231009 multiple ENU analysis/14-bulk-rna-analysis/3-differential-expression/batchqc/corrected_files/figure-html/unnamed-chunk-25-1.png)<!-- -->![](/Users/ronaldcutler/Dropbox (EinsteinMed)/Vijg-lab/Projects/mutation accumulation/231009 multiple ENU analysis/14-bulk-rna-analysis/3-differential-expression/batchqc/corrected_files/figure-html/unnamed-chunk-25-2.png)<!-- -->![](/Users/ronaldcutler/Dropbox (EinsteinMed)/Vijg-lab/Projects/mutation accumulation/231009 multiple ENU analysis/14-bulk-rna-analysis/3-differential-expression/batchqc/corrected_files/figure-html/unnamed-chunk-25-3.png)<!-- -->

```
## Warning in ks.test.default(gamma.hat[1, ], "pnorm", gamma.bar[1], sqrt(t2[1])): ties should not be present for the Kolmogorov-Smirnov test
```

![](/Users/ronaldcutler/Dropbox (EinsteinMed)/Vijg-lab/Projects/mutation accumulation/231009 multiple ENU analysis/14-bulk-rna-analysis/3-differential-expression/batchqc/corrected_files/figure-html/unnamed-chunk-25-4.png)<!-- -->

```
## Warning in ks.test.default(gamma.hat[1, ], "pnorm", gamma.bar[1], sqrt(shinyInput$t2[1])): ties should not be present for the Kolmogorov-Smirnov test
```

```
## Warning in ks.test.default(delta.hat[1, ], invgam): p-value will be approximate in the presence of ties
```

```
## Batch mean distribution across genes: Normal vs Empirical distribution
## Two-sided Kolmogorov-Smirnov test
## Selected Batch: 1
## Statistic D = 0.4894
## p-value = 0
## 
## 
## Batch Variance distribution across genes: Inverse Gamma vs Empirical distribution
## Two-sided Kolmogorov-Smirnov test
## Selected Batch: 1
## Statistic D = 0.2528
## p-value = 0Note: The non-parametric version of ComBat takes much longer time to run and we recommend it only when the shape of the non-parametric curve widely differs such as a bimodal or highly skewed distribution. Otherwise, the difference in batch adjustment is very negligible and parametric version is recommended even if p-value of KS test above is significant.
```


SVA
===
## Summary

```
## Number of Surrogate Variables found in the given data: 1
```
