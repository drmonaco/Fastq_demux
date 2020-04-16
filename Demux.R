library(tidyverse)
library(ShortRead)
library(data.table)

barcode = fread("LISH28_JJC_barcode_map.csv")
x=  "122-BLSA_AD-serum-Con-704-post-20A20G-1_S111_R1_001.fastq.gz"



fq <- readFastq(x) # Imports first FASTQ file



  f <- FastqStreamer(x) 
  while(length(fq <- yield(f))) {
    for(i in 1:dim(barcode)[1]) {
      pattern <- barcode[i,2]
      fqsub <- fq[grepl(pattern, sread(fq))] 
      if(length(fqsub) > 0) {
        writeFastq(fqsub, paste(barcode[i,1],paste0("S",i,collapse = ""),"R1_001.fastq.gz", sep="_"), mode="w", compress=T)
      }
    }
  }
  close(f)

