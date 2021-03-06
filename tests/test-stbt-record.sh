# Run with ./run-tests.sh

test_record() {
    (
        cd "$scratchdir"
        stbt-record -v -o test.py --control-recorder=file://<(
            sleep 1; echo gamut;
            sleep 1; echo checkers-8;
            sleep 1; echo smpte; sleep 1;)
    ) &&
    sed -e 's/0000-gamut-complete.png/videotestsrc-gamut.png/' \
        -e 's/0001-checkers-8-complete.png/videotestsrc-checkers-8.png/' \
        -e 's/0002-smpte-complete.png/videotestsrc-redblue.png/' \
        "$scratchdir/test.py" > "$scratchdir/test.with-cropped-images.py" &&
    mv "$scratchdir/test.with-cropped-images.py" "$scratchdir/test.py" &&
    rm "$scratchdir/"{0000,0001,0002}-*-complete.png &&

    stbt-run -v "$scratchdir/test.py"
}

test_that_invalid_control_doesnt_hang_stbt_record() {
    timeout 10 stbt-record --control asdf
    local ret=$?
    [ $ret -ne $timedout ] || fail "'stbt-record --control asdf' timed out"
}
