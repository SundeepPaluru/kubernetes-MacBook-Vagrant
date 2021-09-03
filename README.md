# Kubernetes-MacBook-Vagrant
Installing kubernetes on MacBook, using Vagrant and Virtual Box.

## Installing Virtual Box

```shell
brew install virtualbox
```
or
```url
https://www.virtualbox.org/wiki/Downloads
```

> In case if you receive an kernal driver not installed RC=-1908 error. Make sure you allow oracle software under system preferences. System Preferences --> Security & Privacy --> General --> Allow or click on Advanced

## Installing Vagrant
```bash
brew install vagrant
```

## Cloning GITHUB Repo
```git
git clone https://github.com/SundeepPaluru/kubernetes-MacBook-Vagrant.git
```

## Lets build Kubernetes Cluster
```bash
vagrant up
```
> This will build one master and two worker nodes

## SSH into a master
```bash
vagrant ssh master
```

## Issues
> In case of any issues, please open the same in the repo. Ill try correct ASAP.

### Yours
## Sundeep :) AKA Sunny ;)