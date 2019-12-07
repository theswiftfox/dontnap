# DontNap
Indicator for Wingpanel to quickly disable sleep settings.  

Inspired by the popular application [caffeine](https://launchpad.net/caffeine) I decided to write a small indicator application for [elementary OS](https://elementary.io/) using their wingpanel API.  
On enabling the 'Prevent Sleep' option the application will store your current settings for inactivity and update the gsettings temporarily and restore your settings once you disable it.  

This is my first application for elementary OS and written for personal use. So use at your own risk. But I am always open for suggestions on improvements.  

## How to build  
Make sure you have the elementary SDK installed as explained [here](https://elementary.io/de/docs/code/getting-started#developer-sdk).  
The steps to clone and build the application are quite simple as it doesn't require any other dependencies.  
```
git clone https://github.com/theswiftfox/dontnap.git
cd dontnap
meson build --prefix=/usr
cd build
ninja
sudo ninja install
```
This will install the indicator to your system. After restarting wingpanel it will be visible:  
```
killall wingpanel
```  

