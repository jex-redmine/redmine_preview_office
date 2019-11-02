**Support redmine4 now**

# redmine_preview_office

Plugin for Redmine. Show Microsoft Office attachments in preview pane. 
Supports .doc, .docx, .xls, .xlsx, .ppt, .pptx, .rtf, .odt

![PNG that represents a quick overview](/doc/Overview.png)

### Use case(s)

* View contents of a Microsoft Office file as pdf in Redmine's preview pane 

### Install

1. Install [libreoffice]:https://www.libreoffice.org (many linux distributions provide ready installers) 

2. download plugin and copy plugin folder redmine_preview_office go to Redmine's plugins folder 

3. Install [unoconv](https://github.com/unoconv/unoconv)

4. restart server f.i.  

`sudo /etc/init.d/apache2 restart`

### 补充

Production servers should consider running unoconv in listener mode, see Installing_unoconv#Run_a_unoconv_listener or follow directions bellow

  `vi /etc/systemd/system/unoconv.service`
    
  And then copy and paste the following configuration into it:

  ```
  [Unit]
  Description=Unoconv listener for document conversions
  Documentation=https://github.com/dagwieers/unoconv
  After=network.target remote-fs.target nss-lookup.target

[Service]
Type=simple
Environment="UNO_PATH=/usr/lib64/libreoffice/program"
ExecStart=/usr/bin/unoconv --listener

[Install]
WantedBy=multi-user.target
And then enable and start the above service

systemctl enable unoconv.service
systemctl start unoconv.service
  ```

`vi  /etc/init/unoconv.conf`

 ```
# Unoconv listener service

# Install to /etc/init/ folder and start with "sudo service unoconv start"
# This will start a unoconv listener and restart it if it dies. The listener
# will run as the apache user "www-data" and have access to the same files/folders
# as that user.
# The home folder for this listener will point to /tmp/ and any temporary files used by
# libreoffice will be created there.

description     "Unoconv Apache Listener"
author          "Damyon Wiese <damyon@moodle.com>"

start on runlevel [2345]
stop on starting rc RUNLEVEL=[016]

respawn
respawn limit 2 5

env HOME=/tmp
setuid www-data

# The default of 5 seconds is too low for mysql which needs to flush buffers

pre-start script
    # Kill any currently running soffice processes.
    /usr/bin/killall soffice.bin || true
end script

exec /usr/bin/unoconv --listener
```
 
### Uninstall

1. go to plugins folder, delete plugin folder redmine_preview_office

`rm -r redmine_preview_office`

2. restart server f.i. 

`sudo /etc/init.d/apache2 restart`

### For CJK (Chinese, Japan, Korea) users

If you have encountered charaters not correctly shown when converting office docuemnts to pdf, that probably related to missing some language pack in
your system.

[Installing Asian Fonts on Ubuntu & Debian](https://help.accusoft.com/PrizmDoc/v12.1/HTML/Installing_Asian_Fonts_on_Ubuntu_and_Debian.html)

* To install Chinese language support, run following commands:
  ```
  # sudo apt-get install language-pack-zh*
  # sudo apt-get install chinese*
  ```

* To install Japanese language support, run following commands:
  ```
  # sudo apt-get install language-pack-ja
  # sudo apt-get install japan*
  ```

* To install Korean language support, run following commands:
  ```
  # sudo apt-get install language-pack-ko
  # sudo apt-get install korean*
  ```

* Add additional fonts:
  ```
  # sudo apt-get install -y \
      culmus \
      fonts-beng \
      fonts-hosny-amiri \
      fonts-lklug-sinhala \
      fonts-lohit-guru \
      fonts-lohit-knda \
      fonts-samyak-gujr \
      fonts-samyak-mlym \
      fonts-samyak-taml \
      fonts-sarai \
      fonts-sil-abyssinica \
      fonts-sil-padauk \
      fonts-telu \
      fonts-thai-tlwg \
      ttf-liberation \
      ttf-wqy-zenhei \
      fonts-arphic-ukai \
      fonts-arphic-uming \
      fonts-ipafont-mincho \
      fonts-ipafont-gothic \
      fonts-unfonts-core
  ```

* Reconfigure locales (zh_CN for example)
  ```
  echo "Asia/Shanghai" > /etc/timezone && \
    dpkg-reconfigure -f noninteractive tzdata && \
    sed -i -e 's/# zh_CN GB2312/zh_CN GB2312/' /etc/locale.gen && \
    sed -i -e 's/# zh_CN.GB18030 GB18030/zh_CN.GB18030 GB18030/' /etc/locale.gen && \
    sed -i -e 's/# zh_CN.GBK GBK/zh_CN.GBK GBK/' /etc/locale.gen && \
    sed -i -e 's/# zh_CN.UTF-8 UTF-8/zh_CN.UTF-8 UTF-8/' /etc/locale.gen && \
    sed -i -e 's/# zh_HK BIG5-HKSCS/zh_HK BIG5-HKSCS/' /etc/locale.gen && \
    sed -i -e 's/# zh_HK.UTF-8 UTF-8/zh_HK.UTF-8 UTF-8/' /etc/locale.gen && \
    sed -i -e 's/# zh_SG GB2312/zh_SG GB2312/' /etc/locale.gen && \
    sed -i -e 's/# zh_SG.GBK GBK/zh_SG.GBK GBK/' /etc/locale.gen && \
    sed -i -e 's/# zh_SG.UTF-8 UTF-8/zh_SG.UTF-8 UTF-8/' /etc/locale.gen && \
    sed -i -e 's/# zh_TW BIG5/zh_TW BIG5/' /etc/locale.gen && \
    sed -i -e 's/# zh_TW.EUC-TW EUC-TW/zh_TW.EUC-TW EUC-TW/' /etc/locale.gen && \
    sed -i -e 's/# zh_TW.UTF-8 UTF-8/zh_TW.UTF-8 UTF-8/' /etc/locale.gen && \
    sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
    echo 'LANG="zh_CN.UTF-8"'>/etc/default/locale && \
    dpkg-reconfigure --frontend=noninteractive locales && \
    update-locale LANG=zh_CN.UTF-8
  ```

### Use

* Go to Administration->Information and verify if Libreoffice is available
* On Issue show page click on a docx or other Microsoft Office attachment and view its contents in Redmine's preview pane as a pdf file

**Have fun!**

### Localization

* 1.0.1 
  - English
  - German
* 1.0.0 - no localizable strings present in plugin

### Change-Log* 

**1.0.4**
  - support redmine 4 now

**1.0.3** 
  - cleaned code
  - added support for MS Windows platform

**1.0.2** a
  - dded option to embed preview via `<object><embed>`-tag or via `<iframe>`-tag

**1.0.1** 
  - added check for libreoffice

**1.0.0** 
  - running on Redmine 3.4.6 
