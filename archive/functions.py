#!/usr/bin/env python
import time, os, argparse, ctypes, sys, random, platform, subprocess, shutil, getopt, serial
from sys import platform as _platform

def parse_input():
    parser = argparse.ArgumentParser()
    parser.add_argument("-r","--readFile",default='0',help="Tell the program you want to test reading files x times")
    parser.add_argument("-w","--writeFile",default='0',help="Tell the program you want to test writing files x times")
    parser.add_argument("-z","--size",default='4',help="Tell the program what size files you want in form size1,size2,size3.")
    parser.add_argument("-l","--location",default=os.getcwd(),help="Give us the location of the files")
    parser.add_argument("-L","--remote_location",default="C:\\Users\samsungssd\\Desktop\\",help="Location on computer to read and write files from.\n\n")
    parser.add_argument("-s","--start_serial_port",default="COM13,9600",help="serial COM and port you are using (Separate by comma)\n\t\tex:\tCOM13,9600")
    parser.add_argument("-S","--stop_serial_port",default="COM12,9600",help="serial COM and port you are using (Separate by comma)\n\t\tex:\tCOM12,9600")
    parser.add_argument("-R","--record_time",default=200,help="How long do you want to record")
    parser.add_argument("-c","--create_file",help="give me a size for the file and Ill make it")
    return parser.parse_args()

def create_tag():
    return '_'.join([str(time.localtime()[j]) for j in range(5)])+'.txt'

def time_process(process):
    start  = time.time()
    part_1 = process
    part_2 = time.time()-start
    return [part_1,part_2]

def get_time():
    cur_time = time.localtime()
    hours    = cur_time[3]
    minutes  = cur_time[4]
    seconds  = cur_time[5]
    return ':'.join(str(i).zfill(2) for i in [hours,minutes,seconds])

err_file = open("error_file_"+create_tag(),'w')

def error(process,error_message="None"):
    err_file.write(get_time()+' -- Program failed on: '+process+'\n\tNotes: '+error_message+'\n\n')
    err_file.close()
    quit()

def success(process,notes="None"):
    err_file.write(get_time()+' -- '+ process+' successfully executed.\n\tNotes: '+notes+'\n\n')

def note(note):
    err_file.write(get_time()+' -- '+ note + '\n\n')

def create_file(size,file_name):
    try:
        file = open(file_name,'wb')
        success("create_file","Created file with name: "+file_name)
    except:
        error("create_file","Could not create file named: "+file_name)

    try:
        KB = os.urandom(1024)
        for i in range(int(size)*1024):
            file.write(KB)
        file.close()
        success("create_file","Filled file with "+str(size)+" MB of random data")
    except:
        file.close()
        remove_file(file_name)
        error("create_file","Failed to fill file named "+str(size)+"MB.txt\n\tThe previous remove file was for this failed one")

def remove_file(file_name):
    try:
        os.remove(file_name)
        success("remove_file","Removed file named: "+file_name)
    except:
        error("remove_file","Failed to remove file called: "+file_name)

def confirm_file(file_name):
    if os.path.isfile(file_name):
        success("confirm_file","Found file: "+file_name)
        return 'Found'
    else:
        success("confirm_file","Failed to find file: "+file_name)
        return 'Not Found'

def move_file(cur_file_path,new_file_path):
    try:
        shutil.move(cur_file_path,new_file_path)
        success("move_file","Moved file "+cur_file_path+" to "+new_file_path)
    except:
        error("move_file","Failed to move file "+cur_file_path+" to "+new_file_path)

def wait(wait_time):
    for second in range(wait_time):
        sys.stdout.write('\r'+str(wait_time-second)+' seconds left to start recording\t\t')
        time.sleep(1)
    print()

class ssd_test_class:
    def __init__(self,size_of_file,location_of_file,remote_location,start_serial_coms,stop_serial_coms,wait_time):
        self.size    = int(size_of_file)
        self.sname   = str(size_of_file)+"MB.txt"
        self.fname   = location_of_file+'\\'+str(size_of_file)+"MB.txt"
        self.floc    = location_of_file
        self.rloc    = remote_location
        self.start   = start_serial_coms
        self.stop    = stop_serial_coms
        self.sleep   = int(wait_time)

    def blank_test(self):
        try:
            ###ACTUAL IMPORTANT THING
            note("BEGINNING RECORDING")
            self.start.write(bytes(42))
            time.sleep(15)
            self.stop.write(bytes(42))
            ###DONE WITH IMPORTANT THING
            wait(self.sleep)
            success("blank_test")
        except:
            error("blank_test")

    def write_test(self):
        try:
            note("BEGINNING WRITE TEST OF "+self.sname)
            if confirm_file(self.fname) == 'Not Found':
                create_file(self.size,self.fname)
            note("MOVING FILE TO REMOTE LOCATION")
            move_file(self.fname,self.rloc+'\\'+self.sname)
            ###ACTUAL IMPORTANT THING
            note("BEGINNING RECORDING")
            self.start.write(bytes(42))
            time.sleep(2)
            move_file(self.rloc+'\\'+self.sname,self.fname)
            time.sleep(20)
            self.stop.write(bytes(42))
            ###DONE WITH IMPORTANT THING
            wait(self.sleep)
            success("write_test")
        except:
            error("write_test")

    def read_test(self):
        try:
            note("BEGINNING OF READ TEST OF "+self.sname)
            confirm_file(self.fname)
            if confirm_file(self.fname) == 'Not Found':
                create_file(self.size,self.fname)
            ###ACTUAL IMPORTANT THING
            note("BEGINNING RECORDING")
            self.start.write(bytes(42))
            time.sleep(2)
            move_file(self.fname,self.rloc+'\\'+self.sname)
            time.sleep(20)
            self.stop.write(bytes(42))
            ###DONE WITH IMPORTANT THING
            move_file(self.rloc+'\\'+self.sname,self.fname)
            wait(self.sleep)
            success("read_test")
        except:
            error("read_test")

    def clear_cache(self):
        os.system(os.getcwd()+'EmptyStandbyList.exe standbylist')
