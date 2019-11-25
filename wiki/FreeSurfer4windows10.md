# Walkthrough for Freesurfer4Windows10

This is a short walkthrough on how to run Freesurfer v6.0.0 from the Windows command line using Windows 10 Pro Version 1803 build 17134.799 with Ubuntu 18.04 LTS.  
Date of creation is November 25th 2019.  

The entire install including Downloads (depending on your connection) took me less than 20 minutes.  

## Install WSL and Ubuntu

First install the Windows subsystem for Linux which gives you access to a Linux shell from here on called bash:  

Open Start.  
Search for PowerShell, right-click it and Run as administrator.  
Type the following command to add the required module and press Enter:  

**Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux**

Type *Y* to complete the installation and restart your computer.  

An easy way to install Linux distros on Windows 10 is to use the Windows Store, find Ubuntu and install.  

Run Ubuntu from the start menu
Ubuntu will install (takes a while) and will ask you for a username and password (you can choose)

## Define proxy settings (e.g. inside hospital network)

To get Ubuntu apt online you need to define the your proxy, therefore open the proxy configuration script with nano:

**sudo nano /etc/apt/apt.conf.d/proxy.conf**  

write the lines (replace charite with your proxy address):

**Acquire::http::proxy "http://proxy.charite.de:8080";**  
**Acquire::https::proxy "https://proxy.charite.de:8080";**  
**Acquire::ftp::proxy "ftp://proxy.charite.de:8080";**  

save with *Ctrl+O* + *Enter*  
and exit with *Ctrl+X* 


## Install Ubuntu and Freesurfer packages
In Ubuntu run: **apt-get update**  

Install necessary packages:  

**sudo apt-get install tcsh libfreetype6 libglu1-mesa libfontconfig1 libxrender1 libsm6 libxt6 libgomp1**  

Create a linux folder in windows for easier file transfer:

**mkdir /mnt/c/linux/**

Change to windows and download Freesurfer tar.gz file from the freesurfer website:
(see https://surfer.nmr.mgh.harvard.edu/fswiki/DownloadAndInstall)

*https://surfer.nmr.mgh.harvard.edu/pub/dist/freesurfer/6.0.0/freesurfer-Linux-centos6_x86_64-stable-pub-v6.0.0.tar.gz*

Back in Ubuntu cd /mnt/c/linux/ and run

**sudo tar -C /usr/local -xzvf freesurfer-Linux-centos6_x86_64-stable-pub-v6.0.0.tar.gz**  

This will take as while and install freesurfer to */usr/local/freesurfer/* as recommended.

You can now delete the tar.gz file in the *C:\linux\* folder to free up space.

If you don't have one, obtain a license file from:
*https://surfer.nmr.mgh.harvard.edu/registration.html*

In Windows you can place the license file in your C:\linux\ folder.
Next in Ubuntu you can move the file to the freesurfer folder:

**sudo mv /mnt/c/linux/license.txt /usr/local/freesurfer/**  

Next you add a folder where you want to store (can be temporarily) your freesurfer subject data. 

**mkdir /mnt/c/linux/freesurfer_subjects/**  

## Add Freesurfer to the bashrc to have all commands in place from bash startup

Finally, you need to define *FREESUFER_HOM*E and *SUBJECTS_DIR*. and set it up. You can do that with every start from command line or by adding it to *.bashrc* - Write these lines:

To do that use nano ~/.bashrc, scroll to the end and add:  

**export FREESURFER_HOME=/usr/local/freesurfer**  
**source $FREESURFER_HOME/SetUpFreeSurfer.sh**  
**export SUBJECTS_DIR=/mnt/c/linux/freesurfer_subjects/**  
**cd $SUBJECTS_DIR**  

press *CTRL+O* followed by *ENTER* and *CTRL+X* to return to bash

## Test your Freesurfer install
Restart the Ubuntu bash e.g. by writing *exit* followed by *bash* and can do a test using the following command:

**sudo cp $FREESURFER_HOME/subjects/sample-001.mgz .**
**mri_convert sample-001.mgz sample-001.nii.gz**

If it worked you can now use the windows explorer to find both the original sample-001.mgz and the converted sample-001.nii.gz file in your freesurfer_subjects folder.

## You are done. Run recon-all from Windows Command line, Matlab or Python

You can now run recon-all from windows command line or within matlab or python using:

**bash -ic "recon-all -i yourfile.nii -s yoursubjectname -all"**


