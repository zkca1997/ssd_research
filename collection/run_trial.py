#!/usr/bin/env python
import time, os, ctypes, sys, random, subprocess, shutil, getopt, serial, argparse

class ssd_test_class:
    def __init__(self, size, floc, args, trigger_on, trigger_off):
        self.size           = 0
        self.sname          = ""
        self.fname          = ""
        self.floc           = floc
        self.rloc           = args.ssd_path
        self.sleep          = int(args.wait)
        self.start          = args.start_buf
        self.stop           = args.record_time
        self.trigger_on     = trigger_on
        self.trigger_off    = trigger_off

    def read_test(self):

        # create a file and save it to the C:\ Drive
        if not os.path.isfile(self.fname):
            self.create_file(self.size, self.fname)
        shutil.move(self.fname, self.rloc+'\\'+self.sname)

        self.clear_cache()

        # START WRITE TRIAL
        self.trigger_on.write(bytes(42))
        time.sleep(self.start)
        shutil.move(self.rloc+'\\'+self.sname,self.fname)
        time.sleep(self.stop)
        self.trigger_off.write(bytes(42))
        # END OF WRITE TRIAL

        self.wait()

    def write_test(self):

        # create a file and save it the SSD
        if not os.path.isfile(self.fname):
            self.create_file(self.size, self.fname)

        self.clear_cache()

        # START READ TRIAL
        self.start.write(bytes(42))
        time.sleep(self.start)
        shutil.move(self.fname,self.rloc+'\\'+self.sname)
        time.sleep(self.stop)
        self.stop.write(bytes(42))
        # END OF READ TRIAL

        shutil.move(self.rloc+'\\'+self.sname,self.fname)
        self.wait()

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

def ParseArgs():
    parser = argparse.ArgumentParser(description='automated test script')

    parser.add_argument("-n", "--num_trials",
                        default=5,
                        help="number of read and write trials to run")

    parser.add_argument("-l", "--ssd_path",
                        help="path to target directory on test SSD")

    parser.add_argument("-w", "--wait",
                        default=60,
                        help="idle time between trials in seconds")

    parser.add_argument("-p", "--start_buf",
                        default=2,
                        help="seconds to begin recording before operation begins")

    parser.add_argument("-t", "--record_time",
                        default=20,
                        help="seconds to record after event is triggered")

    parser.add_argument("-s", "--sizes",
                        type=list,
                        default=[4, 16, 64, 256, 1024],
                        help="file sizes to test (in MB)")

    return parser.parse_args()

def main():

    trigger_on  = serial.Serial('COM13',9600)
    trigger_off = serial.Serial('COM12',9600)
    floc        = os.getcwd()
    args        = ParseArgs()

    test    = ssd_test_class(0, os.getcwd(), args, trigger_on, trigger_off)
    for size in args.sizes:
        test.size = size
        test.sname = str(size)+"MB.txt"
        test.fname = test.floc + '\\' + test.sname
        for trial in range(args.num_trials):
            test.write_test()
            test.read_test()
    quit()

main()
