For running bismark, 
   

 (1) first run the  'trim_and_align.sh' script, 
    this requires two downloads:  trimgalore (for trimming adaptors from reads) 
                                 &  bismark  ( for creating + alignment to bisulfite converted genome ) 

    NOTE that prior to running alignment, a bisulfite coverted reference must be generated 
       --  see bismark doumentation for more details:
            https://github.com/FelixKrueger/Bismark/blob/master/README.md

 (2) next run the subsetThenExtract.sh
      which will generate bismark output files 

 
