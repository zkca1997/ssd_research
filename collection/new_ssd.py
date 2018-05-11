#!/usr/bin/env python
from functions import *
from functions import create_file as cfile

def main():
    start   = serial.Serial('COM13',9600)
    stop    = serial.Serial('COM12',9600)
    sizes   = [1024,5120]
    floc    = os.getcwd()
    rloc    = "C:\\Users\\samsungssd\\Desktop\\"
    wait    = 60
    test    = ssd_test_class(0,floc,rloc,start,stop,wait)

    trials  = 10
    for size in sizes:
        test.size = size
        test.sname = str(size)+"MB.txt"
        test.fname = test.floc + '\\' + test.sname
        test.clear_cache()
        for trial in range(trials):
            test.read_test()
            test.clear_cache()
        for trial in range(trials):
            test.write_test()
            test.clear_cache()
    quit()

main()
'''
if __name__ == '__main__':
    args    = parse_input()
    #seed    = args.seed
    temp_start  = args.start_serial_port.split(',')
    temp_stop   = args.stop_serial_port.split(',')
    if args.create_file != None:
        cfile(args.create_file,args.create_file+'MB.txt')
        quit()
    else:
        start   = serial.Serial(temp_start[0],int(temp_start[1]))
        stop    = serial.Serial(temp_stop[0],int(temp_stop[1]))
        tstSSD  = ssd_test_class(0,args.location,args.remote_location,start,stop,args.record_time)
        
        sizes   = [int(i) for i in args.size.split(',')]
        for size in sizes:
            tstSSD.size = size
            for test in range(int(args.readFile)):
                tstSSD.read_test()
                create_file(1024,'2048MB.txt')
                remove_file("2048MB.txt")
            for test in range(int(args.writeFile)):
                tstSSD.write_test()
                create_file(1024,'2048MB.txt')
                remove_file("2048MB.txt")
        tstSSD.blank_test()
    
'''
