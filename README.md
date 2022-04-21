# doc-monitor-client
This is the brother of [doc-monitor-host](https://github.com/zqxyz/doc-monitor-host). This is installed on your desktops and laptops. The host script is installed on your server.

This is an alternative to cloud storage, while achieving a similar effect. I find it useful to store files locally so programs can readily access them. This results in redunancy of my work, reducing the risk of loss, and better loading and saving times.

This is essentially a wrapper around `rsync` with a confidence check for file deletion. Deleting files on a client device will not work. It will sync right back into place. To delete a file, you must use the `doc-rm.sh` script on the host/server. The installation adds itself to your path, so you can just run `. doc-rm.sh filetodelete.txt` or `. doc-rm.sh directory2rm` _with no trailing slash_. This will remove it from the server and also from any clients that are active or from inactive clients next time they become active.

## Installation
Before using this, consider that this was an educational exercise for me. It meets my needs, but it may not meet yours. If you don't understand the code, it might not be the best fit for you.

This is installed after [doc-monitor-host](https://github.com/zqxyz/doc-monitor-host).

### BEFORE YOU INSTALL
You _must_ set up passwordless access to your server. I don't mean don't use a password (unless it's all local), instead use `ssh-keygen`: read about it at https://linuxize.com/post/how-to-setup-passwordless-ssh-login/

```
cd ~
git clone https://github.com/zqxyz/doc-monitor-client.git
cd doc-monitor-client
. install.sh
cd ../ && rm -rf doc-monitor-client
```

This will place `doc-monitor-client.sh` and `doc-monitor-config.sh` into `/opt/doc-monitor`. You will be prompted to edit the configuration: **you must specify your host address here. The other defaults are fine as is.** It will create a cronjob at boot time to run `doc-monitor-client.sh`. It will start `doc-monitor-client.sh` in the background.

Once running, three dotfiles will be generated for storing data. `.doc_mod_time` stores the most recent modification of any local file. `.rmlist` stores paths of files to be deleted.

![File diagram](https://zquint.xyz/images/docmondiag.png)
