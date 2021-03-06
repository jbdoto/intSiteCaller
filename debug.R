
#    This source code file is a component of the larger INSPIIRED genomic analysis software package.
#    Copyright (C) 2016 Frederic Bushman
#
#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with this program.  If not, see <http://www.gnu.org/licenses/>.
#

## load hiReadsProcessor.R
libs <- c("plyr", "BiocParallel", "Biostrings", "GenomicAlignments" ,"hiAnnotator" ,"sonicLength", "GenomicRanges", "BiocGenerics", "ShortRead", "GenomicRanges", "igraph")
null <- suppressMessages(sapply(libs, library, character.only=TRUE))

load("completeMetadata.RData")

reverseComplement(DNAStringSet( paste0(completeMetadata$primer, completeMetadata$ltrBit) ))

rc.primerltrbit <- as.character(reverseComplement(DNAStringSet( paste0(completeMetadata$primer, completeMetadata$ltrBit) )))

rc.primerltrbitInlargeLTR <- mapply(function(x,y ) grepl(paste0("^",x), y),
                                    x=rc.primerltrbit,
                                    y=completeMetadata$largeLTRFrag)

if(!all(rc.primerltrbitInlargeLTR)) {
    print(data.frame(PLTR=names(rc.primerltrbitInlargeLTR),
                     rc.primerltrbitInlargeLTR))
}



submat1 <- nucleotideSubstitutionMatrix(match=1,
                                        mismatch=0,
                                        baseOnly=TRUE)

## p for primer
## search for primer from the beginning
aln.p <- pairwiseAlignment(pattern=rc.primerltrbit[1],
                           subject=completeMetadata$largeLTRFrag[1],
                           substitutionMatrix=submat1,
                           gapOpening = 0,
                           gapExtension = 1,
                           type="overlap")



rc.primer <- as.character(
    reverseComplement(DNAStringSet(completeMetadata$primer)))
rc.ltrbit <- as.character(
    reverseComplement(DNAStringSet(completeMetadata$ltrBit)))

rc.primerltrbitInlargeLTR <- mapply(function(x,y, z) grepl(y, x) | grepl(z, x),
                                    x=completeMetadata$largeLTRFrag,
                                    y=rc.primer,
                                    z=rc.ltrbit)




marker <- completeMetadata$largeLTRFrag[1]

matchPattern(marker, Hsapiens[["chr1"]])
matchPattern(marker, Hsapiens)

marker <- substring(completeMetadata$largeLTRFrag[1], 1, 20)


library(Biostrings)

marker <- "AGTCCCTTAAGCGGAG"
seq <- paste0(paste(sample(c("A","C","G","T"), 10, replace=TRUE), collapse=""),
              marker)

submat1 <- nucleotideSubstitutionMatrix(match=1,
                                        mismatch=0,
                                        baseOnly=TRUE)

     marker <- "AGTCCCTTAAGCGGAG"
seq <- c("ACTGCCCAAGTCAATTAAGCGGTTAAAAAAAAAAAA",
         "ACTGCCCAAGTCAATTAAGCGGTT",
         "ACTGCCCAAGTCAATTAAGCG",
         "ACTGCCCCAA",
         "ACTTGATCCGTCCGATCGGGTACTCGACAA",
         "TAGGGAGGGCAAACCGCATCGAATAACGAT",
         "CGCTGTAGCCAACGCCGTGACCAGACGGTG",
         "AGTCCCTTGCGGAG",
         "TTTGGGAGTCCCTTTAAGCGGAG",
         "AGTCCCTTCCAAGCGGAG",
         "TTCTTACATGCAAACTGGTCAGTTCTGATG")

tmp <- pairwiseAlignment(pattern=seq,
                         subject=marker,
                         substitutionMatrix=submat1,
                         gapOpening = 0,
                         gapExtension = 1,
                         type="overlap")


pairwiseAlignment(pattern="AGTCCCTTAAGCGGAG",
                  subject="ACTGCCCAATAGTCCCTTAAGCGGAT")

