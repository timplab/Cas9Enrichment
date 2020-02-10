#### 

The associated script is based on the shell scripts provided with nanopolish and used to generate a
 "methylation calls" file.

These methylation calls can be used to generate the red/blue bams for methylation visualization in IGV
  in two easy steps using code found at my colleague Isac Lee's GitHub : 
   https://github.com/isaclee/nanopore-methylation-utilities

note that his code take the methylation calls file (not the methylation frequency file made by the last block of the associated code)

Also note that some older versions of samtools may cause his scripts to terminate, and that if you have issues making the red/blue bams
  we suggest updating samtools .


  yours, 
    gilfunk + isac 






