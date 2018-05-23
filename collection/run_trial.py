#!/usr/bin/env python
import time, os, ctypes, sys, random, subprocess, shutil, getopt, serial

class ssd_test_class:
    def __init__(self, size, floc, rloc, trials, start, stop, wait_time, trigger_on, trigger_off):
        self.size           = int(size)
        self.sname          = str(size)+"MB.txt"
        self.fname          = floc+'\\'+str(size)+"MB.txt"
        self.floc           = floc
        self.rloc           = rloc
        self.sleep          = int(wait_time)
        self.start          = start
        self.stop           = stop
        self.trigger_on     = trigger_on
        self.trigger_off    = trigger_off

    def write_test(self):

        # create a file and save it to the C:\ Drive
        if not os.path.isfile(self.fname):
            create_file(self.size, self.fname)
        shutil.move(self.fname, self.rloc+'\\'+self.sname)

        # START WRITE TRIAL
        self.trigger_on.write(bytes(42))
        time.sleep(self.start)
        shutil.move(self.rloc+'\\'+self.sname,self.fname)
        time.sleep(self.stop)
        self.trigger_off.write(bytes(42))
        # END OF WRITE TRIAL

        wait()

    def read_test(self):

        # create a file and save it the SSD
        if not os.path.isfile(self.fname):
            create_file(self.size, self.fname)

        # START READ TRIAL
        self.start.write(bytes(42))
        time.sleep(self.start)
        shutil.move(self.fname,self.rloc+'\\'+self.sname)
        time.sleep(self.stop)
        self.stop.write(bytes(42))
        # END OF READ TRIAL

        move_file(self.rloc+'\\'+self.sname,self.fname)
        wait()

    def clear_cache(self):
        os.system(os.getcwd()+'EmptyStandbyList.exe standbylist')

    def wait(self):
        for second in range(self.sleep):
            sys.stdout.write('\r'+str(self.sleep - second)+' seconds left to start recording\t\t')
            time.sleep(1)
        print()

    def create_file(self):
        file = open(self.fname,'wb')

        try:
            MB = os.urandom(1024 * 1024)
            for i in range(int(self.size)):
                file.write(MB)
            file.close()
        except:
            file.close()
            os.remove(file_name)

def main():

    #####################################################################
    # User Defined Trial Parameters - (safe to edit these)
    #####################################################################
    trigger_on   = serial.Serial('COM13',9600)
    trigger_off  = serial.Serial('COM12',9600)
    trials  = 10
    sizes   = [1024,5120]
    floc    = os.getcwd()
    rloc    = "C:\\Users\\samsungssd\\Desktop\\"
    start   = 2
    stop    = 20
    wait    = 60
    #####################################################################

    test    = ssd_test_class(0, floc, rloc, trials, start, stop, wait, trigger_on, trigger_off)
    for size in sizes:
        test.size = size
        test.sname = str(size)+"MB.txt"
        test.fname = test.floc + '\\' + test.sname
        test.clear_cache()
        for trial in range(trials):
            test.clear_cache()
            test.write_test()
            test.clear_cache()
            test.read_test()
    quit()

main()