pairwiseAlignment(pattern="AGTCCCTTAAGCGGAG",
                  subject="ACTGCCCAATAGTCCCTTTTTTT")

pairwiseAlignment(pattern=marker, subject=seq,  type = "local")


  filenames <- list(read1, read2)
  
  reads <- lapply(list(read1, read2), readFastq)
    sapply(x, readFastq)
  })

reads1 <- lapply(list(read1, read2), sapply, readFastq)

#' Look for a string through a whole BS genome
#' @param marker chr of length 1
#' @param ref a BS genome
#' @param misMatch, number of mis matches allowed
#' @return dataframe of location and the matched sequences
#' @example
#' searchBSreference("TGCTAGAGATTTTCCACACT", Hsapiens, 1)
#' searchBSreference("TGCTAGAGATTTTCCACACT", Hsapiens, 2)
#' 
searchBSreference <- function(marker, ref=Hsapiens, misMatch=0) {
    stopifnot(length(marker)==1)
    marker.loci <- lapply(seqnames(ref), function(chr)
        { message("...Looking in ", chr)
          m <- matchPattern(marker, Hsapiens[[chr]], max.mismatch=misMatch)
          df <- data.frame()
          if ( length(m)>0 ) {
              df <- data.frame(chr=chr,
                               start=start(m),
                               end=end(m),
                               mseq=as.character(m))
          }
          return(df)
      })
    return(plyr::rbind.fill(marker.loci))
}



PairwiseAlignmentsSingleSubject2DF <- function(PA) {
    stopifnot("PairwiseAlignmentsSingleSubject"  %in% class(PA))

return(data.frame(
    width=width(pattern(PA)),
    score=score(PA),
    mismatch=width(pattern(PA))-score(PA),
    start=start(pattern(PA)),
    end=end(pattern(PA)),
    ))
}

trim_overreading <- function(reads, marker, misMatch=1) {
    reads=reads.p
    marker=linker_common
    misMatch=1
    
    stopifnot(class(reads) %in% "DNAStringSet")
stopifnot(!any(duplicated(names(reads))))
stopifnot(length(marker)==1)


submat1 <- nucleotideSubstitutionMatrix(match=1,
mismatch=0,
baseOnly=TRUE)

tmp <- pairwiseAlignment(pattern=reads,
subject=marker,
substitutionMatrix=submat1,
gapOpening = 0,
gapExtension = 1,
type="overlap")


mwidth <- as.integer(stringr::str_match(names(reads), "(\\d+):(\\d+)$")[,2])

ovldf <- data.frame(size=nchar(linker_common),
width=width(pattern(tmp)),
score=score(tmp),
mismatch=width(pattern(tmp))-score(tmp),
start=start(pattern(tmp)),
end=end(pattern(tmp)),
rlen=nchar(reads),
mwidth=mwidth,
cut=ifelse( mwidth<nchar(reads), mwidth+1, nchar(reads) ))

ovldf$good <- ( abs(ovldf$cut-ovldf$start)<=2 )

library(rpart)
fit <- rpart(good ~ size + width + score + mismatch + start + end + rlen,
data=ovldf,
method="class")


## search for primer from the beginning
res <- IRanges(start=nchar(reads)+1,
                   width=1,
                   names=names(reads))
    
    res.p <- unlist(vmatchPattern(pattern=marker,
                                  subject=reads,
                                  max.mismatch=misMatch))
    
    res[names(res.p)] <- res.p
    start(res[start(res)<5]) <- 5
    stopifnot(all(names(res) == names(reads)))
    
    reads <- subseq(reads, 1, start(res)-1)
    
    return(reads)
}



searchBSreference(marker, Hsapiens, 1)

"TGCTAGAGATTTTCCACACTGACTAAAAGGGTCT"

