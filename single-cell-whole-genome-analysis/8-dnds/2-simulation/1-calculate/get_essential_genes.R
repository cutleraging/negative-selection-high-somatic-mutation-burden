# load essential and non essential genes
setwd("/Users/ronaldcutler/Dropbox\ (EinsteinMed)/Vijg-lab/Projects/mutation\ accumulation/annotation/gene-sets")

essential <- read.csv("AchillesCommonEssentialControls.csv", header = TRUE)
essential$Gene <- sub(" \\(.*", "", essential$Gene)

nonessential <- read.csv("AchillesNonessentialControls.csv", header = TRUE)
nonessential$Gene <- sub(" \\(.*", "", nonessential$Gene)

# load expressed genes
setwd("/Users/ronaldcutler/Dropbox (EinsteinMed)/Vijg-lab/Projects/mutation accumulation/231009 multiple ENU analysis/10-dnds-ratio")

expressed.genes <- readRDS("expressed.genes.RDS")

# subset essential and non essential genes which are expressed
essential.expressed <- subset(essential, Gene %in% expressed.genes)
nonessential.expressed <- subset(nonessential, Gene %in% expressed.genes)

# save
saveRDS(essential.expressed$Gene, "essential.expressed.genes.RDS")
saveRDS(nonessential.expressed$Gene, "nonessential.expressed.genes.RDS")