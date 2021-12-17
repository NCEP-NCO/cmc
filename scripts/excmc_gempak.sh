#!/bin/bash
set -x

cpreq ${FIXcmc}/* $DATA  # directory containing nagrib index tables

if [ -z "$RUN" -o -z "$COMOUT" -o -z "$COMOUTnawips" ]; then
    msg="One or more required parameters have not been defined in excmc_generate_gempak.sh"
    err_exit
fi

for fhr in $(seq -f "%03g" 0 6 240); do
    igrib=$DCOM/glb_${cyc}_${fhr}

    let attempts=1
    while [ $attempts -le 50 ]; do
        if [ -f $igrib ]; then
            cpreq $igrib $DATA
            break
        else
            sleep 60
            attempts=$((attempts+1))
        fi
    done
    if [ $attempts -gt 50 ] && [ ! -f $igrib ]; then
        msg= "$igrib still not available after waiting fifty minutes... exiting"
        err_exit
    fi

    #Define gempak and grib output filename
    export gdoutf=${RUN}_${PDY}${cyc}f${fhr}
    export goutf=${RUN}_${PDY}${cyc}f${fhr}

    $USHcmc/decode_model.sh $(basename $igrib)
    export err=$?;err_chk

    if [ "$SENDCOM" = YES ]; then
       if [ -e $gdoutf ]; then
          cpfs $gdoutf $COMOUTnawips/$gdoutf
       else
          msg="Conversion FAILED for GRIB file $gbfile to GEMPAK file $gdoutf"
          echo "`date -u` -- $msg" >>$log
          err_exit
       fi

       cpfs $igrib $COMOUT/$goutf

       if [ "$SENDDBN" = YES ]; then
          $SIPHONROOT/bin/dbn_alert MODEL CMC_GRIB $jobid ${COMOUT}/${goutf}
          $SIPHONROOT/bin/dbn_alert MODEL CMC_GEMPAK $jobid ${COMOUTnawips}/${gdoutf}
       fi
    fi
    
done

exit 0
