      * 
       identification division.
       program-id.  labfile2.
       environment division. 
       input-output section.
       file-control.
           select lab2fil ASSIGN TO seqfile-name 
      *      assign to "lab2recs.txt"
           organization is sequential
           access is sequential
           file status is file-stat.
      *
           SELECT batchfil ASSIGN TO batchfile-name
           ORGANIZATION IS LINE SEQUENTIAL
           ACCESS IS SEQUENTIAL
           FILE STATUS IS batchfil-stat.
      *          
       data division. 
       file section.
       fd lab2fil.
       01 lab2fil-record.
           05 sequence-no     pic 9(7).
           05 name            pic X(25).
           05 addr            pic X(25).
           05 zip             pic 9(10).
           05 salary          pic 9(7)V99.
      *
       FD batchfil.
       01 batchfil-record.
           05 batchfile-line  PIC x(100).
      *              
       working-storage section.
       77 batchfil-stat  PIC xx.
       77 seqfile-name PIC x(15).
       77 sortedfile-name PIC x(20).
       77 batchfile-name PIC x(24).
       77 batchfile-command PIC X(25).
       77 batchfile-command2 PIC X(30).
       01 seqfile-random PIC 9V9(10).
       01 seqfile-rand-red REDEFINES seqfile-random PIC X(11).
       77 seqfile-ext PIC X(4) VALUE ".txt".
       77 output-file-name PIC X(16).
       01 time-var.
         05 time-var-hhmmss PIC 9(6).
         05 time-var-hundredths PIC 9(2).
       77 ws-dummy    pic x.
       77 file-stat   pic xx. 
       procedure division.
       main. 
           PERFORM CREATE-SEQFILE-NAME.
           PERFORM CREATE-SORTEDFILE-NAME.
           PERFORM CREATE-BATCHFILE-NAME.
           PERFORM CREATE-BATCHFILE.
           PERFORM CREATE-BATCHFILE-COMMAND.
           
           initialize sequence-no.
           move all "A" to name.
           move all "B" to addr.
           move 1234567890 to zip.
           move 9876543.21 to salary.
      *
           open output lab2fil.
           perform load-file 2000000 times.
           close lab2fil.
           CALL "system" USING batchfile-command2. 
           CALL "system" USING batchfile-command. 
           stop run.
      *
       CREATE-SEQFILE-NAME.
           ACCEPT time-var FROM TIME.
           MOVE FUNCTION RANDOM(time-var-hundredths) TO seqfile-random.
           STRING seqfile-rand-red DELIMITED BY SIZE, 
                  seqfile-ext DELIMITED BY size, 
                  INTO seqfile-name.
      *
       CREATE-SORTEDFILE-NAME. 
      *seqfile-var-sort.txt
           STRING seqfile-rand-red, DELIMITED BY SIZE,
           "sort.txt", DELIMITED BY SIZE, 
           INTO sortedfile-name. 
      *
       CREATE-BATCHFILE-NAME.
      * lab[seqfile-rand-red].bat
            STRING "lab" DELIMITED BY size, 
            seqfile-rand-red, DELIMITED BY size, 
            ".sh", DELIMITED BY size, 
            INTO batchfile-name.
      *
       CREATE-BATCHFILE.
           OPEN OUTPUT batchfil.
      *@echo off
           INITIALIZE batchfil-record.
      *     MOVE "@ECHO off" TO batchfil-record.
      *     WRITE batchfil-record.
      *   
      *echo %time% > begin2a.txt
           INITIALIZE batchfil-record.
           STRING seqfile-rand-red, DELIMITED BY size, 
             "A", DELIMITED BY size, 
             ".TXT", DELIMITED BY size, 
             INTO output-file-name.
             
           STRING "echo $time > ", DELIMITED BY size, 
             output-file-name, DELIMITED BY size, 
             INTO batchfil-record.
           WRITE batchfil-record.
      *                
      *citsort use lab2recs.txt record f 76 sort fields=(1,7,nu,d) give lab2citsort.txt 
           INITIALIZE batchfil-record.
           STRING "citsort USE ", DELIMITED BY size, 
           seqfile-name, DELIMITED BY size, 
           " RECORD f 76 SORT fields=\(1,7,nu,d\) give ", 
                                     DELIMITED BY size, 
           sortedfile-name, DELIMITED BY size, 
           INTO batchfil-record.
           WRITE batchfil-record.
      *     
      *echo $time >> begin2a.txt
           INITIALIZE batchfil-record.
           STRING seqfile-rand-red, DELIMITED BY size, 
             "A", DELIMITED BY size, 
             ".TXT", DELIMITED BY size, 
             INTO output-file-name.
           STRING "echo $time >> ", DELIMITED BY size, 
             output-file-name, DELIMITED BY size, 
             INTO batchfil-record.
           WRITE batchfil-record.
      *
           CLOSE batchfil.
      *
       CREATE-BATCHFILE-COMMAND.
           STRING "./", DELIMITED BY size,
           batchfile-name, DELIMITED BY size, 
            ".sh", DELIMITED BY size, 
           INTO batchfile-command. 
           STRING "chmod 777 ", DELIMITED BY size,
           batchfile-name, DELIMITED BY size, 
            ".sh", DELIMITED BY size, 
           INTO batchfile-command2.
      *                
       load-file.
           add 1 to sequence-no.          
           write lab2fil-record.
      *    display sequence-no line 10 col 10.
