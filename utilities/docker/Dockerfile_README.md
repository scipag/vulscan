# Nmap, nmap scripts, vulscan

## Abstract
Comes fully equipped with
the latest Nmap Scripting Engine (NSE) modules, as well as the [Vulscan](https://github.com/scipag/vulscan) NSE script.  
The databases used by Vulscan are pulled using the original updater script when image is built  
  
## Source

https://github.com/scipag/vulscan

## Usage

```bash
docker build -t vulscan .
docker run -it vulscan:latest
```

## Help:

```bash
docker run -it nmap -sV --script=vulscan/vulscan.nse www.example.com
```

## Demo  
[![asciicast](https://asciinema.org/a/141837.png)](https://asciinema.org/a/141837)

