# Table of Cotents

1. [Nemo Installation](#installation)
2. [Replace file manager](#replace)

## Nemo Installation <a name="installation"></a>

Nemo installation is very simple and we even have two options to do it. The first of it is a via Ubuntu repositories, after which we will write the following in the terminal:

`
sudo apt-get install nemo
`

If we want to have the latest version of Nemo, then we have to install the external repository typing in the terminal the following:

```
sudo add-apt-repository ppa:embrosyn/cinnamon
sudo apt install nemo
```

## Replace file manager <a name="replace"></a> 

Now that we already have the two file managers, we have to do the replacement, for which we have to write the following in the terminal:Now that we already have the two file managers, we have to do the replacement, for which we have to write the following in the terminal:

```
xdg-mime default nemo.desktop inode/directory application/x-gnome-saved-search
gsettings set org.gnome.desktop.background show-desktop-icons false
```
This will make Gnome and Ubuntu use Nemo instead of Nautilus. But, something is still missing. We have to make Ubuntu always load Nemo instead of Nautilus when the computer is turned on. For it **We have to add the «Nemo Desktop» application in Start applications**, the file manager executable. This is important because otherwise, when we start the computer, Nautilus will load and not Nemo.

To reverse the process, we have to write the following in the terminal:

```
xdg-mime default nautilus.desktop inode/directory application/x-gnome-saved-search
gsettings set org.gnome.desktop.background show-desktop-icons true
```

And then remove Nemo, by typing the following:

```
sudo apt-get purge nemo nemo*
sudo apt-get autoremove
```

And with this we will have Ubuntu 18.04 again as in the beginning.