status <- tryCatch(eval(as.call(append(getTrimmedSeqs,
                                       unname(as.list(completeMetadata[c("qualityThreshold", "badQualityBases",
                                                                         "qualitySlidingWindow", "primer", "ltrBit",
                                                                         "largeLTRFrag", "linkerSequence", "linkerCommon",
                                                                         "mingDNA", "read1", "read2", "alias", "vectorSeq")]))))),
                   error=function(e){print(paste0("Caught error: ", e$message))})


getTrimmedSeqs( 
    qualityThreshold=completeMetadata$qualityThreshold,
    badQuality=completeMetadata$badQualityBases,
    qualityWindow=completeMetadata$qualitySlidingWindow,
    primer=completeMetadata$primer,
    ltrbit=completeMetadata$ltrBit,
    largeLTRFrag=completeMetadata$largeLTRFrag,
    linker=completeMetadata$linkerSequence,
    linker_common=completeMetadata$linkerCommon,
    mingDNA=completeMetadata$mingDNA,
    read1=completeMetadata$read1,
    read2=completeMetadata$read2,
    alias=completeMetadata$alias,
    vectorSeq=completeMetadata$vectorSeq
    )


sampleID <- as.integer(Sys.getenv("LSB_JOBINDEX"))
sampleID=1
codeDir <- get(load("codeDir.RData"))
source(file.path(codeDir, "intSiteLogic.R"))
completeMetadata <- get(load("completeMetadata.RData"))[sampleID,]
alias <- completeMetadata$alias
print(t(as.data.frame(completeMetadata)), quote=FALSE)

    qualityThreshold=completeMetadata$qualityThreshold
    badQuality=completeMetadata$badQualityBases
    qualityWindow=completeMetadata$qualitySlidingWindow
    primer=completeMetadata$primer
    ltrbit=completeMetadata$ltrBit
    largeLTRFrag=completeMetadata$largeLTRFrag
    linker=completeMetadata$linkerSequence
    linker_common=completeMetadata$linkerCommon
    mingDNA=completeMetadata$mingDNA
    read1=completeMetadata$read1
    read2=completeMetadata$read2
    alias=completeMetadata$alias
    vectorSeq=completeMetadata$vectorSeq



#' subsetting and subseqing
#' trim primer and ltrbit off of ltr side of read, R2 in protocol
#' if not both primer and ltrbit found in a read, disgard it
#' allow 1 mismatch for either primer or ltrbit
#' @param reads.p DNAStringSet of reads, normally R2
#' @param primer character string of lenth 1, such as "GAAAATC"
#' @param ltrbit character string of lenth 1, such as "TCTAGCA"
#' @retuen DNAStringSet of reads with primer and ltr removed
#' 
trim_Ltr_side_reads <- function(reads.p, primer, ltrbit) {
    
    stopifnot(class(reads.p) %in% "DNAStringSet")
    stopifnot(!any(duplicated(names(reads.p))))
    stopifnot(length(primer)==1)
    stopifnot(length(ltrbit)==1)
    
    ## search for primer from the beginning
    res.p <- unlist(vmatchPattern(pattern=primer,
                                  subject=subseq(reads.p, 1, 2+nchar(primer)),
                                  max.mismatch=1))
    
    ## search for ltr from after primer
    res.ltr <- unlist(vmatchPattern(pattern=ltrbit,
                                    subject=subseq(reads.p, nchar(primer), nchar(primer)+nchar(ltrbit)+1),
                                    max.mismatch=1))
    ## put correct shift for ltr positions
    res.ltr <- shift(res.ltr, nchar(primer)-1)
    
    ## require both primer and ltr presence
    goodName <- intersect(names(res.p), names(res.ltr))
    
    res.p <- res.p[match(goodName, names(res.p))]
    res.ltr <- res.ltr[match(goodName, names(res.ltr))]
    stopifnot(all(names(res.p) == names(res.ltr)))
    stopifnot(all(names(res.p) == goodName))
    
    ## subset and cut after ltr
    reads.p <- reads.p[match(goodName, names(reads.p))]
    reads.p <- subseq(reads.p, end(res.ltr)+1)
    
    return(reads.p)
}
##trim_Ltr_side_reads(reads.p, primer, ltrbit)



