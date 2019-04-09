For running bismark, 
   

 (1) first run the  'trim_and_align.sh' script, which uses the trimgalore sortware for read trimming, and then runs bismark alignment ;
    ( this requires first building a bisulfite converted reference --  see bismark doumentation for more details:
  https://github.com/FelixKrueger/Bismark/blob/master/README.md )


 (2) next run the subsetThenExtract.sh
      which will generate bismark outpput files  
