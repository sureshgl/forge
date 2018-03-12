#!/usr/local/bin/perl

$subchip = shift;
print $subchip,"\n";
if (-e "${subchip}") {
print "INFO: ${subchip} directory exists","\n";
} else {
print "INFO: creating ${subchip} directory";
system ("mkdir ${subchip};");
      }
if (-e "${subchip}/${subchip}_rtl.vf") {
   print "INFO: Backing up exisiting ${subchip}_rtl.vf file ...";
   system ("mv ${subchip}/${subchip}_rtl.vf ${subchip}/${subchip}_rtl.vf.bak");
}