#' subsetting and subseqing
#' trim primerID linker side of read, R1 in protocol
#' a primerIDlinker has N's in the middle
#' allow 1+n/15 mismatches for either part before and after Ns
#' @param reads.l DNAStringSet of reads, normally R1
#' @param linker character string of lenth 1, such as
#'               "AGCAGGTCCGAAATTCTCGGNNNNNNNNNNNNCTCCGCTTAAGGGACT"
#' @return list of read.l and primerID
#' 
trim_primerIDlinker_side_reads <- function(reads.l, linker) {
    
    stopifnot(class(reads.l) %in% "DNAStringSet")
    stopifnot(!any(duplicated(names(reads.l))))
    stopifnot(length(linker)==1)
    
    pos.N <- unlist(gregexpr("N", linker))
    len.N <- length(pos.N)
    link1 <- substr(linker, 1, min(pos.N)-1)
    link2 <- substr(linker, max(pos.N)+1, nchar(linker))
    
    ## search beginning of reads for primer
    res.1 <- unlist(vmatchPattern(pattern=link1,
                                  subject=subseq(reads.l, 1, 2+nchar(link1)),
                                  max.mismatch=1+as.integer(nchar(link1)/15)))
    
    ## search reads after primer for ltr
    res.2 <- unlist(vmatchPattern(pattern=link2,
                                  subject=subseq(reads.l, max(pos.N)-1, nchar(linker)+1),
                                  max.mismatch=1+as.integer(nchar(link1)/15)))
    ## put correct shift for ltr positions
    res.2 <- shift(res.2, max(pos.N)-2)
    
    ## names of seqs with both link1 and link2 hits
    goodName <- intersect(names(res.2), names(res.1))
    
    res.1 <- res.1[match(goodName, names(res.1))]
    res.2 <- res.2[match(goodName, names(res.2))]
    stopifnot(all(names(res.1) == names(res.2)))
    stopifnot(all(names(res.1) == goodName))
    
    reads.l <- reads.l[match(goodName, names(reads.l))]
    
    primerID <- subseq(reads.l, end(res.1)+1, start(res.2)-1)
    reads.l <- subseq(reads.l, end(res.2)+1)
    
    return(list("reads.l"=reads.l, "primerID"=primerID))
}
##trim_primerIDlinker_side_reads(reads.l, linker)



#' subseqing, trim ltrbit side of reads to remove linker sequences
#' when human part of sequence is short, ltr side read will read in to 
#' linker, which may cause trouble for alignment
#' allow 1 mismatch for linker common
#' @param reads.p DNAStringSet of reads, normally R2
#' @param linker_common reverse complement of the second part of linker sequence
#' @retuen DNAStringSet of reads with linker sequences removed
#' 
trim_overreeading_linker <- function(reads.p, linker_common) {
    
    stopifnot(class(reads.p) %in% "DNAStringSet")
    stopifnot(!any(duplicated(names(reads.p))))
    stopifnot(length(linker_common)==1)
    
    ## search for primer from the beginning
    res <- IRanges(start=nchar(reads.p)+1,
                   width=1,
                   names=names(reads.p))
    
    res.p <- unlist(vmatchPattern(pattern=linker_common,
                                  subject=reads.p,
                                  max.mismatch=1))
    
    res[match(names(res.p) ,names(reads.p))] <- res.p
    start(res[start(res)<5]) <- 5
    stopifnot(all(names(res) == names(reads.p)))
    
    
    reads.p <- subseq(reads.p, 1, start(res)-1)
    
    return(reads.p)
}
##trim_overreeading_linker(reads.p, linker_common)


