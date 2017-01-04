# radicast

* Record Radiko
* Serve RSS for Podcast

## Requirements

* rtmpdump
* swftools
* ffmpeg or avconv
* or docker (see docker section)

## Install

```
$ go get github.com/calpismate/radicast
```

## Usage

### Setup config.json

```
$ radicast --setup > config.json
```

### Edit config.json

```
$ vim config.json
$ cat config.json

{
  "FMT": [
    "0 0 17 * * *"
  ]
}
```

Cron specification is [here](https://godoc.org/github.com/robfig/cron#hdr-CRON_Expression_Format)

### Launch

```
$ radicast
$ curl 127.0.0.1:3355/rss # podcast rss
```

### Reload config.json

Radicast will reload config when receive HUP signal.

## Docker

```
$ mkdir workspace
$ cd workspace
$ docker pull calpismate/radicast
$ docker run --rm calpismate/radicast:latest --setup > config.json
$ docker run --rm -p 3355:3355 -v `pwd`/config.json:/app/config.json -v `pwd`/output calpismate/radicast:latest --config /app/config.json --output /app/output
```

## See also

* [miyagawa/ripdiko](https://github.com/miyagawa/ripdiko)
* [kojisano/radicast](https://github.com/kojisano/radicast)
* [omiso46/radcast](https://github.com/omiso46/radcast)\

## License

* MIT License