#' subseqing, trim ltrbit side of reads to remove linker sequences
#' when human part of sequence is short, ltr side read will read in to 
#' linker, which may cause trouble for alignment
#' allow 1 mismatch for linker common
#' @param reads.p DNAStringSet of reads, normally R2
#' @param linker_common reverse complement of the second part of linker sequence
#' @retuen DNAStringSet of reads with linker sequences removed
#' 
trim_overreeading_linker <- function(reads.p, linker_common) {
    
    stopifnot(class(reads.p) %in% "DNAStringSet")
    stopifnot(!any(duplicated(names(reads.p))))
    stopifnot(length(linker_common)==1)
    
    ## search for primer from the beginning
    res <- IRanges(start=nchar(reads.p)+1,
                   width=1,
                   names=names(reads.p))
    
    res.p <- unlist(vmatchPattern(pattern=linker_common,
                                  subject=reads.p,
                                  max.mismatch=1))
    
    res[match(names(res.p) ,names(reads.p))] <- res.p
    start(res[start(res)<5]) <- 5
    stopifnot(all(names(res) == names(reads.p)))
    
    
    reads.p <- subseq(reads.p, 1, start(res)-1)
    
    return(reads.p)
}
##trim_overreeading_linker(reads.p, linker_common)



reads.p <- reads[[2]]
if(length(res.p) > 0){
    reads.p <- trimSeqs(reads[[2]], res.p, side='left', offBy=1)
}

res.ltr <- pairwiseAlignSeqs(reads.p, patternSeq=ltrbit, 
                             qualityThreshold=1, doRC=F)

if(length(res.ltr) > 0 ){
    reads.p <- trimSeqs(reads.p, res.ltr, side='left', offBy=1)
}





stats.bore$primed <- length(reads.p)



## order tthe R1 R2 fa files so that large file align first
toAlign <- list.files(".", "R[12]-.*fa$", recursive=TRUE)
toAlign <- toAlign[order(-file.size(toAlign))]
save(toAlign, file="toAlign.RData", compress=FALSE)
toAlign <- get(load("toAlign.RData"))


#### debugging vector trimming parameters ####
## It trimmed 10% of perfect human reads ##

library(dplyr)
library(ggplot2)
library(Biostrings)
library(stringr)
library(gridExtra)

load("completeMetadata.RData")

hitspFile <- list.files(".", pattern="hits.v.p.RData", recursive=TRUE)
hitslFile <- list.files(".", pattern="hits.v.l.RData", recursive=TRUE)

hits.p  <- do.call(rbind, lapply(hitspFile, function(f) get(load(f)) ))
hits.l  <- do.call(rbind, lapply(hitslFile, function(f) get(load(f)) ))

hits.p$POI <- hits.p$matches/hits.p$qSize
hits.l$POI <- hits.l$matches/hits.l$qSize

qplot(hits.p$POI)
qplot(hits.p$qStart, hits.p$POI, geom='bin2d') +
    scale_fill_gradient2(low = 'blue', mid = 'white', high = 'red')

qplot(hits.l$POI)
qplot(hits.l$qStart, hits.l$POI, geom='bin2d') +
    scale_fill_gradient2(low = 'blue', mid = 'white', high = 'red')


WAS <- read.csv("region.csv", header=TRUE)

hits.p$ID <- sub("^GTSP.*%", "", hits.p$qName)
hits.l$ID <- sub("^GTSP.*%", "", hits.l$qName)

hits.p.WAS <- hits.p[hits.p$ID %in% WAS$ID, ]
hits.l.WAS <- hits.l[hits.l$ID %in% WAS$ID, ]

needed <- c("matches", "misMatches", "strand", "qSize", "qStart",
            "tStart", "POI", "ID")

hits.p.WAS <- hits.p.WAS[, needed]
hits.l.WAS <- hits.l.WAS[, needed]

hits.p.WAS <- hits.p.WAS %>% group_by(ID) %>% mutate(value=POI) %>%
    top_n(1) %>% mutate(value=NULL)
hits.l.WAS <- hits.l.WAS %>% group_by(ID) %>% mutate(value=POI) %>%
    top_n(1) %>% mutate(value=NULL)


Vector <- readDNAStringSet("vector_WasLenti.fa")
primer <- paste0(completeMetadata$primer, completeMetadata$ltrBit)[1]
primer.loci <- str_locate_all(Vector, primer)

aln.p <- qplot(hits.p.WAS$tStart) + xlim(c(1, 10000)) +
    geom_vline(xintercept =primer.loci[[1]][,"start"])
aln.l <- qplot(hits.l.WAS$tStart) +  xlim(c(1, 10000)) +
    geom_vline(xintercept =primer.loci[[1]][,"start"])
grid.arrange(aln.p, aln.l)

grid.arrange(qplot(hits.p.WAS$POI), qplot(hits.l.WAS$POI))

grid.arrange(qplot(hits.p.WAS$qStart), qplot(hits.l.WAS$qStart))


Vector <- readDNAStringSet("../vector_sim.fa")

primer <- paste0(completeMetadata$primer, completeMetadata$ltrBit)

primer.loci <- str_locate_all(Vector, primer)

aln.p <- qplot(hits.p$tStart, xlim=c(0,10000)) +
    geom_vline(xintercept =primer.loci[[1]][,"start"])

aln.l <- qplot(hits.l$tStart, xlim=c(0,10000)) +
    geom_vline(xintercept =primer.loci[[1]][,"start"])

## alignments of trimmed reads on vector
grid.arrange(aln.p, aln.l)


pOI <- c(hits.p$matches/hits.p$qSize, hits.l$matches/hits.l$qSize)
rLen <- c(hits.p$qSize, hits.l$qSize)
qplot(pOI)
qplot(rLen, pOI, xlab="Read length", ylab="Percent of identity")



hits.v.p <- get(load("hits.v.p.RData"))
hits.v.l <- get(load("hits.v.l.RData"))
load("reads.p.RData")
load("reads.l.RData")

Vector <- readDNAStringSet("../p746vector.fasta")

load("../completeMetadata.RData")
primerltr <- unique(paste0(completeMetadata$primer, completeMetadata$ltrBit))

stringr::str_locate_all(Vector, primerltr)


path="~/Nobles/vector/run20150929"
get_stat <- function(path) {
    sampleInfo <- read.table(file.path(path, "sampleInfo.tsv"), header=TRUE)
    
    stats.file <- list.files(path, pattern="^stats.RData$", recursive=TRUE, full.names=TRUE)
    
    stats <- plyr:::rbind.fill( lapply(stats.file, function(x) get(load(x))) )
    
    stats$sample <- as.character(stats$sample)
    rownames(stats) <- NULL
    
    stats <- merge(data.frame(sample=as.character(sampleInfo$alias)),
                   plyr:::rbind.fill(lapply(stats.file, function(x) get(load(x)))),
                   by="sample",
                   all.x=TRUE)
stats$sample <- as.character(stats$sample)
    stats$gtsp <- sub("-\\d+$", "", stats$sample)
    stats$Replicate <- sub("GTSP\\d+-", "", stats$sample)
    rownames(stats) <- NULL
    
    needed <- c("sample", "reads.p_afterTrim", "reads.l_afterTrim", "reads.p_afterVTrim", "reads.l_afterVTrim", "curated", "totalSonicLengths", "numUniqueSites", "totalEvents")
    return( stats[, needed] )
}

stat.new <- get_stat("~/Nobles/vector/run20150929")
stat.old <- get_stat("~/Nobles/run20150929")


stat.new <- get_stat("~/Frances/vector/run20150903")
stat.old <- get_stat("~/Frances/run20150903")


stat.new <- get_stat("~/Frances/vector/run20141104")
stat.old <- get_stat("~/Frances/run20141104")


stat.comp <- merge(stat.old, stat.new, by="sample")

toShow <- c("sample", "curated.x", "curated.y", "totalSonicLengths.x", "totalSonicLengths.y", "totalEvents.x", "totalEvents.y")

write.table(stat.comp[, toShow], row.names=F, quote=FALSE, sep="\t")
